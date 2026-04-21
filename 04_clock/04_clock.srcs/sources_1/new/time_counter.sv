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
    input logic [5:0] right_value,
    input logic [4:0] left_value,
    input logic enable_counter,
    output logic [5:0] right_value_out,
    output logic [4:0] left_value_out
    );
    logic [32:0] timing_count = 33'd6000000000; // 6 billion counts for 1 minute at 100 MHz
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            timing_count <= 33'd6000000000; // reset the count for the next minute
            right_value_out <= 0;
            left_value_out <= 0;
        end else if (enable_counter) begin
            if (timing_count == 0) begin
                timing_count <= 33'd6000000000; // reset the count for the next minute
                if(right_value == 6'd59) begin
                    right_value_out <= 0;
                    if(left_value == 5'd23) left_value_out <= 0;
                    else left_value_out <= left_value + 1;
                end else begin
                    right_value_out <= right_value + 1;
                    left_value_out <= left_value;
                end
            end else begin
                timing_count <= timing_count - 1;
                right_value_out <= right_value;
                left_value_out <= left_value;
            end
        end else begin
            timing_count <= 33'd6000000000; // reset the count when not enabled
            right_value_out <= right_value;
            left_value_out <= left_value;
        end
    end
endmodule
