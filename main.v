`include"router.v"
module mesh(
    input clk,
    input rst,
    );
    parameter No_data=9'b000000000;
    
    //wire [9:0] d01,d10,d12,d21,d34,d43,d45,d54,d67,d76,d78,d87,d03,d30,d36,d63,d14,d41,d44,d74,d25,d52,d58,d85;
    wire [9:0] d01,d10,d23,d32,d02,d20,d13,d31;
    //wire  use01,use10,use23,use32,use02,use20,use13,use31;
    reg Nr0,Sr0,Er0,Wr0;
    reg Nr1,Sr1,Er1,Wr1;
    reg Nr2,Sr2,Er2,Wr2;
    reg Nr3,Sr3,Er3,Wr3;
    
    reg [5:0] Path_usage_bits_0;
    reg [5:0] Path_usage_bits_1;
    reg [5:0] Path_usage_bits_2;
    reg [5:0] Path_usage_bits_3;

    reg [23:0] Path_usage_bits;

    // wire [9:0] d00,d11,d22,d33,d44,d55,d66,d77,d88;
    //wire use_bits[0],use_bits[1],use_bits[2],use_bits[3],use_bits[4],use_bits[5],use_bits[6],use_bits[7],use_bits[8],use_bits[9],use_bits[10],use_bits[11],use_bits[12],use_bits[13],use_bits[14],use_bits[15],use_bits[16],use_bits[17],use_bits[18],use_bits[19],use_bits[20],use_bits[21],use_bits[22],use_bits[23];
    //wire [7:0]use_bits;
    
//Set commands by master
    router r0(
        .clk(clock),
        .rst(reset),
        .select_north(),
        .select_south(),
        .select_east(),
        .select_west(),
        .select_processor(),
        .data_north(d20),
        .data_south(No_data),
        .data_east(d10),
        .data_west(No_data),
        .data_processor(),
        .output_north(d02),
        .output_south(),
        .output_east(d01),
        .output_west(),
        .output_processor(),
        .north_ready(Nr0),
        .south_ready(Sr0),
        .east_ready(Er0),
        .west_ready(Wr0),
        .processor_ready()
        .SetNR(),
        .SetSR(),
        .SetER(),
        .SetWR(),
        .SetPR()
    );
    
    router r1(
        .clk(clock)
        .select_north(),
        .select_south(),
        .select_east(),
        .select_west(),
        .select_processor(),
        .data_north(d41),
        .data_south(No_data),
        .data_east(d21),
        .data_west(d01),
        .data_processor(),
        .output_north(d14),
        .output_south(),
        .output_east(d12),
        .output_west(d10),
        .output_processor(),
        .north_ready(Nr1),
        .south_ready(Sr1),
        .east_ready(Er1),
        .west_ready(Wr1),
        .processor_ready()
        .SetNR(),
        .SetSR(),
        .SetER(),
        .SetWR(),
        .SetPR()
    );

    router r2(
        .clk(clock),
        .select_north(),
        .select_south(),
        .select_east(),
        .select_west(),
        .select_processor(),
        .data_north(d52),
        .data_south(No_data),
        .data_east(No_data),
        .data_west(d12),
        .data_processor(),
        .output_north(d25),
        .output_south(),
        .output_east(),
        .output_west(d21),
        .output_processor(),
        .north_ready(Nr2),
        .south_ready(Sr2),
        .east_ready(Er2),
        .west_ready(Wr2),
        .processor_ready() 
        .SetNR(),
        .SetSR(),
        .SetER(),
        .SetWR(),
        .SetPR()    
    );

    router r3(
        .clk(clock),
        .select_north(),
        .select_south(),
        .select_east(),
        .select_west(),
        .select_processor(),
        .data_north(d63),
        .data_south(d03),
        .data_east(d43),
        .data_west(No_data),
        .data_processor(),
        .output_north(d36),
        .output_south(d30),
        .output_east(d34),
        .output_west(),
        .output_processor(),
        .north_ready(Nr3),
        .south_ready(Sr3),
        .east_ready(Er3),
        .west_ready(Wr3),
        .processor_ready(),
        
        .SetNR(),
        .SetSR(),
        .SetER(),
        .SetWR(),
        .SetPR()
    );

    always @ (*) //router 0
    begin
        
        Path_usage_bits_0[0] = Er0; //0to1 //flat
        Path_usage_bits_0[1] = Nr0|Er2|Sr3|; //0 to 1 longer

        Path_usage_bits_0[2] = Nr0; //0 to 2 //vertical
        Path_usage_bits_0[3] = Er0|Nr1|Wr3; //0 to 2 longer

        Path_usage_bits_0[4] = Nr0|Er2 //0 to 3 //diagonal (vertical)
        Path_usage_bits_0[5] = Er0|Nr1; //0 to 3 (flat)

    end
    

    always @ (*) //router1
    begin
        Path_usage_bits_1[0] = Er1; //1 to 0 //flat
        Path_usage_bits_1[1] = Nr1|Wr3|Sr2; //1 to 0 longer

        Path_usage_bits_1[2] = Nr1; //1 to 3 //vertical
        Path_usage_bits_1[3] = Wr1|Nr0|Er2; // 1 to 3 longer
        
        Path_usage_bits_1[4] = Nr1|Wr3; // 1 to 2 //diagonal (vertical)
        Path_usage_bits_1[5] = Wr1|Nr0; //1 to 2 (flat)

    end

    
    always @ (*) //router2
    begin
        Path_usage_bits_2[0] = Er2; //2 to 3 //flat
        Path_usage_bits_2[1] = Sr2|Er0|Nr1; //2 to 3 longer

        Path_usage_bits_2[2] = Sr2; //2 to 0 //vertical
        Path_usage_bits_2[3] = Er2|Sr3|Wr1; //2 to 0 longer

        Path_usage_bits_2[4] = Sr2|Er0; //2 to 1 //diagonal (vertical)
        Path_usage_bits_2[5] = Er2|Sr3;  //2 to 1 (flat)

    end
    
    always @ (*) //router3
    begin
        Path_usage_bits_3[0] = Wr3; //3 to 2 //flat
        Path_usage_bits_3[1] = Sr3|Wr1|Nr0; //3 to 2 longer

        Path_usage_bits_3[2] = Sr3; //3 to 1 //vertical
        Path_usage_bits_3[3] = Wr3|Sr2|Er0; //3 to 1 longer

        Path_usage_bits_3[4] = Sr3|Wr1; //3 to 0 //diagonal (vertical)
        Path_usage_bits_3[5] = Wr3|Sr2;  //3 to 0 (flat)

    end

    Path_usage_bits = {Path_usage_bits_0, Path_usage_bits_1, Path_usage_bits_2, Path_usage_bits_3}
endmodule







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