ORG	0x0000
.CODE
	NOP
	NOP
	NOP
	IN r1   ; 03
	IN r2	; 05
	NOP
	NOP
	NOP
	NOP
	ADD r3, r2, r1
	NOP
	NOP
	NOP
	NOP
	SHL r3, 2
	NOP
	NOP
	NOP
	NOP
	MUL r2, r1, r3
	NOP
	NOP
	NOP
	NOP
	OUT r2	
	NOP
END