// top level file

//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Fri Dec 12 16:10:43 2025
// Version: 2025.1 2025.1.0.14
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// AES256_CBC
module AES256_CBC(
    // Inputs
    c_i,
    clk,
    cvalid_i,
    enable_i,
    iv_i,
    ivalid_i,
    key_i,
    kvalid_i,
    resetn,
    seed_i,
    // Outputs
    plain_o,
    ready_o,
    valid_o
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [127:0] c_i;
input          clk;
input          cvalid_i;
input          enable_i;
input  [127:0] iv_i;
input          ivalid_i;
input  [255:0] key_i;
input          kvalid_i;
input          resetn;
input  [127:0] seed_i;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [127:0] plain_o;
output         ready_o;
output         valid_o;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   [3:0]    aes256_dec_0_round_o;
wire   [1:0]    aes256_dec_0_sel_o;
wire            aes256_key_expansion_0_valid_o;
wire   [127:0]  aes256_key_expansion_0_w0_o;
wire   [127:0]  aes256_key_expansion_0_w1_o;
wire   [127:0]  aes256_key_expansion_0_w2_o;
wire   [127:0]  aes_mux_0_out0_o;
wire   [127:0]  aes_mux_0_out1_o;
wire   [127:0]  aes_mux_0_out2_o;
wire            aes_mux_0_valid_o;
wire            AND2_0_Y;
wire   [127:0]  c_i;
wire            clk;
wire            cvalid_i;
wire            enable_i;
wire   [127:0]  iv_i;
wire            ivalid_i;
wire   [255:0]  key_i;
wire            kvalid_i;
wire   [127:0]  latch128_0_d_o;
wire            latch128_0_valid_o;
wire   [255:0]  latch256_0_d_o;
wire            latch256_0_valid_o;
wire   [127:0]  plain_o_net_0;
wire            ready_o_net_0;
wire            resetn;
wire   [255:0]  rng_0_m0_o;
wire   [255:0]  rng_0_m1_o;
wire   [3455:0] rng_0_rb_o;
wire   [431:0]  rng_0_rw_o;
wire            rng_0_valid_o;
wire   [127:0]  seed_i;
wire            valid_o_net_0;
wire            ready_o_net_1;
wire            valid_o_net_1;
wire   [127:0]  plain_o_net_1;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign ready_o_net_1  = ready_o_net_0;
assign ready_o        = ready_o_net_1;
assign valid_o_net_1  = valid_o_net_0;
assign valid_o        = valid_o_net_1;
assign plain_o_net_1  = plain_o_net_0;
assign plain_o[127:0] = plain_o_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------aes256_dec
aes256_dec aes256_dec_0(
        // Inputs
        .clk      ( clk ),
        .resetn   ( resetn ),
        .enable_i ( enable_i ),
        .bvalid_i ( aes_mux_0_valid_o ),
        .rvalid_i ( rng_0_valid_o ),
        .b0_i     ( aes_mux_0_out0_o ),
        .b1_i     ( aes_mux_0_out1_o ),
        .b2_i     ( aes_mux_0_out2_o ),
        .r_i      ( rng_0_rb_o ),
        // Outputs
        .ready_o  ( ready_o_net_0 ),
        .valid_o  ( valid_o_net_0 ),
        .plain_o  ( plain_o_net_0 ),
        .round_o  ( aes256_dec_0_round_o ),
        .sel_o    ( aes256_dec_0_sel_o ) 
        );

//--------aes256_key_expansion
aes256_key_expansion aes256_key_expansion_0(
        // Inputs
        .clk      ( clk ),
        .resetn   ( resetn ),
        .enable_i ( enable_i ),
        .kvalid_i ( AND2_0_Y ),
        .rvalid_i ( rng_0_valid_o ),
        .k0_i     ( latch256_0_d_o ),
        .k1_i     ( rng_0_m0_o ),
        .k2_i     ( rng_0_m1_o ),
        .r_i      ( rng_0_rw_o ),
        .addr_i   ( aes256_dec_0_round_o ),
        // Outputs
        .valid_o  ( aes256_key_expansion_0_valid_o ),
        .w0_o     ( aes256_key_expansion_0_w0_o ),
        .w1_o     ( aes256_key_expansion_0_w1_o ),
        .w2_o     ( aes256_key_expansion_0_w2_o ) 
        );

//--------aes_mux
aes_mux aes_mux_0(
        // Inputs
        .wvalid_i ( aes256_key_expansion_0_valid_o ),
        .ivalid_i ( latch128_0_valid_o ),
        .cvalid_i ( cvalid_i ),
        .mvalid_i ( rng_0_valid_o ),
        .w0_i     ( aes256_key_expansion_0_w0_o ),
        .w1_i     ( aes256_key_expansion_0_w1_o ),
        .w2_i     ( aes256_key_expansion_0_w2_o ),
        .iv_i     ( latch128_0_d_o ),
        .c_i      ( c_i ),
        .m_i      ( rng_0_m0_o ),
        .sel_i    ( aes256_dec_0_sel_o ),
        // Outputs
        .valid_o  ( aes_mux_0_valid_o ),
        .out0_o   ( aes_mux_0_out0_o ),
        .out1_o   ( aes_mux_0_out1_o ),
        .out2_o   ( aes_mux_0_out2_o ) 
        );

//--------AND2
AND2 AND2_0(
        // Inputs
        .A ( latch256_0_valid_o ),
        .B ( rng_0_valid_o ),
        // Outputs
        .Y ( AND2_0_Y ) 
        );

//--------latch128
latch128 latch128_0(
        // Inputs
        .clk      ( clk ),
        .resetn   ( resetn ),
        .enable_i ( enable_i ),
        .clear_i  ( ready_o_net_0 ),
        .valid_i  ( ivalid_i ),
        .d_i      ( iv_i ),
        // Outputs
        .valid_o  ( latch128_0_valid_o ),
        .d_o      ( latch128_0_d_o ) 
        );

//--------latch256
latch256 latch256_0(
        // Inputs
        .clk      ( clk ),
        .resetn   ( resetn ),
        .enable_i ( enable_i ),
        .clear_i  ( AND2_0_Y ),
        .valid_i  ( kvalid_i ),
        .d_i      ( key_i ),
        // Outputs
        .valid_o  ( latch256_0_valid_o ),
        .d_o      ( latch256_0_d_o ) 
        );

//--------rng
rng rng_0(
        // Inputs
        .clk      ( clk ),
        .resetn   ( resetn ),
        .enable_i ( enable_i ),
        .seed_i   ( seed_i ),
        // Outputs
        .m0_o     ( rng_0_m0_o ),
        .m1_o     ( rng_0_m1_o ),
        .rw_o     ( rng_0_rw_o ),
        .rb_o     ( rng_0_rb_o ),
        .valid_o  ( rng_0_valid_o ) 
        );


endmodule
