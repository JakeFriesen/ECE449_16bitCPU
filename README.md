# ECE 449 16-Bit CPU Project
#### Jake Friesen, V00906053
#### Matt Ebert, V00884117
#### Samuel Pacheco, V00883523

## Things to Do
- [x] Format B Instruction
    - [x] Reset needs to be redone - should be a specific signal to flush buffer contents, not reset everything
    - [x] OUT_PORT needs to be moved (could output before branch decision is made). Would be fine if PC calc is done in decode
    - [x] Test with RAW integration
- [x] Format L Instructions
    - [x] Load, Store, Ld Imm, mov instructions
    - [x] Test standalone
    - [x] Test Integrated 
- [x] RAW Hazard Checking
    - [x] Test standalone
    - [x] Test Integrated (partially done)
    - [x] RAW hazards for Load/Store/Imm instructions
        - Saw issue when running factorial test, load imm twice, with immediate move from R7 to R5 causes a problem. Need to queue up R7 with load imm.
- [x] Change PC to 16 bit (idk why I thought it was 6 bit)
- [ ] Get data addressing for ROM/RAM mapped
    - ROM from 0x0000 to 0x400, RAM from 0x400 to 0x800
    - Accessing RAM or ROM should be exactly the same (will need a small mem controller between RAM, ROM, stages)
    - Indexing has to be updated (PC currently increments by 1 (RAM is word addressed), and ROM can probably be the same, but to keep compatibility with what they want, will probably need to increment by 2 and cut off the LSB when addressing)
- [ ] Move PC to decode Stage (Optional)
    - Could dramatically increase the branching speed, only a fetch would be wasted, no pipeline flushing 
    - Should look at stage speeds at the moment before doing this.
    - Could move only unconditional branching to decode stage, but could cause issues with conditional branching in the previous instruction
- [ ] General Clean up
    - [X] Standardized naming for inputs and outputs
    - [ ] Fix uninitialized values, make sure there is always an 'else'
    - [ ] Remove unused internal signals
    - [X] Rework some stages (MEM) to switch cases
    - [X] Merge Matt's cleaned branch (issues with file tracking? git mv?)
    - [ ] Documentation (header comments, general comments, README description)
    - [ ] Timing considerations - Look into timing warnings, clock results when possible.
- [ ] Bootloader
    - Reset_load and reset_execute signals
    - ROM integration
    - Connect to other board to load programs
- [ ] Hardware Testing
    - Get IN_PORT and OUT_PORT connected to lights and keypad
    - Make sure timing is working well
- [ ] IF will miss the first instruction after reset
    - This may only be an issue when we aren't using the bootloader, but it's important to keep in mind while testing
    - Can be bypassed by adding a nop as the first instruction
    - Has to do with coming out of reset, won't output the signal at the right time before the counter is incremented
    - Look at negative reset
- [ ] Branch Prediction Unit
    - predicts branch taken not taken.
- [ ] Forwarding Signalling (Matt)
    - back paths from EX buffer and MEM buffer back into ALU MUX and RAM ports
    - Should get data from each buffer to combinationally determine if forwarding is possible
    - Might require coordination with RAW (either RAW moved out to read buffers, or IR queue saved in decode stage)
- [ ] Stack (Jake)
    - Need to specify RAM space for stack, SP register
    - [X] Push, Pop instructions
    - [ ] Load SP, RTI
    - Interrupt Sequence
        - [ ] CPU level Interrupt pin
        - [ ] Set interrupt vector sequence
        - [ ] Test interrupt subroutine (Stack loading/unloading)
        - How much of this needs to be in hardware/how much in software?
- [ ] Halt Instruction (Optional, low priority)
    - Would be good to have instead of going into infinite loop
- [ ] Change Multiply (Optional, Only if better alternative)
    - Prof mentioned he didn't like our current method
## Project Items To be Completed
- [ ] Demo
    - [ ] Get Bootloader working
    - [ ] Finish integration of forwarding and branching in Decode
- [ ] Presentation
    - What is required for this?
- [ ] Report
    - Due April 14th?


