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
