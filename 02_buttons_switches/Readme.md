# Button Switches

In this project, the aim is to visualize changes using the mechanical buttons on the board.

We have to take two points into consideration:

1) In SystemVerilog, we can check the button level directly, not the press itself

2) Unlike switches, buttons can bounce when clicked, so the bouncing problem can make the state unstable at the moment of the click

The idea in this project is to use the 5 buttons on the board to control the states of the 16 LEDs.

- `BTNU` turns the LED on
- `BTND` turns the LED off
- `BTNL` selects the next LED on the left
- `BTNR` selects the next LED on the right
- `BTNC` resets to the initial state (all LEDs off, and `LED0` is the selected one)

For the first problem, which is detecting the press rather than only the level, we need to check the level of the button before and after each positive clock edge. Only when the level is `0` before the clock edge and `1` after the clock edge does this mean the button has been clicked.

To resolve the bouncing, we first detect a change in the button level, then wait for a short period of time. In our case, it is `10 ms`. A clock frequency of `100 MHz` means `1,000,000` counts equals `10 ms`. If this period passes and the button level remains stable after the change, we accept the change in the button level and apply the function of the respective button.

