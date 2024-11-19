module xor_hash (input wire[511:0] linha_cache, output wire[7:0] saida);
    parameter NUM_BLOCOS = 64;
    
    wire[7:0][NUM_BLOCOS] saidas_xor;
    genvar i;

    assign saidas_xor[0] = linha_cache[512 -: 8];

    generate
        for (i = 1; i < NUM_BLOCOS; i = i + 1) begin
            assign saidas_xor[i] = linha_cache[512 - i * 8 -: 8] ^ saidas_xor[i - 1];
        end
    endgenerate

    assign saida = saidas_xor[NUM_BLOCOS - 1];
endmodule