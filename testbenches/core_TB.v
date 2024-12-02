module core_TB ();
    reg reset, clk;
    reg[511 : 0] linha_cache;
    reg[63 : 0] endereco;

    initial begin
        $dumpfile();
        $dumpvars();
        $readmemh();
        $readmemh();
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