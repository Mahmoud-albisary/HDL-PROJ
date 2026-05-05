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


module timer(
    input logic clk,
    input logic rst,
    input logic btnU,
    input logic btnD,
    input logic btnR,
    input logic btnL,
    output logic [3:0] an,
    output logic [6:0] c,
    );
    logic btnU_c, btnD_c, btnR_c, btnL_c;
    logic [5:0] right_value;
    logic [6:0] left_value;
    logic show_sec = 1'b1;
    logic show_min = 1'b1;
    logic blink = 1'b1;
    logic tick;

    blink_display(.clk (clk), .rst (rst), .blink (blink));
    toggle t1(.clk (clk), .rst (rst), .activate (activate));
    state_t state = IDLE;
    assign dp = 1'b1; // decimal point off
    debounce db1(.clk (clk), .btn (btnU), .clean (btnU_c));
    debounce db2(.clk (clk), .btn (btnD), .clean (btnD_c));
    debounce db3(.clk (clk), .btn (btnL), .clean (btnL_c));
    debounce db4(.clk (clk), .btn (btnR), .clean (btnR_c));

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
            SET_SECONDS: begin
                show_sec = 1'b0;
                show_min = 1'b1;
            end
            SET_MINUTES: begin
                show_sec = 1'b1;
                show_min = 1'b0;
            end
            DONE: begin
                show_sec = blink;
                show_min = blink;
            end
        endcase
    end
endmodule
