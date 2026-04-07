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

module toggle(
    input logic clk,
    input logic rst,
    output logic [1:0] activate
);
    logic [15:0] refresh_count;
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            refresh_count <= 0;
        end else begin
            refresh_count <= refresh_count + 1;
        end
    end
    assign activate = refresh_count[15:14];
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
    logic [1:0] activate = 2'b00;
    logic edit_left_pair = 0;
    logic initial_value = 4'd0;
    logic [5:0] right_value;
    logic [4:0] left_value;
    logic [3:0] digits [3:0];
    blink_display(.clk (clk), .rst (rst), .blink (blink));

    assign dp = 1'b1;        // decimal point OFF
    toggle(.clk (clk), .rst (rst), .activate (activate));
    always_comb begin
        digits[0] = right_value % 10;
        digits[1] = right_value / 10;
        digits[2] = left_value % 10;
        digits[3] = left_value / 10;
        
        case (activate)
            2'b00: begin
                c = num_to_display(digits[0]); 
                an = (!edit_left_pair && !blink) ? 4'b1111 : 4'b1110;
            end

            2'b01: begin
                c = num_to_display(digits[1]); 
                an = (!edit_left_pair && !blink) ? 4'b1111 : 4'b1101;
            end

            2'b10: begin
                 c = num_to_display(digits[2]);
                an = (edit_left_pair && !blink) ? 4'b1111 : 4'b1011;
            end

            2'b11: begin
                 c = num_to_display(digits[3]);
                an = (edit_left_pair && !blink) ? 4'b1111 : 4'b0111;
            end
        endcase
    end
    logic btnU_c;
    logic btnD_c;
    
    debounce db1(.clk (clk), .btn (btnU), .clean (btnU_c));
    debounce db2(.clk (clk), .btn (btnD), .clean (btnD_c));
    logic btnU_prev;
    logic btnD_prev;
    logic btnR_prev;
    logic btnL_prev;

    always_ff @(posedge rst or posedge clk) begin
        if(rst) begin 
            edit_left_pair <= 0;  
        end else begin
                btnU_prev <= btnU_c;
                btnD_prev <= btnD_c;
                btnR_prev <= btnR;
                btnL_prev <= btnL;
                if(btnL && !btnL_prev) begin
                    edit_left_pair <= 1;
                    //c <= num_to_display(initial_value);
                end 
                else if(btnR && !btnR_prev) begin
                    edit_left_pair <= 0;    
                    //c <= num_to_display(initial_value); 
                end
                else if (btnD_c && !btnD_prev) begin
                    if (edit_left_pair) begin
                        if(left_value > 0) begin
                            left_value <= left_value - 1;
                        end
                        else begin
                            left_value <= 23;
                        end
                    end
                    else begin
                        if(right_value > 0) begin
                            right_value <= right_value - 1;
                        end
                        else begin
                            right_value <= 59;
                        end
                    end
                end
                else if (btnU_c && !btnU_prev) begin
                     if (edit_left_pair) begin
                        if(left_value < 23) begin
                            left_value <= left_value + 1;
                        end
                        else begin
                            left_value <= 0;
                        end
                    end
                    else begin
                        if(right_value < 59) begin
                            right_value <= right_value + 1;
                        end
                        else begin
                            right_value <= 0;
                        end
                    end
                end
            end
        end
endmodule