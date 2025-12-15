module GF_SCALE #(
    parameter N = 2 // GF(2^N)
)(
    input  logic [N-1:0] x,
    output logic [N-1:0] q
);
    generate
        if (N == 2) begin
            assign q = {x[1], x[0] ^ x[1]};
        end else if (N == 4) begin
            assign q = {x[0] ^ x[2], x[1] ^ x[3], x[1] ^ x[0], x[0]};
        end
    endgenerate
endmodule

module GF_MUL #(
    parameter N = 1 // GF(2^N)
)(
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    output logic [N-1:0] q
);
    generate
        if (N == 1) begin
            assign q = a & b;
        end else if (N == 2) begin
            assign q[1] = ((a[1] ^ a[0]) & (b[1] ^ b[0])) ^ (a[1] & b[1]);
            assign q[0] = ((a[1] ^ a[0]) & (b[1] ^ b[0])) ^ (a[0] & b[0]);
        end else if (N == 4) begin
            wire [1:0] m_lo, m_hi, aa, bb, m_s;
            
            assign m_lo = {((a[1] ^ a[0]) & (b[1] ^ b[0])) ^ (a[1] & b[1]), ((a[1] ^ a[0]) & (b[1] ^ b[0])) ^ (a[0] & b[0])};
            assign m_hi = {((a[3] ^ a[2]) & (b[3] ^ b[2])) ^ (a[3] & b[3]), ((a[3] ^ a[2]) & (b[3] ^ b[2])) ^ (a[2] & b[2])};
            
            assign aa = a[3:2] ^ a[1:0];
            assign bb = b[3:2] ^ b[1:0];
            
            assign m_s[1] = ((aa[1] ^ aa[0]) & (bb[1] ^ bb[0])) ^ (aa[0] & bb[0]);
            assign m_s[0] = ((aa[1] ^ aa[0]) & (bb[1] ^ bb[0])) ^ (aa[1] & bb[1]) ^ m_s[1];
            
            assign q = {m_hi ^ m_s, m_lo ^ m_s};
        end
    endgenerate
endmodule

module GF_SHARED_MUL #(
    parameter N      = 2, // GF(2^N)
    parameter SHARES = 3
)(
    input  logic         clk,
    input  logic         resetn,
    input  logic         enable_i,
    input  logic [N-1:0] a[0:SHARES-1],
    input  logic [N-1:0] b[0:SHARES-1],
    input  logic [N-1:0] z[0:(SHARES*(SHARES-1)/2)-1],
    output logic [N-1:0] q[0:SHARES-1]
);
    logic [N-1:0] AiBj[0:SHARES*SHARES-1], FF[0:SHARES*SHARES-1];
    logic [N-1:0] result[0:SHARES-1];
    
    genvar k, l;
    generate
        for (k = 0; k < SHARES; k++) begin
            for (l = 0; l < SHARES; l++) begin
                GF_MUL #(N) mul(a[k], b[l], AiBj[SHARES*k + l]);
            end
        end
    endgenerate
    

    integer n, m;
    always_comb begin
        for (n = 0; n < SHARES; n++) begin
            result[n] = 'd0;
            for (m = 0; m < SHARES; m++) begin
                result[n] ^= FF[SHARES*n + m];
            end
        end
    end
    
    assign q = result;
    
    integer i, j;
    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            FF <= '{default: 'd0};
        end else if (enable_i) begin
            for (i = 0; i < SHARES; i++) begin
                for (j = 0; j < SHARES; j++) begin
                    if      (i == j) FF[SHARES*i + j] <= AiBj[SHARES*i + j];
                    else if (i >= j) FF[SHARES*i + j] <= AiBj[SHARES*i + j] ^ z[j + i*(i-1)/2];
                    else             FF[SHARES*i + j] <= AiBj[SHARES*i + j] ^ z[i + j*(j-1)/2];
                end
            end
        end
    end
endmodule

