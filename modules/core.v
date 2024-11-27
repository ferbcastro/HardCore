module core (input[511:0] linha_cache, input[63:0] endereco, input clk, output trava);
    parameter NUM_CLUSTERS = 5,
              AMPLITUDE_HASH = 256,
              TAMANHO_BUFFER = 10,
              TAMANHO_ENDERECO = 64;
    
    reg[AMPLITUDE_HASH-1 : 0][NUM_CLUSTERS-1 : 0] primeira_matriz;
    reg[AMPLITUDE_HASH-1 : 0][NUM_CLUSTERS-1 : 0] segunda_matriz;
    reg[TAMANHO_ENDERECO-9 : 0] resultados;
    reg bloquear_entrada, bitmap_processado;

    assign trava = bloquear_entrada;

    always @(posedge clk) begin
        
    end
endmodule