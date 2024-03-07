/*
Module name: 
    Processing_unit
Module Description:
    This Module contains demonstrates the working of our processor.
Pin Description:
    Clock: 1 bit input port for the clock signal.
    Reset: 1 bit input port for the reset signal.
    master_response: 1 bit input which shows the availability of processor (1->Master has accepted the request of processor)
    data_from_router: 9bit input reg which contains the data received from the router to its corresponding processor
    data_to_router: 9bit output reg which contains the data processor sends to its corresponding router
    request_transfer: 1bit output where processor requests master for allocation (1->request is high)
    which_processor: 2 bit output register corresponding to the destination router/processor
    processor_ready: 1 bit output indicates the processor is free to send out data
    tb_request: 1 bit input which is the value user gives to processor to use as request_transfer
    tb_processor: 2 bit output reg is the value user gives to processor to use as which_processor
    tb_len: 8 bit output reg is the value user gives to processor the burst size
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
    reg request_line;
    reg processor_ready1;
    reg [7:0]counter_value;
    reg tlast;
    always@(*)
    begin
        request_line=tb_request & processor_ready1;
    end
    always@(posedge clock or posedge reset)
    begin
        if(reset==1'b1)
        begin
            request_transfer<=0;
            which_processor<=2'b00;
        end
        else
        begin
            request_transfer<=request_line;
            which_processor<=tb_processor;
        end
    end
    always@(posedge clock or posedge reset)
    begin
        if (reset==1'b1)
        begin
            processor_ready1<=1;
        end
        else if(master_response==1'b1)
        begin
            processor_ready1<=0;
        end
        else if(tlast==1)
        begin
            processor_ready1<=1;
        end
    end
    always@(*)
    begin
        if(counter_value==tb_len)
        begin
            tlast=1;
        end
        else
        begin
            tlast=0;
        end
    end
    always@(posedge clock or posedge reset) //next packet
    begin
        if(reset==1'b1)
        begin
            counter_value<=8'b00000001;
        end
        else if(request_line==1)
        begin
            counter_value<=8'b00000001;
        end
        else
        begin
            counter_value<=counter_value+1;
        end
    end
    always@(posedge clock or posedge reset)
    begin
        if(reset==1'b1)
        begin
            data_to_router<=8'b0;
        end
        else
        begin
            data_to_router<={tlast,counter_value[7:0]};
        end
    end
    assign processor_ready=processor_ready1;
endmodule
