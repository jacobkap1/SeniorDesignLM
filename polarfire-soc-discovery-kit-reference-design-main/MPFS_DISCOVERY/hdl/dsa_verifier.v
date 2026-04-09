module dsa_verifier #(
    parameter N = 256,
    parameter L = 2048
)(
    input  logic         clk,
    input  logic         resetn,
    input  logic         enable,
    input  logic         start,
    
    input  logic [N-1:0] r,
    input  logic [N-1:0] s,
    input  logic [N-1:0] h,
    
    output logic         valid,
    output logic         busy
);
    localparam [L-1:0] p = 2048'hd0f433c6c4b8a5c6c2a3d178f24ed4e96e7e17819aa5f72ee96409f547be8fd0dfb1c86e779f8c2739a5f74ccec0afa4450571f661eb58e3b99fc836453bd064d444e55f13ffcf9886cfc4793ec3b8834cf09489f4719c66f843e185bf00e985ce26bd57b3e7c1cedaa43dd10fb02b4f0643ffb55016a95440468a4931a690f864c8d1bd7a0a7727ce08819cdb69766e30169cb2350c8ea17228f0f665acb3f7540a2fa6e21281c6c0cc86387cac0a9fa3633fc85261fe2480dbd8616aa76a60013759fcb0461df99a85007b72b5e6ad4dcc157d650a658c9c1d07ab73a187ea3ad35b3333a69a3b6fcc63984e79c4e69f3e1fa9146fd2bd03a2fa54c83800db;
    localparam [N-1:0] q = 256'hae392d5e7ea739cd0dd0763f1921322d6225fd01e270eef96fc51546c381e45b;
    localparam [L-1:0] g = 2048'h6346cd6f11a9593c052049b420ba25597fbe9196f3ff6cdeb7ea9357e0b4ba380b7e018c2dab62265f3fc953206ac31078d6b77556e8f4d6dfc1fa96ce0460ede23fd315b6a73e81e81e5fd39362a9b9516e80731bf5e768a16366b1cefbb99c69f07a32151296caafab7be0c665e43ba6392ca0043f1e2125837c356c1b97da54ab0b8dc63189dbe7e14bfebe0e7754479b86fa53cd5fc7b15a7635a846933c5e42cae2df9567829aa91fef3d4fe119500f0a4e42d46e442101d39c08fa6eb81ac5bd0e6736dc55d37d373e7e6f06fdd2d34a64364ee5433077e0bf5e54e510551531035a651cc3f6d41384a4365c0dc658487a316a57858c9c3e7c7d63ae15;
    localparam [L-1:0] y = 2048'h110589a1bfb8d814db64e34bcee935ce8c6f4e7ccf2e76cf91a8675111a7efdecf9597b5d408d9995827fd07b267ffdd18f1922058011b7de0086e292126c3baae1cc282e9864dcc0aedb516017ff55be1338e6ae568e04c9083cdb4fa096553225438e77a56681605944a304fe781f3ba743a6470db05538c5a936e9ea51d990bf6dcdc902a2d1b0bcd7fab607da05a260efab6545d07df56958f8e8a4ba7b8e4456d8a54cab857cdf3da03fe79e4a1fd8dfc45dc726973068b673fa3207e48aeadd414db76bf732b4e7f1f225fa3e1aa597b59732b4fe39882c637d6e2d2d6338c2042bc3c5c964fa7ec250e9cd56cfb5b75dbd7e3b11892638c3fbcdec055;

    wire  [L-1:0] mul_a, mul_b, mul_m;
    logic [L-1:0] mul_c;
    logic         mul_start, mul_busy, mul_ready;
    
    mult #(L) mul_inst (clk, resetn, enable, mul_start, mul_a, mul_b, mul_m, mul_c, mul_busy, mul_ready);
    
    logic [N-1:0] u1, u2;
    logic [L-1:0] p1;
    
    logic [L-1:0] exp_r, exp_s, exp_mod;
    logic [N-1:0] exp_e;
    logic         exp_start, exp_ready;
    
    typedef enum logic [2:0] {EXP_AWAIT, EXP_LOOP, EXP_MUL, EXP_WAIT_R, EXP_SQ, EXP_WAIT_S} exp_state_t;
    exp_state_t exp_state;
    
    typedef enum logic [3:0] {AWAIT, COMPUTE_U1, COMPUTE_U2, COMPUTE_P1, COMPUTE_P2, COMPUTE_V, REDUCE, COMPARE} state_t;
    state_t state;
    
    assign mul_a = (exp_state == EXP_MUL) ? exp_r :
                   (exp_state == EXP_SQ)  ? exp_s :
                   (state == COMPUTE_U1)  ? h     :
                   (state == COMPUTE_U2)  ? r     :
                   (state == COMPUTE_V)   ? p1    : 'd1;
    
    assign mul_b = (exp_state != EXP_AWAIT) ? exp_s :
                   (state == REDUCE)        ? mul_c : exp_r;
    
    assign mul_m = (exp_state != EXP_AWAIT)         ? exp_mod :
                   (state == COMPUTE_V ||
                   (state == REDUCE && !mul_ready)) ? p : q;

    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            mul_start <= 1'b0;
            
            u1 <= 'd0;
            u2 <= 'd0;
            p1 <= 'd0;
            
            exp_r   <= 'd0;
            exp_s   <= 'd0;
            exp_e   <= 'd0;
            exp_mod <= 'd0;
            
            exp_start <= 1'b0; exp_ready <= 1'b0;

            valid <= 1'b0;
            busy  <= 1'b0;
            
            exp_state <= EXP_AWAIT;
            state     <= AWAIT;
            
        end else if (enable) begin
            mul_start <= 1'b0;
            exp_start <= 1'b0;
            
            case (exp_state)
                EXP_AWAIT: begin
                    exp_ready <= 1'b1;
                    
                    if (exp_start) begin
                        exp_r <= 'd1;
                        exp_ready <= 1'b0;
                        exp_state <= EXP_LOOP;
                    end
                end
                
                EXP_LOOP: begin
                    if (exp_e == 0) begin
                        exp_ready <= 1'b1;
                        exp_state <= EXP_AWAIT;
                    end else begin
                        if (exp_e[0]) exp_state <= EXP_MUL;
                        else          exp_state <= EXP_SQ;
                    end
                end
                
                EXP_MUL: begin
                    mul_start <= 1'b1;
                    exp_state <= EXP_WAIT_R;
                end
                
                EXP_WAIT_R: begin
                    if (mul_ready) begin
                        exp_r <= mul_c;
                        exp_state <= EXP_SQ;
                    end
                end
                
                EXP_SQ: begin
                    mul_start <= 1'b1;
                    exp_state <= EXP_WAIT_S;
                end
                
                EXP_WAIT_S: begin
                    if (mul_ready) begin
                        exp_s     <= mul_c;
                        exp_e     <= exp_e >> 1;
                        exp_state <= EXP_LOOP;
                    end
                end
            endcase
            
            case (state)
                AWAIT: begin
                    if (start && !busy) begin
                        if (r == 0 || s == 0 || r >= q || s >= q) begin
                            valid <= 1'b0;
                        end else begin 
                            // w = s^-1 mod q = s^(q-2) mod q
                            exp_s   <= s;
                            exp_e   <= q - 'd2;
                            exp_mod <= q;
                            
                            busy      <= 1'b1;
                            exp_start <= 1'b1;
                            state     <= COMPUTE_U1;
                        end
                    end 
                end
                
                COMPUTE_U1: begin
                    if (exp_ready) begin
                        // u1 = h * w mod q
                        mul_start <= 1'b1;
                        state     <= COMPUTE_U2;
                    end
                end
                
                COMPUTE_U2: begin
                    if (mul_ready) begin
                        u1 <= mul_c[N-1:0];
                        
                        // u2 = r * w mod q
                        mul_start <= 1'b1;
                        state <= COMPUTE_P1;
                    end
                end
                
                COMPUTE_P1: begin
                    if (mul_ready) begin
                        u2 <= mul_c[N-1:0];
                        
                        // p1 = g^u1 mod p
                        exp_s   <= g;
                        exp_e   <= u1;
                        exp_mod <= p;
                        
                        exp_start <= 1'b1;
                        state <= COMPUTE_P2;
                    end
                end
                
                COMPUTE_P2: begin
                    if (exp_ready) begin
                        p1 <= exp_r;
                        
                        // p2 = y^u2 mod p
                        exp_s   <= y;
                        exp_e   <= u2;
                        exp_mod <= p;
                        
                        exp_start <= 1'b1;
                        state <= COMPUTE_V;
                    end
                end
                
                COMPUTE_V: begin
                    if (exp_ready) begin
                        // v = p1 * p2 mod p
                        mul_start <= 1'b1;
                        state <= REDUCE;
                    end
                end
                
                REDUCE: begin
                    if (mul_ready) begin
                        // v = v mod q
                        mul_start <= 1'b1;
                        state <= COMPARE;
                    end
                end
                
                COMPARE: begin
                    if (mul_ready) begin                        
                        valid <= mul_c == r;
                        
                        busy  <= 1'b0;
                        state <= AWAIT;
                    end
                end
            endcase
        end
    end
endmodule