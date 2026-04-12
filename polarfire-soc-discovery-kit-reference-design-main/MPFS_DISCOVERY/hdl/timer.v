module timer #(
    parameter CYCLES = 1000
)(
    input  logic        clk,
    input  logic        resetn,
    input  logic        enable_i,
    output logic        out
);
    logic [$clog2(CYCLES)-1:0] count;
    
    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            count <= 'd0;
            out   <= 1'b0;
        end else if (enable_i) begin
            if (count == CYCLES - 1) out <= 1'b1;
            else count <= count + 1;
        end else out <= 1'b0;
    end
endmodule