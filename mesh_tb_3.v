`include "main.v"

module tb_noc();
    reg clk=0;
    reg reset=0;
    wire [3:0] processor_ready_signals;
    reg [10:0] p0_configure,p1_configure,p2_configure,p3_configure;
    wire [8:0] p0_recieve_data,p1_recieve_data,p2_recieve_data,p3_recieve_data;
    reg block_all_paths;
    integer i;
    parameter No_DATA=18'b0;
    mesh m1 (
        .clock(clk), 
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
         .r0_output(),   // These lines were commented out as the corresponding ports are not defined in the module instantiation
         .r1_output(),
         .r2_output(),
         .r3_output()
    );
    
    initial begin
        $dumpfile("noc_sim.vcd");
        $dumpvars(0,tb_noc);
        reset=1'b0;
        block_all_paths=1'b0;
        p0_configure=11'b0;
        p1_configure=11'b0;
        p2_configure=11'b0;
        p3_configure=11'b0;
        #1 reset = 1'b1;
        #16 reset = 1'b0;

        #10 p0_configure = 11'b00000001011;
        #30 p0_configure = 11'b00000001010;
        p3_configure = 11'b00000001111;
        #10 p0_configure = 11'b00000001011;
        #10 p1_configure = 11'b00000000101;

        #20 p2_configure = 11'b00000001011;
        #40 p2_configure = 11'b00000001010;
        p3_configure = 11'b00000001111;
        #20 p2_configure = 11'b00000001011;

        #40 p3_configure = 11'b00000001011;
        #30 p3_configure = 11'b00000001010;
        p0_configure = 11'b00000001001;
        #10 p3_configure = 11'b00000001011;

        #60 p1_configure = 11'b000000001011;

        #50 block_all_paths=1'b1;
        #50 block_all_paths=1'b0;

        #1 reset = 1'b1;
        #16 reset = 1'b0;
        #200;

        #10 p0_configure = 11'b00000001101;
        p3_configure = 11'b00000001111;
        #10 p0_configure = 11'b00000001101;
        #10 p1_configure = 11'b000000001010;

        #20 p2_configure = 11'b00000001101;
        #1 p3_configure = 11'b00000001111;

        #40 p3_configure = 11'b00000001101;
        #1 p1_configure = 11'b00000001010;
        #10 p3_configure = 11'b00000001101;

        #60 p1_configure = 11'b000000001101;
        #10 p0_configure = 11'b000000001000;
        #10 p1_configure = 11'b000000001101;

        #50 block_all_paths=1'b1;
        #50 block_all_paths=1'b0;

        #1 reset = 1'b1;
        #16 reset = 1'b0;

        #200;

        #60 p1_configure = 11'b000000001101;
        #1 p3_configure = 11'b000000001101;
        #10 p1_configure = 11'b000000001101;

        #50 block_all_paths=1'b1;
        #50 block_all_paths=1'b0;

        #200;

        #10 p0_configure = 11'b00000001111;
        #10 p1_configure = 11'b00000001011;
        #10 p0_configure = 11'b00000001111;
        #10 p1_configure = 11'b00000000110;

        #20 p2_configure = 11'b00000001111;
        #10 p0_configure = 11'b00000001111;
        #10 p2_configure = 11'b00000001111;

        #40 p3_configure = 11'b00000001111;
        p0_configure = 11'b00000001111;
        #10 p3_configure = 11'b00000001111;

        #60 p1_configure = 11'b00000001111;

        #40 reset = 1'b1;
        #16 reset = 1'b0;

        #50 block_all_paths=1'b1;
        #50 block_all_paths=1'b0;

        #200;

        #20 p0_configure = 11'b00000010001;
        #1 p1_configure = 11'b00000010011;
        #1 p2_configure = 11'b00000010101;
        #1 p3_configure = 11'b00000010111;

	
        #50 reset = 1'b1;
        #16 reset = 1'b0;

        #50 block_all_paths=1'b1;
        #50 block_all_paths=1'b0;

	 #40 reset = 1'b1;
        #16 reset = 1'b0;
        #200;


	
       

	//p0_configure = 11'b00000001001;

	

	//#10 p1_configure = 11'b00000001001;
        //#30 p1_configure = 11'b00000001000;
        //p3_configure = 11'b00000001111;
        //#10 p1_configure = 11'b00000001001;

	#2 p1_configure = 11'b00000001001;
	#1 p2_configure = 11'b00000001001;
	#1 p3_configure = 11'b00000001001;
	
	
	#50 p1_configure = 11'b00000001001;
	#1 p2_configure = 11'b00000001001;
	#1 p3_configure = 11'b00000001001;

	 #70 reset = 1'b1;
        #16 reset = 1'b0;

        #50 block_all_paths=1'b1;
        #50 block_all_paths=1'b0;

	 #70 reset = 1'b1;
        #16 reset = 1'b0;
        #200;
	 
	#2 p1_configure = 11'b00000001001;

	#40 p1_configure = 11'b00000001000;

	#2 p1_configure = 11'b00000001001;
	

	 #70 reset = 1'b1;
        #16 reset = 1'b0;

        #50 block_all_paths=1'b1;
        #50 block_all_paths=1'b0;

	 #70 reset = 1'b1;
        #16 reset = 1'b0;
	#200;

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

	#10000 $finish;
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

	#70 reset = 1'b1;
        #16 reset = 1'b0;

        #50 block_all_paths=1'b1;
        #50 block_all_paths=1'b0;

	 #70 reset = 1'b1;
        #16 reset = 1'b0;
	#200;
        
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

#70 reset = 1'b1;
        #16 reset = 1'b0;

        #50 block_all_paths=1'b1;
        #50 block_all_paths=1'b0;

	 #70 reset = 1'b1;
        #16 reset = 1'b0;
	#200;
        

 #20  p2_configure = 11'b00000001101;
         #20  p2_configure = 11'b00000010101;
	 #20  p2_configure = 11'b00000100101;

#20 p1_configure = 11'b00000010001;
	 #20  p1_configure = 11'b00001100001;
         #20 p1_configure = 11'b00001001101;
          #20 p3_configure = 11'b00100001001;
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

# 10000 $finish;
end
    always #10 clk = ~clk;

endmodule
