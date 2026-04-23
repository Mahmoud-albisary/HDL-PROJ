# Clock 

In this project, we are creating a clock with the Basys3 board using the buttons and the 7-segment display.

The aim here is to focus on bigger projects, where we have the following:

1) A larger number of lines in the project, which means we need to split the design into multiple files

2) Starting to use the concept of Finite State Machines (FSMs)

Compared to the previous project, this design does not only allow the user to set the time, but also lets the clock run normally after the setup is finished.

The design uses three states:

1) `SET_MINUTES`
2) `SET_HOURS`
3) `DISPLAY`

In `SET_MINUTES`, the user edits the minutes value. In `SET_HOURS`, the user edits the hours value. In `DISPLAY`, the stored time is updated automatically by the counter logic so the clock keeps running.

The button behavior is organized around these states:

- `BTNU` increments the currently selected value
- `BTND` decrements the currently selected value
- `BTNL` moves forward through the states
- `BTNR` moves back from `SET_HOURS` to `SET_MINUTES`

As in the previous projects, the button inputs are first debounced. After that, the design reacts to the positive edge of the clean button signals, which prevents one long press from being treated as many presses.

The project is split into several modules so that each part has a clear responsibility:

1) `update_state_data` handles the FSM transitions and updates the stored hour and minute values according to the button presses
2) `time_counter` keeps track of real time while the design is in the `DISPLAY` state and updates the minutes and hours values with wrap-around from `59` to `00` minutes and from `23` to `00` hours
3) `display_mux` converts the hour and minute values into four digits and drives the 7-segment display through multiplexing
4) `toggle` generates the fast display refresh selection signal
5) `blink_display` generates the slower blinking signal that highlights the part currently being edited

The blinking effect is used as a visual indication of the current editing state. When the design is in `SET_MINUTES`, the minute digits blink. When it is in `SET_HOURS`, the hour digits blink. In the `DISPLAY` state, both pairs remain visible all the time.

This project is a useful step toward more structured FPGA designs, because it introduces state-based control, separates the design into reusable modules, and shows how several synchronous blocks can work together in one system.

