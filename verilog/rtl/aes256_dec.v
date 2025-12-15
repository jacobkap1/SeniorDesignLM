// -----------------------------------------------------------------------------
// aes256_dec.v 
// -----------------------------------------------------------------------------
// - byte-sequential sbox, (SHARES-1)-th order secure
// - Active-high enable_i, active-low resetn
// - Streaming input with bvalid_i
// - 'valid_o' pulses after block is done
// ----------------------------------------------------------------------------- 
`timescale 1ns/1ps
module aes256_dec #(
    parameter SHARES = 3
)(
    // control
    input  logic         clk,
    input  logic         resetn,
    input  logic         enable_i,

    // muxed input
    // can either be key round shares, iv shares or cipher shares
    input  logic [127:0] b_i[0:SHARES-1],
    input  logic         bvalid_i,
    
    // sbox
    output logic [7:0]   sbox_i[0:SHARES-1],
    input  logic [7:0]   sbox_o[0:SHARES-1],
    
    // plaintext
    output logic [127:0] plain_o,

    // outputs
    output logic         ready_o,
    output logic         valid_o,
    output logic [3:0]   round_o,
    output logic [1:0]   sel_o
);
    int i, j, o;
    // --------------------------------------------------- ROM ---------------------------------------------------
    localparam logic [7:0] gmul_09[0:255] = '{
        8'h00, 8'h09, 8'h12, 8'h1b, 8'h24, 8'h2d, 8'h36, 8'h3f, 8'h48, 8'h41, 8'h5a, 8'h53, 8'h6c, 8'h65, 8'h7e, 8'h77,
        8'h90, 8'h99, 8'h82, 8'h8b, 8'hb4, 8'hbd, 8'ha6, 8'haf, 8'hd8, 8'hd1, 8'hca, 8'hc3, 8'hfc, 8'hf5, 8'hee, 8'he7,
        8'h3b, 8'h32, 8'h29, 8'h20, 8'h1f, 8'h16, 8'h0d, 8'h04, 8'h73, 8'h7a, 8'h61, 8'h68, 8'h57, 8'h5e, 8'h45, 8'h4c,
        8'hab, 8'ha2, 8'hb9, 8'hb0, 8'h8f, 8'h86, 8'h9d, 8'h94, 8'he3, 8'hea, 8'hf1, 8'hf8, 8'hc7, 8'hce, 8'hd5, 8'hdc,
        8'h76, 8'h7f, 8'h64, 8'h6d, 8'h52, 8'h5b, 8'h40, 8'h49, 8'h3e, 8'h37, 8'h2c, 8'h25, 8'h1a, 8'h13, 8'h08, 8'h01,
        8'he6, 8'hef, 8'hf4, 8'hfd, 8'hc2, 8'hcb, 8'hd0, 8'hd9, 8'hae, 8'ha7, 8'hbc, 8'hb5, 8'h8a, 8'h83, 8'h98, 8'h91,
        8'h4d, 8'h44, 8'h5f, 8'h56, 8'h69, 8'h60, 8'h7b, 8'h72, 8'h05, 8'h0c, 8'h17, 8'h1e, 8'h21, 8'h28, 8'h33, 8'h3a,
        8'hdd, 8'hd4, 8'hcf, 8'hc6, 8'hf9, 8'hf0, 8'heb, 8'he2, 8'h95, 8'h9c, 8'h87, 8'h8e, 8'hb1, 8'hb8, 8'ha3, 8'haa,
        8'hec, 8'he5, 8'hfe, 8'hf7, 8'hc8, 8'hc1, 8'hda, 8'hd3, 8'ha4, 8'had, 8'hb6, 8'hbf, 8'h80, 8'h89, 8'h92, 8'h9b,
        8'h7c, 8'h75, 8'h6e, 8'h67, 8'h58, 8'h51, 8'h4a, 8'h43, 8'h34, 8'h3d, 8'h26, 8'h2f, 8'h10, 8'h19, 8'h02, 8'h0b,
        8'hd7, 8'hde, 8'hc5, 8'hcc, 8'hf3, 8'hfa, 8'he1, 8'he8, 8'h9f, 8'h96, 8'h8d, 8'h84, 8'hbb, 8'hb2, 8'ha9, 8'ha0,
        8'h47, 8'h4e, 8'h55, 8'h5c, 8'h63, 8'h6a, 8'h71, 8'h78, 8'h0f, 8'h06, 8'h1d, 8'h14, 8'h2b, 8'h22, 8'h39, 8'h30,
        8'h9a, 8'h93, 8'h88, 8'h81, 8'hbe, 8'hb7, 8'hac, 8'ha5, 8'hd2, 8'hdb, 8'hc0, 8'hc9, 8'hf6, 8'hff, 8'he4, 8'hed,
        8'h0a, 8'h03, 8'h18, 8'h11, 8'h2e, 8'h27, 8'h3c, 8'h35, 8'h42, 8'h4b, 8'h50, 8'h59, 8'h66, 8'h6f, 8'h74, 8'h7d,
        8'ha1, 8'ha8, 8'hb3, 8'hba, 8'h85, 8'h8c, 8'h97, 8'h9e, 8'he9, 8'he0, 8'hfb, 8'hf2, 8'hcd, 8'hc4, 8'hdf, 8'hd6,
        8'h31, 8'h38, 8'h23, 8'h2a, 8'h15, 8'h1c, 8'h07, 8'h0e, 8'h79, 8'h70, 8'h6b, 8'h62, 8'h5d, 8'h54, 8'h4f, 8'h46
    };

    localparam logic [7:0] gmul_0b[0:255] = '{
        8'h00, 8'h0b, 8'h16, 8'h1d, 8'h2c, 8'h27, 8'h3a, 8'h31, 8'h58, 8'h53, 8'h4e, 8'h45, 8'h74, 8'h7f, 8'h62, 8'h69,
        8'hb0, 8'hbb, 8'ha6, 8'had, 8'h9c, 8'h97, 8'h8a, 8'h81, 8'he8, 8'he3, 8'hfe, 8'hf5, 8'hc4, 8'hcf, 8'hd2, 8'hd9,
        8'h7b, 8'h70, 8'h6d, 8'h66, 8'h57, 8'h5c, 8'h41, 8'h4a, 8'h23, 8'h28, 8'h35, 8'h3e, 8'h0f, 8'h04, 8'h19, 8'h12,
        8'hcb, 8'hc0, 8'hdd, 8'hd6, 8'he7, 8'hec, 8'hf1, 8'hfa, 8'h93, 8'h98, 8'h85, 8'h8e, 8'hbf, 8'hb4, 8'ha9, 8'ha2,
        8'hf6, 8'hfd, 8'he0, 8'heb, 8'hda, 8'hd1, 8'hcc, 8'hc7, 8'hae, 8'ha5, 8'hb8, 8'hb3, 8'h82, 8'h89, 8'h94, 8'h9f,
        8'h46, 8'h4d, 8'h50, 8'h5b, 8'h6a, 8'h61, 8'h7c, 8'h77, 8'h1e, 8'h15, 8'h08, 8'h03, 8'h32, 8'h39, 8'h24, 8'h2f,
        8'h8d, 8'h86, 8'h9b, 8'h90, 8'ha1, 8'haa, 8'hb7, 8'hbc, 8'hd5, 8'hde, 8'hc3, 8'hc8, 8'hf9, 8'hf2, 8'hef, 8'he4,
        8'h3d, 8'h36, 8'h2b, 8'h20, 8'h11, 8'h1a, 8'h07, 8'h0c, 8'h65, 8'h6e, 8'h73, 8'h78, 8'h49, 8'h42, 8'h5f, 8'h54,
        8'hf7, 8'hfc, 8'he1, 8'hea, 8'hdb, 8'hd0, 8'hcd, 8'hc6, 8'haf, 8'ha4, 8'hb9, 8'hb2, 8'h83, 8'h88, 8'h95, 8'h9e,
        8'h47, 8'h4c, 8'h51, 8'h5a, 8'h6b, 8'h60, 8'h7d, 8'h76, 8'h1f, 8'h14, 8'h09, 8'h02, 8'h33, 8'h38, 8'h25, 8'h2e,
        8'h8c, 8'h87, 8'h9a, 8'h91, 8'ha0, 8'hab, 8'hb6, 8'hbd, 8'hd4, 8'hdf, 8'hc2, 8'hc9, 8'hf8, 8'hf3, 8'hee, 8'he5,
        8'h3c, 8'h37, 8'h2a, 8'h21, 8'h10, 8'h1b, 8'h06, 8'h0d, 8'h64, 8'h6f, 8'h72, 8'h79, 8'h48, 8'h43, 8'h5e, 8'h55,
        8'h01, 8'h0a, 8'h17, 8'h1c, 8'h2d, 8'h26, 8'h3b, 8'h30, 8'h59, 8'h52, 8'h4f, 8'h44, 8'h75, 8'h7e, 8'h63, 8'h68,
        8'hb1, 8'hba, 8'ha7, 8'hac, 8'h9d, 8'h96, 8'h8b, 8'h80, 8'he9, 8'he2, 8'hff, 8'hf4, 8'hc5, 8'hce, 8'hd3, 8'hd8,
        8'h7a, 8'h71, 8'h6c, 8'h67, 8'h56, 8'h5d, 8'h40, 8'h4b, 8'h22, 8'h29, 8'h34, 8'h3f, 8'h0e, 8'h05, 8'h18, 8'h13,
        8'hca, 8'hc1, 8'hdc, 8'hd7, 8'he6, 8'hed, 8'hf0, 8'hfb, 8'h92, 8'h99, 8'h84, 8'h8f, 8'hbe, 8'hb5, 8'ha8, 8'ha3
    };

    localparam logic [7:0] gmul_0d[0:255] = '{
        8'h00, 8'h0d, 8'h1a, 8'h17, 8'h34, 8'h39, 8'h2e, 8'h23, 8'h68, 8'h65, 8'h72, 8'h7f, 8'h5c, 8'h51, 8'h46, 8'h4b,
        8'hd0, 8'hdd, 8'hca, 8'hc7, 8'he4, 8'he9, 8'hfe, 8'hf3, 8'hb8, 8'hb5, 8'ha2, 8'haf, 8'h8c, 8'h81, 8'h96, 8'h9b,
        8'hbb, 8'hb6, 8'ha1, 8'hac, 8'h8f, 8'h82, 8'h95, 8'h98, 8'hd3, 8'hde, 8'hc9, 8'hc4, 8'he7, 8'hea, 8'hfd, 8'hf0,
        8'h6b, 8'h66, 8'h71, 8'h7c, 8'h5f, 8'h52, 8'h45, 8'h48, 8'h03, 8'h0e, 8'h19, 8'h14, 8'h37, 8'h3a, 8'h2d, 8'h20,
        8'h6d, 8'h60, 8'h77, 8'h7a, 8'h59, 8'h54, 8'h43, 8'h4e, 8'h05, 8'h08, 8'h1f, 8'h12, 8'h31, 8'h3c, 8'h2b, 8'h26,
        8'hbd, 8'hb0, 8'ha7, 8'haa, 8'h89, 8'h84, 8'h93, 8'h9e, 8'hd5, 8'hd8, 8'hcf, 8'hc2, 8'he1, 8'hec, 8'hfb, 8'hf6,
        8'hd6, 8'hdb, 8'hcc, 8'hc1, 8'he2, 8'hef, 8'hf8, 8'hf5, 8'hbe, 8'hb3, 8'ha4, 8'ha9, 8'h8a, 8'h87, 8'h90, 8'h9d,
        8'h06, 8'h0b, 8'h1c, 8'h11, 8'h32, 8'h3f, 8'h28, 8'h25, 8'h6e, 8'h63, 8'h74, 8'h79, 8'h5a, 8'h57, 8'h40, 8'h4d,
        8'hda, 8'hd7, 8'hc0, 8'hcd, 8'hee, 8'he3, 8'hf4, 8'hf9, 8'hb2, 8'hbf, 8'ha8, 8'ha5, 8'h86, 8'h8b, 8'h9c, 8'h91,
        8'h0a, 8'h07, 8'h10, 8'h1d, 8'h3e, 8'h33, 8'h24, 8'h29, 8'h62, 8'h6f, 8'h78, 8'h75, 8'h56, 8'h5b, 8'h4c, 8'h41,
        8'h61, 8'h6c, 8'h7b, 8'h76, 8'h55, 8'h58, 8'h4f, 8'h42, 8'h09, 8'h04, 8'h13, 8'h1e, 8'h3d, 8'h30, 8'h27, 8'h2a,
        8'hb1, 8'hbc, 8'hab, 8'ha6, 8'h85, 8'h88, 8'h9f, 8'h92, 8'hd9, 8'hd4, 8'hc3, 8'hce, 8'hed, 8'he0, 8'hf7, 8'hfa,
        8'hb7, 8'hba, 8'had, 8'ha0, 8'h83, 8'h8e, 8'h99, 8'h94, 8'hdf, 8'hd2, 8'hc5, 8'hc8, 8'heb, 8'he6, 8'hf1, 8'hfc,
        8'h67, 8'h6a, 8'h7d, 8'h70, 8'h53, 8'h5e, 8'h49, 8'h44, 8'h0f, 8'h02, 8'h15, 8'h18, 8'h3b, 8'h36, 8'h21, 8'h2c,
        8'h0c, 8'h01, 8'h16, 8'h1b, 8'h38, 8'h35, 8'h22, 8'h2f, 8'h64, 8'h69, 8'h7e, 8'h73, 8'h50, 8'h5d, 8'h4a, 8'h47,
        8'hdc, 8'hd1, 8'hc6, 8'hcb, 8'he8, 8'he5, 8'hf2, 8'hff, 8'hb4, 8'hb9, 8'hae, 8'ha3, 8'h80, 8'h8d, 8'h9a, 8'h97
    };

    localparam logic [7:0] gmul_0e[0:255] = '{
        8'h00, 8'h0e, 8'h1c, 8'h12, 8'h38, 8'h36, 8'h24, 8'h2a, 8'h70, 8'h7e, 8'h6c, 8'h62, 8'h48, 8'h46, 8'h54, 8'h5a,
        8'he0, 8'hee, 8'hfc, 8'hf2, 8'hd8, 8'hd6, 8'hc4, 8'hca, 8'h90, 8'h9e, 8'h8c, 8'h82, 8'ha8, 8'ha6, 8'hb4, 8'hba,
        8'hdb, 8'hd5, 8'hc7, 8'hc9, 8'he3, 8'hed, 8'hff, 8'hf1, 8'hab, 8'ha5, 8'hb7, 8'hb9, 8'h93, 8'h9d, 8'h8f, 8'h81,
        8'h3b, 8'h35, 8'h27, 8'h29, 8'h03, 8'h0d, 8'h1f, 8'h11, 8'h4b, 8'h45, 8'h57, 8'h59, 8'h73, 8'h7d, 8'h6f, 8'h61,
        8'had, 8'ha3, 8'hb1, 8'hbf, 8'h95, 8'h9b, 8'h89, 8'h87, 8'hdd, 8'hd3, 8'hc1, 8'hcf, 8'he5, 8'heb, 8'hf9, 8'hf7,
        8'h4d, 8'h43, 8'h51, 8'h5f, 8'h75, 8'h7b, 8'h69, 8'h67, 8'h3d, 8'h33, 8'h21, 8'h2f, 8'h05, 8'h0b, 8'h19, 8'h17,
        8'h76, 8'h78, 8'h6a, 8'h64, 8'h4e, 8'h40, 8'h52, 8'h5c, 8'h06, 8'h08, 8'h1a, 8'h14, 8'h3e, 8'h30, 8'h22, 8'h2c,
        8'h96, 8'h98, 8'h8a, 8'h84, 8'hae, 8'ha0, 8'hb2, 8'hbc, 8'he6, 8'he8, 8'hfa, 8'hf4, 8'hde, 8'hd0, 8'hc2, 8'hcc,
        8'h41, 8'h4f, 8'h5d, 8'h53, 8'h79, 8'h77, 8'h65, 8'h6b, 8'h31, 8'h3f, 8'h2d, 8'h23, 8'h09, 8'h07, 8'h15, 8'h1b,
        8'ha1, 8'haf, 8'hbd, 8'hb3, 8'h99, 8'h97, 8'h85, 8'h8b, 8'hd1, 8'hdf, 8'hcd, 8'hc3, 8'he9, 8'he7, 8'hf5, 8'hfb,
        8'h9a, 8'h94, 8'h86, 8'h88, 8'ha2, 8'hac, 8'hbe, 8'hb0, 8'hea, 8'he4, 8'hf6, 8'hf8, 8'hd2, 8'hdc, 8'hce, 8'hc0,
        8'h7a, 8'h74, 8'h66, 8'h68, 8'h42, 8'h4c, 8'h5e, 8'h50, 8'h0a, 8'h04, 8'h16, 8'h18, 8'h32, 8'h3c, 8'h2e, 8'h20,
        8'hec, 8'he2, 8'hf0, 8'hfe, 8'hd4, 8'hda, 8'hc8, 8'hc6, 8'h9c, 8'h92, 8'h80, 8'h8e, 8'ha4, 8'haa, 8'hb8, 8'hb6,
        8'h0c, 8'h02, 8'h10, 8'h1e, 8'h34, 8'h3a, 8'h28, 8'h26, 8'h7c, 8'h72, 8'h60, 8'h6e, 8'h44, 8'h4a, 8'h58, 8'h56,
        8'h37, 8'h39, 8'h2b, 8'h25, 8'h0f, 8'h01, 8'h13, 8'h1d, 8'h47, 8'h49, 8'h5b, 8'h55, 8'h7f, 8'h71, 8'h63, 8'h6d,
        8'hd7, 8'hd9, 8'hcb, 8'hc5, 8'hef, 8'he1, 8'hf3, 8'hfd, 8'ha7, 8'ha9, 8'hbb, 8'hb5, 8'h9f, 8'h91, 8'h83, 8'h8d
    };
    
    // ------------------------------------------------ Functions ------------------------------------------------
    function logic [127:0] InvShiftRows(input logic [127:0] s);
        logic [7:0] st[0:15];
        {st[15], st[14], st[13], st[12],
         st[11], st[10], st[ 9], st[ 8],
         st[ 7], st[ 6], st[ 5], st[ 4],
         st[ 3], st[ 2], st[ 1], st[ 0]} = s;

        InvShiftRows = {st[15], st[ 2], st[ 5], st[ 8],
                        st[11], st[14], st[ 1], st[ 4],
                        st[ 7], st[10], st[13], st[ 0],
                        st[ 3], st[ 6], st[ 9], st[12]};
    endfunction
    
    function logic [127:0] InvMixColumns(input logic [127:0] s);
        logic [7:0] st[0:15], a0, a1, a2, a3;
        {st[15], st[14], st[13], st[12],
         st[11], st[10], st[ 9], st[ 8],
         st[ 7], st[ 6], st[ 5], st[ 4],
         st[ 3], st[ 2], st[ 1], st[ 0]} = s;

        for (j = 0; j < 16; j = j + 4) begin
            a0 = st[j+3];
            a1 = st[j+2];
            a2 = st[j+1];
            a3 = st[j];
        
            st[j+3] = gmul_0e[a0] ^ gmul_0b[a1] ^ gmul_0d[a2] ^ gmul_09[a3];
            st[j+2] = gmul_09[a0] ^ gmul_0e[a1] ^ gmul_0b[a2] ^ gmul_0d[a3];
            st[j+1] = gmul_0d[a0] ^ gmul_09[a1] ^ gmul_0e[a2] ^ gmul_0b[a3];
            st[j]   = gmul_0b[a0] ^ gmul_0d[a1] ^ gmul_09[a2] ^ gmul_0e[a3];
        end

        InvMixColumns = {st[15], st[14], st[13], st[12],
                         st[11], st[10], st[ 9], st[ 8],
                         st[ 7], st[ 6], st[ 5], st[ 4],
                         st[ 3], st[ 2], st[ 1], st[ 0]};
    endfunction
    

    function logic [127:0] AddRoundKey(input logic [127:0] s, input logic [127:0] w);
        AddRoundKey = s ^ w;
    endfunction

    // ------------------------------------------------ Registers ------------------------------------------------
    // Working/state logics
    logic [127:0] P[0:SHARES-1];
    logic [127:0] s[0:SHARES-1];
    logic [127:0] s_tmp[0:SHARES-1];
    
    logic [127:0] C     [0:SHARES-1];
    logic [127:0] C_prev[0:SHARES-1];
    logic [7:0]   byte_i[0:SHARES-1];
    logic [7:0]   byte_o[0:SHARES-1];
    
    logic [127:0] w[0:SHARES-1][0:14];
    logic [3:0]   t;
    
    logic [2:0] p;
    logic [3:0] idx_i, idx_o;

    // ------------------------------------------- Next/Derived States -------------------------------------------
    assign sbox_i = byte_i;
    assign byte_o = sbox_o;
    
    logic [7:0] st [0:SHARES-1][0:15];
    logic [7:0] s_o[0:SHARES-1][0:15];
    
    genvar k, l;
    generate
        for (k = 0; k < SHARES; k++) begin
            for (l = 0; l < 16; l++) begin
                assign st[k][l] = s[k][8*l+7:8*l];
            end
        end
    endgenerate
    
    // --------------------------------------------------- FSM ---------------------------------------------------
    // FSM
    typedef enum logic [2:0] {LOAD_W, LOAD_IV, LOAD_S, FIRST, SUBBYTES, ROUND, UPDATE} state_t;
    state_t state;

    // ------------------------------------------ Main sequential block ------------------------------------------
    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            P      <= '{default:128'd0};
            s      <= '{default:128'd0};
            C      <= '{default:128'd0};
            C_prev <= '{default:128'd0};
            byte_i <= '{default:8'd0};
            
            w <= '{default:'{default:128'd0}};
            
            sel_o   <= 2'd0;
            round_o <= 4'd0;
            
            state <= LOAD_W;
            t     <= 4'b0;
            
            p     <= 3'd0;
            idx_i <= 4'd0;
            idx_o <= 4'd0;
            
        end else if (enable_i) begin
            valid_o <= 1'b0;
            // ---------------- accept input blocks ----------------
            
            // --- FSM ---
            case(state)
                LOAD_W: begin
                    if (bvalid_i) begin
                        // mux points to key round shares: store internally
                        for (i = 0; i < SHARES; i++) begin
                            w[i][t] <= b_i[i];
                        end
                        
                        if (t >= 4'd14) begin
                            sel_o <= 2'd1;
                            state <= LOAD_IV;
                        end else begin
                            round_o <= round_o + 1;
                            t       <= t + 1;
                        end
                    end
                end
                
                LOAD_IV: begin
                    if (bvalid_i) begin
                        // mux points to iv
                        C_prev <= b_i;
                        
                        sel_o <= 2'd2;
                        state <= LOAD_S;
                    end
                end
                
                LOAD_S: begin
                    if (bvalid_i) begin
                        // mux points to actual ciphertext block
                        s     <= b_i;
                        C     <= b_i;
                        state <= FIRST;
                    end
                end
                
                FIRST: begin
                    // first round
                    for (i = 0; i < SHARES; i++) begin
                        s_tmp[i] = InvShiftRows(AddRoundKey(s[i], w[i][14]));
                        
                        s[i] <= s_tmp[i];
                        
                        byte_i[i] = s_tmp[i][7:0];
                    end
                    
                    t     <= 4'd13;
                    p     <= 3'd0;
                    idx_i <= 4'd1;
                    idx_o <= 4'd0;
                    state <= SUBBYTES;
                end
                
                SUBBYTES: begin
                    if (idx_i > 0) begin
                        for (i = 0; i < SHARES; i++) begin
                            byte_i[i] = st[i][idx_i];
                        end
                        idx_i++;
                    end
                    
                    if (p == 3'd7) begin
                        for (i = 0; i < SHARES; i++) begin
                            s_o[i][idx_o] <= byte_o[i];
                        end
                        
                        if (idx_o >= 4'd14) state <= ROUND;
                        else idx_o++;
                    end else p++;
                end
                
                ROUND: begin
                    for (i = 0; i < SHARES; i++) begin
                        s_tmp[i] = { byte_o[i], s_o[i][14], s_o[i][13], s_o[i][12],
                                    s_o[i][11], s_o[i][10], s_o[i][ 9], s_o[i][ 8],
                                    s_o[i][ 7], s_o[i][ 6], s_o[i][ 5], s_o[i][ 4],
                                    s_o[i][ 3], s_o[i][ 2], s_o[i][ 1], s_o[i][ 0]};
                    end
                
                    
                    if (t >= 1) begin
                        // round = 1..13
                        for (i = 0; i < SHARES; i++) begin
                            s_tmp[i] = InvShiftRows(InvMixColumns(AddRoundKey(s_tmp[i], w[i][t])));
                            
                            s[i] <= s_tmp[i];
                            
                            byte_i[i] = s_tmp[i][7:0];
                        end
                        
                        t     <= t - 1;
                        p     <= 3'd0;
                        idx_i <= 4'd1;
                        idx_o <= 4'd0;
                        state <= SUBBYTES;
                    end else begin
                        // final round
                        for (i = 0; i < SHARES; i++) begin
                            s[i] <= AddRoundKey(s_tmp[i], w[i][t]);
                        end
                        
                        state <= UPDATE;
                    end
                end
                
                UPDATE: begin
                    valid_o <= 1'b1;
                    for (i = 0; i < SHARES; i++) begin
                        P[i] <= s[i] ^ C_prev[i];
                    end
                    
                    C_prev <= C;
                    state <= LOAD_S;
                end
                
                default: begin
                    state <= LOAD_W;
                end
            endcase
        end
    end
    
    // ------------------------------------------------- Outputs ------------------------------------------------- 
    logic [127:0] result;
    
    always_comb begin
        result = 128'd0;
        for (o = 0; o < SHARES; o++) begin
            result ^= P[o];
        end
    end
    
    assign plain_o = result;
    assign ready_o = state == LOAD_S;
endmodule
