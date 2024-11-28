module buffer #(parameter NUM_CLUSTERS = 5, TAM_ENDERECO = 64, TAM_HASH_DOIS = 8)
(
    input zero, clk,
    input wire[NUM_CLUSTERS-1 : 0] bitmap_novo, 
    input wire[TAM_ENDERECO-1 : 0] endereco_novo,
    input wire[TAM_HASH_DOIS-1 : 0] hash_nova,
    input wire[NUM_CLUSTERS-1 : 0] bitmap_atualizado,
    output wire[NUM_CLUSTERS-1 : 0] bitmap_atual,
    output wire[TAM_ENDERECO-1 : 0] endereco_atual,
    output wire[TAM_HASH_DOIS-1 : 0] hash_atual,
    output bloquear, saida_valida
);
    parameter TAM_BUFFER = 32;

    reg[TAM_ENDERECO-1 : 0][TAM_BUFFER-1 : 0]enderecos;
    reg[NUM_CLUSTERS-1 : 0][TAM_BUFFER-1 : 0]bitmaps;
    reg[TAM_HASH_DOIS-1 : 0][TAM_BUFFER-1 : 0]hash;
    reg[TAM_BUFFER-1 : 0]flags;
    reg[4:0] posicao;
    reg bloquear_entrada;

    priority_encoder_32 encoder(.in(flags), .out(posicao));

    always @(posedge clk) begin : BLOCO
        integer i;

        if (zero == 1'b1) begin
            flags[posicao] <= 1'b0;
        end
    
        if (flags[posicao] != 1'b0) begin
            bitmaps[posicao] <= bitmap_atualizado;
        end
    end

    always @(negedge clk) begin
        if (flags[TAM_BUFFER-1] == 1'b0) begin
            enderecos[0] <= endereco_novo;
            bitmaps[0] <= bitmap_novo;
            hash[0] <= hash_nova;

            for (i = TAM_BUFFER-1; i > 0; i = i+1) begin
                enderecos[i] <= enderecos[i-1];
                bitmaps[i] <= bitmaps[i-1];
                hash[i] <= hash[i-1];
            end

            bloquear_entrada <= 1'b0;
        end else begin
            bloquear_entrada <= 1'b1;
        end
    end

    assign bitmap_atual = bitmaps[posicao]; 
    assign endereco_atual = enderecos[posicao];
    assign hash_atual = hash[posicao];
    assign bloquear = bloquear_entrada;
endmodule