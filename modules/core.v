module core (input[511:0] linha_cache, input[63:0] endereco, input clk, reset);
    parameter NUM_CLUSTERS = 8,
              AMPLITUDE_HASH = 256,
              TAM_HASH = $clog2(AMPLITUDE_HASH),
              TAM_ENDERECO = 64,
              TAM_PAGINA = 4096,
              AMPLITUDE_ENDERECOS = (1 << (TAM_ENDERECO-$clog2(TAM_PAGINA)));

    reg[NUM_CLUSTERS-1 : 0] primeira_matriz[0 : AMPLITUDE_HASH-1];
    reg[AMPLITUDE_HASH-1 : 0] segunda_matriz[0 : NUM_CLUSTERS-1];
    reg[AMPLITUDE_ENDERECOS-1 : 0] resultados;

    wire zero, suspeito, valida;
    wire[TAM_ENDERECO-1 : 0] endereco_buffer;
    wire[NUM_CLUSTERS-1 : 0] entrada_bitmap, bitmap_processado, bitmap_buffer;
    wire[TAM_HASH-1 : 0] saida_primeira_hash, saida_segunda_hash, hash_buffer;
    wire[$clog2(NUM_CLUSTERS)-1 : 0] saida_encoder; // variavel de enderecamento

    circular_buffer #(.NUM_CLUSTERS(NUM_CLUSTERS)) buffer 
            (.suspeito(suspeito), .zero(zero), .clk(clk), .reset(reset), 
             .bitmap_novo(entrada_bitmap), .endereco_novo(endereco), 
             .hash_nova(saida_segunda_hash), .bitmap_atualizado(bitmap_processado), 
             .bitmap_atual(bitmap_buffer), .endereco_atual(endereco_buffer), 
             .hash_atual(hash_buffer), .saida_valida(valida));
    
    xor_hash primeira_hash(.in(linha_cache), .out(saida_primeira_hash));
    add_hash segunda_hash(.in(linha_cache), .out(saida_segunda_hash));
    priority_encoder_8 encoder(.in(bitmap_buffer), .out(saida_encoder));

    assign entrada_bitmap = primeira_matriz[saida_primeira_hash];
    assign bitmap_processado = bitmap_buffer & ~(1 << saida_encoder);
    assign suspeito = (segunda_matriz[saida_encoder][hash_buffer]);
    assign zero = ~(|bitmap_buffer);

    always @(posedge clk) begin
        if (reset == 1'b1) begin
            resultados <= 0;
        end else begin
            if (zero == 1'b1) begin
                resultados[endereco[63 -: 52]] <= 1'b0;
            end else begin
                if (suspeito == 1'b1) begin
                    resultados[endereco[63 -: 52]] <= 1'b1;
                end
            end
        end
    end 
endmodule