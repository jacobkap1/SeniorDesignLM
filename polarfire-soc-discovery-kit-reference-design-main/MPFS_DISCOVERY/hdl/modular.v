module mult #(
    parameter WIDTH = 256
)(
    input  logic         clk,
    input  logic         resetn,
    input  logic         enable,
    input  logic         start,
    
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [WIDTH-1:0] m,

    output wire  [WIDTH-1:0] c,
    output logic             busy,
    output logic             ready
);

    logic [WIDTH-1:0] a_reg, b_reg;
    logic [WIDTH:0]   p;
    wire  [WIDTH:0]   p_add, p_next, a_next;
    
    assign p_add  = (b_reg[0]) ? p + a_reg : p;
    assign p_next = (p_add >= m) ? p_add - m : p_add;
    assign a_next = ({a_reg[WIDTH-2:0], 1'b0} >= m) ? 
                     {a_reg[WIDTH-2:0], 1'b0} - m : 
                     {a_reg[WIDTH-2:0], 1'b0};
    
    logic [$clog2(WIDTH)-1:0] t;

    assign c = p_next;

    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            a_reg <= 'd0;
            b_reg <= 'd0;
            p     <= 'd0;
            t     <= 'd0;
            
            busy  <= 1'b0;
            ready <= 1'b0;
        end else if (enable) begin
            ready <= 1'b0;
            if (start && !busy) begin
                p     <= 'd0;
                a_reg <= a;
                b_reg <= b;
                t     <= 'd0;
                busy  <= 1'b1;
            end else if (busy) begin
                if (t == WIDTH - 1) begin
                    ready <= 1'b1;
                    busy  <= 1'b0;
                end else begin
                    p     <= p_next;
                    a_reg <= a_next;
                    t     <= t + 1;
                    b_reg <= b_reg >> 1;
                end
            end
        end
    end
endmodule