// -----------------------------------------------------------------------------
// aes256_key_expansion.v 
// -----------------------------------------------------------------------------
// KeyExpansion() for AES-256
// - UNROLL_DEPTH rounds per cycle
// - Active-high enable, active-low resetn
// - 'done' stays high while new key expansion is not in progress
// ----------------------------------------------------------------------------- 
`timescale 1ns/1ps
module aes256_key_expansion #(
    parameter SHARES = 3
)(
    input  logic         clk,
    input  logic         resetn,
    input  logic         enable_i,

    // key inputs
    input  logic [255:0] k_i[0:SHARES-1],
    input  logic         kvalid_i,
    
    // sbox
    output logic [7:0]   sbox_i[0:SHARES-1],
    input  logic [7:0]   sbox_o[0:SHARES-1],

    // round outputs
    input  logic [3:0]   addr_i,  // round address 0..13
    output logic [127:0] w_o[0:SHARES-1],
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
    logic [31:0] w[0:SHARES-1][0:59], w_tmp[0:SHARES-1];
    logic [5:0]  t;
    logic [2:0]  p;
    logic [1:0]  idx_i, idx_o;
    
    logic [7:0]  word_i[0:SHARES-1][0:3], word_o[0:SHARES-1][0:2];
    logic [7:0]  x[0:SHARES-1];
    logic [7:0]  s[0:SHARES-1];
    
    // ------------------------------------------- Next/Derived States -------------------------------------------
    assign sbox_i = x;
    assign s = sbox_o;
    
    // --------------------------------------------------- FSM ---------------------------------------------------
    typedef enum logic [2:0] {LOAD, COMPUTE_1, SUBWORD, COMPUTE_2, WAIT_END} state_t;
    state_t state;

    // ------------------------------------------ Main Sequential Block ------------------------------------------
    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin          
            w      <= '{default:'{default:32'd0}};
            word_i <= '{default:'{default:8'd0}};
            word_o <= '{default:'{default:8'd0}};
            x      <= '{default:8'd0};
            
            t     <= 6'd8;
            p     <= 3'd0;
            idx_i <= 2'd0;
            idx_o <= 2'd0;
            
            state <= LOAD;
        end else if (enable_i) begin          
            case (state)
                LOAD: begin
                    t <= 6'd8;
                    
                    if (kvalid_i) begin
                        for (i = 0; i < SHARES; i++) begin
                            {w[i][0], w[i][1], w[i][2], w[i][3], w[i][4], w[i][5], w[i][6], w[i][7]} <= k_i[i];
                        end

                        state <= COMPUTE_1;
                    end
                end
                
                COMPUTE_1: begin
                    if (t[2:0] == 3'd0) begin
                        for (i = 0; i < SHARES; i++) begin
                            {word_i[i][3], word_i[i][2], word_i[i][1], word_i[i][0]} = RotWord(w[i][t-1]);
                            
                            x[i] = word_i[i][0];
                        end
                        
                        p     <= 3'd0;
                        idx_i <= 2'd1;
                        idx_o <= 2'd0;
                        state <= SUBWORD;
                    end else if (t[2:0] == 3'd4) begin
                        for (i = 0; i < SHARES; i++) begin
                            {word_i[i][3], word_i[i][2], word_i[i][1], word_i[i][0]} = w[i][t-1];
                            
                            x[i] = word_i[i][0];
                        end
                        
                        p     <= 3'd0;
                        idx_i <= 2'd1;
                        idx_o <= 2'd0;
                        state <= SUBWORD;
                    end else begin
                        for (i = 0; i < SHARES; i++) begin
                            w[i][t] <= w[i][t-8] ^ w[i][t-1]; 
                        end
                        
                        if (t >= 6'd59) state <= WAIT_END;
                        else t <= t + 1;
                    end
                end
                
                SUBWORD: begin
                    if (idx_i > 0) begin
                        for (i = 0; i < SHARES; i++) begin
                            x[i] = word_i[i][idx_i];
                        end
                        idx_i++;
                    end
                    
                    if (p == 3'd7) begin
                        for (i = 0; i < SHARES; i++) begin
                            word_o[i][idx_o] <= s[i];
                        end
                        
                        if (idx_o >= 2'd2) state <= COMPUTE_2;
                        else idx_o++;
                    end else p++;
                end
                
                COMPUTE_2: begin
                    for (i = 0; i < SHARES; i++) begin
                        w_tmp[i] = {s[i], word_o[i][2], word_o[i][1], word_o[i][0]};
                    end
                    
                    if (t[2:0] == 3'd0) begin
                        for (i = 0; i < SHARES; i++) begin
                            w[i][t] <= w[i][t-8] ^ w_tmp[i] ^ Rcon[t >> 3];
                        end
                    end else begin
                        for (i = 0; i < SHARES; i++) begin
                            w[i][t] <= w[i][t-8] ^ w_tmp[i];
                        end
                    end
                    
                    state <= COMPUTE_1;
                    t <= t + 1;
                end
                
                WAIT_END: begin
                    t <= 6'd8;
                    
                    if (kvalid_i) begin
                        for (i = 0; i < SHARES; i++) begin
                            {w[i][0], w[i][1], w[i][2], w[i][3], w[i][4], w[i][5], w[i][6], w[i][7]} <= k_i[i];
                        end

                        state <= COMPUTE_1;
                    end
                end
                
                default: state <= LOAD;
            endcase
        end
    end
        // ------------------------------------------------- Outputs -------------------------------------------------
    genvar j;
    generate
        for (j = 0; j < SHARES; j++) begin
            assign w_o[j] = {w[j][4*addr_i], w[j][4*addr_i+1], w[j][4*addr_i+2], w[j][4*addr_i+3]};
        end
    endgenerate
    
    assign valid_o = (state == WAIT_END);
endmodule
