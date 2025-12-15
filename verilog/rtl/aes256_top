module aes256_top #(
    parameter SHARES = 3
)(
    input  logic clk,
    input  logic resetn,
    input  logic enable_i,
    
    input  logic [127:0] c_i,
    input  logic         cvalid_i,
    input  logic [127:0] iv_i,
    input  logic         ivalid_i,
    input  logic [255:0] k_i,
    input  logic         kvalid_i,

    input  logic [127:0] seed_i,
    
    // Outputs
    output logic [127:0] plain_o,
    output logic         ready_o,
    output logic         valid_o
);
    // AES Control Signals
    logic exp_valid, exp_ready, dec_ready;
    
    // Latches
    logic l_kvalid, l_ivalid;
    logic [255:0] l_key;
    logic [127:0] l_iv;

    aes_latch #(256) key_latch(clk, resetn, enable_i, exp_ready, k_i,  kvalid_i, l_key, l_kvalid);
    aes_latch #(128)  iv_latch(clk, resetn, enable_i, dec_ready, iv_i, ivalid_i, l_iv,  l_ivalid);
    
    // RNG
    logic [255:0] masks[0:SHARES-2];
    logic [3:0]   zm0[0:(SHARES*(SHARES-1)/2)-1], zm1[0:(SHARES*(SHARES-1)/2)-1], zm2[0:(SHARES*(SHARES-1)/2)-1];
    logic [1:0]   zi0[0:(SHARES*(SHARES-1)/2)-1], zi1[0:(SHARES*(SHARES-1)/2)-1], zi2[0:(SHARES*(SHARES-1)/2)-1];
    logic         rng_valid;
    
    aes_rng #(SHARES) rng_mod(clk, resetn, enable_i, seed_i, masks, zm0, zm1, zm2, zi0, zi1, zi2, rng_valid);
    
    // Shares
    logic [255:0] k_shared[0:SHARES-1];
    logic [127:0] c_shared[0:SHARES-1], iv_shared[0:SHARES-1];
    logic [127:0] small_masks[0:SHARES-2];
    
    genvar i;
    generate
        for (i = 0; i < SHARES - 1; i++) assign small_masks[i] = masks[i][127:0];
    endgenerate

    masker #(SHARES, 256) k_masker(l_key, masks, k_shared);
    
    masker #(SHARES, 128) iv_masker(l_iv, small_masks, iv_shared);
    masker #(SHARES, 128)  c_masker(c_i,  small_masks,  c_shared);
    
    // Sbox
    logic [7:0] k_sbox[0:SHARES-1], d_sbox[0:SHARES-1];
    logic [7:0] sbox_i[0:SHARES-1], sbox_o[0:SHARES-1];
    logic       sbox_mode;
    
    assign sbox_i    = (exp_valid ? d_sbox : k_sbox);
    
    sbox #(SHARES) sbox(clk, resetn, enable_i, sbox_i, zm0, zm1, zm2, zi0, zi1, zi2, exp_valid, sbox_o);
    
    // Key Expansion
    logic [127:0] w[0:SHARES-1];
    logic [3:0]   waddr;
    
    assign exp_ready = rng_valid & l_kvalid;
    
    aes256_key_expansion #(SHARES) key_expansion(clk, resetn, enable_i, k_shared, exp_ready, k_sbox, sbox_o, waddr, w, exp_valid);
    
    // AES Mux
    logic [127:0] mux_out[0:SHARES-1];
    logic [1:0]   mux_sel;
    logic         mux_valid;
    
    aes_mux #(SHARES) mux(w, exp_valid, iv_shared, l_ivalid, c_shared, cvalid_i, mux_sel, mux_out, mux_valid);
    
    // AES Decryption
    aes256_dec #(SHARES) dec(clk, resetn, enable_i, mux_out, mux_valid, d_sbox, sbox_o, plain_o, dec_ready, valid_o, waddr, mux_sel);
    
    assign ready_o = dec_ready;

endmodule
