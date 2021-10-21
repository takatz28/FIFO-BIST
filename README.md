# First-in, First-out (FIFO) Memory Buffer with Built-in Self Test (BIST)

### Specifications
* Write speed: 400 MHz
* Read speed: 40 MHz 
* Depth: 10 words
* Flags
  * Empty: set when the synchronized write pointer is equal to read pointer
  * Full: Write pointer's MSB is not equal to synchronized read pointer's MSB, 
          while the rest of the bits must be equal.

### Features
* Utilized 5-bit Johnson counters for clock domain crossing.
* BIST features a walking ones pattern generator, controller, ROM, and comparator.


### Operating Modes
* If BIST = 1, ring counter outputs are compared to ROM values to ensure no lines are shorted together
* If BIST = 0, FIFO is in normal operation
