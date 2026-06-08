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

module clock #(
    parameter int CLK_DIV = 1000000,
    parameter int COUNT_MAX = 1000000, // 10 ms debounce at 100 MHz
    parameter int DISPLAY_REFRESH_COUNT = 50000000 // 50 ms refresh at 100 MHz
    )(
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
    logic tick;

    blink_display #(.REFRESH_COUNT(DISPLAY_REFRESH_COUNT)) blnk(.clk (clk), .rst (rst), .blink (blink));
    toggle t1(.clk (clk), .rst (rst), .activate (activate));
    state_t state = SET_MINUTES;
    assign dp = 1'b1; // decimal point off

    debounce #(.COUNT_MAX(COUNT_MAX)) db1(.clk (clk), .rst (rst), .btn (btnU), .clean (btnU_c));
    debounce #(.COUNT_MAX(COUNT_MAX)) db2(.clk (clk), .rst (rst), .btn (btnD), .clean (btnD_c));
    debounce #(.COUNT_MAX(COUNT_MAX)) db3(.clk (clk), .rst (rst), .btn (btnL), .clean (btnL_c));
    debounce #(.COUNT_MAX(COUNT_MAX)) db4(.clk (clk), .rst (rst), .btn (btnR), .clean (btnR_c));

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
        .tick (tick),
        .state (state),
        .right_value (right_value),
        .left_value (left_value)
    );

    time_counter #(
        .ONE_MINUTE_COUNT(CLK_DIV * 60) // 1 minute at the given clock frequency
    ) tc (
        .clk (clk),
        .rst (rst),
        .enable_counter (state == DISPLAY),
        .tick (tick)
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
