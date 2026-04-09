module security_core #(
    parameter SHARES = 3
)(
    input wire          clk,
    input wire          resetn,
    
    input wire [31:0]   awaddr,
    input wire          awvalid,
    output wire         awready,
    input wire [31:0]   wdata,
    input wire [3:0]    wstrb,
    input wire          wvalid,
    output wire         wready,
    output wire [1:0]   bresp,
    output wire         bvalid,
    input wire          bready,
    input wire [31:0]   araddr,
    input wire          arvalid,
    output wire         arready,
    output wire [31:0]  rdata,
    output wire [1:0]   rresp,
    output wire         rvalid,
    input wire          rready
);
    integer i;
    // Internal signals
    reg [31:0] rdata_reg;
    reg rvalid_reg, bvalid_reg;
    reg awready_reg, wready_reg, arready_reg;

    assign awready = awready_reg;
    assign wready = wready_reg;
    assign bresp = 2'b00; // OKAY response
    assign bvalid = bvalid_reg;
    assign arready = arready_reg;
    assign rdata = rdata_reg;
    assign rresp = 2'b00; // OKAY response
    assign rvalid = rvalid_reg;

    localparam integer ADDR_LSB = 2; // 32-bit word aligned
    localparam integer OPT_MEM_ADDR_BITS = 5;

    // Write address handshake
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            awready_reg <= 1'b0;
        end else if (awvalid && !awready_reg) begin
            awready_reg <= 1'b1;
        end else begin
            awready_reg <= 1'b0;
        end
    end
    
    // Stream
    logic [31:0] stream_in;
    
    // SHA
    logic [511:0] hash_block;
    logic [255:0] hash_digest;
    logic [3:0]   hash_count;
    logic         hash_enable, hash_end, msg_end, hash_block_valid, hash_ready, hash_valid;
    logic [1:0]   hash_state;
    
    wire hash_write;
    assign hash_write = hash_ready || hash_count < 4'd15;

    // RNG
    logic [63:0] z;
    logic [3:0]  zm0[0:(SHARES*(SHARES-1)/2)-1], zm1[0:(SHARES*(SHARES-1)/2)-1], zm2[0:(SHARES*(SHARES-1)/2)-1];
    logic [1:0]  zi0[0:(SHARES*(SHARES-1)/2)-1], zi1[0:(SHARES*(SHARES-1)/2)-1], zi2[0:(SHARES*(SHARES-1)/2)-1];
    logic        rng_valid;
    
    // AES
    logic [255:0] aes_key[0:SHARES-1];
    logic [127:0] aes_block[0:SHARES-1], aes_exp[0:SHARES-1], aes_plain;
    logic [3:0]   aes_exp_addr;
    logic [1:0]   aes_count;
    logic         aes_enable, aes_reseed, aes_puf, aes_key_valid, aes_block_valid, aes_end, aes_exp_valid, aes_ready, aes_valid, aes_stream;
    
    wire aes_write;
    assign aes_write = aes_stream && (aes_ready || aes_count < 2'd3);
    
    logic [7:0] k_sbox[0:SHARES-1], d_sbox[0:SHARES-1], sbox_i[0:SHARES-1], sbox_o[0:SHARES-1];
    
    genvar k;
    generate
        for (k = 0; k < SHARES; k++) begin
            assign sbox_i[k] = (aes_exp_valid ? d_sbox[k] : k_sbox[k]);
        end
    endgenerate

    // Write data handshake
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            wready_reg <= 1'b0;
            bvalid_reg <= 1'b0;
            
            hash_block       <= 512'b0;
            hash_count       <= 4'b0;
            
            hash_enable      <= 1'b0;
            hash_block_valid <= 1'b0;
            hash_end         <= 1'b0;
            msg_end          <= 1'b0;
            
            for (i = 0; i < SHARES; i++) begin
                aes_key[i]   <= 256'b0;
                aes_block[i] <= 128'b0;
            end
            
            aes_exp_addr <= 4'b0;
            aes_count    <= 2'b0;
            
            aes_enable      <= 1'b0;
            aes_reseed      <= 1'b0;
            aes_key_valid   <= 1'b0;
            aes_block_valid <= 1'b0;
            aes_end         <= 1'b0;
            
            aes_stream      <= 1'b0;
        end else begin
            
            hash_block_valid <= 1'b0;
            msg_end          <= 1'b0;
            aes_key_valid    <= 1'b0;
            aes_block_valid  <= 1'b0;
            aes_reseed       <= 1'b0;
            aes_stream       <= 1'b0;
            aes_end          <= 1'b0;
            
            if (aes_exp_valid) begin
                if (aes_exp_addr == 4'd14) aes_stream <= 1'b1;
                else begin
                    aes_block <= aes_exp;
                    aes_block_valid <= 1'b1;
                    aes_exp_addr <= aes_exp_addr + 1;
                end
            end else aes_exp_addr <= 4'b0;
            
            if (wvalid && !wready_reg) begin
            wready_reg <= 1'b1;
            
            case (awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS-1:ADDR_LSB])
                // CTRL
                5'd0: begin
                    if (wstrb[0]) begin
                        hash_enable <= wdata[0];
                        aes_enable  <= wdata[1];
                        
                        hash_end <= wdata[2];
                        
                        aes_reseed <= wdata[3];
                        
                        aes_puf       <= wdata[4];
                        aes_key_valid <= wdata[5];
                        aes_end       <= wdata[6];
                    end
                end
                // Hash
                5'd1: begin
                    if (hash_write) begin
                        stream_in = 32'b0;
                        
                        if (wstrb[0]) stream_in[ 7: 0] = wdata[ 7: 0];
                        if (wstrb[1]) stream_in[15: 8] = wdata[15: 8];
                        if (wstrb[2]) stream_in[23:16] = wdata[23:16];
                        if (wstrb[3]) stream_in[31:24] = wdata[31:24];
                        
                        hash_block <= {hash_block[479:0], stream_in};
                        
                        if (hash_count == 4'd15) begin
                            hash_block_valid <= 1'b1;
                            hash_count <= 4'd0;
                            if (hash_end) begin
                                msg_end <= 1'b1;
                                hash_end <= 1'b0;
                            end
                        end else hash_count <= hash_count + 1;
                    end
                end
                // AES Key
                5'd2: begin
                    if (rng_valid) begin
                        if (wstrb[0]) begin
                            aes_key[0][231:224] <= wdata[7:0] ^ z[7:0] ^ z[15:8];
                            aes_key[1][231:224] <= z[7:0];
                            aes_key[2][231:224] <= z[15:8];
                        end
                        
                        if (wstrb[1]) begin
                            aes_key[0][239:232] <= wdata[15:8] ^ z[23:16] ^ z[31:24];
                            aes_key[1][239:232] <= z[23:16];
                            aes_key[2][239:232] <= z[31:24];
                        end
                        
                        if (wstrb[2]) begin
                            aes_key[0][247:240] <= wdata[23:16] ^ z[39:32] ^ z[47:40];
                            aes_key[1][247:240] <= z[39:32];
                            aes_key[2][247:240] <= z[47:40];
                        end
                        
                        if (wstrb[3]) begin
                            aes_key[0][255:248] <= wdata[31:24] ^ z[55:48] ^ z[63:56];
                            aes_key[1][255:248] <= z[55:48];
                            aes_key[2][255:248] <= z[63:56];
                        end
                    end
                end
                5'd3: begin
                    if (rng_valid) begin
                        if (wstrb[0]) begin
                            aes_key[0][199:192] <= wdata[7:0] ^ z[7:0] ^ z[15:8];
                            aes_key[1][199:192] <= z[7:0];
                            aes_key[2][199:192] <= z[15:8];
                        end
                        
                        if (wstrb[1]) begin
                            aes_key[0][207:200] <= wdata[15:8] ^ z[23:16] ^ z[31:24];
                            aes_key[1][207:200] <= z[23:16];
                            aes_key[2][207:200] <= z[31:24];
                        end
                        
                        if (wstrb[2]) begin
                            aes_key[0][215:208] <= wdata[23:16] ^ z[39:32] ^ z[47:40];
                            aes_key[1][215:208] <= z[39:32];
                            aes_key[2][215:208] <= z[47:40];
                        end
                        
                        if (wstrb[3]) begin
                            aes_key[0][223:216] <= wdata[31:24] ^ z[55:48] ^ z[63:56];
                            aes_key[1][223:216] <= z[55:48];
                            aes_key[2][223:216] <= z[63:56];
                        end
                    end
                end
                5'd4: begin
                    if (rng_valid) begin
                        if (wstrb[0]) begin
                            aes_key[0][167:160] <= wdata[7:0] ^ z[7:0] ^ z[15:8];
                            aes_key[1][167:160] <= z[7:0];
                            aes_key[2][167:160] <= z[15:8];
                        end
                        
                        if (wstrb[1]) begin
                            aes_key[0][175:168] <= wdata[15:8] ^ z[23:16] ^ z[31:24];
                            aes_key[1][175:168] <= z[23:16];
                            aes_key[2][175:168] <= z[31:24];
                        end
                        
                        if (wstrb[2]) begin
                            aes_key[0][183:176] <= wdata[23:16] ^ z[39:32] ^ z[47:40];
                            aes_key[1][183:176] <= z[39:32];
                            aes_key[2][183:176] <= z[47:40];
                        end
                        
                        if (wstrb[3]) begin
                            aes_key[0][191:184] <= wdata[31:24] ^ z[55:48] ^ z[63:56];
                            aes_key[1][191:184] <= z[55:48];
                            aes_key[2][191:184] <= z[63:56];
                        end
                    end
                end
                5'd5: begin
                    if (rng_valid) begin
                        if (wstrb[0]) begin
                            aes_key[0][135:128] <= wdata[7:0] ^ z[7:0] ^ z[15:8];
                            aes_key[1][135:128] <= z[7:0];
                            aes_key[2][135:128] <= z[15:8];
                        end
                        
                        if (wstrb[1]) begin
                            aes_key[0][143:136] <= wdata[15:8] ^ z[23:16] ^ z[31:24];
                            aes_key[1][143:136] <= z[23:16];
                            aes_key[2][143:136] <= z[31:24];
                        end
                        
                        if (wstrb[2]) begin
                            aes_key[0][151:144] <= wdata[23:16] ^ z[39:32] ^ z[47:40];
                            aes_key[1][151:144] <= z[39:32];
                            aes_key[2][151:144] <= z[47:40];
                        end
                        
                        if (wstrb[3]) begin
                            aes_key[0][159:152] <= wdata[31:24] ^ z[55:48] ^ z[63:56];
                            aes_key[1][159:152] <= z[55:48];
                            aes_key[2][159:152] <= z[63:56];
                        end
                    end
                end
                5'd6: begin
                    if (rng_valid) begin
                        if (wstrb[0]) begin
                            aes_key[0][103: 96] <= wdata[7:0] ^ z[7:0] ^ z[15:8];
                            aes_key[1][103: 96] <= z[7:0];
                            aes_key[2][103: 96] <= z[15:8];
                        end
                        
                        if (wstrb[1]) begin
                            aes_key[0][111:104] <= wdata[15:8] ^ z[23:16] ^ z[31:24];
                            aes_key[1][111:104] <= z[23:16];
                            aes_key[2][111:104] <= z[31:24];
                        end
                        
                        if (wstrb[2]) begin
                            aes_key[0][119:112] <= wdata[23:16] ^ z[39:32] ^ z[47:40];
                            aes_key[1][119:112] <= z[39:32];
                            aes_key[2][119:112] <= z[47:40];
                        end
                        
                        if (wstrb[3]) begin
                            aes_key[0][127:120] <= wdata[31:24] ^ z[55:48] ^ z[63:56];
                            aes_key[1][127:120] <= z[55:48];
                            aes_key[2][127:120] <= z[63:56];
                        end
                    end
                end
                5'd7: begin
                    if (rng_valid) begin
                        if (wstrb[0]) begin
                            aes_key[0][71:64] <= wdata[7:0] ^ z[7:0] ^ z[15:8];
                            aes_key[1][71:64] <= z[7:0];
                            aes_key[2][71:64] <= z[15:8];
                        end
                        
                        if (wstrb[1]) begin
                            aes_key[0][79:72] <= wdata[15:8] ^ z[23:16] ^ z[31:24];
                            aes_key[1][79:72] <= z[23:16];
                            aes_key[2][79:72] <= z[31:24];
                        end
                        
                        if (wstrb[2]) begin
                            aes_key[0][87:80] <= wdata[23:16] ^ z[39:32] ^ z[47:40];
                            aes_key[1][87:80] <= z[39:32];
                            aes_key[2][87:80] <= z[47:40];
                        end
                        
                        if (wstrb[3]) begin
                            aes_key[0][95:88] <= wdata[31:24] ^ z[55:48] ^ z[63:56];
                            aes_key[1][95:88] <= z[55:48];
                            aes_key[2][95:88] <= z[63:56];
                        end
                    end
                end
                5'd8: begin
                    if (rng_valid) begin
                        if (wstrb[0]) begin
                            aes_key[0][39:32] <= wdata[7:0] ^ z[7:0] ^ z[15:8];
                            aes_key[1][39:32] <= z[7:0];
                            aes_key[2][39:32] <= z[15:8];
                        end
                        
                        if (wstrb[1]) begin
                            aes_key[0][47:40] <= wdata[15:8] ^ z[23:16] ^ z[31:24];
                            aes_key[1][47:40] <= z[23:16];
                            aes_key[2][47:40] <= z[31:24];
                        end
                        
                        if (wstrb[2]) begin
                            aes_key[0][55:48] <= wdata[23:16] ^ z[39:32] ^ z[47:40];
                            aes_key[1][55:48] <= z[39:32];
                            aes_key[2][55:48] <= z[47:40];
                        end
                        
                        if (wstrb[3]) begin
                            aes_key[0][63:56] <= wdata[31:24] ^ z[55:48] ^ z[63:56];
                            aes_key[1][63:56] <= z[55:48];
                            aes_key[2][63:56] <= z[63:56];
                        end
                    end
                end
                5'd9: begin
                    if (rng_valid) begin
                        if (wstrb[0]) begin
                            aes_key[0][ 7: 0] <= wdata[7:0] ^ z[7:0] ^ z[15:8];
                            aes_key[1][ 7: 0] <= z[7:0];
                            aes_key[2][ 7: 0] <= z[15:8];
                        end
                        
                        if (wstrb[1]) begin
                            aes_key[0][15: 8] <= wdata[15:8] ^ z[23:16] ^ z[31:24];
                            aes_key[1][15: 8] <= z[23:16];
                            aes_key[2][15: 8] <= z[31:24];
                        end
                        
                        if (wstrb[2]) begin
                            aes_key[0][23:16] <= wdata[23:16] ^ z[39:32] ^ z[47:40];
                            aes_key[1][23:16] <= z[39:32];
                            aes_key[2][23:16] <= z[47:40];
                        end
                        
                        if (wstrb[3]) begin
                            aes_key[0][31:24] <= wdata[31:24] ^ z[55:48] ^ z[63:56];
                            aes_key[1][31:24] <= z[55:48];
                            aes_key[2][31:24] <= z[63:56];
                        end
                    end
                end
                
                // AES Ciphertext
                5'd10: begin
                    if (rng_valid && aes_write) begin
                        stream_in = 32'b0;
                        
                        if (wstrb[0]) stream_in[ 7: 0] = wdata[ 7: 0];
                        if (wstrb[1]) stream_in[15: 8] = wdata[15: 8];
                        if (wstrb[2]) stream_in[23:16] = wdata[23:16];
                        if (wstrb[3]) stream_in[31:24] = wdata[31:24];
                        
                        aes_block[0] <= {aes_block[0][95:0], stream_in ^ z[63:32] ^ z[31:0]};
                        aes_block[1] <= {aes_block[1][95:0], z[63:32]};
                        aes_block[2] <= {aes_block[2][95:0], z[31:0]};
                        
                        if (aes_count == 2'd3) begin
                            aes_block_valid <= 1'b1;
                            aes_count <= 2'd0;
                        end else aes_count <= aes_count + 1;
                    end
                end
                default: begin
                    // Handle invalid addresses
                end
            endcase
            bvalid_reg <= 1'b1;
            end else if (bready && bvalid_reg) begin
                bvalid_reg <= 1'b0;
            end else begin
                wready_reg <= 1'b0;
            end
        end
    end

    // Read address handshake
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            arready_reg <= 1'b0;
            rvalid_reg <= 1'b0;
        end else if (arvalid && !arready_reg) begin
            arready_reg <= 1'b1;
            case (araddr[ADDR_LSB+OPT_MEM_ADDR_BITS-1:ADDR_LSB])
                5'd0:  rdata_reg <= {25'b0, aes_end, aes_key_valid, aes_puf, aes_reseed, hash_end, aes_enable, hash_enable}; // 0x00
                
                5'd1:  rdata_reg <= hash_block[31:0];                                                   // 0x04
                
                5'd2:  rdata_reg <= aes_key[0][255:224] ^ aes_key[1][255:224] ^ aes_key[2][255:224];    // 0x08
                5'd3:  rdata_reg <= aes_key[0][223:192] ^ aes_key[1][223:192] ^ aes_key[2][223:192];    // 0x0C
                5'd4:  rdata_reg <= aes_key[0][191:160] ^ aes_key[1][191:160] ^ aes_key[2][191:160];    // 0x10
                5'd5:  rdata_reg <= aes_key[0][159:128] ^ aes_key[1][159:128] ^ aes_key[2][159:128];    // 0x14
                5'd6:  rdata_reg <= aes_key[0][127: 96] ^ aes_key[1][127: 96] ^ aes_key[2][127: 96];    // 0x18
                5'd7:  rdata_reg <= aes_key[0][ 95: 64] ^ aes_key[1][ 95: 64] ^ aes_key[2][ 95: 64];    // 0x1C
                5'd8:  rdata_reg <= aes_key[0][ 63: 32] ^ aes_key[1][ 63: 32] ^ aes_key[2][ 63: 32];    // 0x20
                5'd9:  rdata_reg <= aes_key[0][ 31:  0] ^ aes_key[1][ 31:  0] ^ aes_key[2][ 31:  0];    // 0x24
                
                5'd11: rdata_reg <= hash_digest[255:224];                                               // 0x2C
                5'd12: rdata_reg <= hash_digest[223:192];                                               // 0x30
                5'd13: rdata_reg <= hash_digest[191:160];                                               // 0x34
                5'd14: rdata_reg <= hash_digest[159:128];                                               // 0x38
                5'd15: rdata_reg <= hash_digest[127: 96];                                               // 0x3C
                5'd16: rdata_reg <= hash_digest[ 95: 64];                                               // 0x40
                5'd17: rdata_reg <= hash_digest[ 63: 32];                                               // 0x44
                5'd18: rdata_reg <= hash_digest[ 31:  0];                                               // 0x48
                
                5'd19: rdata_reg <= aes_plain[127: 96];                                                 // 0x4C
                5'd20: rdata_reg <= aes_plain[ 95: 64];                                                 // 0x50
                5'd21: rdata_reg <= aes_plain[ 63: 32];                                                 // 0x54
                5'd22: rdata_reg <= aes_plain[ 31:  0];                                                 // 0x58
                
                5'd23: rdata_reg <= {27'b0, aes_valid, aes_write, rng_valid, hash_valid, hash_write};   // 0x5C
                default: rdata_reg <= 32'h00000000; // Default value
            endcase
            rvalid_reg <= 1'b1;
        end else if (rready && rvalid_reg) begin
            rvalid_reg <= 1'b0;
        end else begin
            arready_reg <= 1'b0;
        end
    end
    
    // SHA256
    sha256 hash_core (
        .clk      (clk),
        .resetn   (resetn),
        .enable_i (hash_enable),
        .block_i  (hash_block),
        .valid_i  (hash_block_valid),
        .end_i    (msg_end),
        .digest_o (hash_digest),
        .ready_o  (hash_ready),
        .valid_o  (hash_valid)
    );
    
    // RNG
    csprng rng(.clk(clk), .resetn(resetn), .enable_i(aes_enable), .reseed_i(aes_reseed), .valid_o(rng_valid), .z(z));
    dom_rng #(SHARES) dom(z, zm0, zm1, zm2, zi0, zi1, zi2);
    
    // SBOX
    sbox #(SHARES) sbox(clk, resetn, aes_enable, sbox_i, zm0, zm1, zm2, zi0, zi1, zi2, aes_exp_valid, sbox_o);
    
    // AES
    aes256_key_expansion #(SHARES) key_expansion(clk, resetn, aes_enable, aes_key, aes_key_valid, aes_end, k_sbox, sbox_o, aes_exp_addr, aes_exp, aes_exp_valid);
    aes256_dec #(SHARES) dec(clk, resetn, aes_enable, aes_block, aes_block_valid, aes_end, d_sbox, sbox_o, aes_plain, aes_ready, aes_valid);

endmodule