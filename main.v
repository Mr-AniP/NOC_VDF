/*
Module name: 
    mesh
Module Description:
    This module helps in identifying the possible paths between any 2 routers:
                                    2 - 3
                                    |   |
                                    0 - 1
Pin Description:
    Clock: 1 bit input port for the clock signal.
    Reset: 1 bit input port for the reset signal.
    configure_signals: (P0 to P3 in order)
        8 bit to indicate no of transfers in a single transaction (burst size)
        2 bit indicating destination of transfer
        1 bit indicates testbench is requesting transfer
    processor_ready_signals: 4 bit output port to indicate the readiness of the processors (in order P3 to P0)
*/

`include"router.v"
`include"master.v"
`include"P_unit.v"

module mesh(
    input clock,
    input reset,
    input [10:0]p0_configure,
    input [10:0]p1_configure,
    input [10:0]p2_configure,
    input [10:0]p3_configure,
    output [3:0] processor_ready_signals,
    output [19:0] temp_path_block_signals
    );
    
    wire [8:0] d01,d10,d23,d32,d02,d20,d13,d31;
    wire [8:0] d00,d11,d22,d33;
    wire [8:0] r00,r11,r22,r33;
    wire Nr0,Sr0,Er0,Wr0;
    wire Nr1,Sr1,Er1,Wr1;
    wire Nr2,Sr2,Er2,Wr2;
    wire Nr3,Sr3,Er3,Wr3;
    wire Pr0,Pr1,Pr2,Pr3;
    
    reg [6:0] Path_usage_bits_0;
    reg [6:0] Path_usage_bits_1;
    reg [6:0] Path_usage_bits_2;
    reg [6:0] Path_usage_bits_3;

    wire [27:0] Path_usage_bits;
    
    wire [3:0] response_signals;
    wire [3:1] P0_signals;
    wire [3:1] P1_signals;
    wire [3:1] P2_signals;
    wire [3:1] P3_signals;
    wire [19:0] R0_control_signals;
    wire [19:0] R1_control_signals;
    wire [19:0] R2_control_signals;
    wire [19:0] R3_control_signals;
    // wire [19:0] temp_path_block_signals;
//instantiation
    master m0(
        .clock(clock),
        .reset(reset),
        .path_free_bits(Path_usage_bits),
        .P0_signals(P0_signals),
        .P1_signals(P1_signals),
        .P2_signals(P2_signals),
        .P3_signals(P3_signals),
        .R0_control_signals(R0_control_signals),
        .R1_control_signals(R1_control_signals),
        .R2_control_signals(R2_control_signals),
        .R3_control_signals(R3_control_signals),
        .response_signals(response_signals),
        .temp_path_block_signals(temp_path_block_signals)
    );
    
    Processing_unit p0(
            .clock(clock),
            .reset(reset),
            .master_response(response_signals[0]),
            .data_from_router(r00),
            .data_to_router(d00),
            .request_transfer(P0_signals[1]),
            .which_processor(P0_signals[3:2]),
            .processor_ready(processor_ready_signals[0]),
            .tb_request(p0_configure[0]),
            .tb_processor(p0_configure[2:1]),
            .tb_len(p0_configure[10:3])
    );
//Set commands by master
    router r0(
        .clock(clock),
        .reset(reset),
        .select_north(R0_control_signals[19:17]),
        .select_south(R0_control_signals[16:14]),
        .select_east(R0_control_signals[13:11]),
        .select_west(R0_control_signals[10:8]),
        .select_processor(R0_control_signals[7:5]),
        .data_north(d20),
        .data_south(),
        .data_east(d10),
        .data_west(),
        .data_processor(d00),
        .output_north(d02),
        .output_south(),
        .output_east(d01),
        .output_west(),
        .output_processor(r00),
        .north_ready(Nr0),
        .south_ready(Sr0),
        .east_ready(Er0),
        .west_ready(Wr0),
        .processor_ready(Pr0),
        .SetNR(R0_control_signals[4]),
        .SetSR(R0_control_signals[3]),
        .SetER(R0_control_signals[2]),
        .SetWR(R0_control_signals[1]),
        .SetPR(R0_control_signals[0])
    );
    
    Processing_unit p1(
            .clock(clock),
            .reset(reset),
            .master_response(response_signals[1]),
            .data_from_router(r11),
            .data_to_router(d11),
            .request_transfer(P1_signals[1]),
            .which_processor(P1_signals[3:2]),
            .processor_ready(processor_ready_signals[1]),
            .tb_request(p1_configure[0]),
            .tb_processor(p1_configure[2:1]),
            .tb_len(p1_configure[10:3])
    );
    router r1(
        .clock(clock),
        .reset(reset),
        .select_north(R1_control_signals[19:17]),
        .select_south(R1_control_signals[16:14]),
        .select_east(R1_control_signals[13:11]),
        .select_west(R1_control_signals[10:8]),
        .select_processor(R1_control_signals[7:5]),
        .data_north(d31),
        .data_south(),
        .data_east(),
        .data_west(d01),
        .data_processor(d11),
        .output_north(d13),
        .output_south(),
        .output_east(),
        .output_west(d10),
        .output_processor(r11),
        .north_ready(Nr1),
        .south_ready(Sr1),
        .east_ready(Er1),
        .west_ready(Wr1),
        .processor_ready(Pr1),
        .SetNR(R1_control_signals[4]),
        .SetSR(R1_control_signals[3]),
        .SetER(R1_control_signals[2]),
        .SetWR(R1_control_signals[1]),
        .SetPR(R1_control_signals[0])
    );
    Processing_unit p2(
            .clock(clock),
            .reset(reset),
            .master_response(response_signals[2]),
            .data_from_router(r22),
            .data_to_router(d22),
            .request_transfer(P2_signals[1]),
            .which_processor(P2_signals[3:2]),
            .processor_ready(processor_ready_signals[2]),
            .tb_request(p2_configure[0]),
            .tb_processor(p2_configure[2:1]),
            .tb_len(p2_configure[10:3])
    );
    router r2(
        .clock(clock),
        .reset(reset),
        .select_north(R2_control_signals[19:17]),
        .select_south(R2_control_signals[16:14]),
        .select_east(R2_control_signals[13:11]),
        .select_west(R2_control_signals[10:8]),
        .select_processor(R2_control_signals[7:5]),
        .data_north(),
        .data_south(d02),
        .data_east(d32),
        .data_west(),
        .data_processor(d22),
        .output_north(),
        .output_south(d20),
        .output_east(d23),
        .output_west(),
        .output_processor(r22),
        .north_ready(Nr2),
        .south_ready(Sr2),
        .east_ready(Er2),
        .west_ready(Wr2),
        .processor_ready(Pr2),
        .SetNR(R2_control_signals[4]),
        .SetSR(R2_control_signals[3]),
        .SetER(R2_control_signals[2]),
        .SetWR(R2_control_signals[1]),
        .SetPR(R2_control_signals[0])
    );
    Processing_unit p3(
            .clock(clock),
            .reset(reset),
            .master_response(response_signals[3]),
            .data_from_router(r33),
            .data_to_router(d33),
            .request_transfer(P3_signals[1]),
            .which_processor(P3_signals[3:2]),
            .processor_ready(processor_ready_signals[3]),
            .tb_request(p3_configure[0]),
            .tb_processor(p3_configure[2:1]),
            .tb_len(p3_configure[10:3])
    );
    router r3(
        .clock(clock),
        .reset(reset),
        .select_north(R3_control_signals[19:17]),
        .select_south(R3_control_signals[16:14]),
        .select_east(R3_control_signals[13:11]),
        .select_west(R3_control_signals[10:8]),
        .select_processor(R3_control_signals[7:5]),
        .data_north(),
        .data_south(d13),
        .data_east(),
        .data_west(d23),
        .data_processor(d33),
        .output_north(),
        .output_south(d31),
        .output_east(),
        .output_west(d32),
        .output_processor(r33),
        .north_ready(Nr3),
        .south_ready(Sr3),
        .east_ready(Er3),
        .west_ready(Wr3),
        .processor_ready(Pr3),
        .SetNR(R3_control_signals[4]),
        .SetSR(R3_control_signals[3]),
        .SetER(R3_control_signals[2]),
        .SetWR(R3_control_signals[1]),
        .SetPR(R3_control_signals[0])
    );

    always @ (*) //router 0
    begin
        Path_usage_bits_0[0] = Pr0 ; //0 to 0
        
        Path_usage_bits_0[1] = Er0 & Pr1; //0 to 1 //flat
        Path_usage_bits_0[2] = Nr0 & Er2 & Sr3 & Pr1 ; //0 to 1 longer 0-2-3-1

        Path_usage_bits_0[3] = Nr0 & Pr2; //0 to 2 //vertical
        Path_usage_bits_0[4] = Er0 & Nr1 & Wr3 & Pr2; //0 to 2 longer 0-1-3-2

        Path_usage_bits_0[5] = Nr0  & Er2  & Pr3 ; //0 to 3 //diagonal (vertical) 0-2-3
        Path_usage_bits_0[6] = Er0 & Nr1  & Pr3 ; //0 to 3 (flat) 0-1-3

    end
    

    always @ (*) //router1
    begin
        Path_usage_bits_1[0] = Pr1 ; //1 to 1

        Path_usage_bits_1[1] = Er1 & Pr0; //1 to 0 //flat
        Path_usage_bits_1[2] = Nr1  & Wr3 & Sr2 & Pr0 ; //1 to 0 longer 1-3-2-0

        Path_usage_bits_1[3] = Nr1  & Pr3 ; //1 to 3 //vertical
        Path_usage_bits_1[4] = Wr1  & Nr0 & Er2 & Pr3 ; // 1 to 3 longer 1-0-2-3
        
        Path_usage_bits_1[5] = Nr1 & Wr3 & Pr2 ; // 1 to 2 //diagonal (vertical) 1-3-2
        Path_usage_bits_1[6] = Wr1 & Nr0 & Pr2 ; //1 to 2 (flat) 1-0-2

    end

    
    always @ (*) //router2
    begin
        Path_usage_bits_2[0] = Pr2; //2 to 2

        Path_usage_bits_2[1] = Er2 & Pr3 ; //2 to 3 //flat
        Path_usage_bits_2[2] = Sr2  & Er0  & Nr1  & Pr3 ; //2 to 3 longer 2-0-1-3

        Path_usage_bits_2[3] = Sr2 & Pr0; //2 to 0 //vertical
        Path_usage_bits_2[4] = Er2 & Sr3  & Wr1  & Pr0 ; //2 to 0 longer 2-3-1-0


        Path_usage_bits_2[5] = Sr2 & Er0  & Pr1 ; //2 to 1 //diagonal (vertical) 2-0-1
        Path_usage_bits_2[6] = Er2 & Sr3  & Pr1 ;  //2 to 1 (flat) 2-3-1

    end
    
    always @ (*) //router3
    begin
        Path_usage_bits_3[0] = Pr3 ; // 3 to 3

        Path_usage_bits_3[1] = Wr3  & Pr2 ; //3 to 2 //flat
        Path_usage_bits_3[2] = Sr3  & Wr1 & Nr0 & Pr2 ; //3 to 2 longer 3-1-0-2

        Path_usage_bits_3[3] = Sr3 & Pr1 ; //3 to 1 //vertical
        Path_usage_bits_3[4] = Wr3  & Sr2  & Er0 & Pr1 ; //3 to 1 longer 3-2-0-1

        Path_usage_bits_3[5] = Sr3  & Wr1 & Pr0 ; //3 to 0 //diagonal (vertical) 3-1-0
        Path_usage_bits_3[6] = Wr3  & Sr2  & Pr0;  //3 to 0 (flat) 3-2-0

    end

    // always @ (*) //router 0
    // begin
    //     Path_usage_bits_0[0] = Pr0 & temp_path_block_signals[0]; //0 to 0
        
    //     Path_usage_bits_0[1] = Er0 & temp_path_block_signals[2] & Pr1 & temp_path_block_signals[5]; //0 to 1 //flat
    //     Path_usage_bits_0[2] = Nr0 & temp_path_block_signals[4] & Er2 & temp_path_block_signals[12] & Sr3 & temp_path_block_signals[18] & Pr1 & temp_path_block_signals[5]; //0 to 1 longer 0-2-3-1

    //     Path_usage_bits_0[3] = Nr0 & temp_path_block_signals[4] & Pr2 & temp_path_block_signals[10]; //0 to 2 //vertical
    //     Path_usage_bits_0[4] = Er0 & Nr1 & Wr3 & Pr2; //0 to 2 longer 0-1-3-2

    //     Path_usage_bits_0[5] = Nr0 & temp_path_block_signals[4] & Er2 & temp_path_block_signals[12] & Pr3 & temp_path_block_signals[15]; //0 to 3 //diagonal (vertical) 0-2-3
    //     Path_usage_bits_0[6] = Er0 & temp_path_block_signals[2] & Nr1 & temp_path_block_signals[9] & Pr3 & temp_path_block_signals[15]; //0 to 3 (flat) 0-1-3

    // end
    

    // always @ (*) //router1
    // begin
    //     Path_usage_bits_1[0] = Pr1 & temp_path_block_signals[5]; //1 to 1

    //     Path_usage_bits_1[1] = Er1 & temp_path_block_signals[7] & Pr0 & temp_path_block_signals[0]; //1 to 0 //flat
    //     Path_usage_bits_1[2] = Nr1 & temp_path_block_signals[9] & Wr3 & temp_path_block_signals[16] & Sr2 & temp_path_block_signals[13] & Pr0 & temp_path_block_signals[0]; //1 to 0 longer 1-3-2-0

    //     Path_usage_bits_1[3] = Nr1 & temp_path_block_signals[9] & Pr3 & temp_path_block_signals[15]; //1 to 3 //vertical
    //     Path_usage_bits_1[4] = Wr1 & temp_path_block_signals[6] & Nr0 & temp_path_block_signals[4] & Er2 & temp_path_block_signals[12] & Pr3 & temp_path_block_signals[15]; // 1 to 3 longer 1-0-2-3
        
    //     Path_usage_bits_1[5] = Nr1 & temp_path_block_signals[9] & Wr3 & temp_path_block_signals[16] & Pr2 & temp_path_block_signals[10]; // 1 to 2 //diagonal (vertical) 1-3-2
    //     Path_usage_bits_1[6] = Wr1 & temp_path_block_signals[6] & Nr0 & temp_path_block_signals[4] & Pr2 & temp_path_block_signals[10]; //1 to 2 (flat) 1-0-2

    // end

    
    // always @ (*) //router2
    // begin
    //     Path_usage_bits_2[0] = Pr2 & temp_path_block_signals[10]; //2 to 2

    //     Path_usage_bits_2[1] = Er2 & temp_path_block_signals[12] & Pr3 & temp_path_block_signals[15]; //2 to 3 //flat
    //     Path_usage_bits_2[2] = Sr2 & temp_path_block_signals[13] & Er0 & temp_path_block_signals[2] & Nr1 & temp_path_block_signals[9] & Pr3 & temp_path_block_signals[15]; //2 to 3 longer 2-0-1-3

    //     Path_usage_bits_2[3] = Sr2 & temp_path_block_signals[13] & Pr0 & temp_path_block_signals[0]; //2 to 0 //vertical
    //     Path_usage_bits_2[4] = Er2 & temp_path_block_signals[12] & Sr3 & temp_path_block_signals[18]  & Wr1 & temp_path_block_signals[6] & Pr0 & temp_path_block_signals[0]; //2 to 0 longer 2-3-1-0

    //     Path_usage_bits_2[5] = Sr2 & temp_path_block_signals[13] & Er0 & temp_path_block_signals[2] & Pr1 & temp_path_block_signals[5]; //2 to 1 //diagonal (vertical) 2-0-1
    //     Path_usage_bits_2[6] = Er2 & temp_path_block_signals[12] & Sr3 & temp_path_block_signals[18] & Pr1 & temp_path_block_signals[5];  //2 to 1 (flat) 2-3-1

    // end
    
    // always @ (*) //router3
    // begin
    //     Path_usage_bits_3[0] = Pr3 & temp_path_block_signals[15]; // 3 to 3

    //     Path_usage_bits_3[1] = Wr3 & temp_path_block_signals[16] & Pr2 & temp_path_block_signals[10]; //3 to 2 //flat
    //     Path_usage_bits_3[2] = Sr3 & temp_path_block_signals[18] & Wr1 & temp_path_block_signals[6] & Nr0 & temp_path_block_signals[4] & Pr2 & temp_path_block_signals[10]; //3 to 2 longer 3-1-0-2

    //     Path_usage_bits_3[3] = Sr3 & temp_path_block_signals[18] & Pr1 & temp_path_block_signals[5]; //3 to 1 //vertical
    //     Path_usage_bits_3[4] = Wr3 & temp_path_block_signals[16] & Sr2 & temp_path_block_signals[13] & Er0 & temp_path_block_signals[2] & Pr1 & temp_path_block_signals[5]; //3 to 1 longer 3-2-0-1

    //     Path_usage_bits_3[5] = Sr3 & temp_path_block_signals[18] & Wr1 & temp_path_block_signals[6] & Pr0 & temp_path_block_signals[0]; //3 to 0 //diagonal (vertical) 3-1-0
    //     Path_usage_bits_3[6] = Wr3 & temp_path_block_signals[16] & Sr2 & temp_path_block_signals[13] & Pr0 & temp_path_block_signals[0];  //3 to 0 (flat) 3-2-0

    // end

    assign Path_usage_bits = { Path_usage_bits_3, Path_usage_bits_2, Path_usage_bits_1, Path_usage_bits_0};
endmodule


    
// Old khichri (no need to look here)

// module main (
// );
// wire d01,d10,d12,d21,d34,d43,d45,d54,d67,d76,d78,d87,d03,d30,d36,d63,,d14,d41,d44,d74,d25,d52,d58,d85; // cross edges
// wire d00,d11,d22,d33,d44,d55,d66,d77,d88; //self edges
// reg p00_1;
// reg p01_1,p01_2,p01_3,p01_4, p01_5,p01_6,p01_7,p01_8;
// reg p02_2,p02_3,p02_4, p02_5,p02_6,p02_7,p02_8, p02_9,p02_20,p02_11;


// // Paths from 0 to 0:
// // 0 
// always @(*)
// begin
//     p00_1 = d00;
// end

// //for 0 to 1
// // 0 1
// // 0 3 4 1 
// // 0 3 4 5 2 1 
// // 0 3 6 7 4 1 

// // 0 3 4 7 8 5 2 1 
// // 0 3 6 7 4 5 2 1 
// // 0 3 6 7 8 5 2 1 
// // 0 3 6 7 8 5 4 1 
// always @ (*)
// begin
//     p01_1 = d01;
//     p01_2 = d03|d34|d41;
//     p01_3 = d03|d34|d45|d52|d21;
//     p01_4 = d03|d36|d67|d74|d41;
//     p01_5 = d03|d34|d47|d78|d85|d52|d21;
//     p01_6 = d03|d36|d67|d74|d45|d52
//     p01_7= 
//     p01_8

// end

// // Paths from 0 to 2:
// // 0 1 2 
// // 0 1 4 5 2 
// // 0 3 4 1 2 
// // 0 3 4 5 2 
// // 0 1 4 7 8 5 2 
// // 0 3 4 7 8 5 2 
// // 0 3 6 7 4 1 2 
// // 0 3 6 7 4 5 2 
// // 0 3 6 7 8 5 2 
// // 0 1 4 3 6 7 8 5 2 
// // 0 3 6 7 8 5 4 1 2     

// always @(*)
// begin

// end
    


    
// endmodule
