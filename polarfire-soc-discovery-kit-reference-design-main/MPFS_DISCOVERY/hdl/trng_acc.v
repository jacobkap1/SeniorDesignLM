module trng_acc(
    input  logic        clk,
    input  logic        resetn,
    input  logic        enable_i,
    input  logic [7:0]  byte_i,
    input  logic        trng_valid,

    output logic [63:0] seed_o,
    output logic        valid_o
);
    logic [2:0] count;
    
    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            seed_o  <= 64'd0;
            count    = 3'd0;
            valid_o <= 1'b0;
        end else if (enable_i) begin
            if (trng_valid) begin
                seed_o <= {seed_o[55:0], byte_i};
                
                if (count < 3'd7) count = count + 1;
            end

            valid_o <= count == 3'd7;
        end else begin
            valid_o <= 1'b0;
        end
    end
endmodule