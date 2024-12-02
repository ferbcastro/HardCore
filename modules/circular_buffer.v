module circular_buffer #(parameter NUM_CLUSTERS = 8, TAM_ENDERECO = 64, TAM_HASH_DOIS = 8)
(
    input suspeito, zero, clk, reset,
    input wire[NUM_CLUSTERS-1 : 0] bitmap_novo, 
    input wire[TAM_ENDERECO-1 : 0] endereco_novo,
    input wire[TAM_HASH_DOIS-1 : 0] hash_nova,
    input wire[NUM_CLUSTERS-1 : 0] bitmap_atualizado,
    output wire[NUM_CLUSTERS-1 : 0] bitmap_atual,
    output wire[TAM_ENDERECO-1 : 0] endereco_atual,
    output wire[TAM_HASH_DOIS-1 : 0] hash_atual,
    output saida_valida
);
    parameter TAM_BUFFER = 32;

    reg[TAM_ENDERECO-1 : 0][TAM_BUFFER-1 : 0]enderecos;
    reg[NUM_CLUSTERS-1 : 0][TAM_BUFFER-1 : 0]bitmaps;
    reg[TAM_HASH_DOIS-1 : 0][TAM_BUFFER-1 : 0]hash;
    reg[$clog2(TAM_BUFFER)-1 : 0] ini, fim; // variaveis de enderecamento
    reg[$clog2(TAM_BUFFER) : 0] ocupacao;

    wire remover_buffer;

    always @(posedge clk) begin
        if (reset == 1'b1) begin
            ocupacao <= 5'b0;
            ini <= 5'b0;
            fim <= 6'b0;
        end else begin
            if (ocupacao != 6'b0) begin
                if (zero == 1'b1 || remover_buffer == 1'b1) begin
                    ini <= ini + 5'b1; // Overflow ajuda aqui
                    ocupacao <= ocupacao - 6'b1;
                end else begin
                    bitmaps[ini] <= bitmap_atualizado;
                end
            end

            if (ocupacao != TAM_BUFFER || remover_buffer == 1'b1) begin
                bitmaps[fim] <= bitmap_novo;
                enderecos[fim] <= endereco_novo;
                hash[fim] <= hash_nova;
                fim <= fim + 5'b1; // Overflow ajuda aqui
                ocupacao <= ocupacao + 6'b1; 
            end
        end
    end

    assign remover_buffer = zero || suspeito;
    assign saida_valida = |ocupacao;
    assign bitmap_atual = bitmaps[ini]; 
    assign endereco_atual = enderecos[ini];
    assign hash_atual = hash[ini];
endmodule