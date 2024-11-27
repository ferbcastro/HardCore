module buffer #(
    parameter NUM_CLUSTERS = 5;
)(input[NUM_CLUSTERS-1 : 0] bitmap_novo, 
  input[NUM_CLUSTERS-1 : 0] bitmap_atualizado,
  output[NUM_CLUSTERS-1 : 0] bitmap_atual
  input atualizar, clk);
    parameter TAM_ENDERECO = 64,
              TAM_FLAG = 1,
              TAM_BUFFER = 10;

    reg[NUM_CLUSTERS+TAM_ENDERECO+TAM_FLAG-1 : 0][TAM_BUFFER-1 : 0]memoria;
    

endmodule