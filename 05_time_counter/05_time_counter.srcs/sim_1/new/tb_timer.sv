`timescale 1ns / 1ps

module tb_timer;

    logic clk;
    logic rst;
    logic btn_U;
    logic btn_D;
    logic btn_R;
    logic btn_L;

    logic [3:0] an;
    logic [6:0] c;

    // The current timer uses hardware timing: 10 ms debounce and 1 s ticks.
    // Hold AND release each button for longer than the debounce interval.
    localparam time BUTTON_TIME = 20ms;

    timer dut (
        .clk  (clk),
        .rst  (rst),
        .btnU (btn_U),
        .btnD (btn_D),
        .btnR (btn_R),
        .btnL (btn_L),
        .an   (an),
        .c    (c)
    );

    // 100 MHz clock
    always #5 clk = ~clk;

    // Drive buttons on falling edges to avoid races with the DUT.
    task automatic press_button(input logic [3:0] buttons);
        @(negedge clk);
        {btn_U, btn_D, btn_R, btn_L} = buttons;
        #(BUTTON_TIME);
        {btn_U, btn_D, btn_R, btn_L} = 4'b0000;
        #(BUTTON_TIME);
    endtask

    initial begin
        clk   = 0;
        rst   = 1;
        btn_U = 0;
        btn_D = 0;
        btn_R = 0;
        btn_L = 0;

        // Reset
        repeat (4) @(negedge clk);
        rst = 0;
        #(BUTTON_TIME);

        // Countdown: select timer mode (the default).
        press_button(4'b0010); // IDLE -> SET_MODE
        press_button(4'b0010); // SET_MODE -> SET_MINUTES
        press_button(4'b1000); // Increment minutes to 1
        press_button(4'b0100); // Decrement minutes to 0
        press_button(4'b0010); // SET_MINUTES -> SET_SECONDS
        press_button(4'b1000); // Set seconds to 1
        press_button(4'b1000); // Set seconds to 2
        press_button(4'b1000); // Set seconds to 3
        press_button(4'b0010); // SET_SECONDS -> RUN

        #1100ms;
        press_button(4'b0010); // RUN -> PAUSE
        #1100ms;              // Values should remain unchanged
        press_button(4'b0010); // PAUSE -> RUN
        #2200ms;              // Countdown reaches 00:00 / DONE
        press_button(4'b0001); // DONE -> IDLE

        // Stopwatch: select mode and start from 00:00.
        press_button(4'b0010); // IDLE -> SET_MODE
        press_button(4'b1000); // Toggle to stopwatch mode
        press_button(4'b0010); // SET_MODE -> SET_MINUTES
        press_button(4'b0010); // SET_MINUTES -> SET_SECONDS
        press_button(4'b0010); // SET_SECONDS -> RUN

        #2200ms;
        press_button(4'b0010); // RUN -> PAUSE
        #1100ms;              // Values should remain unchanged
        press_button(4'b0010); // PAUSE -> RUN
        #1100ms;
        press_button(4'b0010); // RUN -> PAUSE
        press_button(4'b0001); // PAUSE -> IDLE, clearing the values

        #(BUTTON_TIME);
        $finish;
    end

endmodule
