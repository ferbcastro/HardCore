module priority_encoder_8(input wire[7:0] in, output reg[2:0] out);
    reg gs, eout;

    task automatic encoder_8b;
        input reg[7:0] dec; 
        input reg e_in;
        output reg[2:0] enc;
        output reg gs;
        output reg e_out;

        reg or_dec;
        begin 
            enc[0] = (~dec[6] & ~dec[4] & ~dec[2] & dec[1]) |
                            (~dec[6] & ~dec[4] & dec[3]) |
                            (~dec[6] & dec[5]) | dec[7];
            enc[1] = (~dec[5] & ~dec[4] & dec[2]) |
                            (~dec[5] & ~dec[4] & dec[3]) |
                            dec[6] | dec[7];
            enc[2] = dec[4] | dec[5] | dec[6] | dec[7];

            or_dec = dec[0] | dec[1] | dec[2] | dec[3] |
                     dec[4] | dec[5] | dec[6] | dec[7];
            gs = e_in & or_dec;
            e_out = e_in & ~or_dec;
        end
    endtask

    // task automatic encoder_32b;
    //     input reg[31:0] dec;
    //     input reg e_in; 
    //     output reg[4:0] enc;
    //     output reg gs;
    //     output reg e_out;

    //     reg[2:0] s3, s2, s1, s0;
    //     reg gs3, eout3, gs2, eout2, gs1, eout1, gs0;
    //     begin
    //         encoder_8b(dec[31:24], e_in, s3, gs3, eout3);
    //         encoder_8b(dec[23:16], eout3, s2, gs2, eout2);
    //         encoder_8b(dec[15:8], eout2, s1, gs1, eout1);
    //         encoder_8b(dec[7:0], eout1, s0, gs0, e_out);
    //         enc[4] = gs3 | gs2;
    //         enc[3] = gs3 | gs1;
    //         enc[2:0] = s3 | s2 | s1 | s0;
    //         gs = gs3 | gs2 | gs1 | gs0;
    //     end
    // endtask

    always @* begin
        encoder_8b(in, 1, out, gs, eout);
    end
endmodule