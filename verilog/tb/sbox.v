// a * b = a & b in GF(2), requires DOM-protection 
module GF_MUL(
    input a0, input a1, input a2,
    input b0, input b1, input b2,
    input [2:0] r,
    
    output q0, output q1, output q2
);
    // q = a & b
    assign q0 = (a0 & b0) ^ (a0 & b1) ^ (a0 & b2) ^ r[0] ^ r[1];
    assign q1 = (a1 & b0) ^ (a1 & b1) ^ (a1 & b2) ^ r[0] ^ r[2];
    assign q2 = (a2 & b0) ^ (a2 & b1) ^ (a2 & b2) ^ r[1] ^ r[2];
endmodule

// b^-1 = b^2 = [b0, b1] in GF(2^2), no gates required
module GF_INV_2(
    input  [1:0] b0, input  [1:0] b1, input  [1:0] b2,
    output [1:0] q0, output [1:0] q1, output [1:0] q2
);
    // q = {b[0], b[1]}
    assign q0 = {b0[0], b0[1]};
    assign q1 = {b1[0], b1[1]};
    assign q2 = {b2[0], b2[1]};
endmodule

// scale2(b) = [b0, b0 + b1] in GF(2^2)
module GF_SCALE_2(
    input  [1:0] b0, input  [1:0] b1, input  [1:0] b2,
    output [1:0] q0, output [1:0] q1, output [1:0] q2
);
    // q = {b[0], b[0] ^ b[1]}
    assign q0 = {b0[0], b0[0] ^ b0[1]};
    assign q1 = {b1[0], b1[0] ^ b1[1]};
    assign q2 = {b2[0], b2[0] ^ b2[1]};
endmodule

// combine squaring (inversion) with scaling in GF(2^2)
module GF_SQR_SCL_2(
    input  [1:0] b0, input  [1:0] b1, input  [1:0] b2,
    output [1:0] q0, output [1:0] q1, output [1:0] q2
);
    // q = {b[1], b[0] ^ b[1]}
    assign q0 = {b0[1], b0[0] ^ b0[1]};
    assign q1 = {b1[1], b1[0] ^ b1[1]};
    assign q2 = {b2[1], b2[0] ^ b2[1]};
endmodule

// a * b = [(a1 * b1) + ((a0 + a1) * (b0 + b1)), (a0 * b0) + ((a0 + a1) * (b0 + b1))]
// a * b = [m1 + m2, m0 + m2]
// where m0 = a0 * b0
//       m1 = a1 * b1
//       m2 = (a0 + a1) * (b0 + b1)
//
// in GF(2^2)
module GF_MUL_2(
    input  [1:0] a0, input  [1:0] a1, input  [1:0] a2,
    input  [1:0] b0, input  [1:0] b1, input  [1:0] b2,
    input  [8:0] r,
    
    output [1:0] q0, output [1:0] q1, output [1:0] q2
);
    wire m0_0, m0_1, m0_2;
    wire m1_0, m1_1, m1_2;
    wire m2_0, m2_1, m2_2;
    
    // m0 = a0 * b0
    GF_MUL mul_0(a0[0], a1[0], a2[0], b0[0], b1[0], b2[0], r[2:0], m0_0, m0_1, m0_2);
    
    // m1 = a1 * b1
    GF_MUL mul_1(a0[1], a1[1], a2[1], b0[1], b1[1], b2[1], r[5:3], m1_0, m1_1, m1_2);
    
    // m2 = (a0 ^ a1) * (b0 ^ b1)
    GF_MUL mul_2(a0[0] ^ a0[1], a1[0] ^ a1[1], a2[0] ^ a2[1], b0[0] ^ b0[1], b1[0] ^ b1[1], b2[0] ^ b2[1], r[8:6], m2_0, m2_1, m2_2);
    
    // q = {m1 ^ m2, m0 ^ m2}
    assign q0 = {m1_0 ^ m2_0, m0_0 ^ m2_0};
    assign q1 = {m1_1 ^ m2_1, m0_1 ^ m2_1};
    assign q2 = {m1_2 ^ m2_2, m0_2 ^ m2_2};
endmodule

