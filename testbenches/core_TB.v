module core_TB ();
    reg reset, clk;
    reg[511 : 0] linha_cache;
    reg[63 : 0] endereco;

    core DUT(.linha_cache(linha_cache), .endereco(endereco), .clk(clk), .reset(reset));

    initial begin
        // Carrega primeira matriz de assinaturas '[HASH][CLUSTER]'
        $readmemh("./memory_files/primeira_matriz.mem", DUT.primeira_matriz);
        // Carrega segunda matriz de assinaturas '[CLUSTER][HASH]'
        $readmemh("./memory_files/segunda_matriz.mem", DUT.segunda_matriz);
        $dumpfile("core_TB.vcd");
        $dumpvars(2, DUT);
        $monitor();
    end

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        #1 clk = 1'b1;
        #1 reset = 1'b0;
        clk = 1'b0;

        // Elaborar casos de teste

        $stop()
    end

endmodule