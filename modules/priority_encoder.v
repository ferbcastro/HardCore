module priority_encoder_256b(input wire[255:0] in, output reg[7:0] out);
    task encoder_8b(input wire[7:0] dec, input e_in, output wire[2:0] enc,
                    output gs, e_out);
    begin
        wire or_dec;
        assign enc[0] = (~dec[6] & ~dec[4] & ~dec[2] & dec[1]) |
                        (~dec[6] & ~dec[4] & dec[3]) |
                        (~dec[6] & dec[5]) | dec[7];
        assign enc[1] = (~dec[5] & ~dec[4] & dec[2]) |
                        (~dec[5] & ~dec[4] & dec[3]) |
                        dec[6] | dec[7];
        assign enc[2] = dec[4] | dec[5] | dec[6] | dec[7];

        assign or_dec = dec[0] | dec[1] | dec[2] | dec[3] |
                        dec[4] | dec[5] | dec[6] | dec[7];
        assign gs = e_in & or_dec;
        assign e_out = e_in & ~or_dec;
    end

    task encoder_32b(input wire[31:0] dec, input e_in, output wire[4:0] enc,
                     output gs, e_out);
    begin
        wire[2:0] s3, s2, s1, s0;
        wire gs3, gs2, gs1, e_out3, e_out2, e_out1;
        encoder_8b(dec[31 -: 8], 1, s3, gs3, e_out3);
        encoder_8b();
        encoder_8b();
        encoder_8b();
    end

    always @* begin
        
    end
endmodule