// combine multiplication with scaling in GF(2^2)
module GF_MUL_SCL_2(
    input  [1:0] a0, input  [1:0] a1, input  [1:0] a2,
    input  [1:0] b0, input  [1:0] b1, input  [1:0] b2,
    input  [8:0] r,
    
    output [1:0] q0, output [1:0] q1, output [1:0] q2
);
    wire m0_0, m0_1, m0_2;
    wire m1_0, m1_1, m1_2;
    wire m2_0, m2_1, m2_2;
    
    // m0 = a0 * b0
    GF_MUL mul_0(a0[0], a1[0], a2[0], b0[0], b1[0], b2[0], r[2:0], m0_0, m0_1, m0_2);
    
    // m1 = a1 * b1
    GF_MUL mul_1(a0[1], a1[1], a2[1], b0[1], b1[1], b2[1], r[5:3], m1_0, m1_1, m1_2);
    
    // m2 = (a0 ^ a1) * (b0 ^ b1)
    GF_MUL mul_2(a0[0] ^ a0[1], a1[0] ^ a1[1], a2[0] ^ a2[1], b0[0] ^ b0[1], b1[0] ^ b1[1], b2[0] ^ b2[1], r[8:6], m2_0, m2_1, m2_2);
    
    // q = {m0 ^ m2, m0 ^ m1}
    assign q0 = {m0_0 ^ m2_0, m0_0 ^ m1_0};
    assign q1 = {m0_1 ^ m2_1, m0_1 ^ m1_1};
    assign q2 = {m0_2 ^ m2_2, m0_2 ^ m1_2};
endmodule

// scale_sqr4(b) = [(b1 + b0)^2, (scale2(b0))^2] in GF(2^4)
module GF_SCALE_4(
    input  [3:0] b0, input  [3:0] b1, input  [3:0] b2,
    output [3:0] q0, output [3:0] q1, output [3:0] q2
);
    wire [1:0] b0_0, b0_1, b0_2;
    wire [1:0] b1_0, b1_1, b1_2;
    
    wire [1:0] q0_0, q0_1, q0_2;
    wire [1:0] q1_0, q1_1, q1_2;
    
    wire [1:0] s0, s1, s2;
    wire [1:0] sqr0_0, sqr0_1, sqr0_2;
    wire [1:0] sqr1_0, sqr1_1, sqr1_2;
    
    assign b0_0 = b0[1:0];
    assign b0_1 = b1[1:0];
    assign b0_2 = b2[1:0];
    
    assign b1_0 = b0[3:2];
    assign b1_1 = b1[3:2];
    assign b1_2 = b2[3:2];
    
    // s = scale(b0) = N * b0
    GF_SCALE_2 scale(b0_0, b0_1, b0_2, s0, s1, s2);
    
    // q0 = s^2 = s^-1
    GF_INV_2 sqr_0(s0, s1, s2, q0_0, q0_1, q0_2);
    
    // q1 = (b0 ^ b1)^2 = (b0 ^ b1)^-1
    GF_INV_2 sqr_1(b0_0 ^ b1_0, b0_1 ^ b1_1, b0_2 ^ b1_2, q1_0, q1_1, q1_2);
    
    assign q0 = {q1_0, q0_0};
    assign q1 = {q1_1, q0_1};
    assign q2 = {q1_2, q0_2};
endmodule   

// a * b = [(a1 * b1) + scale2((a0 + a1) * (b0 + b1)), (a0 * b0) + scale2((a0 + a1) * (b0 + b1))]
// a * b = [m1 + m2, m0 + m2]
// where m0 = a0 * b0
//       m1 = a1 * b1
//       m2 = scale2((a0 + a1) * (b0 + b1))
//
// in GF(2^4)
module GF_MUL_4(
    input  [3:0] a0, input  [3:0] a1, input  [3:0] a2,
    input  [3:0] b0, input  [3:0] b1, input  [3:0] b2,
    input [26:0] r,
    
    output [3:0] q0, output [3:0] q1, output [3:0] q2
);
    wire [1:0] a0_0, a0_1, a0_2;
    wire [1:0] a1_0, a1_1, a1_2;
    
    wire [1:0] b0_0, b0_1, b0_2;
    wire [1:0] b1_0, b1_1, b1_2;
    
    wire [1:0] m0_0, m0_1, m0_2;
    wire [1:0] m1_0, m1_1, m1_2;
    wire [1:0] m2_0, m2_1, m2_2;
    
    assign a0_0 = a0[1:0];
    assign a0_1 = a1[1:0];
    assign a0_2 = a2[1:0];
    
    assign a1_0 = a0[3:2];
    assign a1_1 = a1[3:2];
    assign a1_2 = a2[3:2];
    
    assign b0_0 = b0[1:0];
    assign b0_1 = b1[1:0];
    assign b0_2 = b2[1:0];
    
    assign b1_0 = b0[3:2];
    assign b1_1 = b1[3:2];
    assign b1_2 = b2[3:2];
    
    // m0 = a0 * b0
    GF_MUL_2 mul_0(a0_0, a0_1, a0_2, b0_0, b0_1, b0_2, r[ 8:0], m0_0, m0_1, m0_2);
    
    // m1 = a1 * b1
    GF_MUL_2 mul_1(a1_0, a1_1, a1_2, b1_0, b1_1, b1_2, r[17:9], m1_0, m1_1, m1_2);
    
    // m2 = scale2((a0 ^ a1) * (b0 ^ b1))
    GF_MUL_SCL_2 mul_2(a0_0 ^ a1_0, a0_1 ^ a1_1, a0_2 ^ a1_2, b0_0 ^ b1_0, b0_1 ^ b1_1, b0_2 ^ b1_2, r[26:18], m2_0, m2_1, m2_2);
    
    // q = [m1 ^ m2, m0 ^ m2]
    assign q0 = {m1_0 ^ m2_0, m0_0 ^ m2_0};
    assign q1 = {m1_1 ^ m2_1, m0_1 ^ m2_1};
    assign q2 = {m1_2 ^ m2_2, m0_2 ^ m2_2};
