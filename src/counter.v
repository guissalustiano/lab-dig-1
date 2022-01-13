module counter
    #(parameter N = 4)
        (
            input clk,
            input clr,
            input ld,
            input [N-1:0] din,
            input enp,
            input ent,
            output reg [N-1:0] dout,
            output rco
        );

    always @ (posedge clk) begin
        if (clr == 0) dout <= 0;
        else if (ld == 0) dout <= din;
        else if (enp == 1 && ent == 1) dout <= dout + 1;
        else dout <= dout;
    end
    assign rco = dout == 2**N-1 && enp == 1;
endmodule
