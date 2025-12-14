`timescale 1ns/1ps
module latch256(
    input  logic         clk,
    input  logic         resetn,
    input  logic         enable_i,
    input  logic         clear_i,
    
    input  logic [255:0] d_i,
    input  logic         valid_i,

    output logic [255:0] d_o,
    output logic         valid_o
);

    logic [255:0] d_reg;
    logic         valid_reg;
    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn || clear_i) begin
            d_reg     <= 256'd0;
            valid_reg <= 1'b0;
        end else begin
            if (valid_i) begin
                d_reg     <= d_i;
                valid_reg <= valid_i;
            end
        end
    end

    assign d_o     = d_reg;
    assign valid_o = valid_reg;
    
endmodule
