/*
Module name: 
    Processing_unit
Module Description:
    This Module contains demonstrates the working of our processor.
Pin Description:
    Clock: 1 bit input port for the clock signal.
    Reset: 1 bit input port for the reset signal.
    master_response: 1 bit input which shows the availability of processor (1->Master has accepted the request of processor)
    data_from_router: 9bit input reg which contains the data received from the router to its corresponding processor. [8] ->last flit
    data_to_router: 9bit output reg which contains the data processor sends to its corresponding router. [8] ->last flit
    request_transfer: 1bit output where processor requests master for allocation (1->request is high)
    which_processor: 2 bit output register corresponding to the destination router/processor
    processor_ready: 1 bit output indicates the processor is free to send out data
    tb_request: 1 bit input which is the value user gives to processor to use as request_transfer
    tb_processor: 2 bit output reg is the value user gives to processor to use as which_processor
    tb_len: 8 bit output reg is the value user gives to processor the burst size/number of packets (essentially the 8bit data we are using)
*/

module Processing_unit(
    input clock,
    input reset,
    input master_response,
    input [8:0] data_from_router,
    output reg[8:0] data_to_router,
    output reg request_transfer,
    output reg [1:0] which_processor,
    output processor_ready,
    input tb_request,
    input [1:0] tb_processor,
    input [7:0] tb_len
);

//variables

//To check a valid request
    reg request_line;
//Temorarily stores value of processor_ready till clockedge
    reg processor_ready1;

//Keeps a note of packets received
    reg [7:0]counter_value;
//Keeps a note of packets received temporarily till clockedge
    reg [7:0]counter_value1;

//  Checks whether last bit or no  
    reg tlast;

//a variable that is a copy of tlast one clockcycle prior
    reg tlast_prev;

//temporily stores value of tlast till clockedge
    reg tlast1;

    always@(*)
    begin
        request_line=tb_request & processor_ready1; //high only when processor is free and user has asked for a request transfer from processor
    end

    always@(*)
    begin
        if(reset==1'b1)
        begin
            request_transfer<=1'b0; //if reset all requests are null and void
            which_processor<=2'b00; //set destination processor to default
        end
        else
        begin
            request_transfer<=request_line; //else raise request_transfer if a valid request 
            which_processor<=tb_processor; //and set which_processor according to the destination the user has set 
        end
    end

    always@(posedge clock or posedge reset)
    begin
        if(reset==1'b1)
        begin
            tlast_prev<=1'b0; //if reset, no data, therefore definitely not the last bit
        end
        else
        begin
            tlast_prev<=tlast; //assign tlast which checks whether last element or not 
            //tlast_prev is assigned 1 clock cycle after tlast is evaluated and assigned
        end
    end

    always@(*)
    begin
        if(reset==1'b1)
        begin
            processor_ready1=1'b1; //if reset, evidently processor is free to transmit
        end
        else if(master_response==1'b1)
        begin
            processor_ready1=1'b0; //if master commands to utilise processor, it is no more free to transmit
        end
        else if(tlast_prev==1'b1)
        begin
            processor_ready1=1'b1; //if the last packet of data is sent, now processor is again free
        end
    end

    //set the values of processor_ready
    assign processor_ready=processor_ready1;
    //processor_ready is in 1 clock cycle lag as tlast_prev is assigned 1 clock cycle after tlast is evaluated and assigned

    always@(*)
    begin
        if(reset==1'b1)
        begin
            tlast1=1'b0; //if reset, no data, therefore definitely not the last bit
        end
        else if(counter_value1==tb_len)
        begin
            tlast1=1'b1; //if the number of packets to be sent are transmitted (counter = tb_len) it means it is the last packets so raise tlast to 1  
        end
        else
        begin
            tlast1=1'b0; //else continue with 0 as either it is in middle of transfer of no transfer atall, so no last flit
        end
    end

    always@(posedge clock or posedge reset)
    begin
        if(reset==1'b1)
        begin
            tlast<=1'b0; //if reset, no data, therefore definitely not the last bit
        end
        else
        begin
            tlast<=tlast1; //assign values as computed above
        end
    end

    always@(*)
    begin
        if(request_line==1 || counter_value==8'b11111111) 
        begin
            counter_value1=8'b00000001; //if new request or overflow start counter from 1
        end
        else 
        begin
            counter_value1=counter_value+1; //else increment counter by 1
        end
    end

    always@(posedge clock or posedge reset) //next packet at clockedge
    begin
        if(reset==1'b1)
        begin
            counter_value<=8'b00000001; //if reset, restart from 1
        end
        else
        begin
            counter_value<=counter_value1; //else assign the value obtained from computation shown above
        end
    end

    always@(posedge clock or posedge reset)
    begin
        if(reset==1'b1)
        begin
            data_to_router<=9'b0; //if it was a reset, send 0 as output
        end
        else
        begin
            data_to_router<={tlast,counter_value[7:0]}; //else concatenate the last flit with counter value
        end
    end

endmodule

    // output reg processor_ready, in module

    // reg tlast_prev_2;
                // tlast_prev_2<=1'b0;
                        // else if(tlast_prev_2==1'b1)

            // tlast_prev_2<=tlast_prev;


    // always@(posedge clock or posedge reset)
    // begin
    //     if(reset==1'b1)
    //     begin
    //         request_transfer<=0;
    //         which_processor<=2'b00;
    //     end
    //     else if(master_response==1'b0)
    //     begin
    //         request_transfer<=request_line;
    //         which_processor<=tb_processor;
    //     end
    //     else
    //     begin
    //         request_transfer<=0;
    //         which_processor<=2'b00;
    //     end
    // end


    // always@(posedge clock or posedge reset)
    // begin
    //     if (reset==1'b1)
    //     begin
    //         processor_ready<=1;
    //     end
    //     else
    //     begin
    //         processor_ready<=processor_ready1;
    //     end
    // end