// apply transformation of input byte to normal basis for selected operation
module LINEAR_TRANSFORM #(
    parameter N = 1
)(input logic [7:0] x, input logic decrypt, output logic [7:0] y);
    wire [7:0] ye, yi;
    
    generate
        if (N) begin
            assign ye[7] = x[7] ^ x[6] ^ x[5] ^ x[2] ^ x[1] ^ x[0];
            assign ye[6] = x[6] ^ x[5] ^ x[4] ^ x[0];
            assign ye[5] = x[6] ^ x[5] ^ x[1] ^ x[0];
            assign ye[4] = x[7] ^ x[6] ^ x[5] ^ x[0];
            assign ye[3] = x[7] ^ x[4] ^ x[3] ^ x[1] ^ x[0];
            assign ye[2] = x[0];
            assign ye[1] = x[6] ^ x[5] ^ x[0];
            assign ye[0] = x[6] ^ x[3] ^ x[2] ^ x[1] ^ x[0];
            
            assign yi[7] = x[7] ^ x[4];
            assign yi[6] = x[6] ^ x[4] ^ x[1] ^ x[0];
            assign yi[5] = x[6] ^ x[4];
            assign yi[4] = x[6] ^ x[3] ^ x[1] ^ x[0];
            assign yi[3] = x[7] ^ x[6] ^ x[4];
            assign yi[2] = x[7] ^ x[5] ^ x[2];
            assign yi[1] = x[4] ^ x[3] ^ x[0];
            assign yi[0] = x[6] ^ x[5] ^ x[4] ^ x[1] ^ x[0];
        end else begin
            assign ye[7] = x[5] ^ x[3];
            assign ye[6] = x[7] ^ x[3];
            assign ye[5] = x[6] ^ x[0];
            assign ye[4] = x[7] ^ x[5] ^ x[3];
            assign ye[3] = x[7] ^ x[6] ^ x[5] ^ x[4] ^ x[3];
            assign ye[2] = x[6] ^ x[5] ^ x[3] ^ x[2] ^ x[0];
            assign ye[1] = x[5] ^ x[4] ^ x[1];
            assign ye[0] = x[6] ^ x[4] ^ x[1];
            
            assign yi[7] = x[4] ^ x[1];
            assign yi[6] = x[7] ^ x[6] ^ x[5] ^ x[3] ^ x[1] ^ x[0];
            assign yi[5] = x[7] ^ x[6] ^ x[5] ^ x[3] ^ x[2] ^ x[0];
            assign yi[4] = x[6] ^ x[1];
            assign yi[3] = x[6] ^ x[5] ^ x[4] ^ x[3] ^ x[2] ^ x[1];
            assign yi[2] = x[7] ^ x[5] ^ x[4] ^ x[1];
            assign yi[1] = x[5] ^ x[1];
            assign yi[0] = x[2];
        end
    endgenerate
    
    assign y = (decrypt ? yi : ye);
endmodule

