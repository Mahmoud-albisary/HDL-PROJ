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

module num_to_display(
    input logic num[3:0];
    output logic display[6:0];
)
    case(num)
        4'd0: display = 7'b1000000;  
        4'd1: display = 7'b1111001;  
        4'd2: display = 7'b0100100;  
        4'd3: display = 7'b0110000;  
        4'd4: display = 7'b0011001;  
        4'd5: display = 7'b0010010;  
        4'd6: display = 7'b0000010;  
        4'd7: display = 7'b1111000;  
        4'd8: display = 7'b0000000;  
        4'd9: display = 7'b0010000;
endmodule

module segment_display(
    output logic [3:0] an ,
    output logic [6:0] c ,
    output logic dp
    );
    always_comb begin
        an = 4'b0000;     // enable all displays
        c  = 7'b1000000;  // pattern for "0" for all displays
        dp = 1'b0;        // decimal point ON

    end
endmodule