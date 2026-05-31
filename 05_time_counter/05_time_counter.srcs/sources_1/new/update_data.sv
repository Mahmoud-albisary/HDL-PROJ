`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2026 01:22:37 AM
// Design Name: 
// Module Name: update_data
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

module update_data(
    input logic clk,
    input logic rst,
    input logic btnU_c,
    input logic btnD_c,
    input logic btnL_c,
    input logic btnR_c,
    input logic tick,
    input state_t state,
    output logic [5:0] right_value,
    output logic [6:0] left_value,
    output logic mode // 1 for stopwatch, 0 for timer
);      

    logic btnU_prev;
    logic btnD_prev;
    logic btnR_prev;
    logic btnL_prev;
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin 
            right_value <= 6'd0;
            left_value <= 7'd0;
            btnU_prev <= 1'd0;
            btnD_prev <= 1'd0;
            btnR_prev <= 1'd0;
            btnL_prev <= 1'd0;
            mode <= 1'b0;
        end else begin
                btnU_prev <= btnU_c;
                btnD_prev <= btnD_c;
                btnR_prev <= btnR_c;
                btnL_prev <= btnL_c;
                case (state) 

                    IDLE: begin
                        right_value <= 6'd0;
                        left_value <= 7'd0;
                        mode <= 1'b0;
                    end

                    SET_MODE: begin
                        if(btnU_c && !btnU_prev) begin
                            mode <= ~mode; // toggle mode on each press
                        end
                    end

                    SET_MINUTES: begin
                        if(btnU_c && !btnU_prev) begin
                            if(left_value == 7'd99) left_value <= 0;
                            else left_value <= left_value + 1;
                        end else if(btnD_c && !btnD_prev) begin
                            if(left_value == 0) left_value <= 7'd99;
                            else left_value <= left_value - 1;
                        end
                    end

                    SET_SECONDS: begin
                        if(btnU_c && !btnU_prev) begin
                            if(right_value == 6'd59) right_value <= 0;
                            else right_value <= right_value + 1;
                        end else if(btnD_c && !btnD_prev) begin
                            if(right_value == 0) right_value <= 6'd59;
                            else right_value <= right_value - 1;
                        end
                    end

                    RUN: begin
                        if(tick) begin
                            if(mode == 1'b0) begin
                                if(right_value == 0) begin
                                    right_value <= 6'd59;
                                    if(left_value == 0) left_value <= 7'd99;
                                    else left_value <= left_value - 1;
                                end else begin
                                    right_value <= right_value - 1;
                                end
                            end else begin
                                if(right_value == 6'd59) begin
                                    right_value <= 0;
                                    if(left_value == 7'd99) left_value <= 0;
                                    else left_value <= left_value + 1;
                                end else begin
                                    right_value <= right_value + 1;
                                end
                            end
                        end
                    end
                endcase
        end
    end
endmodule
