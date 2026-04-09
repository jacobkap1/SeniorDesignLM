module trivium (
    input  logic        clk,
    input  logic        resetn,
    input  logic        enable_i,
    input  logic [63:0] seed_i,
    input  logic        valid_i,
    input  logic        reseed_i,

    output logic [63:0] z,
    output logic        valid_o
);
    logic [63:0] A[0:1];
    logic [63:0] B[0:1];
    logic [63:0] C[0:1];
    
    logic [63:0] s66,  s69,  s91,  s92,  s93;
    logic [63:0] s162, s171, s175, s176, s177;
    logic [63:0] s243, s264, s286, s287, s288;
    logic [63:0] t1, t2, t3;
    
    logic seeded;
    
    assign s66  = (A[1] << 62) ^ (A[0] >>  2);
    assign s93  = (A[1] << 35) ^ (A[0] >> 29);
    assign s162 = (B[1] << 59) ^ (B[0] >>  5);
    assign s177 = (B[1] << 44) ^ (B[0] >> 20);
    assign s243 = (C[1] << 62) ^ (C[0] >>  2);
    assign s288 = (C[1] << 17) ^ (C[0] >> 47);
    assign s91  = (A[1] << 37) ^ (A[0] >> 27);
    assign s92  = (A[1] << 36) ^ (A[0] >> 28);
    assign s171 = (B[1] << 50) ^ (B[0] >> 14);
    assign s175 = (B[1] << 46) ^ (B[0] >> 18);
    assign s176 = (B[1] << 45) ^ (B[0] >> 19);
    assign s264 = (C[1] << 41) ^ (C[0] >> 23);
    assign s286 = (C[1] << 19) ^ (C[0] >> 45);
    assign s287 = (C[1] << 18) ^ (C[0] >> 46);
    assign s69  = (A[1] << 59) ^ (A[0] >>  5);
    
    assign t1 = s66  ^ s93;
    assign t2 = s162 ^ s177;
    assign t3 = s243 ^ s288;
        
    logic [4:0] t;
    
    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            A <= '{default: 64'd0};
            B <= '{default: 64'd0};
            C <= '{default: 64'd0};
            
            seeded   = 1'b0;
            z       <= 64'b0;                    
            valid_o <= 1'b0;
        end else if (enable_i) begin
            if (reseed_i) seeded = 1'b0;
            
            if (valid_i && !seeded) begin
                A[0] <= seed_i;
                A[1] <= 64'd0;
                
                B[0] <= 64'd0;
                B[1] <= 64'd0;
                
                C[0] <= 64'd0;
                C[1] <= 64'h700000000000;
                
                seeded = 1'b1;
                t <= 5'd0;
            end else if (seeded) begin
                z <= t1 ^ t2 ^ t3;
                
                A[1] <= A[0];
                A[0] <= t3 ^ s171 ^ (s91 & s92);
                
                B[1] <= B[0];
                B[0] <= t2 ^ s264 ^ (s175 & s176);
                
                C[1] <= C[0];
                C[0] <= t1 ^ s69 ^ (s286 & s287);
                
                if (t < 5'd18) begin
                    t <= t + 1;
                    valid_o <= 1'b0;
                end else valid_o <= 1'b1;
            end
        end else begin
            valid_o <= 1'b0;
        end
    end
endmodule