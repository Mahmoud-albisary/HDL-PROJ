`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2026 12:08:58 AM
// Design Name: 
// Module Name: timer_counter
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


module timer_counter #(
    parameter int unsigned CLK_DIV = 100_000_000
)(
    input logic clk,
    input logic rst,
    input logic enable_counter,
    output logic tick
    );
    localparam int COUNT_WIDTH = (CLK_DIV > 1) ? $clog2(CLK_DIV) : 1;
    logic [COUNT_WIDTH-1:0] timing_count = CLK_DIV - 1;
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            timing_count <= CLK_DIV - 1; // reset the count for the next second
            tick <= 1'b0; // clear the tick on reset
        end else if (enable_counter) begin // Count only in RUN
            if (timing_count == 0) begin
                timing_count <= CLK_DIV - 1; // reset the count for the next second
                tick <= 1'b1; // generate a tick when the count reaches zero
            end else begin
                timing_count <= timing_count - 1;
                tick <= 1'b0; // clear tick while counting
            end
        end else begin
            timing_count <= CLK_DIV - 1; // reset the count when not enabled
            tick <= 1'b0; // clear the tick when not counting
        end
    end
endmodule