endmodule

// b^-1    = [t * b0, t * b1]
// where t = (sqr_scl2(b1 + b0) + (b1 * b0))^-1
// in GF(2^4)
module GF_INV_4(
    input  [3:0] b0, input  [3:0] b1, input  [3:0] b2,
    input [26:0] r,
    
    output [3:0] q0, output [3:0] q1, output [3:0] q2
);
    wire [1:0] b0_0, b0_1, b0_2;
    wire [1:0] b1_0, b1_1, b1_2;
    
    wire [1:0] q0_0, q0_1, q0_2;
    wire [1:0] q1_0, q1_1, q1_2;
    
    wire [1:0] m0, m1, m2;
    wire [1:0] s0, s1, s2;
    wire [1:0] t0, t1, t2;
    
    assign b0_0 = b0[1:0];
    assign b0_1 = b1[1:0];
    assign b0_2 = b2[1:0];
    
    assign b1_0 = b0[3:2];
    assign b1_1 = b1[3:2];
    assign b1_2 = b2[3:2];
    
    // m = b0 * b1
    GF_MUL_2     mul_0(b0_0, b0_1, b0_2, b1_0, b1_1, b1_2, r[8:0], m0, m1, m2);
    
    // s = sqr_scl2(b0 ^ b1)
    GF_SQR_SCL_2 sqr_scl(b0_0 ^ b1_0, b0_1 ^ b1_1, b0_2 ^ b1_2, s0, s1, s2);
    
    // t = (m ^ s)^-1
    GF_INV_2 inv(m0 ^ s0, m1 ^ s1, m2 ^ s2, t0, t1, t2);
    
    // q1 = b0 * t
    GF_MUL_2 mul_1(b0_0, b0_1, b0_2, t0, t1, t2, r[17: 9], q1_0, q1_1, q1_2);
    
    // q0 = b1 * t
    GF_MUL_2 mul_2(b1_0, b1_1, b1_2, t0, t1, t2, r[26:18], q0_0, q0_1, q0_2);
    
    assign q0 = {q1_0, q0_0};
    assign q1 = {q1_1, q0_1};
    assign q2 = {q1_2, q0_2};
endmodule

// b^-1    = [t * b0, t * b1]
// where t = (scale4(b1 + b0) + (b1 * b0))^-1
// in GF(2^8)
module GF_INV_8(
    input   [7:0] b0, input [7:0] b1, input  [7:0] b2,
    input [107:0] r,
    
    output [7:0] q0, output [7:0] q1, output [7:0] q2
);
    wire [3:0] b0_0, b0_1, b0_2;
    wire [3:0] b1_0, b1_1, b1_2;

    wire [3:0] q0_0, q0_1, q0_2;
    wire [3:0] q1_0, q1_1, q1_2;
    
    wire [3:0] m0, m1, m2;
    wire [3:0] s0, s1, s2;
    wire [3:0] t0, t1, t2;
    
    assign b0_0 = b0[3:0];
    assign b0_1 = b1[3:0];
    assign b0_2 = b2[3:0];
    
    assign b1_0 = b0[7:4];
    assign b1_1 = b1[7:4];
    assign b1_2 = b2[7:4];
    
    // m = b0 * b1
    GF_MUL_4   mul_0(b0_0, b0_1, b0_2, b1_0, b1_1, b1_2, r[26:0], m0, m1, m2);
    
    // s = scale2(b0 ^ b1)
    GF_SCALE_4 scale(b0_0 ^ b1_0, b0_1 ^ b1_1, b0_2 ^ b1_2, s0, s1, s2);
    
    // t = (m ^ s)^-1
    GF_INV_4 inv(m0 ^ s0, m1 ^ s1, m2 ^ s2, r[53:27], t0, t1, t2);
    
    // q1 = t * b0
    GF_MUL_4 mul_1(b0_0, b0_1, b0_2, t0, t1, t2, r[ 80:54], q1_0, q1_1, q1_2);
    
    // q0 = t * b1
    GF_MUL_4 mul_2(b1_0, b1_1, b1_2, t0, t1, t2, r[107:81], q0_0, q0_1, q0_2);
    
    assign q0 = {q1_0, q0_0};
    assign q1 = {q1_1, q0_1};
    assign q2 = {q1_2, q0_2};
