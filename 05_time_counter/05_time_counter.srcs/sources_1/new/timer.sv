`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2026 06:44:39 PM
// Design Name: 
// Module Name: timer
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

import timer_states_pkg::*;

module timer #(
    parameter int unsigned CLK_DIV = 100_000_000,
    parameter int COUNT_MAX = 1_000_000,
    parameter int unsigned DISPLAY_REFRESH_COUNT = 50_000_000,
    parameter int REFRESH_BITS_HIGH = 15,
    parameter int REFRESH_BITS_LOW = 14
)(
    input logic clk,
    input logic rst,
    input logic btnU,
    input logic btnD,
    input logic btnR,
    input logic btnL,
    output logic [3:0] an,
    output logic [6:0] c
    );
    logic btnU_c, btnD_c, btnR_c, btnL_c;
    logic [5:0] right_value;
    logic [6:0] left_value;
    logic [1:0] activate;
    logic show_sec = 1'b1;
    logic show_min = 1'b1;
    logic blink = 1'b1;
    logic tick;
    logic mode;

    blink_display #(.REFRESH_COUNT(DISPLAY_REFRESH_COUNT)) blnk(
        .clk (clk), .rst (rst), .blink (blink)
    );
    toggle #(
        .REFRESH_BITS_HIGH(REFRESH_BITS_HIGH),
        .REFRESH_BITS_LOW(REFRESH_BITS_LOW)
    ) t1(.clk (clk), .rst (rst), .activate (activate));
    state_t state = IDLE;
    update_data ud(
        .clk (clk),
        .rst (rst),
        .btnU_c (btnU_c),
        .btnD_c (btnD_c),
        .btnL_c (btnL_c),
        .btnR_c (btnR_c),
        .tick (tick),
        .state (state),
        .right_value (right_value),
        .left_value (left_value),
        .mode (mode)
    );
    update_state us(
        .clk (clk),
        .rst (rst),
        .btnU_c (btnU_c),
        .btnD_c (btnD_c),
        .btnL_c (btnL_c),
        .btnR_c (btnR_c),
        .tick (tick),
        .right_value (right_value),
        .left_value (left_value),
        .mode (mode),
        .state (state)
    );
    timer_counter #(.CLK_DIV(CLK_DIV)) tc(
        .clk (clk),
        .rst (rst),
        .enable_counter (state == RUN),
        .tick (tick)
    );
    display_mux dm(
        .right_value (right_value),
        .left_value (left_value),
        .show_min (show_sec),
        .show_hours (show_min),
        .activate (activate),
        .state (state),
        .mode (mode),
        .an (an),
        .c (c)
    );
    debounce #(.COUNT_MAX(COUNT_MAX)) db1(.clk (clk), .rst (rst), .btn (btnU), .clean (btnU_c));
    debounce #(.COUNT_MAX(COUNT_MAX)) db2(.clk (clk), .rst (rst), .btn (btnD), .clean (btnD_c));
    debounce #(.COUNT_MAX(COUNT_MAX)) db3(.clk (clk), .rst (rst), .btn (btnL), .clean (btnL_c));
    debounce #(.COUNT_MAX(COUNT_MAX)) db4(.clk (clk), .rst (rst), .btn (btnR), .clean (btnR_c));

    always_comb begin
        show_sec = 1'b1;
        show_min = 1'b1;
        case (state)
            IDLE: begin
                show_sec = blink;
                show_min = blink;
            end
            RUN: begin
                show_min = 1'b1;
                show_sec = 1'b1;
            end
            PAUSE: begin
                show_sec = 1'b1;
                show_min = 1'b1;
            end
            SET_MODE: begin
                show_sec = blink;
                show_min = blink;
            end
            SET_SECONDS: begin
                show_sec = blink;
                show_min = 1'b1;
            end
            SET_MINUTES: begin
                show_sec = 1'b1;
                show_min = blink;
            end
            DONE: begin
                show_sec = blink;
                show_min = blink;
            end
        endcase
    end
endmodule
