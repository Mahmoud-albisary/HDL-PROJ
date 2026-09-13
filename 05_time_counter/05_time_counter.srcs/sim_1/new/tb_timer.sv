`timescale 1ns / 1ps

module tb_timer;
    import timer_states_pkg::*;

    logic clk;
    logic rst;
    logic btn_U;
    logic btn_D;
    logic btn_R;
    logic btn_L;

    logic [3:0] an;
    logic [6:0] c;

    // One simulated second takes 1 us; button presses complete between ticks.
    localparam int CLK_DIV_SIM = 100;
    localparam int DEBOUNCE_SIM = 3;
    localparam time SECOND_TIME = CLK_DIV_SIM * 10ns;
    localparam time BUTTON_TIME = (DEBOUNCE_SIM + 3) * 10ns;

    timer #(
        .CLK_DIV(CLK_DIV_SIM),
        .COUNT_MAX(DEBOUNCE_SIM),
        .DISPLAY_REFRESH_COUNT(5),
        .REFRESH_BITS_HIGH(3),
        .REFRESH_BITS_LOW(2)
    ) dut (
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

    task automatic check_timer(input state_t expected_state,
                               input int expected_seconds);
        if (dut.state !== expected_state ||
            dut.left_value !== 0 || dut.right_value !== expected_seconds)
            $fatal(1, "Expected state=%0d time=00:%0d; got state=%0d time=%0d:%0d",
                   expected_state, expected_seconds, dut.state,
                   dut.left_value, dut.right_value);
    endtask

    // Stop failed simulations instead of running indefinitely.
    initial begin
        #100us;
        $fatal(1, "Testbench timeout");
    end

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

        #(SECOND_TIME + SECOND_TIME / 10);
        press_button(4'b0010); // RUN -> PAUSE
        check_timer(PAUSE, 2);
        #(SECOND_TIME + SECOND_TIME / 10);
        check_timer(PAUSE, 2);
        press_button(4'b0010); // PAUSE -> RUN
        #(2 * SECOND_TIME + SECOND_TIME / 5);
        check_timer(DONE, 0);
        press_button(4'b0001); // DONE -> IDLE

        // Stopwatch: select mode and start from 00:00.
        press_button(4'b0010); // IDLE -> SET_MODE
        press_button(4'b1000); // Toggle to stopwatch mode
        press_button(4'b0010); // SET_MODE -> SET_MINUTES
        press_button(4'b0010); // SET_MINUTES -> SET_SECONDS
        press_button(4'b0010); // SET_SECONDS -> RUN

        #(2 * SECOND_TIME + SECOND_TIME / 5);
        press_button(4'b0010); // RUN -> PAUSE
        check_timer(PAUSE, 2);
        #(SECOND_TIME + SECOND_TIME / 10);
        check_timer(PAUSE, 2);
        press_button(4'b0010); // PAUSE -> RUN
        #(SECOND_TIME + SECOND_TIME / 10);
        press_button(4'b0010); // RUN -> PAUSE
        check_timer(PAUSE, 3);
        press_button(4'b0001); // PAUSE -> IDLE, clearing the values

        #(BUTTON_TIME);
        check_timer(IDLE, 0);
        $display("PASS: countdown, stopwatch, pause/resume, and return to idle");
        $finish;
    end

endmodule
