// -----------------------------------------------------------------------------
// sha256_tb.v  (SystemVerilog testbench)
// Tests NIST vectors ("", "abc", and multi-block "abc...nopq")
// Also includes 1,000,000 'a' performance test
// -----------------------------------------------------------------------------
`timescale 1ns/1ps

module sha256_tb;

  // DUT inputs
  logic         clk = 0;
  logic         resetn = 0;
  logic         enable = 1;
  logic         clear  = 0;

  logic [511:0] block_in    = 512'h0;
  logic         block_valid = 0;
  logic         end_flag    = 0;
  logic [9:0]   last_bits   = 10'd0;

  // DUT outputs
  logic [255:0] digest;
  logic         wready;
  logic         done;

  // Instantiate DUT (unchanged)
  sha256 dut (
    .clk(clk), .resetn(resetn),
    .enable_i(enable), .clear_i(clear),
    .block_i(block_in), .valid_i(block_valid),
    .end_i(end_flag), .last_i(last_bits),
    .digest_o(digest), .ready_o(wready), .valid_o(done)
  );

  // 100 MHz clock
  always #5 clk = ~clk;

  // ---------------------------------------------------------------------------
  // Tasks
  // ---------------------------------------------------------------------------

  task pulse_reset();
    begin
      resetn = 0;
      repeat (4) @(negedge clk);
      resetn = 1;
      @(negedge clk);
    end
  endtask

  task clear_regs();
    begin
      @(negedge clk); clear <= 1;
      @(negedge clk); clear <= 0;
    end
  endtask

  // Non-final block
  task send_block(input logic [511:0] b);
    int guard;
    begin
      @(negedge clk);
      guard = 0;
      while (!wready && guard < 20000) begin
        @(negedge clk);
        guard++;
      end
      if (!wready) begin
        $display("[%0t] ERROR: timeout waiting for wready", $time);
        $stop;
      end
      
      block_in    <= b;
      block_valid <= 1'b1;
      @(negedge clk);
      block_valid <= 1'b0;
    end
  endtask

  // Final block (nbits = valid bits)
  task send_last_block(input logic [511:0] b, input logic [9:0] nbits);
    int guard;
    begin
      @(negedge clk);
      guard = 0;
      while (!wready && guard < 20000) begin
        @(negedge clk);
        guard++;
      end
      if (!wready) begin
        $display("[%0t] ERROR: timeout waiting for wready", $time);
        $stop;
      end
      
      block_in    <= b;
      last_bits   <= nbits;
      block_valid <= 1'b1;
      end_flag    <= 1'b1;
      @(negedge clk);
      block_valid <= 1'b0;
      end_flag    <= 1'b0;
    end
  endtask

  // Empty message
  task end_empty();
    int guard;
    begin
      @(negedge clk);
      guard = 0;
      while (!wready && guard < 20000) begin
        @(negedge clk);
        guard++;
      end
      if (!wready) begin
        $display("[%0t] ERROR: timeout waiting for wready", $time);
        $stop;
      end

      end_flag  <= 1'b1;
      last_bits <= 10'd0;
      @(negedge clk);
      end_flag  <= 1'b0;
    end
  endtask

  // Wait until done=1
  task wait_done();
    int guard;
    begin
      guard = 0;
      while (!done && guard < 20000) begin
        @(negedge clk);
        guard++;
      end
      if (!done) begin
        $display("[%0t] ERROR: timeout waiting for done", $time);
        $stop;
      end
    end
  endtask

  // ---------------------------------------------------------------------------
  // NIST test vectors
  // ---------------------------------------------------------------------------

  localparam logic [255:0] DIGEST_EMPTY = 256'h
    e3b0c442_98fc1c14_9afbf4c8_996fb924_27ae41e4_649b934c_a495991b_7852b855;

  localparam logic [255:0] DIGEST_ABC = 256'h
    ba7816bf_8f01cfea_414140de_5dae2223_b00361a3_96177a9c_b410ff61_f20015ad;

  localparam logic [255:0] DIGEST_ABC_MULTI = 256'h
    248d6a61_d20638b8_e5c02693_0c3e6039_a33ce459_64ff2167_f6ecedd4_19db06c1;

  localparam logic [255:0] DIGEST_MILLION_A = 256'h
    cdc76e5c_9914fb92_81a1c7e2_84d73e67_f1809a48_a497200e_046d39cc_c7112cd0;

  // ---------------------------------------------------------------------------
  // Test sequence
  // ---------------------------------------------------------------------------

  int i, j;
  time start_time, end_time;

  initial begin
    pulse_reset();

    // Test 1: empty
    clear_regs();
    end_empty();
    wait_done();
    if (digest === DIGEST_EMPTY)
      $display("? PASS: SHA256(\"\")");
    else begin
      $display("? FAIL: SHA256(\"\") got %h", digest);
      $stop;
    end

    // Test 2: "abc"
    clear_regs();
    send_last_block({32'h61626300, 480'b0}, 10'd24);
    wait_done();
    if (digest === DIGEST_ABC)
      $display("? PASS: SHA256(\"abc\")");
    else begin
      $display("? FAIL: SHA256(\"abc\") got %h", digest);
      $stop;
    end

    // Test 3: multi-block
    clear_regs();
    send_last_block(
      {
        128'h61626364_62636465_63646566_64656667,
        128'h65666768_66676869_6768696a_68696a6b,
        128'h696a6b6c_6a6b6c6d_6b6c6d6e_6c6d6e6f,
        128'h6d6e6f70_6e6f7071_00000000_00000000
      },
      10'd448
    );
    wait_done();
    if (digest === DIGEST_ABC_MULTI)
      $display("? PASS: multi-block NIST test");
    else begin
      $display("? FAIL: multi-block NIST test got %h", digest);
      $stop;
    end

    $display("? All short NIST vectors passed.");

    // Million 'a'
    clear_regs();
    for (j = 0; j < 15625 - 1; j++)
      send_block({64{8'h61}});

    send_last_block({64{8'h61}}, 10'd512);
    wait_done();

    if (digest === DIGEST_MILLION_A)
      $display("? PASS: SHA256(1M � 'a')");
    else begin
      $display("? FAIL: SHA256(1M � 'a') got %h", digest);
      $stop;
    end

    $display("? All tests completed successfully.");
    $finish;
  end

endmodule
