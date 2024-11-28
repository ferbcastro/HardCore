module core (input[511:0] linha_cache, input[63:0] endereco, input clk, output trava);
    parameter NUM_CLUSTERS = 8,
              AMPLITUDE_HASH = 256,
              TAM_HASH = 8,
              TAM_BUFFER = 10,
              TAM_ENDERECO = 64;
    
    reg[AMPLITUDE_HASH-1 : 0][NUM_CLUSTERS-1 : 0] primeira_matriz;
    reg[NUM_CLUSTERS-1 : 0][AMPLITUDE_HASH-1 : 0] segunda_matriz;
    reg[TAM_ENDERECO-9 : 0] resultados;
    reg[TAM_ENDERECO-1 : 0] endereco_buffer;
    reg[NUM_CLUSTERS-1 : 0] bitmap_buffer;
    reg[TAM_HASH-1 : 0] hash_buffer;
    reg bloq, valida;
    reg[2:0] saida_encoder;

    wire zero;
    wire[NUM_CLUSTERS-1 : 0] entrada_bitmap;
    wire[NUM_CLUSTERS-1 : 0] bitmap_processado;
    wire[TAM_HASH-1 : 0] saida_primeira_hash;
    wire[TAM_HASH-1 : 0] saida_segunda_hash;

    buffer temp_buf(.zero(zero), .bitmap_novo(entrada_bitmap), .endereco_novo(endereco), 
                    .hash_nova(saida_segunda_hash), .bitmap_atualizado(bitmap_processado), 
                    .bitmap_atual(bitmap_buffer), .endereco_atual(endereco_buffer), 
                    .hash_atual(hash_buffer), .bloquear(bloq), .saida_valida(valida));
    
    xor_hash primeira_hash(.in(linha_cache), .out(saida_primeira_hash));
    xor_hash segunda_hash(.in(linha_cache), .out(saida_segunda_hash)); // Mudar segunda hash
    encoder priority_encoder_8(.in(bitmap_buffer), .out(saida_encoder));

    assign trava = bloq;
    assign entrada_bitmap = primeira_matriz[saida_primeira_hash];
    assign bitmap_processado = bitmap_buffer & ~(1 << saida_encoder);
    assign zero = ~(|bitmap_buffer) | (segunda_matriz[saida_encoder][hash_buffer]);

    always @(posedge clk) begin : BLOCO
        reg tmp;

        tmp = segunda_matriz[saida_encoder][saida_segunda_hash];
        if (tmp == 1'b1 && valida == 1'b1) begin
            // Escrever na memoria com endereco_buffer
        end
    end
endmodule