endmodule

// apply transformation of input byte to normal basis for selected operation
module NORMAL_BASIS(input [7:0] x, input decrypt, output [7:0] y);
    wire [7:0] xi, ye, yi;
    
    assign xi = x ^ 8'b01100011;
    
    assign ye[7] = x[7] ^ x[6] ^ x[5] ^ x[2] ^ x[1] ^ x[0];
    assign ye[6] = x[6] ^ x[5] ^ x[4] ^ x[0];
    assign ye[5] = x[6] ^ x[5] ^ x[1] ^ x[0];
    assign ye[4] = x[7] ^ x[6] ^ x[5] ^ x[0];
    assign ye[3] = x[7] ^ x[4] ^ x[3] ^ x[1] ^ x[0];
    assign ye[2] = x[0];
    assign ye[1] = x[6] ^ x[5] ^ x[0];
    assign ye[0] = x[6] ^ x[3] ^ x[2] ^ x[1] ^ x[0];
    
    assign yi[7] = xi[7] ^ xi[4];
    assign yi[6] = xi[6] ^ xi[4] ^ xi[1] ^ xi[0];
    assign yi[5] = xi[6] ^ xi[4];
    assign yi[4] = xi[6] ^ xi[3] ^ xi[1] ^ xi[0];
    assign yi[3] = xi[7] ^ xi[6] ^ xi[4];
    assign yi[2] = xi[7] ^ xi[5] ^ xi[2];
    assign yi[1] = xi[4] ^ xi[3] ^ xi[0];
    assign yi[0] = xi[6] ^ xi[5] ^ xi[4] ^ xi[1] ^ xi[0];
    
    assign y = (decrypt ? yi : ye);
endmodule

// apply transformation of inverted base back to polynomial basis
module POLY_BASIS(input [7:0] x, input decrypt, output [7:0] y);
    wire [7:0] ye, yi;
    
    assign ye[7] =   x[5] ^ x[3];
    assign ye[6] = ~(x[7] ^ x[3]);
    assign ye[5] = ~(x[6] ^ x[0]);
    assign ye[4] =   x[7] ^ x[5] ^ x[3];
    assign ye[3] =   x[7] ^ x[6] ^ x[5] ^ x[4] ^ x[3];
    assign ye[2] =   x[6] ^ x[5] ^ x[3] ^ x[2] ^ x[0];
    assign ye[1] = ~(x[5] ^ x[4] ^ x[1]);
    assign ye[0] = ~(x[6] ^ x[4] ^ x[1]);
    
    assign yi[7] = x[4] ^ x[1];
    assign yi[6] = x[7] ^ x[6] ^ x[5] ^ x[3] ^ x[1] ^ x[0];
    assign yi[5] = x[7] ^ x[6] ^ x[5] ^ x[3] ^ x[2] ^ x[0];
    assign yi[4] = x[6] ^ x[1];
    assign yi[3] = x[6] ^ x[5] ^ x[4] ^ x[3] ^ x[2] ^ x[1];
    assign yi[2] = x[7] ^ x[5] ^ x[4] ^ x[1];
    assign yi[1] = x[5] ^ x[1];
    assign yi[0] = x[2];
    
    assign y = (decrypt ? yi : ye);
endmodule

module sbox(
    input [7:0] b0, input [7:0] b1, input [7:0] b2,
    input [107:0] r,
    input decrypt,
    
    output [7:0] s0, output [7:0] s1, output [7:0] s2
);
    wire [7:0] y0, y1, y2;
    wire [7:0] i0, i1, i2;

    NORMAL_BASIS nb0(b0, decrypt, y0);
    NORMAL_BASIS nb1(b1, decrypt, y1);
    NORMAL_BASIS nb2(b2, decrypt, y2);

    GF_INV_8 inv(y0, y1, y2, r, i0, i1, i2);

    POLY_BASIS pb0(i0, decrypt, s0);
    POLY_BASIS pb1(i1, decrypt, s1);
    POLY_BASIS pb2(i2, decrypt, s2);
endmodule
