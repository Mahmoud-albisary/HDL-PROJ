`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2026 11:25:04 PM
// Design Name: 
// Module Name: timer_states_pkg
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

typedef enum logic [2:0] {
    IDLE,       // waiting / showing default screen
    SET_MODE,   // choose timer, stopwatch, event counter, etc.
    SET_SECONDS,  // set countdown start value or counter target
    SET_MINUTES,  // set countdown start value or counter target
    RUN,        // actively counting
    PAUSE,      // frozen count, can resume/reset
    DONE        // countdown finished / target reached
} state_t;
