/*
Module Pin Description :
    Clock: 1 bit input port for the clock signal.
    Path_free_bits: Indicates the usage of all 28 ((24 cross paths + 4 self paths )) paths available in the 2x2 NOC mesh.
    Router_control_signals: (for all R0 to R3)
        3 bits each for selecting lines of a router -> (In order North, South, East, West, Processor) i.e 3x5
        1 bit each for setting the ready regs of a router  (In order North, South, East, West, Processor) i.e 1x5
    Processor_signals: (for all P0 to P3)
        2 bit to indicate to which processor is transaction requested
        1 bit each for requesting transfer
    response_signals: 4 bit signal where each bit indicates the response from the master to the processors (in order P3 to P0)
    temp_path_block_signals:
        1 bit each for setting the ready regs of a router  (In order North, South, East, West, Processor) i.e 1x5 
        and where 1 indicates the path is blocked
        (in order R0 to R3)
    */

module master(
    input clock,
    input reset,
    input [27:0] path_free_bits,
    input [2:0] P0_signals,
    input [2:0] P1_signals,
    input [2:0] P2_signals,
    input [2:0] P3_signals,
    output reg [19:0] R0_control_signals,
    output reg [19:0] R1_control_signals,
    output reg [19:0] R2_control_signals,
    output reg [19:0] R3_control_signals,
    output reg [3:0] response_signals,
    output [19:0] temp_path_block_signals 
);

//temporary variables
    reg [19:0] R0_control_signals1, R1_control_signals1, R2_control_signals1, R3_control_signals1;
    reg [3:0] response_signals1;

