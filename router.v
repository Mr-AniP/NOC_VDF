/*
Module name: 
    router
Module Description:
    This Module contains basic Building block of NoC Mesh.
    It is a 5x5 (NEWS,P) router with 5 input and 5 output ports.
Data Packet: 
    Packet size of data  is 1 byte, 1 bit for last flit (indicates The last Packet)
Module Pin Description :
    Clock: 1 bit input port for the clock signal.
    Reset: 1 bit input port for the reset signal.
    SetNR: 1 bit input port to set the North side port ready reg by master.
    SetSR: 1 bit input port to set the South side port ready reg by master.
    SetER: 1 bit input port to set the East side port ready reg by master.
    SetWR: 1 bit input port to set the West side port ready reg by master
    SetPR: 1 bit input port to set the Processor side port ready reg by master.
    Select North: 3 bit input port to select the data for North side port.
    Select South: 3 bit input port to select the data for South side port.
    Select East: 3 bit input port to select the data for East side port.
    Select West: 3 bit input port to select the data for West side port.
    Select Processor: 3 bit input port to select the data for Processor side port.
    Data North: 9 bit input port for the data from the North side port. [8] ->last flit
    Data South: 9 bit input port for the data from the South side port. [8] ->last flit
    Data East: 9 bit input port for the data from the East side port. [8] ->last flit
    Data West: 9 bit input port for the data from the West side port. [8] ->last flit
    Data Processor: 9 bit input port for the data from the Processor side port. [8] ->last flit
    Output North: 9 bit output port for the data to the North side port. [8] ->last flit
    Output South: 9 bit output port for the data to the South side port. [8] ->last flit
    Output East: 9 bit output port for the data to the East side port. [8] ->last flit
    Output West: 9 bit output port for the data to the West side port. [8] ->last flit
    Output Processor: 9 bit output port for the data to the Processor side port. [8] ->last flit
    North Ready: 1 bit output port to indicate the availability of the North side port line.
    South Ready: 1 bit output port to indicate the availability of the South side port line.
    East Ready: 1 bit output port to indicate the availability of the East side port line.
    West Ready: 1 bit output port to indicate the availability of the West side port line.
    Processor Ready: 1 bit output port to indicate the availability of the Processor side port line.
Additional Notes:
    regPR: Check whether the path is busy  or not. 0->busy, 1->free
    
    Output at each direction can have data from NEWS,P. Therefore,we need 3 select bits in each Router_control_signals in master.v

*/

// Start of the module

module router(
    input clock,
    input reset,
    input [2:0] select_north,
    input [2:0] select_south,
    input [2:0] select_east,
    input [2:0] select_west,
    input [2:0] select_processor,
    input [8:0] data_north, 
    input [8:0] data_south,
    input [8:0] data_east,
    input [8:0] data_west,
    input [8:0] data_processor,
    output [8:0] output_north,
    output [8:0] output_south,
    output [8:0] output_east,
    output [8:0] output_west,
    output [8:0] output_processor,
    output north_ready,
    output south_ready,
    output east_ready,
    output west_ready,
    output processor_ready,
    input SetNR,
    input SetSR,
    input SetER,
    input SetWR,
    input SetPR
    );

// internal working

// temporary variables of output used till clockedge is not reached
    reg [8:0] output_north1,output_south1,output_east1,output_west1,output_processor1; 
    reg [8:0] output_north2,output_south2,output_east2,output_west2,output_processor2;
    assign output_north=output_north2;
    assign output_south=output_south2;
    assign output_east=output_east2;
    assign output_west=output_west2;
    assign output_processor=output_processor2;



// check whether route is free or not
    reg regNR,regSR,regER,regWR,regPR;

