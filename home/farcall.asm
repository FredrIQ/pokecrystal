FarCall_de::
; Call a:de.
; Preserves other registers.

	ldh [hTempBank], a
	ldh a, [hROMBank]
	push af
	ldh a, [hTempBank]
	rst Bankswitch
	call .de
	jr ReturnFarCall

.de
	push de
	ret

FarCall_hl::
; Call a:hl.
; Preserves other registers.

	ldh [hTempBank], a
	ldh a, [hROMBank]
	push af
	ldh a, [hTempBank]
	rst Bankswitch
	call FarCall_JumpToHL
	jr ReturnFarCall

RstFarCall::
; Call the following dba pointer on the stack.
; Preserves a, bc, de, hl
	ldh [hFarCallSavedA], a
	ld a, h
	ld [wPredefTemp + 1], a
	ld a, l
	ld [wPredefTemp], a
	pop hl
	ld a, [hli]
	ldh [hTempBank], a
	add a
	jr c, .farjp
	inc hl
	inc hl
	push hl
	dec hl
	dec hl
.farjp
	ldh a, [hROMBank]
	push af
	ld a, [hli]
	ld h, [hl]
	ld l, a
DoFarCall:
	ldh a, [hTempBank]
DoFarCall_BankInA:
	and $7f
	rst Bankswitch
	call RetrieveHLAndCallFunction

ReturnFarCall::
	ldh [hFarCallSavedA], a
	; We want to retain the contents of f.
	; To accomplish this, mess with the stack a bit...
	push af
	push hl
	ld hl, sp+$2 ; a flags
	ld a, [hli]
	inc l ; faster than inc hl (stack is always c000-c100...)
	ld [hl], a ; write to flags
	pop hl
	pop af
	pop af
	rst Bankswitch
	ldh a, [hFarCallSavedA]
	ret

RetrieveHLAndCallFunction:
	push hl
	ld hl, wPredefTemp
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ldh a, [hFarCallSavedA]
	ret

FarCall_JumpToHL::
	jp hl
