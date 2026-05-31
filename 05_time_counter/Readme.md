# 05 Timer and Stopwatch FSM Design (Basys 3)

This project builds a small timer/stopwatch controller for the Basys 3 board using the push buttons and the four-digit 7-segment display. The design is controlled by a finite state machine (FSM): the user selects a mode, sets the starting minutes and seconds when needed, then starts the count.

Two modes are supported:

- Timer mode counts down from the selected value until it reaches `00:00`.
- Stopwatch mode counts up once started and stops when the maximum display value is reached.

The display shows two digits for the left value and two digits for the right value. In normal operation these represent minutes and seconds. During setup, the active field blinks so the user can see which value is currently being edited.

## Modules

- `timer`: Top-level module for this project. It connects the debounced buttons, FSM state logic, counter tick generator, display multiplexer, blinking control, and 7-segment outputs.
- `timer_states_pkg`: Defines the FSM states used by the timer: `IDLE`, `SET_MODE`, `SET_MINUTES`, `SET_SECONDS`, `RUN`, `PAUSE`, and `DONE`.
- `update_state`: Controls state transitions. It watches clean button edges, checks the selected mode, and moves between setup, running, paused, and done states.
- `update_data`: Stores and updates the displayed values. It handles mode selection, minute/second increment and decrement, countdown behavior for timer mode, and count-up behavior for stopwatch mode.
- `timer_counter`: Generates a one-cycle `tick` every second from the 100 MHz Basys 3 clock while the FSM is in `RUN`.
- `display_mux`: Splits the left and right values into display digits, selects one active 7-segment digit at a time, and shows the mode indicator during `SET_MODE`.
- `debounce`: Shared button-conditioning module used to remove mechanical button bounce before the FSM sees each button press.
- `toggle`: Shared display refresh module that cycles through the four 7-segment anodes.
- `blink_display`: Shared timing module that creates the blink signal used while selecting mode, setting values, or showing the done/idle states.
- `seven_seg_pkg`: Shared package containing `num_to_display`, which converts numeric and mode indicator values into 7-segment cathode patterns.

## Button Mapping

| Button | Function |
|--------|----------|
| btnC   | Reset (global) |
| btnR   | Forward / Confirm / Start / Pause / Resume |
| btnL   | Back |
| btnU   | Increment value / Toggle mode |
| btnD   | Decrement value |

---

## State Transitions

### IDLE
- `btnR` -> `SET_MODE`

---

### SET_MODE
- `btnU` -> toggle between timer and stopwatch mode
- `btnR` -> `SET_MINUTES`
- `btnL` -> `IDLE`

---

### SET_MINUTES
- `btnU` -> minutes + 1
- `btnD` -> minutes - 1
- `btnR` -> `SET_SECONDS`
- `btnL` -> `SET_MODE`

---

### SET_SECONDS
- `btnU` -> seconds + 1
- `btnD` -> seconds - 1
- `btnR` -> `RUN`
- `btnL` -> `SET_MINUTES`

---

### RUN
- Timer mode counts down once per second
- Stopwatch mode counts up once per second
- `btnR` -> `PAUSE`
- Timer mode: if time == `00:00` -> `DONE`
- Stopwatch mode: if time == `99:59` -> `DONE`

---

### PAUSE
- `btnR` -> `RUN`
- `btnL` -> `IDLE`

---

### DONE
- `btnR` -> `SET_MINUTES`
- `btnL` -> `IDLE`

---

## Global Transition

### ANY STATE
- `btnC` -> `IDLE`
- Reset minutes = 0, seconds = 0

---

## Summary

- `btnC` = Reset
- `btnR` = Next / Start / Pause / Resume
- `btnL` = Back
- `btnU` = Increase value / Toggle mode
- `btnD` = Decrease value
