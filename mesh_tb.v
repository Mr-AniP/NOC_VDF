//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2024 20:15:48
// Design Name: 
// Module Name: mesh_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "main.v"
module mesh_tb();

     reg clk=0;
    reg reset=0;
    wire [3:0] processor_ready_signals;
    reg [10:0] p0_configure,p1_configure,p2_configure,p3_configure;
    // wire [19:0] temp_path_block_signals;
    wire [8:0] p0_recieve_data,p1_recieve_data,p2_recieve_data,p3_recieve_data;
    reg block_all_paths;
    integer i;
    parameter No_DATA=18'b0;
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
       
  initial begin
    $dumpfile("noc_sim.vcd");
    $dumpvars(0,mesh_tb);

    reset = 1'b1;
    block_all_paths = 1'b0;
    #16 reset = 1'b0;
	
    for(i = 0; i < 4; i = i + 1) begin
      case(i)
        0: begin 
          p0_configure = 11'b00000001001;
          p1_configure = 11'b00000001001;
          p2_configure = 11'b00000001001;
          p3_configure = 11'b00000001001;
        end
        1: begin 
          p0_configure = 11'b00000001011;
          p1_configure = 11'b00000001011;
          p2_configure = 11'b00000001011;
          p3_configure = 11'b00000001011;
        end
        2: begin 
          p0_configure = 11'b00000001101;
          p1_configure = 11'b00000001101;
          p2_configure = 11'b00000001101;
          p3_configure = 11'b00000001101;
        end
        3: begin 
          p0_configure = 11'b00000001111;
          p1_configure = 11'b00000001111;
          p2_configure = 11'b00000001111;
          p3_configure = 11'b00000001111;
        end
      endcase
      #20; // Delay to ensure parallelism in simulation
    end
    
    reset = 1'b1;
    #16 reset = 1'b0;
     
   // #4000 $finish;
  end

 


	initial begin

 	#1 reset = 1'b1;
        #16 reset = 1'b0;
	#20 p0_configure = 11'b00000001001;
       #20 p0_configure = 11'b00000010001;
	#1 p0_configure = 11'b00000100001;
	#1  p0_configure = 11'b00000001011;
  #1 p0_configure = 11'b00000101011;
  #1 p0_configure = 11'b00000111011;

 #20 p1_configure = 11'b00000010001;
	 #20  p1_configure = 11'b00000100001;
         #20 p1_configure = 11'b00000001101;
        #20 p0_configure = 11'b00000001011;
        #20 p0_configure = 11'b00000010011;

#1 p3_configure = 11'b00000100101;
          #20 p3_configure = 11'b00000100001;
	#20 p0_configure = 11'b00000100011;
        #20 p0_configure = 11'b00000001101;
        #20 p0_configure = 11'b00000010101;

  #20 p2_configure = 11'b00000010001;
	 #20 p2_configure = 11'b00000100001;
	 #20  p2_configure = 11'b00000001101;  #20 p2_configure = 11'b00000010001;
	 #20  p2_configure = 11'b00000100001;

#20 p1_configure = 11'b00000010001;
	 #20  p1_configure = 11'b00000100001;
         #20 p1_configure = 11'b00000001101;
	 #20  p2_configure = 11'b00000001101;
	#20 p0_configure = 11'b00000100101;
        #20 p0_configure = 11'b00000100111;
       #20 p0_configure = 11'b00000001111;
	#20 p0_configure = 11'b00000010111;

	
        
       //#20 p1_configure = 11'b00000001011;
        //#20 p1_configure = 11'b00000001001;
	 #20 p1_configure = 11'b00000001011;
         #20  p1_configure = 11'b00000010011;
	 #20  p1_configure = 11'b00000100011;

 #20  p2_configure = 11'b00000001101;
         #20  p2_configure = 11'b00000010101;
	 #20  p2_configure = 11'b00000100101;
         #20  p1_configure = 11'b00000001001;

  #20 p2_configure = 11'b00000010001;
	 #20  p2_configure = 11'b00000100001;
	 #20  p2_configure = 11'b00000001101;

#1 reset = 1'b1;
      #16 reset = 1'b0;
        
        #20  p1_configure = 11'b00000010001;
	 #20  p1_configure = 11'b00000100001;
         #20 p1_configure = 11'b00000001101;
          #20 p1_configure = 11'b00000010101;

#20 p0_configure = 11'b00000100011;
        #20 p0_configure = 11'b00000001101;
        #20 p0_configure = 11'b00000010101;
	  #20 p1_configure = 11'b00000100101;
          #20 p1_configure = 11'b00000100111;

#20 p3_configure = 11'b00000100101;
          #20 p3_configure = 11'b00000100001;
        #20  p1_configure = 11'b00000001111;
	  #20 p1_configure = 11'b00000010111;
        

        //#20 p2_configure = 11'b00000001011;
        //#20 p2_configure = 11'b00000001001;
         #20 p2_configure = 11'b00000001011;
         #20  p2_configure = 11'b00000011011;
	 #20  p2_configure = 11'b00000100011;
         #20  p2_configure = 11'b00000001001;

	#20  p3_configure = 11'b00000001011;
         #20 p3_configure = 11'b00000010011;
	  #20 p3_configure = 11'b00000100011;
          #20 p3_configure = 11'b00000001101;

#20 p0_configure = 11'b00000100011;
        #20 p0_configure = 11'b00000001101;
        #20 p0_configure = 11'b00000010101;
         #20 p2_configure = 11'b00000010001;

#20 p1_configure = 11'b00000010001;
	 #20  p1_configure = 11'b00000100001;
         #20 p1_configure = 11'b00000001101;
	 #20  p2_configure = 11'b00000100001;
	 #20  p2_configure = 11'b00000001101;
         #20  p2_configure = 11'b00000010101;
	 #20  p2_configure = 11'b00000010101;
         #20  p2_configure = 11'b00100100111;
         #20  p2_configure = 11'b00000001111;

#1 reset = 1'b1;
      #16 reset = 1'b0;
        
	#20 	  p2_configure = 11'b00110010111;

	
        
        //#20 p3_configure = 11'b00000001011;
        //#20 p3_configure = 11'b00000001001;
        #20  p3_configure = 11'b00000001011;
         #20 p3_configure = 11'b00000010011;
	  #20 p3_configure = 11'b00000100011;
          #20 p3_configure = 11'b00000001101;
          #20 p3_configure = 11'b00000010101;

#20 p0_configure = 11'b00000100011;
        #20 p0_configure = 11'b00000001101;
        #20 p0_configure = 11'b00000010101;
	  #20 p3_configure = 11'b00000100101;
          #20 p3_configure = 11'b00000100001;

 #20  p2_configure = 11'b00000001101;
         #20  p2_configure = 11'b00000010101;
	 #20  p2_configure = 11'b00000100101;

#20 p1_configure = 11'b00000010001;
	 #20  p1_configure = 11'b00000100001;
         #20 p1_configure = 11'b00000001101;
          #20 p3_configure = 11'b00000001001;
	  #20 p3_configure = 11'b00000010001;
	  #20 p3_configure = 11'b00000100111;
          #20 p3_configure = 11'b00000001111;
	 #20 p3_configure = 11'b00000010111;


	#1 reset = 1'b1;
      #16 reset = 1'b0;

	 #20 p0_configure = 11'b00000001011;
 #20 p0_configure = 11'b00000011011;
 #20 p0_configure = 11'b00000001011;
 #20 p0_configure = 11'b00000101011;
 #20 p0_configure = 11'b00000111011;
        
       #500000 $finish;
    end

 always #10 clk = ~clk;

    
endmodule
