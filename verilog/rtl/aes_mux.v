module aes_mux #(
    parameter SHARES = 3
)(
    input  logic [127:0] w_i[0:SHARES-1],
    input  logic         wvalid_i,
    
    input  logic [127:0] iv_i[0:SHARES-1],
    input  logic         ivalid_i,
    
    input  logic [127:0] c_i[0:SHARES-1],
    input  logic         cvalid_i,
    
    input  logic [1:0]   sel_i,
    output logic [127:0] d_o[0:SHARES-1],
    output logic         valid_o
);
    always_comb begin
        case (sel_i)
            2'd0: begin
                d_o     = w_i;
                valid_o = wvalid_i;
            end 
            
            2'd1: begin
                d_o     = iv_i;
                valid_o = ivalid_i;
            end
            
            2'd2: begin
                d_o     = c_i;
                valid_o = cvalid_i;
            end
            
            default: begin
                d_o     = '{default:128'd0};
                valid_o = 1'b0;
            end
        endcase
    end
endmodule
