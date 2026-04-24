.include "memory.asm"

.8bit
.bank 1 SLOT 1
.section "reset" FREE

reset:
	cld
	sei
	ldx #$FF
	txs

	lda #$00
	sta $2000
	sta $2001
	jsr cleartable
	
	ldx #0
	txa
-
	sta $0,x
	sta $100,x
	sta $200,x
	sta $300,x
	sta $400,x
	sta $500,x
	sta $600,x
	sta $700,x
	inx
	bne -

	sta $2007
	lda #$3F
	sta $2006
	lda #$00
	sta $2006
	ldx #32
	ldy #0

palload:
	lda pal.w,y
	sta $2007
	iny
	dex
	bne palload


	lda #$20
	sta $2006
	sta $11
	lda #$EA
	sta $2006
	sta $10
	lda #12
	sta $12
	ldx #0
	ldy #144
-
	lda puzzle.w,x
	sta $2007
	inx
	dec $12
	bne +
	lda #12
	sta $12
	clc
	lda $10
	adc #$20
	sta $10
	lda $11
	adc #$00
	sta $11
	lda $11
	sta $2006
	lda $10
	sta $2006
+
	dey
	bne -

	jsr PutInRAM

	lda #$22
	sta $2006
	lda #$AB
	sta $2006
	ldx #0
	ldy #1
-
	sty $2007.w
	iny
	cpy #$0A
	bne -
	lda #$0B
	sta $2007
	lda #$22
	sta $2006
	lda #$CB
	sta $2006

	ldx #9
	ldy #$0C
-
	sty $2007.w
	dex
	bne -

	jsr PutText


	lda #56
	sta $600
	lda #$C0
	sta $601
	lda #80
	sta $603
	lda #168
	sta $604
	lda #$D0
	sta $605
	lda #88
	sta $607
	lda #$20
	sta $11
	lda #$EA
	sta $10
	lda #$31
	sta $22

	lda #$00
	sta $2005
	sta $2005
	jsr wait3vbls
	lda #$18
	sta $2001
	lda #$80
	sta $2000
loop:
	jmp loop

nmi:
	lda #6
	sta $4014
	jsr keypad
	rti

irq:
	rti

wait3vbls:
	lda $2002
	bpl wait3vbls
-
	lda $2002
	bpl -
-
	lda $2002
	bpl -
	rts

cleartable:
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	ldx #3
	ldy #0
-
	sta $2007
	iny
	bne -
	dex
	bne -
	ldy #$BF
-
	sta $2007
	dey
	bne -
	lda #$00
	sta $2005
	sta $2005
	rts

PutInRAM:
	ldx #0
	ldy #0
-
	lda puzzle.w,x
	cmp #$0B
	beq skip
	cmp #$0C
	beq skip
	cmp #$00
	beq skip
	cmp #$FF
	beq end
	sta $31,y
	inx
	iny
	jmp -
end:
	rts

skip:
	inx
	jmp -

PutText:
	lda #$23
	sta $2006
	lda #$22
	sta $2006
	ldx #$1D
	ldy #$60
-
	sty $2007.w
	iny
	dex
	bne -
	lda #$23
	sta $2006
	lda #$42
	sta $2006
	ldx #$1D
	ldy #$7D
-
	sty $2007.w
	iny
	dex
	bne -
	lda #$23
	sta $2006
	lda #$62
	sta $2006
	ldx #$0D
	ldy #$A0
-
	sty $2007.w
	iny
	dex
	bne -
	rts


pal:
	.db $3F,$00,$10,$30,$3F,$00,$10,$30,$3F,$00,$10,$30,$3F,$00,$10,$30
	.db $3F,$00,$15,$27,$3F,$00,$10,$30,$3F,$00,$10,$30,$3F,$00,$10,$30

text:
	.db "HELLO",$5E,"WORLD",$3B

puzzle:
	.include "puzzles.asm"

	.include "joy.asm"
.ends

.bank 2 SLOT 2
.section "graph" FREE
.incbin "graphics.chr"
.ends

.bank 1 SLOT 1
.orga $FFFA
.section "vectors" FORCE
.dw nmi
.dw reset
.dw irq
.ends