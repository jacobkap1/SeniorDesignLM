//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Sat Apr 11 12:05:51 2026
// Version: 2025.2 2025.2.0.14
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// csprng
module csprng(
    // Inputs
    clk,
    enable_i,
    resetn,
    // Outputs
    valid_o,
    z
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input         clk;
input         enable_i;
input         resetn;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output        valid_o;
output [63:0] z;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          clk;
wire          enable_i;
wire   [7:0]  neoTRNG_0_data_o;
wire          neoTRNG_0_valid_o;
wire          resetn;
wire          timer_0_out;
wire   [63:0] trng_acc_0_seed_o;
wire          trng_acc_0_valid_o;
wire          valid_o_net_0;
wire   [63:0] z_net_0;
wire          valid_o_net_1;
wire   [63:0] z_net_1;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign valid_o_net_1 = valid_o_net_0;
assign valid_o       = valid_o_net_1;
assign z_net_1       = z_net_0;
assign z[63:0]       = z_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------neoTRNG
neoTRNG neoTRNG_0(
        // Inputs
        .clk_i    ( clk ),
        .rstn_i   ( resetn ),
        .enable_i ( timer_0_out ),
        // Outputs
        .valid_o  ( neoTRNG_0_valid_o ),
        .data_o   ( neoTRNG_0_data_o ) 
        );

//--------timer
timer timer_0(
        // Inputs
        .clk      ( clk ),
        .resetn   ( resetn ),
        .enable_i ( enable_i ),
        // Outputs
        .out      ( timer_0_out ) 
        );

//--------trivium
trivium trivium_0(
        // Inputs
        .clk      ( clk ),
        .resetn   ( resetn ),
        .enable_i ( timer_0_out ),
        .seed_i   ( trng_acc_0_seed_o ),
        .valid_i  ( trng_acc_0_valid_o ),
        // Outputs
        .z        ( z_net_0 ),
        .valid_o  ( valid_o_net_0 ) 
        );

//--------trng_acc
trng_acc trng_acc_0(
        // Inputs
        .clk        ( clk ),
        .resetn     ( resetn ),
        .enable_i   ( timer_0_out ),
        .byte_i     ( neoTRNG_0_data_o ),
        .trng_valid ( neoTRNG_0_valid_o ),
        // Outputs
        .seed_o     ( trng_acc_0_seed_o ),
        .valid_o    ( trng_acc_0_valid_o ) 
        );


endmodule
