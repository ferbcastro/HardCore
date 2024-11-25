module priority_encoder(input wire[255:0] in, output reg[7:0] out);
    reg eout1, eout0, gs0;
    reg[6:0] s1, s0;
    
    task encoder_8b(input reg[7:0] dec, input reg e_in, output reg[2:0] enc,
                    output reg gs, output reg e_out);
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

    task encoder_32b(input reg[31:0] dec, input reg e_in, output reg[4:0] enc,
                     output reg gs, output reg e_out);
        reg[3:0] s3, s2, s1, s0;
        reg gs3, eout3, gs2, eout2, gs1, eout1, gs0;
        begin
            encoder_8b(dec[31:24], e_in, s3, gs3, eout3);
            encoder_8b(dec[23:16], eout3, s2, gs2, eout2);
            encoder_8b(dec[15:8], eout2, s1, gs1, eout1);
            encoder_8b(dec[7:0], eout1, s0, gs0, e_out);
            enc[4] = gs3 | gs2;
            enc[3] = gs3 | gs1;
            enc[2:0] = s3[2:0] | s2[2:0] | s1[2:0] | s0[2:0];
            gs = gs3 | gs2 | gs1 | gs0;
        end
    endtask

    task encoder_128b(input reg [127:0] dec, input reg e_in, output reg[6:0] enc,
                      output reg gs, output reg e_out);
        reg[3:0] s3, s2, s1, s0;
        reg gs3, eout3, gs2, eout2, gs1, eout1, gs0;
        begin
            encoder_32b(dec[127:96], e_in, s3, gs3, eout3);
            encoder_32b(dec[95:64], eout3, s2, gs2, eout2);
            encoder_32b(dec[63:32], eout2, s1, gs1, eout1);
            encoder_32b(dec[31:0], eout1, s0, gs0, e_out);
            enc[6] = gs3 | gs2;
            enc[5] = gs3 | gs1;
            enc[4:0] = s3[4:0] | s2[4:0] | s1[4:0] | s0[4:0];
            gs = gs3 | gs2 | gs1 | gs0;
        end
    endtask

    always @* begin    
        encoder_128b(in[255:128], 1, s1, out[7], eout1);
        encoder_128b(in[127:0], eout1, s0, gs0, eout0);
        out[6:0] = s1[6:0] | s0[6:0];
    end
endmodule