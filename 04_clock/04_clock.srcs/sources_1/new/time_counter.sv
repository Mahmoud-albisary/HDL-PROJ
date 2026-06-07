`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2026 02:30:18 AM
// Design Name: 
// Module Name: time_counter
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


module time_counter#(
    localparam int ONE_MINUTE_COUNT = 6000000000 // 6 billion counts for 1 minute at 100 MHz
    )
    (
    input logic clk,
    input logic rst,
    input logic enable_counter,
    output logic tick
    );
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            TIMING_COUNT <= 33'ONE_MINUTE_COUNT - 1; // reset the count for the next minute
            tick <= 1'b0; // clear the tick on reset
        end else if (enable_counter) begin // Check if we are on the DISPLAY state
            if (TIMING_COUNT == 0) begin
                TIMING_COUNT <= 33'ONE_MINUTE_COUNT - 1; // reset the count for the next minute
                tick <= 1'b1; // generate a tick when the count reaches zero
            end else begin
                TIMING_COUNT <= TIMING_COUNT - 1;
                tick <= 1'b0; // clear tick while counting
            end
        end else begin
            TIMING_COUNT <= 33'ONE_MINUTE_COUNT - 1; // reset the count when not enabled
            tick <= 1'b0; // clear the tick when not counting
        end
    end
endmodule
