`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2026 11:32:39 PM
// Design Name: 
// Module Name: clock
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

module clock(
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

    typedef enum logic [1:0] {
        SET_MINUTES,
        SET_HOURS,
        DISPLAY
    } state_t;

    logic show_min = 1'b1;
    logic show_hours = 1'b1;
    logic blink = 1'b1;
    logic [1:0] activate = 2'b00;
    logic [5:0] right_value;
    logic [4:0] left_value;
    logic [3:0] digits [3:0];
    blink_display(.clk (clk), .rst (rst), .blink (blink));
    toggle t1(.clk (clk), .rst (rst), .activate (activate));
    state_t state;

// ****** State Register ********
    always_comb begin
        case (state)
            SET_MINUTES: begin
                show_min = blink;
                show_hours = 1'b1;
            end

            SET_HOURS: begin
                show_min = 1'b1;
                show_hours = blink;
            end

            DISPLAY: begin
                show_min = 1'b1;
                show_hours = 1'b1;
            end
        endcase
    end
// *******************************
   
    debounce db1(.clk (clk), .btn (btnU), .clean (btnU_c));
    debounce db2(.clk (clk), .btn (btnD), .clean (btnD_c));
    debounce db3(.clk (clk), .btn (btnL), .clean (btnL_c));
    debounce db4(.clk (clk), .btn (btnR), .clean (btnR_c));

    logic btnU_prev;
    logic btnD_prev;
    logic btnR_prev;
    logic btnL_prev;

    always_ff @(posedge rst or posedge clk) begin
        if(rst) begin 
            state <= SET_MINUTES;
            left_value <= 0;
            right_value <= 0;
        end else begin
                btnU_prev <= btnU_c;
                btnD_prev <= btnD_c;
                btnR_prev <= btnR_c;
                btnL_prev <= btnL_c;

                // ****** Next State Logic and Data Updates ******
                case (state) 
                    SET_MINUTES: begin
                        if(btnU_c && !btnU_prev) begin
                            if(right_value == 6'd59) right_value <= 0;
                            else right_value <= right_value + 1;
                        end else if(btnD_c && !btnD_prev) begin
                            if(right_value == 0) right_value <= 6'd59;
                            else right_value <= right_value - 1;
                        end else if(btnL_c && !btnL_prev) begin
                            state <= SET_HOURS;
                        end
                    end

                    SET_HOURS: begin
                        if(btnU_c && !btnU_prev) begin
                            if(left_value == 5'd23) left_value <= 0;
                            else left_value <= left_value + 1;
                        end else if(btnD_c && !btnD_prev) begin
                            if(left_value == 0) left_value <= 5'd23;
                            else left_value <= left_value - 1;
                        end else if(btnL_c && !btnL_prev) begin
                            state <= DISPLAY;
                        end else if(btnR_c && !btnR_prev) begin
                            state <= SET_MINUTES;
                        end
                    end

                    DISPLAY: begin
                        if(btnL_c && !btnL_prev) begin
                            state <= SET_MINUTES;
                        end
                    end
                endcase
                // ***********************************************
            end
    end
    // ****** Combinational Logic for 7-Segment Display *******
    always_comb begin
        digits[0] = right_value % 10;
        digits[1] = right_value / 10;
        digits[2] = left_value % 10;
        digits[3] = left_value / 10;
        
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
