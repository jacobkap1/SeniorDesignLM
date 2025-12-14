`timescale 1ns/1ps

module tb_aes256_cbc;

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
    AES256_CBC dut (
        .clk(clk),
        .resetn(resetn),
        .enable_i(enable_i),
        .key_i(key_i),
        .kvalid_i(kvalid_i),
        .iv_i(iv_i),
        .ivalid_i(ivalid_i),
        .c_i(c_i),
        .cvalid_i(cvalid_i),
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
    localparam [255:0] TEST_KEY = 256'b0;
    localparam [127:0] TEST_IV  = 128'h0;
    
    localparam [127:0] TEST_CT[0:4]  = '{
        128'h5c9d844e_d46f9885_085e5d6a_4f94c7d7,
        128'ha9ff75bd_7cf6613d_3731c77c_3b6d0c04,
        128'h623a52fc_ea5d443e_48d9181a_b32c7421,
        128'h38f2c7ae_10612415_d27ca190_d27da8b4,
        128'h1bc704f1_bce135ce_b810341b_216d7abe
    };
    
    localparam [127:0] TEST_PT[0:4]  = '{
        128'h014730f8_0ac625fe_84f026c6_0bfd547d,
        128'h0b24af36193ce4665f2825d7b4749c98,
        128'h761c1fe41a18acf20d241650611d90f1,
        128'h8a560769d605868ad80d819bdba03771,
        128'h91fbef2d15a97816060bee1feaa49afe
    };

    integer i;
    
    // Monitoring output
    initial begin
        $display("Starting AES-256 CBC Testbench");
        enable_i = 1;
        kvalid_i = 0;
        ivalid_i = 0;
        cvalid_i = 0;
        resetn = 0;
        @(posedge clk);
        @(posedge clk);
        resetn = 1;

        // Send key
        send_key(TEST_KEY);

        // Send IV
        send_iv(TEST_IV);

        // Send ciphertext blocks and check plaintext
        for (i = 0; i < 5; i = i + 1) begin
            send_cipher(TEST_CT[i]);
            wait(valid_o);
            if (plain_o !== TEST_PT[i]) begin
                $display("Mismatch on block %0d! Expected: %h, Got: %h", i, TEST_PT[i], plain_o);
            end else begin
                $display("Block %0d passed. Plaintext: %h", i, plain_o);
            end
        end

        $display("AES-256 CBC Test Complete.");
        $stop;
    end

endmodule
