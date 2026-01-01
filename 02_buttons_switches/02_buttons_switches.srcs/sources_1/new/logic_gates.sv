`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/30/2025 12:26:35 AM
// Design Name: 
// Module Name: mux
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


module and_gate(
    input logic clk,
//    input logic a1,
//    input logic b1,
    input logic btnU,
    input logic btnD,
    input logic btnC,
    input logic btnL,
    input logic btnR,
    output logic [15:0] led
    );
    logic [3:0] index = 4'd0;
    always_ff @(posedge clk) begin
        if(btnL) begin
            if (index < 15) begin
                index <= index+1;
            end else begin
                index = 0;
            end
        end 
        else if (btnR) begin
            if (index > 0) begin
                index <= index-1;
            end else begin
                index <= 15;
            end
        end
        else if (btnU) begin
            led[index] <= 1'b1;
        end
        else if (btnD) begin
            led[index] <= 1'b0;
        end
        else if(btnC) begin
            led[15:0] <= 16'b0;
            index <= 0;
        end
    end
endmodule
