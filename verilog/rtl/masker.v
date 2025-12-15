module masker #(
    parameter SHARES = 3,
    parameter WIDTH  = 256
)(
    input  wire [WIDTH-1:0] d,
    input  wire [WIDTH-1:0] m[0:SHARES-2],
    output wire [WIDTH-1:0] q[0:SHARES-1]
);
    logic [WIDTH-1:0] result;
    
    always_comb begin
        result = 'd0;
        for (int i = 0; i < SHARES-1; i++) begin
            result ^= m[i];
        end
    end
    
    assign q[0] = d ^ result;
    
    genvar k;
    generate
        for (k = 1; k < SHARES; k++) assign q[k] = m[k-1];
    endgenerate
endmodule
