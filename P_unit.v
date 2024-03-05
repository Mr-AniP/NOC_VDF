module Processing_unit(
    input clock,
    input reset,
    input master_response,
    input [8:0] data_from_router,
    output reg[8:0] data_to_router,
    output request_transfer,
    output [1:0] which_processor;
    output processor_ready,
    input tb_request,
    input [1:0] tb_processor,
    input [7:0] tb_len;
);
    wire request_line;
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
    always@(posedge clock)
    begin
        if(master_response==1'b1)
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
            tlast<=1;
        end
        else
        begin
            tlast<=0;
        end
    end
    always@(posedge clock or posedge reset)
    begin
        if(reset==1'b1)
        begin
            counter_value<=8'b0;
        end
        else if(request_line==1)
        begin
            counter_value<=8'b0;
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
    // always@(negedge request_transfer)
    // begin
    //     // set data
    //     data_to_router<=0;
    // end
endmodule