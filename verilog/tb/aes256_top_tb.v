`timescale 1ns/1ps

module aes256_top_tb;

    // Clock and reset
    logic clk;
    logic resetn;

    // AES-256 CBC DUT signals
    logic enable_i;
    logic [255:0] key_i;
    logic kvalid_i;
    logic [127:0] iv_i;
    logic ivalid_i;
    logic [127:0] c_i;
    logic cvalid_i;
    logic [127:0] plain_o;
    logic ready_o;
    logic valid_o;

    // Instantiate the AES256_CBC module
    aes256_top dut (
        .clk(clk),
        .resetn(resetn),
        .enable_i(enable_i),
        .c_i(c_i),
        .cvalid_i(cvalid_i),
        .iv_i(iv_i),
        .ivalid_i(ivalid_i),
        .k_i(key_i),
        .kvalid_i(kvalid_i),
        .seed_i(128'd0),
        .plain_o(plain_o),
        .ready_o(ready_o),
        .valid_o(valid_o)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz

    // Simple task to drive key, IV, and ciphertext blocks
    task send_key(input [255:0] key);
        begin
            key_i = key;
            kvalid_i = 1;
            @(posedge clk);
            kvalid_i = 0;
        end
    endtask

    task send_iv(input [127:0] iv);
        begin
            iv_i = iv;
            ivalid_i = 1;
            @(posedge clk);
            ivalid_i = 0;
        end
    endtask

    task send_cipher(input [127:0] block);
        begin
            wait(ready_o);
            c_i = block;
            cvalid_i = 1;
            @(posedge clk);
            cvalid_i = 0;
            @(posedge clk);
        end
    endtask

    // GFSbox Know Answer Test Values
    localparam [255:0] GFSBOX_KEY = 256'b0;
    localparam [127:0] GFSBOX_IV  = 128'h0;
    
    localparam [127:0] GFSBOX_CT[0:4]  = '{
        128'h5c9d844e_d46f9885_085e5d6a_4f94c7d7,
        128'ha9ff75bd_7cf6613d_3731c77c_3b6d0c04,
        128'h623a52fc_ea5d443e_48d9181a_b32c7421,
        128'h38f2c7ae_10612415_d27ca190_d27da8b4,
        128'h1bc704f1_bce135ce_b810341b_216d7abe
    };
    
    localparam [127:0] GFSBOX_PT[0:4]  = '{
        128'h014730f8_0ac625fe_84f026c6_0bfd547d,
        128'h0b24af36_193ce466_5f2825d7_b4749c98,
        128'h761c1fe4_1a18acf2_0d241650_611d90f1,
        128'h8a560769_d605868a_d80d819b_dba03771,
        128'h91fbef2d_15a97816_060bee1f_eaa49afe
    };
    
    // KeySbox Know Answer Test Values
    localparam [127:0] KEYSBOX_IV = 128'b0;
    localparam [127:0] KEYSBOX_PT = 128'h0;
    
    localparam [255:0] KEYSBOX_KEY[0:15] = '{
        256'hc47b0294dbbbee0fec4757f22ffeee3587ca4730c3d33b691df38bab076bc558,
        256'h28d46cffa158533194214a91e712fc2b45b518076675affd910edeca5f41ac64,
        256'hc1cc358b449909a19436cfbb3f852ef8bcb5ed12ac7058325f56e6099aab1a1c,
        256'h984ca75f4ee8d706f46c2d98c0bf4a45f5b00d791c2dfeb191b5ed8e420fd627,
        256'hb43d08a447ac8609baadae4ff12918b9f68fc1653f1269222f123981ded7a92f,
        256'h1d85a181b54cde51f0e098095b2962fdc93b51fe9b88602b3f54130bf76a5bd9,
        256'hdc0eba1f2232a7879ded34ed8428eeb8769b056bbaf8ad77cb65c3541430b4cf,
        256'hf8be9ba615c5a952cabbca24f68f8593039624d524c816acda2c9183bd917cb9,
        256'h797f8b3d176dac5b7e34a2d539c4ef367a16f8635f6264737591c5c07bf57a3e,
        256'h6838d40caf927749c13f0329d331f448e202c73ef52c5f73a37ca635d4c47707,
        256'hccd1bc3c659cd3c59bc437484e3c5c724441da8d6e90ce556cd57d0752663bbc,
        256'h13428b5e4c005e0636dd338405d173ab135dec2a25c22c5df0722d69dcc43887,
        256'h07eb03a08d291d1b07408bf3512ab40c91097ac77461aad4bb859647f74f00ee,
        256'h90143ae20cd78c5d8ebdd6cb9dc1762427a96c78c639bccc41a61424564eafe1,
        256'hb7a5794d52737475d53d5a377200849be0260a67a2b22ced8bbef12882270d07,
        256'hfca02f3d5011cfc5c1e23165d413a049d4526a991827424d896fe3435e0bf68e
    };
    
    localparam [127:0] KEYSBOX_CT[0:15] = '{
        128'h46f2fb342d6f0ab477476fc501242c5f,
        128'h4bf3b0a69aeb6657794f2901b1440ad4,
        128'h352065272169abf9856843927d0674fd,
        128'h4307456a9e67813b452e15fa8fffe398,
        128'h4663446607354989477a5c6f0f007ef4,
        128'h531c2c38344578b84d50b3c917bbb6e1,
        128'hfc6aec906323480005c58e7e1ab004ad,
        128'ha3944b95ca0b52043584ef02151926a8,
        128'ha74289fe73a4c123ca189ea1e1b49ad5,
        128'hb91d4ea4488644b56cf0812fa7fcf5fc,
        128'h304f81ab61a80c2e743b94d5002a126b,
        128'h649a71545378c783e368c9ade7114f6c,
        128'h47cb030da2ab051dfc6c4bf6910d12bb,
        128'h798c7c005dee432b2c8ea5dfa381ecc3,
        128'h637c31dc2591a07636f646b72daabbe7,
        128'h179a49c712154bbffbe6e7a84a18e220
    };
    
    // VarTxt Know Answer Test Values
    localparam [255:0] VARTXT_KEY = 256'b0;
    localparam [127:0] VARTXT_IV  = 128'h0;

    localparam logic [127:0] VARTXT_CT [0:127] = '{
        128'hddc6bf79_0c15760d_8d9aeb6f_9a75fd4e,
        128'h0a6bdc6d_4c1e6280_301fd8e9_7ddbe601,
        128'h9b80eefb_7ebe2d2b_16247aa0_efc72f5d,
        128'h7f2c5ece_07a98d8b_ee13c511_77395ff7,
        128'h7818d800_dcf6f4be_1e0e94f4_03d1e4c2,
        128'he74cd1c9_2f0919c3_5a032412_3d6177d3,
        128'h8092a4dc_f2da7e77_e93bdd37_1dfed82e,
        128'h49af6b37_2135acef_10132e54_8f217b17,
        128'h8bcd40f9_4ebb63b9_f7909676_e667f1e7,
        128'hfe1cffb8_3f45dcfb_38b29be4_38dbd3ab,
        128'h0dc58a8d_88662370_5aec15cb_1e70dc0e,
        128'hc218faa1_6056bd07_74c3e8d7_9c35a5e4,
        128'h047bba83_f7aa8417_31504e01_2208fc9e,
        128'hdc8f0e49_15fd81ba_70a33131_0882f6da,
        128'h1569859e_a6b7206c_30bf4fd0_cbfac33c,
        128'h300ade92_f88f48fa_2df730ec_16ef44cd,
        128'h1fe6cc3c_05965dc0_8eb0590c_95ac71d0,
        128'h59e858ea_aa97fec3_8111275b_6cf5abc0,
        128'h2239455e_7afe3b06_16100288_cc5a723b,
        128'h3ee500c5_c8d63479_717163e5_5c5c4522,
        128'hd5e38bf1_5f16d90e_3e214041_d774daa8,
        128'hb1f4066e_6f4f187d_fe5f2ad1_b17819d0,
        128'h6ef4cc4d_e49b1106_5d7af290_9854794a,
        128'hac86bc60_6b6640c3_09e782f2_32bf367f,
        128'h36aff0ef_7bf32807_72cf4cac_80a0d2b2,
        128'h1f8eedea_0f62a140_6d58cfc3_ecea72cf,
        128'habf4154a_3375a1d3_e6b1d454_438f95a6,
        128'h96f96e9d_607f6615_fc192061_ee648b07,
        128'hcf37cdaa_a0d2d536_c7185763_4c792064,
        128'hfbd6640c_80245c2b_805373f1_30703127,
        128'h8d6a8afe_55a6e481_badae0d1_46f436db,
        128'h6a4981f2_915e3e68_af6c2238_5dd06756,
        128'h42a1136e_5f8d8d21_d3101998_642d573b,
        128'h9b471596_dc69ae15_86cee615_8b0b0181,
        128'h753665c4_af1eff33_aa8b628b_f8741cfd,
        128'h9a682acf_40be01f5_b2a4193c_9a82404d,
        128'h54fafe26_e4287f17_d1935f87_eb9ade01,
        128'h49d541b2_e74cfe73_e6a8e822_5f7bd449,
        128'h11a45530_f624ff6f_76a1b382_6626ff7b,
        128'hf96b0c4a_8bc6c861_30289f60_b43b8fba,
        128'h48c7d0e8_0834ebdc_35b6735f_76b46c8b,
        128'h2463531a_b54d6695_5e73edc4_cb8eaa45,
        128'hac9bd8e2_53046913_4b9d5b06_5d4f565b,
        128'h3f5f9106_d0e52f97_3d4890e6_f37e8a00,
        128'h20ebc86f_1304d272_e2e207e5_9db639f0,
        128'he67ae642_6bf9526c_972cff07_2b52252c,
        128'h1a518ddd_af9efa0d_002cc58d_107edfc8,
        128'head731af_4d3a2fe3_b34bed04_7942a49f,
        128'hb1d4efe4_0242f83e_93b6c8d7_efb5eae9,
        128'hcd2b1fec_11fd906c_5c763009_9443610a,
        128'ha1853fe4_7fe29289_d153161d_06387d21,
        128'h46321541_79a555c1_7ea604d0_889fab14,
        128'hdd27cac6_401a022e_8f38f9f9_3e774417,
        128'hc090313e_b98674f3_5f312338_5fb95d4d,
        128'hcc352626_2b92f02e_dce548f7_16b9f45c,
        128'hc0838d1a_2b16a7c7_f0dfcc43_3c399c33,
        128'h0d9ac756_eb297695_eed4d382_eb126d26,
        128'h56ede9dd_a3f6f141_bff1757f_a689c3e1,
        128'h768f520e_fe0f23e6_1d3ec8ad_9ce91774,
        128'hb1144ddf_a7575521_3390e7c5_96660490,
        128'h1d7c0c40_40b355b9_d107a993_25e3b050,
        128'hd8e2bb1a_e8ee3dcf_5bf7d6c3_8da82a1a,
        128'hfaf82d17_8af25a98_86a47e7f_789b98d7,
        128'h9b58dbfd_77fe5aca_9cfc190c_d1b82d19,
        128'h77f39208_9042e478_ac16c0c8_6a0b5db5,
        128'h19f08e34_20ee69b4_77ca1420_281c4782,
        128'ha1b19bee_e4e11713_9f74b3c5_3fdcb875,
        128'ha37a5869_b218a9f3_a0868d19_aea0ad6a,
        128'hbc3594e8_65bcd026_1b132027_31f33580,
        128'h811441ce_1d309eee_7185e8c7_52c07557,
        128'h959971ce_41341905_63518e70_0b9874d1,
        128'h76b5614a_042707c9_8e2132e2_e805fe63,
        128'h7d9fa6a5_7530d0f0_36fec31c_230b0cc6,
        128'h964153a8_3bf6989a_4ba80daa_91c3e081,
        128'ha013014d_4ce8054c_f2591d06_f6f2f176,
        128'hd1c5f639_9bf38250_2e385eee_1474a869,
        128'h0007e20b_8298ec35_4f0f5fe7_470f36bd,
        128'hb95ba05b_332da61e_f63a2b31_fcad9879,
        128'h4620a49b_d9674915_61669ab2_5dce45f4,
        128'h12e71214_ae8e04f0_bb63d742_5c6f14d5,
        128'h4cc42fc1_407b008f_e350907c_092e80ac,
        128'h08b244ce_7cbc8ee9_7fbba808_cb146fda,
        128'h39b333e8_694f2154_6ad1edd9_d87ed95b,
        128'h3b271f8a_b2e6e4a2_0ba8090f_43ba78f3,
        128'h9ad983f3_bf651cd0_393f0a73_cccdea50,
        128'h8f476cbf_f75c1f72_5ce18e4b_bcd19b32,
        128'h905b6267_f1d6ab53_20835a13_3f096f2a,
        128'h145b60d6_d0193c23_f4221848_a892d61a,
        128'h55cfb3fb_6d75cad0_445bbc8d_afa25b0f,
        128'h7b8e7098_e357ef71_237d46d8_b075b0f5,
        128'h2bf27229_901eb40f_2df9d839_8d1505ae,
        128'h83a63402_a77f9ad5_c1e931a9_31ecd706,
        128'h6f8ba652_1152d31f_2bada184_3e26b973,
        128'he5c3b8e3_0fd2d8e6_239b17b4_4bd23bbd,
        128'h1ac1f710_2c59933e_8b2ddc3f_14e94baa,
        128'h21d9ba49_f276b45f_11af8fc7_1a088e3d,
        128'h649f1cdd_c3792b46_38635a39_2bc9bade,
        128'he2775e4b_59c1bc2e_31a2078c_11b5a08c,
        128'h2be1fae5_048a2558_2a679ca1_0905eb80,
        128'hda86f292_c6f41ea3_4fb2068d_f75ecc29,
        128'h220df19f_85d69b1b_562fa69a_3c5beca5,
        128'h1f11d5d0_355e0b55_6ccdb6c7_f5083b4d,
        128'h62526b78_be79cb38_4633c91f_83b4151b,
        128'h90ddbcb9_50843592_dd47bbef_00fdc876,
        128'h2fd0e41c_5b840227_7354a739_1d2618e2,
        128'h3cdf13e7_2dee4c58_1bafec70_b85f9660,
        128'hafa2ffc1_37577092_e2b654fa_199d2c43,
        128'h8d683ee6_3e60d208_e343ce48_dbc44cac,
        128'h705a4ef8_ba213372_9c20185c_3d3a4763,
        128'h0861a861_c3db4e94_194211b7_7ed761b9,
        128'h4b00c27e_8b26da7e_ab9d3a88_dec8b031,
        128'h5f397bf0_3084820c_c8810d52_e5b666e9,
        128'h63fafabb_72c07bfb_d3ddc9b1_203104b8,
        128'h683e2140_585b1845_2dd4ffbb_93c95df9,
        128'h286894e4_8e537f87_63b56707_d7d155c8,
        128'ha423deab_c173dcf7_e2c4c53e_77d37cd1,
        128'heb816831_3e1cfdfd_b5e986d5_429cf172,
        128'h27127daa_fc9accd2_fb334ec3_eba52323,
        128'hee0715b9_6f72e3f7_a22a5064_fc592f4c,
        128'h29ee5267_70f2a11d_cfa989d1_ce88830f,
        128'h0493370e_054b0987_1130fe49_af730a5a,
        128'h9b7b940f_6c509f9e_44a4ee14_0448ee46,
        128'h2915be4a_1ecfdcbe_3e023811_a12bb6c7,
        128'h7240e524_bc51d8c4_d440b1be_55d1062c,
        128'hda63039d_38cb4612_b2dc36ba_26684b93,
        128'h0f59cb5a_4b522e2a_c56c1a64_f558ad9a,
        128'h7bfe9d87_6c6d63c1_d035da8f_e21c409d,
        128'hacdace80_78a32b1a_182bfa49_87ca1347
    };
    
    localparam logic [127:0] VARTXT_PT [0:127] = '{
        128'h80000000_00000000_00000000_00000000,
        128'hc0000000_00000000_00000000_00000000,
        128'he0000000_00000000_00000000_00000000,
        128'hf0000000_00000000_00000000_00000000,
        128'hf8000000_00000000_00000000_00000000,
        128'hfc000000_00000000_00000000_00000000,
        128'hfe000000_00000000_00000000_00000000,
        128'hff000000_00000000_00000000_00000000,
        128'hff800000_00000000_00000000_00000000,
        128'hffc00000_00000000_00000000_00000000,
        128'hffe00000_00000000_00000000_00000000,
        128'hfff00000_00000000_00000000_00000000,
        128'hfff80000_00000000_00000000_00000000,
        128'hfffc0000_00000000_00000000_00000000,
        128'hfffe0000_00000000_00000000_00000000,
        128'hffff0000_00000000_00000000_00000000,
        128'hffff8000_00000000_00000000_00000000,
        128'hffffc000_00000000_00000000_00000000,
        128'hffffe000_00000000_00000000_00000000,
        128'hfffff000_00000000_00000000_00000000,
        128'hfffff800_00000000_00000000_00000000,
        128'hfffffc00_00000000_00000000_00000000,
        128'hfffffe00_00000000_00000000_00000000,
        128'hffffff00_00000000_00000000_00000000,
        128'hffffff80_00000000_00000000_00000000,
        128'hffffffc0_00000000_00000000_00000000,
        128'hffffffe0_00000000_00000000_00000000,
        128'hfffffff0_00000000_00000000_00000000,
        128'hfffffff8_00000000_00000000_00000000,
        128'hfffffffc_00000000_00000000_00000000,
        128'hfffffffe_00000000_00000000_00000000,
        128'hffffffff_00000000_00000000_00000000,
        128'hffffffff_80000000_00000000_00000000,
        128'hffffffff_c0000000_00000000_00000000,
        128'hffffffff_e0000000_00000000_00000000,
        128'hffffffff_f0000000_00000000_00000000,
        128'hffffffff_f8000000_00000000_00000000,
        128'hffffffff_fc000000_00000000_00000000,
        128'hffffffff_fe000000_00000000_00000000,
        128'hffffffff_ff000000_00000000_00000000,
        128'hffffffff_ff800000_00000000_00000000,
        128'hffffffff_ffc00000_00000000_00000000,
        128'hffffffff_ffe00000_00000000_00000000,
        128'hffffffff_fff00000_00000000_00000000,
        128'hffffffff_fff80000_00000000_00000000,
        128'hffffffff_fffc0000_00000000_00000000,
        128'hffffffff_fffe0000_00000000_00000000,
        128'hffffffff_ffff0000_00000000_00000000,
        128'hffffffff_ffff8000_00000000_00000000,
        128'hffffffff_ffffc000_00000000_00000000,
        128'hffffffff_ffffe000_00000000_00000000,
        128'hffffffff_fffff000_00000000_00000000,
        128'hffffffff_fffff800_00000000_00000000,
        128'hffffffff_fffffc00_00000000_00000000,
        128'hffffffff_fffffe00_00000000_00000000,
        128'hffffffff_ffffff00_00000000_00000000,
        128'hffffffff_ffffff80_00000000_00000000,
        128'hffffffff_ffffffc0_00000000_00000000,
        128'hffffffff_ffffffe0_00000000_00000000,
        128'hffffffff_fffffff0_00000000_00000000,
        128'hffffffff_fffffff8_00000000_00000000,
        128'hffffffff_fffffffc_00000000_00000000,
        128'hffffffff_fffffffe_00000000_00000000,
        128'hffffffff_ffffffff_00000000_00000000,
        128'hffffffff_ffffffff_80000000_00000000,
        128'hffffffff_ffffffff_c0000000_00000000,
        128'hffffffff_ffffffff_e0000000_00000000,
        128'hffffffff_ffffffff_f0000000_00000000,
        128'hffffffff_ffffffff_f8000000_00000000,
        128'hffffffff_ffffffff_fc000000_00000000,
        128'hffffffff_ffffffff_fe000000_00000000,
        128'hffffffff_ffffffff_ff000000_00000000,
        128'hffffffff_ffffffff_ff800000_00000000,
        128'hffffffff_ffffffff_ffc00000_00000000,
        128'hffffffff_ffffffff_ffe00000_00000000,
        128'hffffffff_ffffffff_fff00000_00000000,
        128'hffffffff_ffffffff_fff80000_00000000,
        128'hffffffff_ffffffff_fffc0000_00000000,
        128'hffffffff_ffffffff_fffe0000_00000000,
        128'hffffffff_ffffffff_ffff0000_00000000,
        128'hffffffff_ffffffff_ffff8000_00000000,
        128'hffffffff_ffffffff_ffffc000_00000000,
        128'hffffffff_ffffffff_ffffe000_00000000,
        128'hffffffff_ffffffff_fffff000_00000000,
        128'hffffffff_ffffffff_fffff800_00000000,
        128'hffffffff_ffffffff_fffffc00_00000000,
        128'hffffffff_ffffffff_fffffe00_00000000,
        128'hffffffff_ffffffff_ffffff00_00000000,
        128'hffffffff_ffffffff_ffffff80_00000000,
        128'hffffffff_ffffffff_ffffffc0_00000000,
        128'hffffffff_ffffffff_ffffffe0_00000000,
        128'hffffffff_ffffffff_fffffff0_00000000,
        128'hffffffff_ffffffff_fffffff8_00000000,
        128'hffffffff_ffffffff_fffffffc_00000000,
        128'hffffffff_ffffffff_fffffffe_00000000,
        128'hffffffff_ffffffff_ffffffff_00000000,
        128'hffffffff_ffffffff_ffffffff_80000000,
        128'hffffffff_ffffffff_ffffffff_c0000000,
        128'hffffffff_ffffffff_ffffffff_e0000000,
        128'hffffffff_ffffffff_ffffffff_f0000000,
        128'hffffffff_ffffffff_ffffffff_f8000000,
        128'hffffffff_ffffffff_ffffffff_fc000000,
        128'hffffffff_ffffffff_ffffffff_fe000000,
        128'hffffffff_ffffffff_ffffffff_ff000000,
        128'hffffffff_ffffffff_ffffffff_ff800000,
        128'hffffffff_ffffffff_ffffffff_ffc00000,
        128'hffffffff_ffffffff_ffffffff_ffe00000,
        128'hffffffff_ffffffff_ffffffff_fff00000,
        128'hffffffff_ffffffff_ffffffff_fff80000,
        128'hffffffff_ffffffff_ffffffff_fffc0000,
        128'hffffffff_ffffffff_ffffffff_fffe0000,
        128'hffffffff_ffffffff_ffffffff_ffff0000,
        128'hffffffff_ffffffff_ffffffff_ffff8000,
        128'hffffffff_ffffffff_ffffffff_ffffc000,
        128'hffffffff_ffffffff_ffffffff_ffffe000,
        128'hffffffff_ffffffff_ffffffff_fffff000,
        128'hffffffff_ffffffff_ffffffff_fffff800,
        128'hffffffff_ffffffff_ffffffff_fffffc00,
        128'hffffffff_ffffffff_ffffffff_fffffe00,
        128'hffffffff_ffffffff_ffffffff_ffffff00,
        128'hffffffff_ffffffff_ffffffff_ffffff80,
        128'hffffffff_ffffffff_ffffffff_ffffffc0,
        128'hffffffff_ffffffff_ffffffff_ffffffe0,
        128'hffffffff_ffffffff_ffffffff_fffffff0,
        128'hffffffff_ffffffff_ffffffff_fffffff8,
        128'hffffffff_ffffffff_ffffffff_fffffffc,
        128'hffffffff_ffffffff_ffffffff_fffffffe,
        128'hffffffff_ffffffff_ffffffff_ffffffff
    };
    
    // VarKey Know Answer Test Values
    localparam [127:0] VARKEY_IV = 128'b0;
    localparam [127:0] VARKEY_PT = 128'h0;
    
        localparam logic [255:0] VARKEY_KEY [0:255] = '{
        256'h80000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hc0000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'he0000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hf0000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hf8000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hfc000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hfe000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hff000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hff800000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffc00000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffe00000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hfff00000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hfff80000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hfffc0000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hfffe0000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffff0000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffff8000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffc000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffe000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hfffff000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hfffff800_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hfffffc00_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hfffffe00_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffff00_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffff80_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffc0_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffe0_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hfffffff0_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hfffffff8_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hfffffffc_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hfffffffe_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_80000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_c0000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_e0000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_f0000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_f8000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_fc000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_fe000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ff000000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ff800000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffc00000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffe00000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_fff00000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_fff80000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_fffc0000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_fffe0000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffff0000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffff8000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffc000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffe000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_fffff000_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_fffff800_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_fffffc00_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_fffffe00_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffff00_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffff80_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffc0_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffe0_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_fffffff0_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_fffffff8_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_fffffffc_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_fffffffe_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_00000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_80000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_c0000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_e0000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_f0000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_f8000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_fc000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_fe000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ff000000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ff800000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffc00000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffe00000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_fff00000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_fff80000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_fffc0000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_fffe0000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffff0000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffff8000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffc000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffe000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_fffff000_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_fffff800_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_fffffc00_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_fffffe00_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffff00_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffff80_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffc0_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffe0_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_fffffff0_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_fffffff8_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_fffffffc_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_fffffffe_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_00000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_80000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_c0000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_e0000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_f0000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_f8000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_fc000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_fe000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ff000000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ff800000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffc00000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffe00000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_fff00000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_fff80000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_fffc0000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_fffe0000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffff0000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffff8000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffc000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffe000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_fffff000_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_fffff800_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_fffffc00_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_fffffe00_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffff00_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffff80_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffc0_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffe0_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_fffffff0_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_fffffff8_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_fffffffc_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_fffffffe_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_00000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_80000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_c0000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_e0000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_f0000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_f8000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_fc000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_fe000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ff000000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ff800000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffc00000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffe00000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_fff00000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_fff80000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_fffc0000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_fffe0000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffff0000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffff8000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffc000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffe000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_fffff000_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_fffff800_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_fffffc00_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_fffffe00_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffff00_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffff80_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffc0_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffe0_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_fffffff0_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_fffffff8_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_fffffffc_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_fffffffe_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_00000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_80000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_c0000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_e0000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_f0000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_f8000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fc000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fe000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ff000000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ff800000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffc00000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffe00000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fff00000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fff80000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffc0000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffe0000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffff0000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffff8000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffc000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffe000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffff000_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffff800_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffc00_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffe00_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffff00_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffff80_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffc0_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffe0_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffff0_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffff8_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffffc_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffffe_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_00000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_80000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_c0000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_e0000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_f0000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_f8000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fc000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fe000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ff000000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ff800000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffc00000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffe00000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fff00000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fff80000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffc0000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffe0000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffff0000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffff8000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffc000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffe000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffff000_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffff800_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffc00_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffe00_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffff00_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffff80_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffc0_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffe0_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffff0_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffff8_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffffc_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffffe_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_00000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_80000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_c0000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_e0000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_f0000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_f8000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fc000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fe000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ff000000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ff800000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffc00000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffe00000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fff00000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fff80000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffc0000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffe0000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffff0000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffff8000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffc000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffe000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffff000,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffff800,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffc00,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffe00,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffff00,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffff80,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffc0,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffe0,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffff0,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffff8,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffffc,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffffe,
        256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff
    };
    
    localparam logic [255:0] VARKEY_CT [0:255] = '{
        256'he35a6dcb_19b201a0_1ebcfa8a_a22b5759,
        256'hb29169cd_cf2d83e8_38125a12_ee6aa400,
        256'hd8f3a72f_c3cdf74d_faf6c3e6_b97b2fa6,
        256'h1c777679_d50037c7_9491a94d_a76a9a35,
        256'h9cf4893e_cafa0a02_47a898e0_40691559,
        256'h8fbb4137_03735326_310a269b_d3aa94b2,
        256'h60e32246_bed2b0e8_59e55c1c_c6b26502,
        256'hec52a212_f80a09df_6317021b_c2a9819e,
        256'hf23e5b60_0eb70dbc_cf6c0b1d_9a68182c,
        256'ha3f599d6_3a82a968_c33fe265_90745970,
        256'hd1ccb9b1_337002cb_ac42c520_b5d67722,
        256'hcc111f6c_37cf40a1_159d00fb_59fb0488,
        256'hdc43b51a_b6090523_72989a26_e9cdd714,
        256'h4dcede8d_a9e2578f_39703d44_33dc6459,
        256'h1a4c1c26_3bbccfaf_c1178289_4685e3a8,
        256'h937ad848_80db5061_3423d6d5_27a2823d,
        256'h610b71df_c688e150_d8152c5b_35ebc14d,
        256'h27ef2495_dabf3238_85aab39c_80f18d8b,
        256'h633cafea_395bc03a_dae3a1e2_068e4b4e,
        256'h6e1b482b_53761cf6_31819b74_9a6f3724,
        256'h976e6f85_1ab52c77_1998dbb2_d71c75a9,
        256'h85f2ba84_f8c307cf_525e124c_3e22e6cc,
        256'h6bcca98b_f6a835fa_64955f72_de4115fe,
        256'h2c75e2d3_6eebd654_11f14fd0_eb1d2a06,
        256'hbd492950_06250ffc_a5100b60_07a0eade,
        256'ha190527d_0ef7c70f_459cd394_0df316ec,
        256'hbbd1097a_62433f79_449fa97d_4ee80dbf,
        256'h07058e40_8f5b99b0_e0f061a1_761b5b3b,
        256'h5fd1f13f_a0f31e37_fabde328_f894eac2,
        256'hfc4af7c9_48df26e2_ef3e01c1_ee5b8f6f,
        256'h829fd720_8fb92d44_a074a677_ee9861ac,
        256'had9fc613_a703251b_54c64a0e_76431711,
        256'h33ac9ecc_c4cc75e2_711618f8_0b1548e8,
        256'h2025c74b_8ad8f4cd_a17ee204_9c4c902d,
        256'hf85ca05f_e528f1ce_9b790166_e8d551e7,
        256'h6f6238d8_966048d4_967154e0_dad5a6c9,
        256'hf2b21b4e_7640a9b3_346de8b8_2fb41e49,
        256'hf836f251_ad1d11d4_9dc34462_8b1884e1,
        256'h077e9470_ae7abea5_a9769d49_182628c3,
        256'he0dcc2d2_7fc98656_33f85223_cf0d611f,
        256'hbe66cfea_2fecd6bf_0ec7b435_2c99bcaa,
        256'hdf31144f_87a2ef52_3facdcf2_1a427804,
        256'hb5bb0f56_29fb6aae_5e1839a3_c3625d63,
        256'h3c9db333_5306fe1e_c612bdbf_ae6b6028,
        256'h3dd5c346_34a79d3c_fcc83397_60e6f5f4,
        256'h82bda118_a3ed7af3_14fa2ccc_5c07b761,
        256'h2937a64f_7d4f46fe_6fea3b34_9ec78e38,
        256'h225f068c_28476605_735ad671_bb8f39f3,
        256'hae682c5e_cd71898e_08942ac9_aa89875c,
        256'h5e031cb9_d676c302_2d7f2622_7e85c38f,
        256'ha78463fb_064db5d5_2bb64bfe_f64f2dda,
        256'h8aa9b75e_78459387_6c53a00e_ae5af52b,
        256'h3f84566d_f23da48a_f692722f_e980573a,
        256'h31690b5e_d41c7eb4_2a1e8327_0a7ff0e6,
        256'h77dd7702_646d55f0_8365e477_d3590eda,
        256'h4c022ac6_2b3cb78d_739cc67b_3e20bb7e,
        256'h092fa137_ce18b5df_e7906f55_0bb13370,
        256'h3e0cdadf_2e68353c_0027672c_97144dd3,
        256'hd8c4b200_b383fc1f_2b2ea677_618a1d27,
        256'h11825f99_b0e9bb34_77c1c071_3b015aac,
        256'hf8b9fffb_5c187f7d_dc7ab10f_4fb77576,
        256'hffb4e87a_32b37d6f_2c8328d3_b5377802,
        256'hd276c13a_5d220f4d_a9224e74_896391ce,
        256'h94efe7a0_e2e031e2_536da01d_f799c927,
        256'h8f8fd822_680a8597_4e53a5a8_eb9d38de,
        256'he0f0a91b_2e45f8cc_37b7805a_3042588d,
        256'h597a6252_255e46d6_364dbeed_a31e279c,
        256'hf51a0f69_4442b8f0_5571797f_ec7ee8bf,
        256'h9ff071b1_65b5198a_93dddeeb_c54d09b5,
        256'hc20a19fd_5758b0c4_bc1a5df8_9cf73877,
        256'h97120166_307119ca_2280e931_5668e96f,
        256'h4b3b9f1e_099c2a09_dc091e90_e4f18f0a,
        256'heb040b89_1d4b37f6_851f7ec2_19cd3f6d,
        256'h9f0fdec0_8b7fd79a_a39535be_a42db92a,
        256'h2e70f168_fc74bf91_1df240bc_d2cef236,
        256'h462ccd7f_5fd1108d_bc152f3c_acad328b,
        256'ha4af534a_7d0b643a_01868785_d86dfb95,
        256'hab980296_197e1a50_22326c31_da4bf6f3,
        256'hf97d57b3_333b6281_b07d486d_b2d4e20c,
        256'hf33fa367_20231afe_4c759ade_6bd62eb6,
        256'hfdcfac0c_02ca5383_43c68117_e0a15938,
        256'had4916f5_ee5772be_764fc027_b8a6e539,
        256'h2e16873e_1678610d_7e14c02d_002ea845,
        256'h4e6e627c_1acc5134_0053a823_6d579576,
        256'hab0c8410_aeeead92_feec1eb4_30d652cb,
        256'he86f7e23_e835e114_977f60e1_a592202e,
        256'he68ad505_5a367041_fade09d9_a70a794b,
        256'h0791823a_3c666bb6_162825e7_8606a7fe,
        256'hdcca366a_9bf47b7b_868b77e2_5c18a364,
        256'h684c9efc_237e4a44_2965f84b_ce20247a,
        256'ha858411f_fbe63fdb_9c8aa1bf_aed67b52,
        256'h04bc3da2_179c3015_498b0e03_910db5b8,
        256'h40071eea_b3f935db_c25d0084_1460260f,
        256'h0ebd7c30_ed2016e0_8ba806dd_b008bcc8,
        256'h15c6becf_0f4cec71_29cbd22d_1a79b1b8,
        256'h0aeede5b_91f72170_0e9e62ed_bf60b781,
        256'h266581af_0dcfbed1_585e0a24_2c64b8df,
        256'h6693dc91_1662ae47_3216ba22_189a511a,
        256'h7606fa36_d86473e6_fb3a1bb0_e2c0adf5,
        256'h112078e9_e11fbb78_e26ffb88_99e96b9a,
        256'h40b264e9_21e9e4a8_2694589e_f3798262,
        256'h8d4595cb_4fa70267_15f55bd6_8e2882f9,
        256'hb588a302_bdbc0919_7df1edae_68926ed9,
        256'h33f75023_90b8a4a2_21cfecd0_666624ba,
        256'h3d20253a_dbce3be2_373767c4_d822c566,
        256'ha42734a3_929bf84c_f0116c98_56a3c18c,
        256'he3abc493_9457422b_b957da3c_56938c6d,
        256'h972bdd2e_7c525130_fadc8f76_fc6f4b3f,
        256'h84a83d7b_94c699cb_cb8a7d9b_61f64093,
        256'hce61d635_14aded03_d43e6ebf_c3a9001f,
        256'h6c839dd5_8eeae6b8_a36af48e_d63d2dc9,
        256'hcd5ece55_b8da3bf6_22c4100d_f5de46f9,
        256'h3b6f46f4_0e0ac5fc_0a9c1105_f800f48d,
        256'hba26d47d_a3aeb028_de4fb5b3_a854a24b,
        256'h87f53bf6_20d36772_68445212_904389d5,
        256'h10617d28_b5e0f460_5492b182_a5d7f9f6,
        256'h9aaec4fa_bbf6fae2_a71feff0_2e372b39,
        256'h3a90c62d_88b5c428_09abf782_488ed130,
        256'hf1f1c5a4_0899e157_72857ccb_65c7a09a,
        256'h190843d2_9b25a389_7c692ce1_dd81ee52,
        256'ha866bc65_b6941d86_e8420a7f_fb0964db,
        256'h8193c6ff_85225ced_4255e92f_6e078a14,
        256'h9661cb24_24d7d4a3_80d547f9_e7ec1cb9,
        256'h86f93d9e_c08453a0_71e2e287_7877a9c8,
        256'h27eefa80_ce6a4a9d_598e3fec_365434d2,
        256'hd6206844_4578e3ab_39ce7ec9_5dd045dc,
        256'hb5f71d4d_d9a71fe5_d8bc8ba7_e6ea3048,
        256'h6825a347_ac479d4f_9d95c5cb_8d3fd7e9,
        256'he3714e94_a5778955_cc034635_8e94783a,
        256'hd836b44b_b29e0c7d_89fa4b2d_4b677d2a,
        256'h5d454b75_021d76d4_b84f873a_8f877b92,
        256'hc3498f7e_ced20953_14fc2811_5885b33f,
        256'h6e668856_539ad8e4_05bd123f_e6c88530,
        256'h8680db7f_3a87b860_5543cfdb_e6754076,
        256'h6c5d03b1_3069c365_8b3179be_91b0800c,
        256'hef1b384a_c4d93eda_00c92add_0995ea5f,
        256'hbf811580_5471741b_d5ad20a0_3944790f,
        256'hc64c24b6_894b038b_3c0d09b1_df068b0b,
        256'h3967a10c_ffe27d01_78545fbf_6a40544b,
        256'h7c85e9c9_5de1a9ec_5a5363a8_a053472d,
        256'ha9eec03c_8abec7ba_68315c2c_8c2316e0,
        256'hcac8e414_c2f38822_7ae14986_fc983524,
        256'h5d942b7f_4622ce05_6c3ce3ce_5f1dd9d6,
        256'hd240d648_ce21a302_0282c3f1_b528a0b6,
        256'h45d089c3_6d5c5a4e_fc689e3b_0de10dd5,
        256'hb4da5df4_becb5462_e03a0ed0_0d295629,
        256'hdcf4e129_136c1a4b_7a0f3893_5cc34b2b,
        256'hd9a4c761_8b0ce48a_3d5aee1a_1c0114c4,
        256'hca352df0_25c65c7b_0bf306fb_ee0f36ba,
        256'h238aca23_fd3409f3_8af63378_ed2f5473,
        256'h59836a0e_06a79691_b36667d5_380d8188,
        256'h33905080_f7acf1cd_ae0a91fc_3e85aee4,
        256'h72c9e464_6dbc3d63_20fc6689_d93e8833,
        256'hba77413d_ea5925b7_f5417ea4_7ff19f59,
        256'h6cae8129_f843d86d_c786a0fb_1a184970,
        256'hfcfefb53_4100796e_ebbd9902_06754e19,
        256'h8c791d5f_dddf470d_a04f3e6d_c4a5b5b5,
        256'hc93bbdc0_7a4611ae_4bb266ea_5034a387,
        256'hc102e38e_489aa747_62f3efc5_bb23205a,
        256'h93201481_665cbafc_1fcc220b_c545fb3d,
        256'h4960757e_c6ce68cf_195e454c_fd0f32ca,
        256'hfeec7ce6_a6cbd07c_04341673_7f1bbb33,
        256'h11c54139_04487a80_5d70a8ed_d9c35527,
        256'h347846b2_b2e36f1f_0324c86f_7f1b98e2,
        256'h332eee1a_0cbd19ca_2d69b426_894044f0,
        256'h866b5b39_77ba6efa_5128efbd_a9ff03cd,
        256'hcc1445ee_94c0f08c_dee5c344_ecd1e233,
        256'hbe288319_029363c2_622feba4_b05dfdfe,
        256'hcfd18755_23f3cd21_c395651e_6ee15e56,
        256'hcb5a4086_57837c53_bf16f9d8_465dce19,
        256'hca0bf42c_b107f55c_cff2fc09_ee08ca15,
        256'hfdd9bbb4_a7dc2e4a_23536a58_80a2db67,
        256'hede447b3_62c48499_3dec9442_a3b46aef,
        256'h10dffb05_904bff7c_4781df78_0ad26837,
        256'hc33bc13e_8de88ac2_5232aa74_96398783,
        256'hca359c70_803a3b2a_3d542e87_81dea975,
        256'hbcc65b52_6f88d05b_89ce8a52_021fdb06,
        256'hdb91a388_55c8c464_3851fbfb_358b0109,
        256'hca6e8893_a114ae8e_27d5ab03_a5499610,
        256'h6629d2b8_df97da72_8cdd8b1e_7f945077,
        256'h4570a5a1_8cfc0dd5_82f1d88d_5c9a1720,
        256'h72bc65aa_8e89562e_3f274d45_af1cd10b,
        256'h98551da1_a6503276_ae1c7762_5f9ea615,
        256'h0ddfe51c_ed7e3f4a_e927daa3_fe452cee,
        256'hdb826251_e4ce384b_80218b0e_1da1dd4c,
        256'h2cacf728_b88abbad_7011ed0e_64a1680c,
        256'h330d8ee7_c5677e09_9ac74c99_94ee4cfb,
        256'hedf61ae3_62e882dd_c0167474_a7a77f3a,
        256'h6168b00b_a7859e09_70ecfd75_7efecf7c,
        256'hd1415447_866230d2_8bb1ea18_a4cdfd02,
        256'h51618339_2f7a8763_afec68a0_60264141,
        256'h77565c8d_73cfd413_0b4aa14d_8911710f,
        256'h37232a4e_d21ccc27_c19c9610_078cabac,
        256'h804f32ea_71828c7d_329077e7_12231666,
        256'hd64424f2_3cb97215_e9c2c6f2_8d29eab7,
        256'h023e82b5_33f68c75_c238cebd_b2ee89a2,
        256'h193a3d24_157a51f1_ee0893f6_777417e7,
        256'h84ecacfc_d400084d_078612b1_945f2ef5,
        256'h1dcd8bb1_73259eb3_3a5242b0_de31a455,
        256'h35e9eddb_c375e792_c19992c1_9165012b,
        256'h8a772231_c01dfdd7_c98e4cfd_dcc0807a,
        256'h6eda7ff6_b8319180_ff0d6e65_629d01c3,
        256'hc267ef0e_2d01a993_944dd397_101413cb,
        256'he9f80e9d_845bcc0f_62926af7_2eabca39,
        256'h67029907_27aa0878_637b45dc_d3a3b074,
        256'h2e2e647d_5360e092_30a5d738_ca33471e,
        256'h1f56413c_7add6f43_d1d56e4f_02190330,
        256'h69cd0606_e15af729_d6bca143_016d9842,
        256'ha085d7c1_a500873a_20099c4c_aa3c3f5b,
        256'h4fc0d230_f8891415_b87b83f9_5f2e09d1,
        256'h4327d08c_523d8eba_697a4336_507d1f42,
        256'h7a15aab8_2701efa5_ae36ab1d_6b76290f,
        256'h5bf00518_93a18bb3_0e139a58_fed0fa54,
        256'h97e8adf6_5638fd9c_df3bc22c_17fe4dbd,
        256'h1ee6ee32_6583a058_6491c964_18d1a35d,
        256'h26b549c2_ec756f82_ecc48008_e529956b,
        256'h70377b6d_a669b072_129e057c_c28e9ca5,
        256'h9c94b8b0_cb8bcc91_9072262b_3fa05ad9,
        256'h2fbb83df_d0d7abcb_05cd28ca_d2dfb523,
        256'h96877803_de77744b_b970d0a9_1f4debae,
        256'h7379f337_0cf6e5ce_12ae5969_c8eea312,
        256'h02dc99fa_3d4f98ce_80985e72_33889313,
        256'h1e38e759_075ba5ca_b6457da5_1844295a,
        256'h70bed8db_f615868a_1f9d9b05_d3e7a267,
        256'h234b148b_8cb1d8c3_2b287e89_6903d150,
        256'h294b033d_f4da853f_4be3e243_f7e513f4,
        256'h3f58c950_f0367160_adec45f2_441e7411,
        256'h37f65553_6a704e5a_ce182d74_2a820cf4,
        256'hea7bd6bb_63418731_aeac790f_e42d61e8,
        256'he74a4c99_9b4c064e_48bb1e41_3f51e5ea,
        256'hba9ebefd_b4ccf30f_296cecb3_bc1943e8,
        256'h3194367a_4898c502_c13bb747_8640a72d,
        256'hda797713_263d6f33_a5478a65_ef60d412,
        256'hd1ac39bb_1ef86b9c_1344f214_679aa376,
        256'h2fdea9e6_50532be5_bc0e7325_337fd363,
        256'hd3a204db_d9c2af15_8b6ca67a_5156ce4a,
        256'h3a0a0e75_a8da3673_5aee6684_d965a778,
        256'h52fc3e62_0492ea99_641ea168_da5b6d52,
        256'hd2e0c7f1_5b477246_7d2cfc87_3000b2ca,
        256'h56353113_5e0c4d70_a38f8bdb_190ba04e,
        256'ha8a39a0f_5663f4c0_fe5f2d3c_afff421a,
        256'hd94b5e90_db354c1e_42f61fab_e167b2c0,
        256'h50e6d3c9_b6698a7c_d276f96b_1473f35a,
        256'h9338f08e_0ebee969_05d8f2e8_25208f43,
        256'h8b378c86_672aa54a_3a266ba1_9d2580ca,
        256'hcca7c308_6f5f9511_b31233da_7cab9160,
        256'h5b40ff4e_c9be536b_a23035fa_4f06064c,
        256'h60eb5af8_416b2571_49372194_e8b88749,
        256'h2f005a8a_ed8a361c_92e440c1_5520cbd1,
        256'h7b036276_11678a99_77175788_07a800e2,
        256'hcf78618f_74f6f369_6e0a4779_b90b5a77,
        256'h03720371_a04962ea_ea0a852e_69972858,
        256'h1f8a8133_aa8ccf70_e2bd3285_831ca6b7,
        256'h27936bd2_7fb1468f_c8b48bc4_83321725,
        256'hb07d4f3e_2cd2ef2e_b5459807_54dfea0f,
        256'h4bf85f1b_5d54adbc_307b0a04_8389adcb
    };

    integer i;
    
    // Monitoring output
    initial begin
        $display("Starting AES-256 CBC Testbench");
        enable_i = 1;
        kvalid_i = 0;
        ivalid_i = 0;
        cvalid_i = 0;

        $display("GFSBox Test");
        for (i = 0; i < 5; i = i + 1) begin
            resetn = 0;
            @(posedge clk);
            resetn = 1;
            
            // Send key
            send_key(GFSBOX_KEY);

            // Send IV
            send_iv(GFSBOX_IV);
            
            send_cipher(GFSBOX_CT[i]);
            wait(valid_o);
            
            @(posedge clk);
            
            if (plain_o !== GFSBOX_PT[i]) begin
                $display("Mismatch on block %0d! Expected: %h, Got: %h", i, GFSBOX_PT[i], plain_o);
            end else begin
                $display("Block %0d passed. Plaintext: %h", i, plain_o);
            end
        end
        
        $display("KeySBox Test");
        for (i = 0; i < 16; i = i + 1) begin
            resetn = 0;
            @(posedge clk);
            resetn = 1;
            
            // Send key
            send_key(KEYSBOX_KEY[i]);

            // Send IV
            send_iv(KEYSBOX_IV);
            
            send_cipher(KEYSBOX_CT[i]);
            wait(valid_o);
            
            @(posedge clk);
            
            if (plain_o !== KEYSBOX_PT) begin
                $display("Mismatch on block %0d! Expected: %h, Got: %h", i, KEYSBOX_PT, plain_o);
            end else begin
                $display("Block %0d passed. Plaintext: %h", i, plain_o);
            end
        end
        
        $display("GFSBox Test");
        for (i = 0; i < 128; i = i + 1) begin
            resetn = 0;
            @(posedge clk);
            resetn = 1;
            
            // Send key
            send_key(VARTXT_KEY);

            // Send IV
            send_iv(VARTXT_IV);
            
            send_cipher(VARTXT_CT[i]);
            wait(valid_o);
            
            @(posedge clk);
            
            if (plain_o !== VARTXT_PT[i]) begin
                $display("Mismatch on block %0d! Expected: %h, Got: %h", i, VARTXT_PT[i], plain_o);
            end else begin
                $display("Block %0d passed. Plaintext: %h", i, plain_o);
            end
        end
        
        $display("VarKey Test");
        for (i = 0; i < 256; i = i + 1) begin
            resetn = 0;
            @(posedge clk);
            resetn = 1;
            
            // Send key
            send_key(VARKEY_KEY[i]);

            // Send IV
            send_iv(VARKEY_IV);
            
            send_cipher(VARKEY_CT[i]);
            wait(valid_o);
            
            @(posedge clk);
            
            if (plain_o !== VARKEY_PT) begin
                $display("Mismatch on block %0d! Expected: %h, Got: %h", i, VARKEY_PT, plain_o);
            end else begin
                $display("Block %0d passed. Plaintext: %h", i, plain_o);
            end
        end

        $display("AES-256 CBC Test Complete.");
        $stop;
    end

endmodule
