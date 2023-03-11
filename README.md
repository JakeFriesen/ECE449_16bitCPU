# ECE 449 16-Bit CPU Project
#### Jake Friesen, V00906053
#### Matt Ebert, V00884117
#### Samuel Pacheco, V00883523

## Things to Do
- [ ] Format B Instruction
    - [x] Reset needs to be redone - should be a specific signal to flush buffer contents, not reset everything
    - [x] OUT_PORT needs to be moved (could output before branch decision is made). Would be fine if PC calc is done in decode
    - [ ] Test with RAW integration
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
    - [ ] Standardized naming for inputs and outputs
    - [ ] Fix uninitialized values, make sure there is always an 'else'
    - [ ] Remove unused internal signals
    - [ ] Rework some stages (MEM) to switch cases
    - [ ] 
- [ ] Bootloader
    - Reset_load and reset_execute signals
    - ROM integration
    - Connect to other board to load programs
- [ ] Hardware Testing
    - Get IN_PORT and OUT_PORT connected to lights and keypad
    - Make sure timing is working well
    


