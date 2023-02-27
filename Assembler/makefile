CC = python2
CFLAGS = -o
DIR_ASSEMBLER = Assembler
FILE_OUTPUT = out
ASM = Test_asm.asm
MEM_DIR = ../Source/
MEM_FILE = RAM.mem
FILE_CLEAN = *.coe *.hex *.lst *.mem
DIR_CLEAN = ../Source/$(MEM_FILE)


all : clean build

.PHONY : clean build

build:
	$(CC) assembler19.py $(CFLAGS) $(FILE_OUTPUT) $(ASM)
	cp $(FILE_OUTPUT).hex $(MEM_DIR)$(MEM_FILE)

clean : 
	rm -f $(FILE_CLEAN) 
#	rm -f $(DIR_CLEAN)
