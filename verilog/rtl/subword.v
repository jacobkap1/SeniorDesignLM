module subword(
    input  logic [31:0]  w0, w1, w2,  
    input  logic [431:0] r,            // 4 bytes * 108 bits of randomness per byte
    output logic [31:0]  sw0, sw1, sw2
);

    // Temporary signals for each byte
    logic [7:0] b0_0, b0_1, b0_2;
    logic [7:0] b1_0, b1_1, b1_2;
    logic [7:0] b2_0, b2_1, b2_2;
    logic [7:0] b3_0, b3_1, b3_2;

    // Output bytes from SBox
    logic [7:0] s0_0, s0_1, s0_2;
    logic [7:0] s1_0, s1_1, s1_2;
    logic [7:0] s2_0, s2_1, s2_2;
    logic [7:0] s3_0, s3_1, s3_2;

    // Assign input bytes
    assign b0_0 = w0[31:24]; assign b0_1 = w1[31:24]; assign b0_2 = w2[31:24];
    assign b1_0 = w0[23:16]; assign b1_1 = w1[23:16]; assign b1_2 = w2[23:16];
    assign b2_0 = w0[15:8];  assign b2_1 = w1[15:8];  assign b2_2 = w2[15:8];
    assign b3_0 = w0[7:0];   assign b3_1 = w1[7:0];   assign b3_2 = w2[7:0];

    // Instantiate SBoxes for each byte
    sbox sbox0 (
        .b0(b0_0), .b1(b0_1), .b2(b0_2),
        .r(r[107:0]), .decrypt(0),
        .s0(s0_0), .s1(s0_1), .s2(s0_2)
    );

    sbox sbox1 (
        .b0(b1_0), .b1(b1_1), .b2(b1_2),
        .r(r[215:108]), .decrypt(0),
        .s0(s1_0), .s1(s1_1), .s2(s1_2)
    );
    
    sbox sbox2 (
        .b0(b2_0), .b1(b2_1), .b2(b2_2),
        .r(r[323:216]), .decrypt(0),
        .s0(s2_0), .s1(s2_1), .s2(s2_2)
    );
    
    sbox sbox3 (
        .b0(b3_0), .b1(b3_1), .b2(b3_2),
        .r(r[431:324]), .decrypt(0),
        .s0(s3_0), .s1(s3_1), .s2(s3_2)
    );


    // Combine output bytes into 32-bit words
    assign sw0 = {s0_0, s1_0, s2_0, s3_0};
    assign sw1 = {s0_1, s1_1, s2_1, s3_1};
    assign sw2 = {s0_2, s1_2, s2_2, s3_2};

endmodule
