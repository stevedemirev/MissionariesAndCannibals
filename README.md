# MissionariesAndCannibals

Hello! Welcome to the Missionaries and Cannibals Solver!

## Prerequisites
Before attempting to run this program, please ensure that GNU Common Lisp is installed on your device. If not, you can install it by following the instructions on the official GNU Common Lisp website or use the command `sudo apt-get install clisp` for Linux/Unix systems.

## Problem Overview
The Missionaries and Cannibals problem involves transporting 3 Missionaries (M) and 3 Cannibals (C) from the left side of a river to the right using a boat (B). The boat can carry at most 2 individuals at a time, and you must avoid having more Cannibals than Missionaries on either side of the river or the Missionaries will be eaten.

## Constraints
- You can never have more Cannibals (C) on a side than Missionaries (M).
- The boat can at most carry 2 individuals at a time.
- The boat needs at least one person on it for you to move it to the other side.

## Usage
The program takes the initial state and end state in the format `(M C B)`, where:
- `M` is the number of Missionaries on the left side,
- `C` is the number of Cannibals on the left side,
- `B` is the position of the boat (`L` for Left side, `R` for Right side).

### Example Input
(3 3 L) (0 0 R)

## Program Execution
The program generates a list of valid successor states which are traversed using depth-first search until the end state is reached and the path taken is returned.

### Menu
The program menu provides example inputs and allows you to input your own initial and ending states following the problem constraints. Another function is included that allows you view the successor states for each input state.

## Error Handling
If you encounter any errors or have suggestions for improvement, please let me know.

Thank you for using the Missionaries and Cannibals Solver!

