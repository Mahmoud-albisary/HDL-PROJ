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
module debounce(
    input logic clk,
    input logic btn,
    output logic clean
    );
    localparam int COUNT_MAX = 1000000;
    logic [$clog2(COUNT_MAX+1)-1: 0] count;
    always_ff @(posedge clk) begin

        if(clean == btn) begin  
            count <= 0;
        end 
        else if (COUNT_MAX == count) begin
            clean <= btn;
            count <= 0;
        end
        else begin
            count <= count + 1;
        end
    end

endmodule

module and_gate(
    input logic clk,
    input logic btnU,
    input logic btnD,
    input logic btnC,
    input logic btnL,
    input logic btnR,
    output logic [15:0] led
    );
    logic [3:0] index = 4'd0;
    logic btnL_d;
    logic btnR_d;
    logic btnL_c;
    logic btnR_c;
    logic btnU_c;
    logic btnD_c;

    debounce db0(
        .clk (clk),
        .btn (btnL),
        .clean (btnL_c)
    );

    debounce db1(
        .clk (clk),
        .btn (btnR),
        .clean (btnR_c)
    );

    debounce db2(
        .clk (clk),
        .btn (btnU),
        .clean (btnU_c)
    );

    debounce db3(
        .clk (clk),
        .btn (btnD),
        .clean (btnD_c)
    );

     debounce db4(
        .clk (clk),
        .btn (btnC),
        .clean (btnC_c)
    );

    always_ff @(posedge clk) begin
        btnL_d <= btnL_c;
        btnR_d <= btnR_c;
        if(btnL_c & ~btnL_d) begin
            if (index < 15) begin
                index <= index+1;
            end else begin
                index = 0;
            end
        end 
        else if (btnR_c & ~btnR_d) begin
            if (index > 0) begin
                index <= index-1;
            end else begin
                index <= 15;
            end
        end
        else if (btnU_c) begin
            led[index] <= 1'b1;
        end
        else if (btnD_c) begin
            led[index] <= 1'b0;
        end
        else if(btnC_c) begin
            led[15:0] <= 16'b0;
            index <= 0;
        end
    end
endmodule
