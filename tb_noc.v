`include "main.v"

module tb_noc();
    reg clk=0;
    reg reset=0;
    wire [3:0] processor_ready_signals;
    reg block_all_paths;
    reg [10:0] p0_configure,p1_configure,p2_configure,p3_configure;
    wire [8:0] p0_recieve_data,p1_recieve_data,p2_recieve_data,p3_recieve_data;
    //wire [19:0] temp_path_block_signals;
    parameter No_DATA 18'b0;
    mesh m1 (.clock(clk), 
            .reset(reset),
            .r0_input(No_DATA),
            .r1_input(No_DATA),
            .r2_input(No_DATA),
            .r3_input(No_DATA),
            .p0_configure(p0_configure),
            .p1_configure(p1_configure),
            .p2_configure(p2_configure),
            .p3_configure(p3_configure),
            .block_all_paths(block_all_paths),
            .processor_ready_signals(processor_ready_signals),
            .p0_recieve_data(p0_recieve_data),
            .p1_recieve_data(p1_recieve_data),
            .p2_recieve_data(p2_recieve_data),
            .p3_recieve_data(p3_recieve_data),
            .r0_output(),
            .r1_output(),
            .r2_output(),
            .r3_output()
            //.temp_path_block_signals(temp_path_block_signals) 
            );
    initial
    begin
         // $display("in");
        $dumpfile("noc_sim.vcd");
        $dumpvars(0,tb_noc);
        // clock_t=1'b0;
        reset=1'b0;
        block_all_paths=1'b0;
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
