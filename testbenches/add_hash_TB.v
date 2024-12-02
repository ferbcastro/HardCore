module add_hash_TB ();
    reg[511:0] entrada;
    wire[7:0] saida;

    add_hash DUT(.in(entrada), .out(saida));

    initial begin
        $monitor("saida = %d", saida);
    end

    initial begin
        entrada = {511'b0, 1'b1};
        #5 entrada = {503'b0, 1'b1, 8'b0};
        #5 $finish();
    end
endmodule