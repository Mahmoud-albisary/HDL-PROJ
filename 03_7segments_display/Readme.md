# 7 Segment Display

The idea of this project is to set a clock for now. Note that we only set the value in this project.

The aim is to get used to using the 7-segment display and to move into a more complex design compared to the previous two projects.

Here we have to consider the following:

1) Each of the 4 displays has to be active at different times and cannot be simultaneously active if they are displaying different values.

2) Counters are needed to allow each display to work at the required time along with the required logic for the project.

3) The Basys3 7-segment display is active low. This means a segment is turned on by driving its control signal to `0`, and the same idea applies to the anode control lines.

For this reason, the 4 displays are driven using multiplexing. In practice, only one display is enabled at a time, but the switching is done fast enough that the human eye sees all 4 digits as if they were active together.


To support editing the clock value, the buttons are used as a simple user interface:

- `BTNL` selects the left pair of digits
- `BTNR` selects the right pair of digits
- `BTNU` increments the selected value
- `BTND` decrements the selected value

The left pair represents the hours value, while the right pair represents the minutes value. Because mechanical buttons bounce, the button signals should be debounced before being used in the main control logic. After debouncing, it is still better to detect the positive edge of the clean button signal instead of reacting to the level directly. This prevents one long press from producing many unwanted updates.

The display logic can therefore be viewed as three main parts:

1) A refresh counter that cycles through the four digits
2) A decoder that converts a number from `0` to `9` into the correct 7-segment pattern
3) A control block that updates the selected value when the user presses the buttons

There is also a blinking effect used to show which pair of digits is currently selected for editing. Instead of changing the stored value, the design temporarily disables the selected pair during part of the refresh cycle, which makes that pair appear to blink.

As the design grows, reusable modules such as `debounce` should be placed in a common shared folder such as `common/rtl`. That way the same module can be added to multiple Vivado projects without rewriting it in each source file.
