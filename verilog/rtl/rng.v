`timescale 1ns/1ps

module rng(
    input  logic          clk,
    input  logic          resetn,
    input  logic          enable_i,
    input  logic [127:0]  seed_i,

    output logic [255:0]  m0_o,
    output logic [255:0]  m1_o,
    output logic [431:0]  rw_o,
    output logic [3455:0] rb_o,
    output logic          valid_o
);

    // Optional: seed the RNG once at reset using SystemVerilog's srandom()
    initial begin
        void'($urandom(seed_i));  // seeds SV RNG
    end
    
    logic [3455:0] randomness;
    
    assign m0_o = randomness[255:0];
    assign m1_o = randomness[511:256];
    assign rw_o = randomness[943:512];
    assign rb_o = randomness;

    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            randomness  <= '0;
            valid_o <= 1'b0;
        end else if (enable_i) begin
            randomness <= {
                $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(),
                $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(),
                $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(),
                $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(),
                $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(),
                $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(),
                $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(),
                $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(),
                $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(),
                $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(),
                $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(),
                $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(),
                $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(),
                $urandom(), $urandom(), $urandom(), $urandom()
            };
            
            valid_o <= 1'b1;
        end else begin
            valid_o <= 1'b0;
        end
    end

endmodule