module sbox #(
    parameter SHARES = 3
)(
    input  logic       clk,
    input  logic       resetn,
    input  logic       enable_i,
    input  logic [7:0] x[0:SHARES-1],
    input  logic [3:0] zm0[0:(SHARES*(SHARES-1)/2)-1],
    input  logic [3:0] zm1[0:(SHARES*(SHARES-1)/2)-1],
    input  logic [3:0] zm2[0:(SHARES*(SHARES-1)/2)-1],
    input  logic [1:0] zi0[0:(SHARES*(SHARES-1)/2)-1],
    input  logic [1:0] zi1[0:(SHARES*(SHARES-1)/2)-1],
    input  logic [1:0] zi2[0:(SHARES*(SHARES-1)/2)-1],
    input  logic       decrypt,
    
    output logic [7:0] q[0:SHARES-1]
);
    integer i;
    genvar k;
    
    // -----------------------------------------------------------------------------
    // Stage 1: Linear Transform 
    
    logic [7:0] x0, y[0:SHARES-1], y_r[0:SHARES-1];
    
    assign x0 = (decrypt ? x[0] ^ 8'h63 : x[0]);
    
    generate
        LINEAR_TRANSFORM transform0(x0, decrypt, y[0]);
        
        for (k = 1; k < SHARES; k++) begin
            LINEAR_TRANSFORM transform(x[k], decrypt, y[k]);
        end
    endgenerate
    
    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            y_r <= '{default: 'd0};
        end else if (enable_i) begin
            y_r <= y;
        end
    end
    
    // -----------------------------------------------------------------------------
    // Stage 2: Scaling & Multiplier (GF(2^4))
    
    logic [3:0] y_hi[0:SHARES-1], y_lo[0:SHARES-1];
    logic [3:0] y_hi_r0[0:SHARES-1], y_lo_r0[0:SHARES-1];
        
    logic [3:0] s0  [0:SHARES-1], s0_r[0:SHARES-1], m0[0:SHARES-1];
    
    generate
        for (k = 0; k < SHARES; k++) begin
            assign y_hi[k] = y_r[k][7:4];
            assign y_lo[k] = y_r[k][3:0];
            
            GF_SCALE #(4) scale0(y_hi[k] ^ y_lo[k], s0[k]);
        end
    endgenerate
    
    GF_SHARED_MUL #(4, SHARES) mul0(clk, resetn, enable_i, y_hi, y_lo, zm0, m0);
    
    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            y_hi_r0 <= '{default: 'd0};
            y_lo_r0 <= '{default: 'd0};
            s0_r    <= '{default: 'd0};
        end else if (enable_i) begin
            y_hi_r0 <= y_hi;
            y_lo_r0 <= y_lo;
            s0_r    <= s0;
        end
    end

    // -----------------------------------------------------------------------------
    // Stage 3: Recombine Mult & Scale (GF(2^4))
    
    logic [3:0] t_r[0:SHARES-1];
    
    logic [3:0] y_hi_r1[0:SHARES-1], y_lo_r1[0:SHARES-1];

    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            y_hi_r1 <= '{default: 'd0};
            y_lo_r1 <= '{default: 'd0};
            t_r     <= '{default: 'd0};
        end else if (enable_i) begin
            y_hi_r1 <= y_hi_r0;
            y_lo_r1 <= y_lo_r0;
            
            for (i = 0; i < SHARES; i++) t_r[i] <= s0_r[i] ^ m0[i];
        end
    end
    
    // -----------------------------------------------------------------------------
    // Stage 4: Scaling & Multiplier (GF(2^2))
    
    logic [1:0] t_hi[0:SHARES-1], t_lo[0:SHARES-1];
    logic [1:0] t_hi_r0[0:SHARES-1], t_lo_r0[0:SHARES-1];
        
    logic [1:0] s1  [0:SHARES-1], s1_r[0:SHARES-1], m1[0:SHARES-1];
    
    logic [3:0] y_hi_r2[0:SHARES-1], y_lo_r2[0:SHARES-1];
    
    generate
        for (k = 0; k < SHARES; k++) begin
            assign t_hi[k] = t_r[k][3:2];
            assign t_lo[k] = t_r[k][1:0];
            
            GF_SCALE #(2) scale1(t_hi[k] ^ t_lo[k], s1[k]);
        end
    endgenerate
    
    GF_SHARED_MUL #(2, SHARES) mul1(clk, resetn, enable_i, t_hi, t_lo, zi0, m1);
    
    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            t_hi_r0 <= '{default: 'd0};
            t_lo_r0 <= '{default: 'd0};
            y_hi_r2 <= '{default: 'd0};
            y_lo_r2 <= '{default: 'd0};
            s1_r    <= '{default: 'd0};
        end else if (enable_i) begin
            t_hi_r0 <= t_hi;
            t_lo_r0 <= t_lo;
            y_hi_r2 <= y_hi_r1;
            y_lo_r2 <= y_lo_r1;
            s1_r    <= s1;
        end
    end
    
    // -----------------------------------------------------------------------------
    // Stage 5: Recombine & Invert (GF(2^2))
    
    logic [1:0] o_r[0:SHARES-1];
    
    logic [1:0] t_hi_r1[0:SHARES-1], t_lo_r1[0:SHARES-1];
    logic [3:0] y_hi_r3[0:SHARES-1], y_lo_r3[0:SHARES-1];

    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            t_hi_r1 <= '{default: 'd0};
            t_lo_r1 <= '{default: 'd0};
            y_hi_r3 <= '{default: 'd0};
            y_lo_r3 <= '{default: 'd0};
            o_r     <= '{default: 'd0};
        end else if (enable_i) begin
            t_hi_r1 <= t_hi_r0;
            t_lo_r1 <= t_lo_r0;
            y_hi_r3 <= y_hi_r2;
            y_lo_r3 <= y_lo_r2;
            
            for (i = 0; i < SHARES; i++) o_r[i] <= {s1_r[i][0] ^ m1[i][0], s1_r[i][1] ^ m1[i][1]};
        end
    end
    
    // -----------------------------------------------------------------------------
    // Stage 6: Multiply with inversion result (GF(2^2))
    
    logic [1:0] i0[0:SHARES-1], i1[0:SHARES-1];
    
    logic [3:0] y_hi_r4[0:SHARES-1], y_lo_r4[0:SHARES-1];
    
    GF_SHARED_MUL #(2, SHARES) mul2(clk, resetn, enable_i, o_r, t_hi_r1, zi1, i0);
    GF_SHARED_MUL #(2, SHARES) mul3(clk, resetn, enable_i, o_r, t_lo_r1, zi2, i1);

    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            y_hi_r4 <= '{default: 'd0};
            y_lo_r4 <= '{default: 'd0};
        end else if (enable_i) begin
            y_hi_r4 <= y_hi_r3;
            y_lo_r4 <= y_lo_r3;
        end
    end
    
    // -----------------------------------------------------------------------------
    // Stage 7: Recombine & Multiply by inversion result (GF(2^4))
    
    logic [3:0] inv[0:SHARES-1], d0[0:SHARES-1], d1[0:SHARES-1];
    
    generate
        for (k = 0; k < SHARES; k++) begin
            assign inv[k] = {i1[k], i0[k]};
        end
    endgenerate
    
    GF_SHARED_MUL #(4, SHARES) mul4(clk, resetn, enable_i, inv, y_hi_r4, zm1, d0);
    GF_SHARED_MUL #(4, SHARES) mul5(clk, resetn, enable_i, inv, y_lo_r4, zm2, d1);
    
// -----------------------------------------------------------------------------
    // Stage 8: Linear Transform 
    
    logic [7:0] d[0:SHARES-1], l[0:SHARES-1];
    generate
        for (k = 0; k < SHARES; k++) begin
            assign d[k] = {d1[k], d0[k]};
            
            LINEAR_TRANSFORM #(0) inv_transform(d[k], decrypt, l[k]);
            
            if (k > 0) assign q[k] = l[k];
        end
        
        assign q[0] = (decrypt ? l[0] : l[0] ^ 8'h63);
    endgenerate

endmodule