//temporary variable used till clockedge is not reached
    reg regNR1,regSR1,regER1,regWR1,regPR1;

    // Data Packet Routing (Crossbar Working)

    always@(*)
    begin 
        case(select_north) //choosing which input of router will go as output on north, essentially a multiplexer
            3'b000: output_north1 = data_north;
            3'b001: output_north1 = data_south;
            3'b010: output_north1 = data_east;
            3'b011: output_north1 = data_west;
            3'b100: output_north1 = data_processor;
	    default: output_north1 = 9'b000000000;
            //3'b101: output_north1 = 9'b00000000;
            //3'b110: output_north1 = 9'b00000000;
            //3'b111: output_north1 = 9'b00000000;
        endcase
    end

    always@(*)
    begin
        case(select_south) //choosing which input of router will go as output on south, essentially a multiplexer
            3'b000: output_south1 = data_north;
            3'b001: output_south1 = data_south;
            3'b010: output_south1 = data_east;
            3'b011: output_south1 = data_west;
            3'b100: output_south1 = data_processor;
	    default: output_south1 = 9'b000000000;
            //3'b101: output_south1 = 9'b00000000;
            //3'b110: output_south1 = 9'b00000000;
            //3'b111: output_south1 = 9'b00000000;
        endcase
    end

    always@(*)
    begin
        case(select_east) //choosing which input of router will go as output on east, essentially a multiplexer
            3'b000: output_east1 = data_north;
            3'b001: output_east1 = data_south;
            3'b010: output_east1 = data_east;
            3'b011: output_east1 = data_west;
            3'b100: output_east1 = data_processor;
	    default: output_east1 = 9'b000000000;
            //3'b101: output_east1 = 9'b00000000;
            //3'b110: output_east1 = 9'b00000000;
            //3'b111: output_east1 = 9'b00000000;
        endcase
    end

    always@(*)
    begin
        case(select_west) //choosing which input of router will go as output on west, essentially a multiplexer
            3'b000: output_west1 = data_north;
            3'b001: output_west1 = data_south;
            3'b010: output_west1 = data_east;
            3'b011: output_west1 = data_west;
            3'b100: output_west1 = data_processor;
	    default: output_west1 = 9'b000000000;
            //3'b101: output_west1 = 9'b00000000;
            //3'b110: output_west1 = 9'b00000000;
            //3'b111: output_west1 = 9'b00000000;
        endcase
    end

    always@(*)
    begin
        case(select_processor) //choosing which input of router will go as output on processor, essentially a multiplexer
            3'b000: output_processor1 = data_north;
            3'b001: output_processor1 = data_south;
            3'b010: output_processor1 = data_east;
            3'b011: output_processor1 = data_west;
            3'b100: output_processor1 = data_processor;
	    default: output_processor1 = 9'b000000000;
            //3'b101: output_processor1 = 9'b00000000;
            //3'b110: output_processor1 = 9'b00000000;
            //3'b111: output_processor1 = 9'b00000000;
        endcase
    end

    // Output Port Selection
    always@(*)
    begin
        if(output_north1[8]==1'b1)
        begin
            regNR1=1; // If last bit of data packet, make route free
        end
        else if(SetNR==1'b1)
        begin
            regNR1=0; // The master has granted permission to route through this direction, make the path busy (for next incoming packet)
        end
        else
        begin
            regNR1=regNR; //Else continue with the previous value
        end
    end
    always@(*)
    begin
        if(output_south1[8]==1'b1)
        begin
            regSR1=1;// If last bit of data packet, make route free
        end
        else if(SetSR==1'b1)
        begin
            regSR1=0; // The master has granted permission to route through this direction, make the path busy (for next incoming packet)
        end
        else
        begin
            regSR1=regSR; //Else continue with the previous value
        end
    end
    always@(*)
    begin
        if(output_east1[8]==1'b1)
        begin
            regER1=1;// If last bit of data packet, make route free
        end
        else if(SetER==1'b1)
        begin
            regER1=0; // The master has granted permission to route through this direction, make the path busy (for next incoming packet)
        end
        else
        begin
            regER1=regER; //Else continue with the previous value
        end
    end
    always@(*)
    begin
        if(output_west1[8]==1'b1)
        begin
            regWR1=1;// If last bit of data packet, make route free
        end
        else if(SetWR==1'b1)
        begin
            regWR1=0; // The master has granted permission to route through this direction, make the path busy (for next incoming packet)
        end
        else
        begin
            regWR1=regWR; //Else continue with the previous value
        end
    end
    always@(*)
    begin
        if(output_processor1[8]==1'b1)
        begin
            regPR1=1;// If last bit of data packet, make route free
        end
        else if(SetPR==1'b1)
        begin
            regPR1=0; // The master has granted permission to route through this direction, make the path busy (for next incoming packet)
        end
        else
        begin
            regPR1=regPR; //Else continue with the previous value
        end
    end
    //assigning output at posedge of clock or reset
    always@(posedge clock)
    begin
        output_north2<=output_north1; //assign output according to the output of MUX, at clock edge
    end
    always@(posedge clock or posedge reset)
    begin
        if(reset==1'b1)
        begin
            regNR<=1; //if reset, all paths are made free
        end
        else
        begin
            regNR<=regNR1; //assign path freeness according to the algorithm done above, at clock edge
        end
    end
    always@(posedge clock)
    begin
        output_south2<=output_south1; //assign output according to the output of MUX, at clock edge
    end
    always@(posedge clock or posedge reset)
    begin
        if(reset==1'b1)
        begin
            regSR<=1; //if reset, all paths are made free
        end
        else
        begin
            regSR<=regSR1; //assign path freeness according to the algorithm done above, at clock edge
        end
    end
    always@(posedge clock)
    begin
        output_east2<=output_east1; //assign output according to the output of MUX, at clock edge
    end
    always@(posedge clock or posedge reset)
    begin
        if(reset==1'b1)
        begin
            regER<=1; //if reset, all paths are made free
        end
        else
        begin
            regER<=regER1; //assign path freeness according to the algorithm done above, at clock edge
        end
    end
    always@(posedge clock)
    begin
        output_west2<=output_west1; //assign output according to the output of MUX done above, at clock edge
    end
    always@(posedge clock or posedge reset)
    begin
        if(reset==1'b1)
        begin
            regWR<=1; //if reset, all paths are made free
        end
        else
        begin
            regWR<=regWR1; //assign path freeness according to the algorithm done above, at clock edge
        end
    end
    always@(posedge clock)
    begin
        output_processor2<=output_processor1; //assign output according to the output of MUX done above, at clock edge
    end
    always@(posedge clock or posedge reset)
    begin
        if(reset==1'b1)
        begin
            regPR<=1;//if reset, all paths are made free
        end
        else
        begin
            regPR<=regPR1; //assign path freeness according to the algorithm done above, at clock edge
        end
    end

    // Assigning ussage bit (freeness of paths found using regNR, regSR, regER, regWR, regPR)
    assign north_ready=regNR;
    assign south_ready=regSR;
    assign east_ready=regER;
    assign west_ready=regWR;
    assign processor_ready=regPR;
    
endmodule

// End of the module

// Vatwani ki salah
// always@(posedge clock)
//     begin
//         output_east<=output_east1;
//         // Path Freeing mechanism (Usage of 9th bit of output)
//         if(output_east1[8]==1'b1)
//         begin
//             east_ready<=1;
//         end
//         else
//         begin
//             east_ready<=east_ready;
//         end
        
//         output_west<=output_west1;
//         if(output_west1[8]==1'b1)
//         begin
//             west_ready<=1;
//         end
//         else
//         begin
//             west_ready<=west_ready;
//         end
//         output_processor<=output_processor1;
//         if(output_processor1[8]==1'b1)
//         begin
//             processor_ready<=1;
//         end
//         else
//         begin
//             processor_ready<=processor_ready;
//         end
//         output_south<=output_south1;
//         if(output_south1[8]==1'b1)
//         begin
//             south_ready<=1;
//         end
//         else
//         begin
//             south_ready<=south_ready;
//         end
//     end

// old logic
    // always@(posedge output_north[8])
    // begin
    //     north_ready<=0;
    // end
    // always@(posedge output_south[8])
    // begin
    //     south_ready<=0;
    // end
    // always@(posedge output_east[8])
    // begin
    //     east_ready<=0;
    // end
    // always@(posedge output_west[8])
    // begin
    //     west_ready<=0;
    // end
    // always@(posedge output_processor[8])
    // begin
    //     processor_ready<=0;
    // end

// End of file
