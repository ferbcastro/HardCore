module priority_encoder_TB();
    reg[255:0] dec;
    wire[7:0] enc;

    priority_encoder DUT(.in(dec), .out(enc));

    initial begin
        $monitor("%d", enc);
    end

    initial begin : BLOCO
        integer i;
        dec = 255'b0;
        dec[255] = 1'b1;
        for (i = 255; i > 0; i = i-1) begin
            #1
            if (enc != i) begin
                $display("Resposta %d errada!", enc);
            end
            dec[i] = 1'b0;
            dec[i-1] = 1'b1;
        end

        #1 $finish();
    end
endmodule