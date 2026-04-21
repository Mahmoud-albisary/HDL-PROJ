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
import state_types_pkg::*;

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

    logic btnU_c, btnD_c, btnR_c, btnL_c;
    logic show_min = 1'b1;
    logic show_hours = 1'b1;
    logic blink = 1'b1;
    logic [1:0] activate = 2'b00;
    logic [5:0] right_value;
    logic [4:0] left_value;
    logic [5:0] tc_right_value;
    logic [4:0] tc_left_value;

    blink_display(.clk (clk), .rst (rst), .blink (blink));
    toggle t1(.clk (clk), .rst (rst), .activate (activate));
    state_t state = SET_MINUTES;
    assign dp = 1'b1; // decimal point off

    debounce db1(.clk (clk), .btn (btnU), .clean (btnU_c));
    debounce db2(.clk (clk), .btn (btnD), .clean (btnD_c));
    debounce db3(.clk (clk), .btn (btnL), .clean (btnL_c));
    debounce db4(.clk (clk), .btn (btnR), .clean (btnR_c));

// ****** State Register ********
    always_comb begin
        show_min = 1'b1;
        show_hours = 1'b1;
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
    update_state_data up(
        .clk (clk),
        .rst (rst),
        .btnU_c (btnU_c),
        .btnD_c (btnD_c),
        .btnL_c (btnL_c),
        .btnR_c (btnR_c),
        .tc_right_value (tc_right_value),
        .tc_left_value (tc_left_value),
        .state (state),
        .right_value (right_value),
        .left_value (left_value)
    );

    time_counter tc(
        .clk (clk),
        .rst (rst),
        .right_value (right_value),
        .left_value (left_value),
        .enable_counter (state == DISPLAY),
        .right_value_out (tc_right_value),
        .left_value_out (tc_left_value)
    );

    display_mux dm(
        .right_value (right_value),
        .left_value (left_value),
        .show_min (show_min),
        .show_hours (show_hours),
        .activate (activate),
        .an (an),
        .c (c)
    );

endmodule
