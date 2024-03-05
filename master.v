/*
Module Pin Description :
    Clock: 1 bit input port for the clock signal.
    Path_usage_bits: Indicates the usage of all 32 paths available in the.
    Router_control_signals: (R0 to R3 in order)
        3 bits each for selecting lines (In order North, South, East, West, Processor)
        1 bit each for setting the ready regs (In order North, South, East, West, Processor)
    */
module master(
    input clock,
    input reset,
    input [35:0] Path_usage_bits,
    output [19:0] R0_control_signals,
    output [19:0] R1_control_signals,
    output [19:0] R2_control_signals,
    output [19:0] R3_control_signals; 
);
endmodule