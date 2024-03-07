`include "main.v"

module tb_noc();
    reg clk=0;
    reg reset=0;
    wire [3:0] processor_ready_signals;
    reg [10:0] p0_configure,p1_configure,p2_configure,p3_configure;
    mesh m1 (.clock(clk), 
            .reset(reset),
            .p0_configure(p0_configure),
            .p1_configure(p1_configure),
            .p2_configure(p2_configure),
            .p3_configure(p3_configure),
            .processor_ready_signals(processor_ready_signals)
            );
    initial
    begin
         // $display("in");
        $dumpfile("noc_sim.vcd");
        $dumpvars(0,tb_noc);
        // clock_t=1'b0;
        reset=1'b0;
        #1 reset = 1'b1;
        #16 reset = 1'b0;
        #2 p0_configure = 11'b00001000011;
        p1_configure = 11'b00000100111;
        p2_configure = 11'b00010000001;
        p3_configure = 11'b01000000101;
        // #29$finish;
        #2000$finish;
    end
    always #10 clk = ~clk;

endmodule
