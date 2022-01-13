`timescale 1 ns/100 ps  // time-unit = 1 ns, precision = 10 ps

module counter_tb;
    parameter N = 4;
    reg clk;
    reg clr;
    reg ld;
    reg [N-1:0] din;
    reg enp;
    reg ent;
    wire [N-1:0] dout;
    wire rco;

    // unit under test
    counter #(.N(N)) uut ( .clk(clk),
                           .clr(clr),
                           .ld(ld),
                           .din(din),
                           .enp(enp),
                           .ent(ent),
                           .dout(dout),
                           .rco(rco)
                         );

    // Generate clock 10ns
    always #5 clk = ~clk;

    initial begin
        // monitoring
        $dumpfile("counter_tb.vcd");
        $dumpvars(0, counter_tb);
        $monitor ("t=%6t clr=0b%b dout=0x%h rco=0b%b", 
            $time, clr, dout, rco);

        // reset
        clk <= 0;
        clr <= 0;
        ld <= 1;
        enp <= 0;
        ent <= 0;

        #7 clr <= 1;
        if(!(dout == 0)) $display("Fail reset test");
        #10 if(!(dout == 0 && rco == 0)) $display("Fail disable");

        // enable count
        enp <= 1;
        ent <= 1;

        #10 if(!(dout == 1 && rco == 0)) $display("Fail count 1");
        #140 if(!(dout == 15 && rco == 1)) $display("Fail count 15");
        #10 if(!(dout == 0)) $display("Fail overflow");

        // load
        #10 din <= 6;
        ld <= 0;
        #10 if(!(dout == din)) $display("Fail load");
        ld <= 1;

        #10 $finish;
    end
endmodule
