`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2026 02:42:57 AM
// Design Name: 
// Module Name: display_mux
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

import seven_seg_pkg::*;
import timer_states_pkg::*;

module display_mux(
    input logic [5:0] right_value,
    input logic [6:0] left_value,
    input logic show_min,
    input logic show_hours,
    input logic [1:0] activate,
    input state_t state,
    input logic mode, // 1 for stopwatch, 0 for timer
    output logic [3:0] an,
    output logic [6:0] c
    );
        // ****** Combinational Logic for 7-Segment Display *******
    logic [3:0] digits [3:0];
    always_comb begin
        digits[0] = right_value % 10;
        digits[1] = right_value / 10;
        digits[2] = left_value % 10;
        digits[3] = left_value / 10;
        if(state == SET_MODE) begin
            if (mode == 1'b0) begin
                digits[0] = 11; // display "t" for timer
                digits[1] = 11; // blank
                digits[2] = 11; // blank
                digits[3] = 11; // blank
            end else begin
                digits[0] = 10; // display "S" for stopwatch
                digits[1] = 10; // display "t" for stopwatch
                digits[2] = 10; // blank
                digits[3] = 10; // blank
            end
        end
        case (activate)
            2'b00: begin
                c = num_to_display(digits[0]); 
                an = (show_min) ? 4'b1110 : 4'b1111;
            end

            2'b01: begin
                c = num_to_display(digits[1]); 
                an = (show_min) ? 4'b1101 : 4'b1111;
            end

            2'b10: begin
                 c = num_to_display(digits[2]);
                an = (show_hours) ? 4'b1011 : 4'b1111;
            end

            2'b11: begin
                 c = num_to_display(digits[3]);
                an = (show_hours) ? 4'b0111 : 4'b1111;
            end
        endcase
    end
    // *******************************************************
endmodule
