// -----------------------------------------------------------------------------
// sha256.v 
// -----------------------------------------------------------------------------
// - 2 rounds per cycle
// - Active-high clear, active-low resetn
// - Streaming input with end_i/valid_i
// - Bit-granular final block via last_i (0..512)
// - Internal auto-padding (1-bit, zeros to 448 mod 512, 64-bit big-endian length)
// - 'valid_o' stays high after final block completes (WAIT_END)
// ----------------------------------------------------------------------------- 
`timescale 1ns/1ps
module sha256 (
    // control
    input  logic         clk,
    input  logic         resetn,
    input  logic         enable_i,

    // stream in 512-bit blocks
    input  logic [511:0] block_i,
    input  logic         valid_i,
    input  logic         end_i,
    input  logic [9:0]   last_i,
    
    // digest
    output logic [255:0] digest_o,

    // outputs
    output logic         ready_o,
    output logic         valid_o
);
    int i;
    // --------------------------------------------------- ROM ---------------------------------------------------
   localparam logic [31:0] K[0:63] = '{
        32'h428a2f98, 32'h71374491, 32'hb5c0fbcf, 32'he9b5dba5, 32'h3956c25b, 32'h59f111f1, 32'h923f82a4, 32'hab1c5ed5,
        32'hd807aa98, 32'h12835b01, 32'h243185be, 32'h550c7dc3, 32'h72be5d74, 32'h80deb1fe, 32'h9bdc06a7, 32'hc19bf174,
        32'he49b69c1, 32'hefbe4786, 32'h0fc19dc6, 32'h240ca1cc, 32'h2de92c6f, 32'h4a7484aa, 32'h5cb0a9dc, 32'h76f988da,
        32'h983e5152, 32'ha831c66d, 32'hb00327c8, 32'hbf597fc7, 32'hc6e00bf3, 32'hd5a79147, 32'h06ca6351, 32'h14292967,
        32'h27b70a85, 32'h2e1b2138, 32'h4d2c6dfc, 32'h53380d13, 32'h650a7354, 32'h766a0abb, 32'h81c2c92e, 32'h92722c85,
        32'ha2bfe8a1, 32'ha81a664b, 32'hc24b8b70, 32'hc76c51a3, 32'hd192e819, 32'hd6990624, 32'hf40e3585, 32'h106aa070,
        32'h19a4c116, 32'h1e376c08, 32'h2748774c, 32'h34b0bcb5, 32'h391c0cb3, 32'h4ed8aa4a, 32'h5b9cca4f, 32'h682e6ff3,
        32'h748f82ee, 32'h78a5636f, 32'h84c87814, 32'h8cc70208, 32'h90befffa, 32'ha4506ceb, 32'hbef9a3f7, 32'hc67178f2
    };

    localparam logic [31:0] H0[0:7] = '{
        32'h6a09e667, 32'hbb67ae85, 32'h3c6ef372, 32'ha54ff53a, 32'h510e527f, 32'h9b05688c, 32'h1f83d9ab, 32'h5be0cd19
    };
    
    // ------------------------------------------------ Functions ------------------------------------------------
    function logic [511:0] msb_mask(input [9:0] nbits);
        if      (nbits >= 512) msb_mask = {512{1'b1}};
        else if (nbits == 0)   msb_mask = 512'b0;
        else                   msb_mask = {512{1'b1}} << (512 - nbits);
    endfunction
    
    function logic [31:0] ROTR2(input logic [31:0] x);
        ROTR2 = (x >> 2)  | (x << 30);
    endfunction

    function logic [31:0] ROTR6(input logic [31:0] x);
        ROTR6 = (x >> 6)  | (x << 26);
    endfunction

    function logic [31:0] ROTR7(input logic [31:0] x);
        ROTR7 = (x >> 7)  | (x << 25);
    endfunction

    function logic [31:0] ROTR11(input logic [31:0] x);
        ROTR11 = (x >> 11) | (x << 21);
    endfunction

    function logic [31:0] ROTR13(input logic [31:0] x);
        ROTR13 = (x >> 13) | (x << 19);
    endfunction

    function logic [31:0] ROTR17(input logic [31:0] x);
        ROTR17 = (x >> 17) | (x << 15);
    endfunction

    function logic [31:0] ROTR18(input logic [31:0] x);
        ROTR18 = (x >> 18) | (x << 14);
    endfunction

    function logic [31:0] ROTR19(input logic [31:0] x);
        ROTR19 = (x >> 19) | (x << 13);
    endfunction

    function logic [31:0] ROTR22(input logic [31:0] x);
        ROTR22 = (x >> 22) | (x << 10);
    endfunction
    
    function logic [31:0] ROTR25(input logic [31:0] x);
        ROTR25 = (x >> 25) | (x << 7);
    endfunction

    function logic [31:0] SHR3(input logic [31:0] x);
        SHR3 = x >> 3;
    endfunction

    function logic [31:0] SHR10(input logic [31:0] x);
        SHR10 = x >> 10;
    endfunction

    function logic [31:0] CH(input logic [31:0] x, input logic [31:0] y, input logic [31:0] z);
        CH = (x & y) ^ (~x & z);
    endfunction

    function logic [31:0] MAJ(input logic [31:0] x, input logic [31:0] y, input logic [31:0] z);
        MAJ = (x & y) ^ (x & z) ^ (y & z);
    endfunction

    function logic [31:0] EP0(input logic [31:0] x);
        EP0 = ROTR2(x) ^ ROTR13(x) ^ ROTR22(x);
    endfunction

    function logic [31:0] EP1(input logic [31:0] x);
        EP1 = ROTR6(x) ^ ROTR11(x) ^ ROTR25(x);
    endfunction

    function logic [31:0] SIG0(input logic [31:0] x);
        SIG0 = ROTR7(x) ^ ROTR18(x) ^ SHR3(x);
    endfunction

    function logic [31:0] SIG1(input logic [31:0] x);
        SIG1 = ROTR17(x) ^ ROTR19(x) ^ SHR10(x);
    endfunction

    function logic [255:0] ROUND(
        input logic [255:0] S,
        input logic [31:0] Wi,
        input logic [31:0] Ki
    );
        logic [31:0] a, b, c, d, e, f, g, h, T1_, T2_;
        {a,b,c,d,e,f,g,h} = S;
        T1_ = h + EP1(e) + CH(e,f,g) + Ki + Wi;
        T2_ = EP0(a) + MAJ(a,b,c);
        ROUND = {T1_ + T2_, a,b,c,d+T1_, e,f,g};
    endfunction

    // ------------------------------------------------ Registers ------------------------------------------------
    // Buffer
    logic [511:0] buffer;
    logic         buffer_full;
    
    // Control
    logic        end_seen;
    logic [63:0] bit_len;

    // Working/state
    logic [31:0] HV[0:7];
    logic [31:0] a, b, c, d, e, f, g, h;
    logic [31:0] W[0:15];
    logic [5:0]  t;
    
    // Pipeline
    logic [255:0] pipe_S;
    logic [31:0]  W_next[0:1];
    logic [31:0]  w_2, w_7, w_15, w_16;
    
    // --------------------------------------------- Derived Signals ---------------------------------------------
    // Next HV    
    logic [31:0] HV0_next, HV1_next, HV2_next, HV3_next;
    logic [31:0] HV4_next, HV5_next, HV6_next, HV7_next;
    
    logic [511:0] last_block;
    logic [63:0]  len_next;
    
    // Next state
    always_comb begin
        HV0_next = HV[0] + a;
        HV1_next = HV[1] + b;
        HV2_next = HV[2] + c;
        HV3_next = HV[3] + d;
        HV4_next = HV[4] + e;
        HV5_next = HV[5] + f;
        HV6_next = HV[6] + g;
        HV7_next = HV[7] + h;
        
        last_block = (last_i >= 10'd512) ?
                               block_i :
                              ((block_i & msb_mask(last_i)) | (512'b1 << (9'd511 - last_i)));
        
        len_next = bit_len + last_i;
    
        for (i = 0; i < 2; i++) begin
            w_2  = W[14 + i];
            w_7  = W[9  + i];
            w_15 = W[1  + i];
            w_16 = W[i];

            W_next[i] = SIG1(w_2) + w_7 + SIG0(w_15) + w_16;
        end
        
        // start from current state
        pipe_S = {a,b,c,d,e,f,g,h};
        // apply 2 rounds
        for (i = 0; i < 2; i++) begin
            pipe_S = ROUND(pipe_S, W[i], K[t + i]);
        end
    end
    
    // --------------------------------------------------- FSM ---------------------------------------------------
    // Padding FSM
    typedef enum logic [1:0] {PAD_IDLE, PAD_PARTIAL, PAD_FULL} pad_t;
    pad_t pad_state;
    
    // Main FSM
    typedef enum logic [1:0] {LOAD, COMPUTE, UPDATE, WAIT_END} state_t;
    state_t state;

    // ------------------------------------------ Main sequential block ------------------------------------------
    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            HV <= H0;
            W  <= '{default:32'd0};
            
            a <= H0[0]; b <= H0[1]; c <= H0[2]; d <= H0[3];
            e <= H0[4]; f <= H0[5]; g <= H0[6]; h <= H0[7];
            
            buffer      <= 512'b0;
            buffer_full <= 1'b0;
            end_seen    <= 1'b0;
            
            pad_state <= PAD_IDLE;
            bit_len   <= 64'b0;
            
            state     <= LOAD;
            t         <= 6'b0;
        end else if (enable_i) begin
            // latch end
            if (end_i) end_seen  <= 1'b1;
            
            // ---------------- accept input blocks ----------------
            if (!end_seen && !buffer_full) begin
                if(valid_i) begin
                    if (end_i) begin
                        if (last_i < 448) begin
                            // padding fits in current block
                            buffer <= {last_block[511:64], len_next};
                            
                            buffer_full <= 1'b1;
                            bit_len     <= len_next;
                        end else if (last_i < 512) begin
                            // final 1 bit fits in current block, rest needs to go in the next
                            buffer <= last_block;
                            
                            buffer_full <= 1'b1;
                            bit_len     <= len_next;
                            pad_state   <= PAD_PARTIAL;
                        end else begin
                            // full block, padding must be done separately
                            buffer <= block_i;
                            
                            buffer_full <= 1'b1;
                            bit_len     <= bit_len + 64'd512;
                            pad_state   <= PAD_FULL;
                        end
                    end else begin
                        // normal data block
                        buffer      <= block_i;
                        buffer_full <= 1'b1;
                        bit_len     <= bit_len + 64'd512;
                    end
                end else if (end_i) begin
                    // empty message (or final cycle with no data) ? start padding
                    buffer      <= {1'b1, 447'd0, bit_len};
                    buffer_full <= 1'b1;
                end
            end
            
            // ---------------- padding generator ----------------
            if (!buffer_full) begin
                case (pad_state)
                    PAD_IDLE: begin end
                    
                    PAD_PARTIAL: begin
                        buffer      <= {448'd0, bit_len};
                        buffer_full <= 1'b1;
                        pad_state   <= PAD_IDLE;
                    end
                    
                    PAD_FULL: begin
                        buffer      <= {1'b1, 447'd0, bit_len};
                        buffer_full <= 1'b1;
                        pad_state   <= PAD_IDLE;
                    end
                    
                    default: begin
                        pad_state <= PAD_IDLE;
                    end
                endcase
            end
            
            // --- FSM ---
            case(state)
                LOAD: begin
                    a <= HV[0]; b <= HV[1]; c <= HV[2]; d <= HV[3];
                    e <= HV[4]; f <= HV[5]; g <= HV[6]; h <= HV[7];
                    
                    if (buffer_full) begin
                        {W[ 0], W[ 1], W[ 2], W[ 3], 
                         W[ 4], W[ 5], W[ 6], W[ 7],
                         W[ 8], W[ 9], W[10], W[11],
                         W[12], W[13], W[14], W[15]} <= buffer;
                        
                        buffer_full <= 1'b0;
                        state <= COMPUTE;
                    end
                end

                COMPUTE: begin
                    {a, b, c, d, e, f, g, h} <= pipe_S;
                
                    for (i =  0; i < 14; i++) W[i] <= W[i + 2];    
                    for (i = 14; i < 16; i++) W[i] <= W_next[i - 14];
                    
                    if (t >= 6'd62) state <= UPDATE; // finished the block
                    else            t     <= t + 2;  // next chunk of rounds
                end
                
                UPDATE: begin
                    HV[0] <= HV0_next; HV[1] <= HV1_next; HV[2] <= HV2_next; HV[3] <= HV3_next;
                    HV[4] <= HV4_next; HV[5] <= HV5_next; HV[6] <= HV6_next; HV[7] <= HV7_next;
                    
                    a <= HV0_next; b <= HV1_next; c <= HV2_next; d <= HV3_next;
                    e <= HV4_next; f <= HV5_next; g <= HV6_next; h <= HV7_next;
                    
                    t <= 6'd0;
                    
                    if (buffer_full) begin
                        {W[ 0], W[ 1], W[ 2], W[ 3], 
                         W[ 4], W[ 5], W[ 6], W[ 7],
                         W[ 8], W[ 9], W[10], W[11],
                         W[12], W[13], W[14], W[15]} <= buffer;
                        
                        buffer_full <= 1'b0;
                        state <= COMPUTE;
                    end else if (end_seen && pad_state == PAD_IDLE) begin
                        end_seen <= 1'b0;
                        state    <= WAIT_END;
                    end else state <= LOAD;
                end
                
                WAIT_END: begin
                    if (buffer_full) begin
                        HV <= H0;
                    
                        a <= H0[0]; b <= H0[1]; c <= H0[2]; d <= H0[3];
                        e <= H0[4]; f <= H0[5]; g <= H0[6]; h <= H0[7];
                    
                        {W[ 0], W[ 1], W[ 2], W[ 3], 
                         W[ 4], W[ 5], W[ 6], W[ 7],
                         W[ 8], W[ 9], W[10], W[11],
                         W[12], W[13], W[14], W[15]} <= buffer;
                        
                        buffer_full <= 1'b0;
                        state <= COMPUTE;
                    end 
                end
                
                default: begin
                    state <= LOAD;
                end
            endcase
        end
    end
    
    // ------------------------------------------------- Outputs -------------------------------------------------
    assign digest_o = {HV[0], HV[1], HV[2], HV[3], HV[4], HV[5], HV[6], HV[7]};
    assign ready_o = !buffer_full;
    assign valid_o   = state == WAIT_END;
endmodule
