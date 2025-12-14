// -----------------------------------------------------------------------------
// aes256_key_expansion.v 
// -----------------------------------------------------------------------------
// KeyExpansion() for AES-256
// - UNROLL_DEPTH rounds per cycle
// - Active-high enable, active-low resetn
// - 'done' stays high while new key expansion is not in progress
// ----------------------------------------------------------------------------- 
`timescale 1ns/1ps
module aes256_key_expansion (
    input  logic         clk,
    input  logic         resetn,
    input  logic         enable_i,

    // key inputs
    input  logic [255:0] k0_i,
    input  logic [255:0] k1_i,
    input  logic [255:0] k2_i,
    input  logic         kvalid_i,
    
    input  logic [431:0] r_i,
    input  logic         rvalid_i,

    // round outputs
    input  logic [3:0]   addr_i,  // round address 0..13
    output logic [127:0] w0_o,
    output logic [127:0] w1_o,
    output logic [127:0] w2_o,
    output logic         valid_o
);
    int i;
    // --------------------------------------------------- ROM ---------------------------------------------------
    localparam logic [31:0] Rcon[1:10] = '{
        32'h01000000, 32'h02000000, 32'h04000000, 32'h08000000, 32'h10000000,
        32'h20000000, 32'h40000000, 32'h80000000, 32'h1b000000, 32'h36000000
    };
    
    // ------------------------------------------------ Functions ------------------------------------------------
    function logic [31:0] RotWord(input logic [31:0] a);
        RotWord = {a[23:0], a[31:24]};
    endfunction

    // ------------------------------------------------ Registers ------------------------------------------------
    logic [31:0] w0[0:59], w1[0:59], w2[0:59];
    logic [5:0]  t;
    
    logic [31:0] sw_w0, sw_w1, sw_w2;
    logic [31:0] subword0, subword1, subword2;
    
    // ------------------------------------------- Next/Derived States -------------------------------------------
    subword sw (
        .w0(sw_w0),
        .w1(sw_w1),
        .w2(sw_w2),
        .r(r_i[431:0]),
        .sw0(subword0),
        .sw1(subword1),
        .sw2(subword2)
    );
    
    // --------------------------------------------------- FSM ---------------------------------------------------
    typedef enum logic [2:0] {LOAD, COMPUTE_1, COMPUTE_2, WAIT_END} state_t;
    state_t state;

    // ------------------------------------------ Main Sequential Block ------------------------------------------
    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin          
            w0 <= '{default:32'd0};
            w1 <= '{default:32'd0};
            w2 <= '{default:32'd0};
            
            subword0 <= 32'd0;
            subword1 <= 32'd0;
            subword2 <= 32'd0;
            
            t     <= 6'd8;
            state <= LOAD;
        end else if (enable_i) begin          
            case (state)
                LOAD: begin
                    t <= 6'd8;
                    
                    if (kvalid_i) begin
                        {w0[0], w0[1], w0[2], w0[3], w0[4], w0[5], w0[6], w0[7]} <= k0_i ^ k1_i ^ k2_i;
                        {w1[0], w1[1], w1[2], w1[3], w1[4], w1[5], w1[6], w1[7]} <= k1_i;
                        {w2[0], w2[1], w2[2], w2[3], w2[4], w2[5], w2[6], w2[7]} <= k2_i;

                        state <= COMPUTE_1;
                    end
                end
                
                COMPUTE_1: begin
                    
                    if (t[2:0] == 3'd0) begin
                        if (rvalid_i) begin
                            sw_w0 = RotWord(w0[t-1]);
                            sw_w1 = RotWord(w1[t-1]);
                            sw_w2 = RotWord(w2[t-1]);
                            
                            state   <= COMPUTE_2;
                        end
                    end else if (t[2:0] == 3'd4) begin
                        if (rvalid_i) begin
                            sw_w0 = w0[t-1];
                            sw_w1 = w1[t-1];
                            sw_w2 = w2[t-1];
                            
                            state   <= COMPUTE_2;
                        end
                    end else begin
                        w0[t] <= w0[t-8] ^ w0[t-1];
                        w1[t] <= w1[t-8] ^ w1[t-1];
                        w2[t] <= w2[t-8] ^ w2[t-1];
                        
                        if (t >= 6'd59) state <= WAIT_END;
                        else t <= t + 1;
                    end
                end
                
                COMPUTE_2: begin
                    if (t[2:0] == 3'd0) begin 
                        w0[t] <= w0[t-8] ^ subword0 ^ Rcon[t >> 3];
                        w1[t] <= w1[t-8] ^ subword1 ^ Rcon[t >> 3];
                        w2[t] <= w2[t-8] ^ subword2 ^ Rcon[t >> 3];
                    end else begin
                        w0[t] <= w0[t-8] ^ subword0;
                        w1[t] <= w1[t-8] ^ subword1;
                        w2[t] <= w2[t-8] ^ subword2;
                    end
                    
                    state <= COMPUTE_1;
                    t <= t + 1;
                end
                
                WAIT_END: begin
                    t <= 6'd8;
                    
                    if (kvalid_i) begin
                        {w0[0], w0[1], w0[2], w0[3], w0[4], w0[5], w0[6], w0[7]} <= k0_i;
                        {w1[0], w1[1], w1[2], w1[3], w1[4], w1[5], w1[6], w1[7]} <= k1_i;
                        {w2[0], w2[1], w2[2], w2[3], w2[4], w2[5], w2[6], w2[7]} <= k2_i;

                        state <= COMPUTE_1;
                    end
                end
                
                default: state <= LOAD;
            endcase
        end
    end
        // ------------------------------------------------- Outputs -------------------------------------------------
    assign w0_o = {w0[4*addr_i], w0[4*addr_i+1], w0[4*addr_i+2], w0[4*addr_i+3]};
    assign w1_o = {w1[4*addr_i], w1[4*addr_i+1], w1[4*addr_i+2], w1[4*addr_i+3]};
    assign w2_o = {w2[4*addr_i], w2[4*addr_i+1], w2[4*addr_i+2], w2[4*addr_i+3]};
    assign valid_o = (state == WAIT_END);
endmodule
