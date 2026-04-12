module dom_rng #(
    parameter SHARES = 3
)(
    input  logic [63:0] data_i,
    
    output logic [3:0] zm0[0:(SHARES*(SHARES-1)/2)-1],
    output logic [3:0] zm1[0:(SHARES*(SHARES-1)/2)-1],
    output logic [3:0] zm2[0:(SHARES*(SHARES-1)/2)-1],
    output logic [1:0] zi0[0:(SHARES*(SHARES-1)/2)-1],
    output logic [1:0] zi1[0:(SHARES*(SHARES-1)/2)-1],
    output logic [1:0] zi2[0:(SHARES*(SHARES-1)/2)-1]
);
    genvar i;
    generate
        for (i = 0; i < SHARES*(SHARES-1)/2; i++) begin
            assign zm0[i] = data_i[18*i + 3 :18*i     ];
            assign zm1[i] = data_i[18*i + 7 :18*i +  4];
            assign zm2[i] = data_i[18*i + 11:18*i +  8]; 
            assign zi0[i] = data_i[18*i + 13:18*i + 12]; 
            assign zi1[i] = data_i[18*i + 15:18*i + 14]; 
            assign zi2[i] = data_i[18*i + 17:18*i + 16]; 
        end
    endgenerate
endmodule