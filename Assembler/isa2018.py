# Original by C. Somers. Modified by N. Dimopoulos to reflect the 2018 16-bit architecture

# !/usr/bin/env python

import string

# constants

DEFAULT_MEMORY_DEPTH = 512
STACK_SIZE = 16
MAX_INT = 255  # may need to consider negatives

# IR masks. Opcode is the 7 MSB of the instruction word.

opcode_mask = 0xff00  # mask should be 0xfe00 to only mask the 7 MSB. It was made 0xff00 to accommodate the Loadimm.upper/lower. -->Revisit

# masks need to be reconsidered -->March 30, 2018
ra_mask = 0x0c0
rb_mask = 0x0038
rc_mask = 0x0007
brx_mask = 0x0c

SINA_3 = 0x1200
SINA_2 = 0x1300
SINA_1 = 0x1400
SINA_0 = 0x1500
NOP = 0x0000
LOAD = 0x2000
STORE = 0x2200
LOADIMM_UPPER = 0x2500
LOADIMM_LOWER = 0x2400
ADD = 0x0200
SUB = 0x0400
MUL = 0x0600
NAND = 0x0800
SHL = 0x0a00
SHR = 0x0c00
BRR = 0x8000
BRR_N = 0x8200
BRR_Z = 0x8400
BR = 0x8600
BR_N = 0x8800
BR_Z = 0x8a00
BR_SUB = 0x8c00
RETURN = 0x8e00
IN = 0x4200
OUT = 0x4000
MOV = 0x2600
PUSH = 0xc000
POP = 0xc200
LOAD_SP = 0xc400
RTI = 0xc600
TEST = 0x0e00
# CLEAR		= 0xe0          unused carried from 2002 instruction set
# add new opcode here
# MYOP		= 0xff00
HALT = 0x1000  # unused, but needed for assembler

opcode2string = \
    {
        NOP 	: 'NOP',
        LOAD		: 'LOAD',
        STORE 		: 'STORE',
        LOADIMM_UPPER	: 'LOADIMM.UPPER',  # note the difference
        LOADIMM_LOWER	: 'LOADIMM.LOWER',  # note the difference
        ADD		: 'ADD',
        SUB		: 'SUB',
        MUL		: 'MUL',
        NAND		: 'NAND',
        SHL		: 'SHL',
        SHR		: 'SHR',
        BRR	: 'BRR',
        BRR_N		: 'BRR.N',	# note the difference
        BRR_Z		: 'BRR.Z',	# note the difference
        BR		: 'BR',
        BR_N		: 'BR.N',	# note the difference
        BR_Z		: 'BR.Z',	# note the difference
        BR_SUB		: 'BR.SUB',	# note the difference
        RETURN		: 'RETURN',
        IN		: 'IN',
        OUT		: 'OUT',
        MOV		: 'MOV',
        PUSH		: 'PUSH',
        POP		: 'POP',
        LOAD_SP		: 'LOAD.SP',  # note the difference
        RTI		: 'RTI',
        TEST	: 'TEST',

        # add new opcode here
        # MYOP		: 'MYOP'
        SINA_3        : 'SINA_3',
        SINA_2        : 'SINA_2',
        SINA_1        : 'SINA_1',
        SINA_0        : 'SINA_0',
        HALT		: 'HALT'
    }

string2opcode = {}
for i in opcode2string.items():
    string2opcode[i[1]] = i[0]

