module priority_encoder_TB();
    reg[255:0] dec;
    wire[7:0] enc;

    priority_encoder DUT(.in(dec), .out(enc));

    initial begin : BLOCO
        dec = 5'b10000;
        #1 $display("%d", enc);
        #1 $finish();
    end
endmodule