//Preliminary conditions for reset and and every posedge
    always@(posedge clock or posedge reset)
    begin
        if(reset==1'b1) //At reset data does not need to go to anywhere, so all destinadirections of router are set to default
        begin
            R0_control_signals <= 20'b0;
            R1_control_signals <= 20'b0;
            R2_control_signals <= 20'b0;
            R3_control_signals <= 20'b0;
            response_signals <= 4'b0; //Master is saying free all paths
        end

        else //assign destination for every direction of a router following the below computation at every clockedge
        begin
            R0_control_signals  <= R0_control_signals1 ;
            R1_control_signals  <= R1_control_signals1 ;
            R2_control_signals  <= R2_control_signals1 ;
            R3_control_signals  <= R3_control_signals1 ;
            response_signals <= response_signals1;
        end
    end

    always@(*)
    begin
        if(reset==1'b1) //At reset data does not need to go to anywhere, so all destinadirections of router are set to default
        begin
            R0_control_signals1 = {15'b0,5'b0};
            R1_control_signals1 = {15'b0,5'b0};
            R2_control_signals1 = {15'b0,5'b0};
            R3_control_signals1 = {15'b0,5'b0};
            response_signals1 = 4'b0; //Master is saying free all paths
        end

        else
        begin //initially all 0, therafter keep the selctlines part as previous (values are changed for those needed using case)
            R0_control_signals1 = {R0_control_signals1[19:5],5'b0};
            R1_control_signals1 = {R1_control_signals1[19:5],5'b0};
            R2_control_signals1 = {R2_control_signals1[19:5],5'b0};
            R3_control_signals1 = {R3_control_signals1[19:5],5'b0};
            response_signals1 = 4'b0;
            if(P0_signals[0]==1'b1)
            begin
                case(P0_signals[2:1]) //iterating all cases of P0
                    2'b00://0 to 0
                    begin
                        if(path_free_bits[0]==1'b1 && R0_control_signals1[0]==1'b0) 
                        begin
                            R0_control_signals1[7:5] =3'b100; //R0 from processor to processor
                            R0_control_signals1[0] = 1'b1; //processor is active
                            response_signals1[0] = 1'b1;
                        end
                    end
                    2'b01://0 to 1
                    begin
                        if(path_free_bits[1]==1'b1 && R0_control_signals1[2]==1'b0 && R1_control_signals1[0]==1'b0)
                        begin //direct
                            R0_control_signals1[13:11] =3'b100; //from processor data goes to east edge of R0
                            R0_control_signals1[2] = 1'b1;// east is active
                            R1_control_signals1[7:5]=3'b011;//from west of R1 to its processor
                            R1_control_signals1[0] = 1'b1;//processor is active
                            response_signals1[0] = 1'b1;
                        end
                        else if(path_free_bits[2]==1'b1 && R0_control_signals1[4]==1'b0 && R2_control_signals1[2]==1'b0 && R3_control_signals1[3]==1'b0 && R1_control_signals1[0]==1'b0)
                        begin//indirect 0-2-3-1
                            R0_control_signals1[19:17] =3'b100;//from processor to north edge of R0
                            R0_control_signals1[4] = 1'b1;//north is active
                            R2_control_signals1[13:11]=3'b001;//from south edge of R2 to east 
                            R2_control_signals1[2] = 1'b1;//east is active
                            R3_control_signals1[16:14]=3'b011;//from west of R3 to its south
                            R3_control_signals1[3]=1'b1;//south is active
                            R1_control_signals1[7:5]=3'b000;//from north of R1 to its processor
                            R1_control_signals1[0] = 1'b1; //processor is active
                            response_signals1[0] = 1'b1;
                        end
                    end
                    2'b10://from 0 to 2
                    begin
                        if(path_free_bits[3]==1'b1 && R0_control_signals1[4]==1'b0 && R2_control_signals1[0]==1'b0)
                        begin//direct
                            R0_control_signals1[19:17] = 3'b100; //from processor data goes to North edge of R0
                            R0_control_signals1[4] = 1'b1; //north edge is active
                            R2_control_signals1[7:5] = 3'b001; //from South of R2 to its processor
                            R2_control_signals1[0] = 1'b1;  //processor edge is active
                            response_signals1[0] = 1'b1; //Processor of Router 1 active
                        end
                        
                        else if (path_free_bits[4]==1'b1 && R0_control_signals1[2]==1'b0 && R1_control_signals1[4]==1'b0 && R3_control_signals1[1]==1'b0 && R2_control_signals1[0]==1'b0)
                        begin//indirect 0-1-3-2
                            
                            R0_control_signals1[13:11] =3'b100; //from processor to east edge
                            R0_control_signals1[2] = 1'b1; //east edge is active
                            R1_control_signals1[19:17]=3'b011; //from west edge to north edge
                            R1_control_signals1[4] = 1'b1; //north edge is active
                            R3_control_signals1[10:8]=3'b001; //from south to west
                            R3_control_signals1[1]=1'b1; //west is active
                            R2_control_signals1[7:5] = 3'b010; //from west of R2 to its processor
                            R2_control_signals1[0] = 1'b1;  //processor edge is active
                            response_signals1[0] = 1'b1;

                        end
                    end
                    2'b11://0 to 3
                    begin
                        if(path_free_bits[5]==1'b1 && R0_control_signals1[4]==1'b0 && R2_control_signals1[2]==1'b0 && R3_control_signals1[0]==1'b0)
                        begin//0-2-3
                            R0_control_signals1[19:17] =3'b100;//from processor to north
                            R0_control_signals1[4] = 1'b1;//north is ready
                            R2_control_signals1[13:11]=3'b001;//from south to east of R2
                            R2_control_signals1[2] = 1'b1;//east is active
                            R3_control_signals1[7:5]=3'b011;//from west to processor
                            R3_control_signals1[0]=1'b1;//processor is active
                            response_signals1[0] = 1'b1;
                        end
                        else if(path_free_bits[6]==1'b1 && R0_control_signals1[2]==1'b0 && R1_control_signals1[4]==1'b0 && R3_control_signals1[0]==1'b0)
                        begin//0-1-3
                            R0_control_signals1[13:11] =3'b100;//from processor to east
                            R0_control_signals1[2] = 1'b1;//east is active
                            R1_control_signals1[19:17]=3'b011;//from west of R1 to north
                            R1_control_signals1[4] = 1'b1;//north is active
                            R3_control_signals1[7:5]=3'b001;//from south of R3 to processor
                            R3_control_signals1[0]=1'b1;//processor is active
                            response_signals1[0] = 1'b1;
                        end
                    end
                endcase
            end

            if(P1_signals[0]==1'b1) //iterating all cases of P1
            begin
                case(P1_signals[2:1])
                    2'b00: //1 to 0
                    begin
                        if(path_free_bits[8]==1'b1 && R1_control_signals1[1]==1'b0 && R0_control_signals1[0]==1'b0)
                        begin //direct
                            R1_control_signals1[10:8] =3'b100;
                            R1_control_signals1[1] = 1'b1;
                            R0_control_signals1[7:5]=3'b010;
                            R0_control_signals1[0] = 1'b1;
                            response_signals1[1] = 1'b1;
                        end
                        else if(path_free_bits[9]==1'b1 && R1_control_signals1[4]==1'b0 && R3_control_signals1[1]==1'b0 && R2_control_signals1[3]==1'b0 && R0_control_signals1[0]==1'b0)
                        begin//indirect
                            R1_control_signals1[19:17] =3'b100;
                            R1_control_signals1[4] = 1'b1;
                            R3_control_signals1[10:8]=3'b001;
                            R3_control_signals1[1] = 1'b1;
                            R2_control_signals1[16:14]=3'b010;
                            R2_control_signals1[3]=1'b1;
                            R0_control_signals1[7:5]=3'b000;
                            R0_control_signals1[0] = 1'b1;
                            response_signals1[1] = 1'b1;
                        end
                    end
                    2'b01://1 to 1
                    begin
                        if(path_free_bits[7]==1'b1 && R1_control_signals1[0]==1'b0 )
                        begin
                            R1_control_signals1[7:5] =3'b100; //R1 from processor to processor
                            R1_control_signals1[0] = 1'b1; //processor is active
                            response_signals1[1] = 1'b1;
                        end
                    end
                    2'b10: //from 1 to 2
                    begin
                        if(path_free_bits[12]==1'b1 && R1_control_signals1[4]==1'b0 && R3_control_signals1[1]==1'b0 && R2_control_signals1[0]==1'b0)
                        begin//1-3-2
                            R1_control_signals1[19:17] =3'b100; //R1 from processor to north
                            R1_control_signals1[4] = 1'b1; //north is active
                            R3_control_signals1[10:8]=3'b001; //R3 from south to west
                            R3_control_signals1[1] = 1'b1; //west is active
                            R2_control_signals1[7:5]=3'b010; //from R2 from east to processor
                            R2_control_signals1[0]=1'b1; //processor is active
                            response_signals1[1] = 1'b1;
                        end
                        else if(path_free_bits[13]==1'b1 && R1_control_signals1[1]==1'b0 && R0_control_signals1[4]==1'b0 && R2_control_signals1[0]==1'b0)
                        begin//1-0-2
                            R1_control_signals1[10:8] =3'b100; //R1 from processsor to west
                            R1_control_signals1[1] = 1'b1; //west is active
                            R0_control_signals1[19:17]=3'b010; //R0 from east to north 
                            R0_control_signals1[4] = 1'b1;//north is active
                            R2_control_signals1[7:5]=3'b001;//R2 from south to processor
                            R2_control_signals1[0]=1'b1;//processor is active
                            response_signals1[1] = 1'b1;
                        end
                    end
                    2'b11://1 to3
                    begin
                        if(path_free_bits[10]==1'b1 && R1_control_signals1[4]==1'b0 && R3_control_signals1[0]==1'b0)
                        begin//direct
                            R1_control_signals1[19:17] =3'b100;
                            R1_control_signals1[4] = 1'b1;
                            R3_control_signals1[7:5]=3'b001;
                            R3_control_signals1[0]=1'b1;
                            response_signals1[1] = 1'b1;
                        end
                        else if(path_free_bits[11]==1'b1 && R1_control_signals1[1]==1'b0 && R0_control_signals1[4]==1'b0 && R2_control_signals1[2]==1'b0 && R3_control_signals1[0]==1'b0)
                        begin//indirect
                            R1_control_signals1[10:8] =3'b100;
                            R1_control_signals1[1] = 1'b1;
                            R0_control_signals1[19:17] =3'b010;
                            R0_control_signals1[4] = 1'b1;
                            R2_control_signals1[13:11]=3'b001;
                            R2_control_signals1[2] = 1'b1;
                            R3_control_signals1[7:5]=3'b011;
                            R3_control_signals1[0]=1'b1;
                            response_signals1[1] = 1'b1;
                        end
                    end
                endcase
            end

            if(P2_signals[0]==1'b1) //iterating all cases of P2
            begin
                case(P2_signals[2:1])
                    2'b00: //2 to 0
                    begin
                        if(path_free_bits[17]==1'b1 && R2_control_signals1[3]==1'b0 && R0_control_signals1[0]==1'b0)
                        begin//direct
                            R2_control_signals1[16:14] = 3'b100;
                            R2_control_signals1[3] = 1'b1; 
                            R0_control_signals1[7:5] = 3'b000;
                            R0_control_signals1[0] = 1'b1;
                            response_signals1[2] = 1'b1;
                        end
                        else if (path_free_bits[18]==1'b1 && R2_control_signals1[2]==1'b0 && R1_control_signals1[1]==1'b0 && R3_control_signals1[3]==1'b0 && R0_control_signals1[0]==1'b0)
                        begin //indirect
                            
                            R2_control_signals1[13:11] =3'b100;
                            R2_control_signals1[2] = 1'b1; 
                            R3_control_signals1[16:14]=3'b011;
                            R3_control_signals1[3] = 1'b1; 
                            R1_control_signals1[10:8]=3'b000;
                            R1_control_signals1[1]=1'b1; 
                            R0_control_signals1[7:5] = 3'b010;
                            R0_control_signals1[0] = 1'b1;
                            response_signals1[2] = 1'b1;
                        end
                    end
                    2'b01://2 to 1
                    begin// modified swapping of 19 and 20
                        if(path_free_bits[20]==1'b1 && R2_control_signals1[2]==1'b0 && R1_control_signals1[0]==1'b0 && R3_control_signals1[3]==1'b0)
                        begin//2-3-1
                            R2_control_signals1[13:11] =3'b100;
                            R2_control_signals1[2] = 1'b1;
                            R3_control_signals1[16:14]=3'b011;
                            R3_control_signals1[3] = 1'b1; 
                            R1_control_signals1[7:5]=3'b000;
                            R1_control_signals1[0] = 1'b1;
                            response_signals1[2] = 1'b1;
                        end
                        else if(path_free_bits[19]==1'b1 && R2_control_signals1[3]==1'b0 && R0_control_signals1[2]==1'b0 && R1_control_signals1[0]==1'b0)
                        begin//2-0-1
                            R2_control_signals1[16:14] = 3'b100;
                            R2_control_signals1[3] = 1'b1; 
                            R0_control_signals1[13:11] = 3'b000;
                            R0_control_signals1[2] = 1'b1;
                            R1_control_signals1[7:5]=3'b011;
                            R1_control_signals1[0] = 1'b1;
                            response_signals1[2] = 1'b1;
                        end
                    end
                    2'b10://2 to 2
                    begin
                        if(path_free_bits[14]==1'b1 && R2_control_signals1[0]==1'b0)
                        begin
                            R2_control_signals1[7:5] =3'b100; //R2 from processor to processor
                            R2_control_signals1[0] = 1'b1; //processor is active
                            response_signals1[2] = 1'b1;
                        end
                    end
                    2'b11: //from 2 to 3
                    begin
                        if(path_free_bits[15]==1'b1 && R2_control_signals1[2]==1'b0 && R3_control_signals1[0]==1'b0)
                        begin//direct
                            R2_control_signals1[13:11] =3'b100;//R2 from processor to east
                            R2_control_signals1[2] = 1'b1;//east is active
                            R3_control_signals1[7:5]=3'b011;//R3 from west to processor
                            R3_control_signals1[0] = 1'b1;//processor is active
                            response_signals1[2] = 1'b1;
                        end
                        else if(path_free_bits[16]==1'b1 && R2_control_signals1[3] == 1'b0 && R0_control_signals1[2] ==1'b0 && R1_control_signals1[4] ==1'b0 && R3_control_signals1[0] ==1'b0)
                        begin//indirect
                            R2_control_signals1[16:14] =3'b100;//from R2 processor to south
                            R2_control_signals1[3] = 1'b1; //south is active
                            R0_control_signals1[13:11]=3'b000; //from R0 north to east
                            R0_control_signals1[2] = 1'b1;// east is active
                            R1_control_signals1[19:17]=3'b011;//from R1 west to north
                            R1_control_signals1[4]=1'b1;//north is active
                            R3_control_signals1[7:5]=3'b001;//from R3 south to processor
                            R3_control_signals1[0] = 1'b1;//processor is active
                            response_signals1[2] = 1'b1;
                        end
                    end
                endcase
            end

            if(P3_signals[0]==1'b1) //iterating all cases of P3
            begin
                case(P3_signals[2:1])
                    2'b00://3 to 0
                    begin
                        if(path_free_bits[26]==1'b1 && R3_control_signals1[3] ==1'b0 && R1_control_signals1[1] ==1'b0 && R0_control_signals1[0] ==1'b0)
                        begin //3-1-0
                            R3_control_signals1[16:14]=3'b100;
                            R3_control_signals1[3] = 1'b1;
                            R1_control_signals1[10:8] =3'b000;
                            R1_control_signals1[1] = 1'b1;
                            R0_control_signals1[7:5]=3'b010;
                            R0_control_signals1[0] = 1'b1;
                            response_signals1[3] = 1'b1;
                        end
                        else if(path_free_bits[27]==1'b1 && R3_control_signals1[1] ==1'b0 && R2_control_signals1[3] ==1'b0 && R0_control_signals1[0] ==1'b0)
                        begin//3-2-0
                            R3_control_signals1[10:8] =3'b100;
                            R3_control_signals1[1] = 1'b1;
                            R2_control_signals1[16:14] = 3'b010;
                            R2_control_signals1[3] = 1'b1;
                            R0_control_signals1[7:5]=3'b000;
                            R0_control_signals1[0] = 1'b1;
                            response_signals1[3] = 1'b1;
                        end
                    end
                    2'b01://3 to 1
                    begin
                        if(path_free_bits[24]==1'b1 && R3_control_signals1[3] ==1'b0 && R1_control_signals1[0] ==1'b0)
                        begin//direct
                            R3_control_signals1[16:14] =3'b100;
                            R3_control_signals1[3] = 1'b1;
                            R1_control_signals1[7:5]=3'b000;
                            R1_control_signals1[0]=1'b1;
                            response_signals1[3] = 1'b1;
                        end
                        else if(path_free_bits[25]==1'b1 && R3_control_signals1[1] == 1'b0 && R2_control_signals1[3] ==1'b0 && R0_control_signals1[2] ==1'b0 && R1_control_signals1[0] ==1'b0)
                        begin//indirect
                            R3_control_signals1[10:8] =3'b100;
                            R3_control_signals1[1] = 1'b1;
                            R2_control_signals1[16:14] =3'b010;
                            R2_control_signals1[3] = 1'b1;
                            R0_control_signals1[13:11]=3'b000;
                            R0_control_signals1[2] = 1'b1;
                            R1_control_signals1[7:5]=3'b011;
                            R1_control_signals1[0]=1'b1;
                            response_signals1[3] = 1'b1;
                        end
                    end
                    2'b10://3 to 2
                    begin
                        if(path_free_bits[22]==1'b1 && R3_control_signals1[1]==1'b0 && R2_control_signals1[0] ==1'b0)
                        begin//direct
                            R3_control_signals1[10:8]=3'b100;
                            R3_control_signals1[1] = 1'b1; 
                            R2_control_signals1[7:5]=3'b010;
                            R2_control_signals1[0]=1'b1;
                            response_signals1[3] = 1'b1;
                        end
                        else if(path_free_bits[23]==1'b1 && R3_control_signals1[3] ==1'b0 && R1_control_signals1[1] ==1'b0 && R0_control_signals1[4] ==1'b0 && R2_control_signals1[0]==1'b0)
                        begin//indirect
                            R3_control_signals1[16:14]=3'b100;
                            R3_control_signals1[3] = 1'b1;
                            R1_control_signals1[10:8] =3'b000; //R1 from North to west
                            R1_control_signals1[1] = 1'b1; //west is active
                            R0_control_signals1[19:17]=3'b010; //R0 from east to north 
                            R0_control_signals1[4] = 1'b1;//north is active
                            R2_control_signals1[7:5]=3'b001;//R2 from south to processor
                            R2_control_signals1[0]=1'b1;//processor is active
                            response_signals1[3] = 1'b1;
                        end
                    end
                    2'b11: //3 to 3
                    begin
                        if(path_free_bits[21]==1'b1 && R3_control_signals1[0]==1'b0)
                        begin
                            R3_control_signals1[7:5] =3'b100; //R3 from processor to processor
                            R3_control_signals1[0] = 1'b1; //processor is active
                            response_signals1[3] = 1'b1;
                        end
                    end
                endcase
            end
        end
    end

    //  Passing path blocking signals for further computation to mesh
    assign temp_path_block_signals = ~{R3_control_signals1[4:0],R2_control_signals1[4:0],R1_control_signals1[4:0],R0_control_signals1[4:0]}; 
endmodule

// End of the module

// Animesh ki kichri

    // //For router, if control_signals1 north is high, synchronously update value for north of control_signal
    // always@(posedge R0_control_signals1[4]) 
    // begin
    //         R0_control_signals[4] <= 1'b1;
    // end
    // always@(posedge R1_control_signals1[4])
    // begin
    //         R1_control_signals[4] <= 1'b1;
    // end
    // always@(posedge R2_control_signals1[4])
    // begin
    //         R2_control_signals[4] <= 1'b1;
    // end
    // always@(posedge R3_control_signals1[4])
    // begin
    //         R3_control_signals[4] <= 1'b1;
    // end

    // // For router, if control_signals1 south is high, synchronously update value for south of control_signal

    // always@(posedge R0_control_signals1[3])
    // begin
    //         R0_control_signals[3] <= 1'b1;
    // end
    // always@(posedge R1_control_signals1[3])
    // begin
    //         R1_control_signals[3] <= 1'b1;
    // end
    // always@(posedge R2_control_signals1[3])
    // begin
    //         R2_control_signals[3] <= 1'b1;
    // end
    // always@(posedge R3_control_signals1[3])
    // begin
    //         R3_control_signals[3] <= 1'b1;
    // end

    // // For router, if control_signals1 east is high, synchronously update value for east of control_signal

    // always@(posedge R0_control_signals1[2])
    // begin
    //         R0_control_signals[2] <= 1'b1;
    // end
    // always@(posedge R1_control_signals1[2])
    // begin
    //         R1_control_signals[2] <= 1'b1;
    // end
    // always@(posedge R2_control_signals1[2])
    // begin
    //         R2_control_signals[2] <= 1'b1;
    // end
    // always@(posedge R3_control_signals1[2])
    // begin
    //         R3_control_signals[2] <= 1'b1;
    // end

    // //For router, if control_signals1 west is high, synchronously update value for west of control_signal

    // always@(posedge R0_control_signals1[1])
    // begin
    //         R0_control_signals[1] <= 1'b1;
    // end
    // always@(posedge R1_control_signals1[1])
    // begin
    //         R1_control_signals[1] <= 1'b1;
    // end
    // always@(posedge R2_control_signals1[1])
    // begin
    //         R2_control_signals[1] <= 1'b1;
    // end
    // always@(posedge R3_control_signals1[1])
    // begin
    //         R3_control_signals[1] <= 1'b1;
    // end

    // // For router, if control_signals1 processor is high, synchronously update value for processor of control_signal

    // always@(posedge R0_control_signals1[0])
    // begin
    //         R0_control_signals[0] <= 1'b1;
    // end
    // always@(posedge R1_control_signals1[0])
    // begin
    //         R1_control_signals[0] <= 1'b1;
    // end
    // always@(posedge R2_control_signals1[0])
    // begin
    //         R2_control_signals[0] <= 1'b1;
    // end
    // always@(posedge R3_control_signals1[0])
    // begin
    //         R3_control_signals[0] <= 1'b1;
    // end
// End of the file
