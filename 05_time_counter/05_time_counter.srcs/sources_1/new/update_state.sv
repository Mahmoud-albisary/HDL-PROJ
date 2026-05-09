`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2026 12:57:21 AM
// Design Name: 
// Module Name: update_state
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


module update_state(
    input logic clk,
    input logic rst,
    input logic btnU_c,
    input logic btnD_c,
    input logic btnL_c,
    input logic btnR_c,
    input logic tick,
    output state_t state
);      

    logic btnU_prev;
    logic btnD_prev;
    logic btnR_prev;
    logic btnL_prev;
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin 
            btnU_prev <= 1'd0;
            btnD_prev <= 1'd0;
            btnR_prev <= 1'd0;
            btnL_prev <= 1'd0;
            state <= IDLE;
        end else begin
                btnU_prev <= btnU_c;
                btnD_prev <= btnD_c;
                btnR_prev <= btnR_c;
                btnL_prev <= btnL_c;
                case (state) 
                    IDLE: begin
                        if(btnR_c && !btnR_prev) begin
                            state <= SET_MODE;
                        end
                    end

                    SET_MODE: begin
                        if(btnR_c && !btnR_prev) begin
                            state <= SET_MINUTES;
                        end else if(btnL_c && !btnL_prev) begin
                            state <= IDLE;
                        end
                    end
                    
                    SET_MINUTES: begin
                        if(btnR_c && !btnR_prev) begin
                            state <= SET_SECONDS;
                        end else if(btnL_c && !btnL_prev) begin
                            state <= SET_MODE;
                        end
                    end

                    SET_SECONDS: begin
                        if(btnR_c && !btnR_prev) begin
                            state <= RUN;
                        end else if(btnL_c && !btnL_prev) begin
                            state <= SET_MINUTES;
                        end
                    end

                    RUN: begin
                            if(btnL_c && !btnL_prev) begin
                                state <= PAUSE;
                            end
                        end

                    PAUSE: begin
                            if(btnR_c && !btnR_prev) begin
                                state <= RUN;
                            end else if(btnL_c && !btnL_prev) begin
                                state <= IDLE;
                            end
                        end

                    DONE: begin
                            if(btnR_c && !btnR_prev) begin
                                state <= SET_MINUTES;
                            end else if(btnL_c && !btnL_prev) begin
                                state <= IDLE;
                            end
                        end
                endcase
        end
    end
endmodule
