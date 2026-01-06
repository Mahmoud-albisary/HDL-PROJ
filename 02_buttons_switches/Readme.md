# Button Switches

In this project the aim is to visualize changes using the mechanical buttons in the board.

We have to put two points into considerations:

1) In System Verilog we can check directly the button level not the press itself

2) Unlike switches, buttons can bounce when clicked on, so bouncing problem can make the state unstable at the moment of the click.

The idea in this project is to use the 5 buttons in the board to control the states of the 16 LEDs. 

- BTNU turns LED on
- BTND turns LED off
- BTNL select the next LED on the left
- BTNR select the next LED on the right
- BTNC resets to the initial state (all LEDs off and the LED0 is the one selected)

For the first problem regarding checking the press not only the level, we need to check the level of the button before and after each positive edge in the clock. Only when the level is 0 before the clock rise and after the clock rise the level is 1, this means the button is clicked on.

To resolve the bouncing we have to notice a change first in the button level, then wait for a small period of time (in our case it is 10 ms, clock frequency = 100 MHz means 1000000 counts = 10ms), if this period has passed and the level of the button stays stable after the change happened, we accept the change of the button level and apply the function of the respective button.

