farcall: MACRO ; bank, address
	ld a, BANK(\1)
	ld hl, \1
	rst FarCall
ENDM

callfar: MACRO ; address, bank
	ld hl, \1
	ld a, BANK(\1)
	rst FarCall
ENDM

farcall2: MACRO ; bank, address
	rst FarCall2
	dbw BANK(\1), \1
ENDM

farjp: MACRO ; bank, address
	rst FarCall2
	dbw BANK(\1) | $80, \1
ENDM

homecall: MACRO
	ldh a, [hROMBank]
	push af
	ld a, BANK(\1)
	rst Bankswitch
	call \1
	pop af
	rst Bankswitch
ENDM
