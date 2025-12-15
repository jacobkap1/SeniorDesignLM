`timescale 1ns/1ps

module aes_rng #(
    parameter SHARES = 3,
    parameter SIM    = 1
)(
    input  logic         clk,
    input  logic         resetn,
    input  logic         enable_i,
    input  logic [127:0] seed_i,

    output logic [255:0] m[0:SHARES-2],
    output logic [3:0]   zm0[0:(SHARES*(SHARES-1)/2)-1],
    output logic [3:0]   zm1[0:(SHARES*(SHARES-1)/2)-1],
    output logic [3:0]   zm2[0:(SHARES*(SHARES-1)/2)-1],
    output logic [1:0]   zi0[0:(SHARES*(SHARES-1)/2)-1],
    output logic [1:0]   zi1[0:(SHARES*(SHARES-1)/2)-1],
    output logic [1:0]   zi2[0:(SHARES*(SHARES-1)/2)-1],
    output logic         valid_o
);
    int i;
    generate
        if (SIM) begin
            initial begin
                void'($urandom(seed_i));
            end

            always_ff @(posedge clk or negedge resetn) begin
                if (!resetn) begin
                    m   <= '{default: 256'd0};
                    
                    zm0 <= '{default: 4'd0};
                    zm1 <= '{default: 4'd0};
                    zm2 <= '{default: 4'd0};
                    
                    zi0 <= '{default: 2'd0};
                    zi1 <= '{default: 2'd0};
                    zi2 <= '{default: 2'd0};
                    
                    valid_o <= 1'b0;
                end else if (enable_i) begin
                    for (i = 0; i < SHARES; i++) begin
                        m[i] <= {$urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom()};
                        
                        zm0[i] <= $urandom();
                        zm1[i] <= $urandom();
                        zm2[i] <= $urandom();
                        
                        zi0[i] <= $urandom();
                        zi1[i] <= $urandom();
                        zi2[i] <= $urandom();
                    end
                    
                    valid_o <= 1'b1;
                end else begin
                    valid_o <= 1'b0;
                end
            end
        end else begin
            always_ff @(posedge clk or negedge resetn) begin
                if (!resetn) begin
                    m   <= '{default: 256'd0};
                    
                    zm0 <= '{default: 4'd0};
                    zm1 <= '{default: 4'd0};
                    zm2 <= '{default: 4'd0};
                    
                    zi0 <= '{default: 2'd0};
                    zi1 <= '{default: 2'd0};
                    zi2 <= '{default: 2'd0};
                    
                    valid_o <= 1'b0;
                end else if (enable_i) begin
                    for (i = 0; i < SHARES; i++) begin
                        m   <= '{default: 256'd0};
                    
                        zm0 <= '{default: 4'd0};
                        zm1 <= '{default: 4'd0};
                        zm2 <= '{default: 4'd0};
                        
                        zi0 <= '{default: 2'd0};
                        zi1 <= '{default: 2'd0};
                        zi2 <= '{default: 2'd0};
                    end
                    
                    valid_o <= 1'b1;
                end else begin
                    valid_o <= 1'b0;
                end
            end
        end
    endgenerate

endmodule
