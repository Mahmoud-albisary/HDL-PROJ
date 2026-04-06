`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/11/2026 10:01:35 PM
// Design Name: 
// Module Name: 7segment_display
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

//The code below shows how to turn on one display for the first two segments
//module segment_display(
//    output logic [3:0] an ,
//    output logic [6:0] c ,
//    output logic dp
//    );
    
//    always_comb begin
//        an = 4'b1110;     // enable digit 0 to enable the first display
//        c  = 7'b1001111;  // pattern for "1" (active low)
//        dp = 1'b1;        // decimal point off
//        //Note in the code above we can see that the segments, decimal point and anodes are active on low (active when 0)
//    end
//endmodule

function automatic logic [6:0] num_to_display(input logic [3:0] num);
    begin
        case(num)
            4'd0: num_to_display = 7'b1000000;
            4'd1: num_to_display = 7'b1111001;
            4'd2: num_to_display = 7'b0100100;
            4'd3: num_to_display = 7'b0110000;
            4'd4: num_to_display = 7'b0011001;
            4'd5: num_to_display = 7'b0010010;
            4'd6: num_to_display = 7'b0000010;
            4'd7: num_to_display = 7'b1111000;
            4'd8: num_to_display = 7'b0000000;
            4'd9: num_to_display = 7'b0010000;
        endcase
    end
endfunction

module blink_display(
    input logic clk, // clock
    input logic rst, // reset
    output logic blink
);
    logic [25:0] count;
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            count <= 26'd0;
            blink <= 1'b1 ;
        end else begin
            if(count == 26'd50000000) begin
                count <= 26'd0;
                blink <= ~blink;
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule

module segment_display(
    input logic clk,
    input logic rst,
    input logic btnU,
    input logic btnD,
    input logic btnR,
    input logic btnL,
    output logic [3:0] an,
    output logic [6:0] c,
    output logic dp
    );
    logic blink = 1'b1;
    logic initial_value = 4'd0;
    blink_display(.clk (clk), .rst (rst), .blink (blink));
    assign an = {2'b00, blink, blink};     
    assign c = num_to_display(initial_value);
    assign dp = 1'b1;        // decimal point OFF
    
//    always_comb begin
//        an = 4'b0000;     // enable all displays
//        c  = 7'b1000000;  // pattern for "0" for all displays
//        dp = 1'b0;        // decimal point ON
//    end
endmodule