`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2026 09:57:40 PM
// Design Name: 
// Module Name: tb_clock
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

`timescale 1ns / 1ps

module tb_clock;

    logic clk;
    logic rst;

    logic btn_U;
    logic btn_D;
    logic btn_R;
    logic btn_L;

    logic [3:0] an;
    logic [6:0] c;
    logic dp;

    // Faster simulation parameters
    localparam CLK_DIV_SIM = 10;
    localparam DEBOUNCE_SIM = 3;
    localparam REFRESH_SIM = 5;
    localparam REFRESH_BITS_HIGH = 15;
    localparam REFRESH_BITS_LOW = 14;

    clock #(
        .CLK_DIV(CLK_DIV_SIM),
        .COUNT_MAX(DEBOUNCE_SIM),
        .DISPLAY_REFRESH_COUNT(REFRESH_SIM)
    ) dut (
        .clk  (clk),
        .rst  (rst),
        .btnU (btn_U),
        .btnD (btn_D),
        .btnR (btn_R),
        .btnL (btn_L),
        .an   (an),
        .c    (c),
        .dp   (dp)
    );

    // 100 MHz clock
    always #5 clk = ~clk;

    initial begin

        clk   = 0;
        rst   = 1;

        btn_U = 0;
        btn_D = 0;
        btn_R = 0;
        btn_L = 0;

        // Reset
        #20;
        rst = 0;

        // Increment minutes
        #20;
        btn_U = 1;
        #50;
        btn_U = 0;

        // Change field/state
        #20;
        btn_L = 1;
        #50;
        btn_L = 0;

        // Increment hours
        #20;
        btn_U = 1;
        #50;
        btn_U = 0;

        // Change to display state
        #20;
        btn_L = 1;
        #50;
        btn_L = 0;

        // Let clock run
        #1000;

        $finish;
    end

endmodule