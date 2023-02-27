CC = python2
CFLAGS = -o
FILE_CLEAN = *.coe *.hex *.lst
DIR_ASSEMBLER = Assembler
FILE_OUTPUT = out
ASM = Test_asm.asm


all : clean build

.PHONY : clean build

build:
	$(CC) assembler19.py $(CFLAGS) $(FILE_OUTPUT) $(ASM)

clean : 
	rm -f $(FILE_CLEAN) 
