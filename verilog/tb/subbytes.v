module subbytes(
    input  logic [127:0] b0, b1, b2,  
    input  logic [1727:0] r,            // 16 bytes * 108 bits of randomness per byte
    input  decrypt,
    output logic [127:0] sw0, sw1, sw2
);
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            sbox sbox_inst (
                .b0(b0[8*i+7:8*i]), .b1(b1[8*i+7:8*i]), .b2(b2[8*i+7:8*i]),
                .r(r[108*i+107:108*i]), .decrypt(decrypt),
                .s0(sw0[8*i+7:8*i]), .s1(sw1[8*i+7:8*i]), .s2(sw2[8*i+7:8*i])
            );
        end
    endgenerate
endmodule
