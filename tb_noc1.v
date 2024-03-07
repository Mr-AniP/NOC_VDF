`include "main.v"

module tb_noc();
    reg clk=0;
    reg reset=0;
    wire [3:0] processor_ready_signals;
    reg [10:0] p0_configure,p1_configure,p2_configure,p3_configure;
    wire [19:0] temp_path_block_signals;
    mesh m1 (.clock(clk), 
            .reset(reset),
            .p0_configure(p0_configure),
            .p1_configure(p1_configure),
            .p2_configure(p2_configure),
            .p3_configure(p3_configure),
            .processor_ready_signals(processor_ready_signals),
            .temp_path_block_signals(temp_path_block_signals)
            );
    initial
    begin
         // $display("in");
        $dumpfile("noc_sim.vcd");
        $dumpvars(0,tb_noc);
        // clock_t=1'b0;
        reset=1'b0;
        p0_configure=11'b0;
        p1_configure=11'b0;
        p2_configure=11'b0;
        p3_configure=11'b0;
        #1 reset = 1'b1;
        #16 reset = 1'b0;
        #2 p0_configure = 11'b01000000101;
        #50 p0_configure=11'b0;
        #10 p1_configure = 11'b01000000001;
        p3_configure = 11'b01000000001;
        #60 p1_configure=11'b0;
        // #29$finish;
        #4000 $finish;
    end
    always #10 clk = ~clk;

endmodule
