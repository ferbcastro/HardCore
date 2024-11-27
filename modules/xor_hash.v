module xor_hash (input wire[511:0] linha_cache, output wire[7:0] saida);
    parameter NUM_BLOCOS = 64;

    wire[NUM_BLOCOS*8-1 : 0] saidas_xor;
    genvar i;

    assign saidas_xor[8-1 : 0] = linha_cache[512 -: 8];

    generate
        for (i = 1; i < NUM_BLOCOS; i = i + 1) begin
            assign saidas_xor[8*(i+1)-1 -: 8] = linha_cache[512-i*8 -: 8] ^ saidas_xor[8*i-1 -: 8];
        end
    endgenerate

    assign saida = saidas_xor[NUM_BLOCOS - 1];
endmodule