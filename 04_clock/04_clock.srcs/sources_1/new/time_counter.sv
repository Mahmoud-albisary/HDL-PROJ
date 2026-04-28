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


module time_counter(
    input logic clk,
    input logic rst,
    input logic enable_counter,
    output logic tick
    );
    logic [32:0] timing_count = 33'd6000000000; // 6 billion counts for 1 minute at 100 MHz
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            timing_count <= 33'd6000000000 - 1; // reset the count for the next minute
            tick <= 1'b0; // clear the tick on reset
        end else if (enable_counter) begin // Check if we are on the DISPLAY state
            if (timing_count == 0) begin
                timing_count <= 33'd6000000000 - 1; // reset the count for the next minute
                tick <= 1'b1; // generate a tick when the count reaches zero
            end else begin
                timing_count <= timing_count - 1;
                tick <= 1'b0; // clear tick while counting
            end
        end else begin
            timing_count <= 33'd6000000000 - 1; // reset the count when not enabled
            tick <= 1'b0; // clear the tick when not counting
        end
    end
endmodule
