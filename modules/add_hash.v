module add_hash (input wire[511:0] in, output wire[7:0] out);
    parameter NUM_BLOCOS = 64;

    wire[7:0] saidas_soma[0 : NUM_BLOCOS-1];
    genvar i;

    assign saidas_soma[0] = in[7:0];
    generate
        for (i = 1; i < NUM_BLOCOS; i = i + 1) begin
            assign saidas_soma[i] = saidas_soma[i-1] + in[8*(i+1)-1 -: 8];
        end
    endgenerate

    assign out = saidas_soma[NUM_BLOCOS-1];
endmodule