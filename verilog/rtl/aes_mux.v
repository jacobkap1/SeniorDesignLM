module aes_mux(
    input  wire [127:0] w0_i,
    input  wire [127:0] w1_i,
    input  wire [127:0] w2_i,
    input  wire         wvalid_i,
    
    input  wire [127:0] iv_i,
    input  wire         ivalid_i,
    
    input  wire [127:0] c_i,
    input  wire         cvalid_i,
    
    input  wire [255:0] m_i,
    input  wire         mvalid_i,
    
    input  wire [1:0]   sel_i,
    output reg  [127:0] out0_o,
    output reg  [127:0] out1_o,
    output reg  [127:0] out2_o,
    output reg          valid_o
);
    always_comb begin
        case (sel_i)
            2'd0: begin
                out0_o   = w0_i;
                out1_o   = w1_i;
                out2_o   = w2_i;
                valid_o  = wvalid_i;
            end 
            
            2'd1: begin
                out0_o  = iv_i;
                out1_o  = m_i[255:128];
                out2_o  = m_i[127:  0];
                valid_o = ivalid_i & mvalid_i;
            end
            
            2'd2: begin
                out0_o  = c_i;
                out1_o  = m_i[255:128];
                out2_o  = m_i[127:  0];
                valid_o = cvalid_i & mvalid_i;
            end
            
            default: begin
                out0_o  = 128'd0;
                out1_o  = 128'd0;
                out2_o  = 128'd0;
                valid_o = 1'b0;
            end
        endcase
    end
endmodule
