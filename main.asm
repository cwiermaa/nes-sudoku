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
	sta $100,x
	inx
	bne -
	
	jsr clear_ram


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


	lda #151
	sta $600
	lda #$C0
	sta $601
	lda #88
	sta $603
	jsr loadname
	jsr turnonscreen
loopy:
	lda $11
	bpl loopy

	jsr clear_ram

	dec $2E
GetPuzzle:
	lda #$00
	sta $2000
	sta $2001
	jsr cleartable
	jsr Puzzler

	jsr PutInRAM



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
	inc $22

	jsr turnonscreen
loop:
	lda $95
	bpl loop
	jsr solve
	jmp loop

nmi:
	pha
	txa
	pha
	tya
	pha
	lda $2E
	bmi +
	jsr MenuPad
	lda #6
	sta $4014
	pla
	tay
	pla
	tax
	pla
	rti
+
	jsr keypad
	lda #6
	sta $4014
	pla
	tay
	pla
	tax
	pla
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
	ldx #4
	ldy #0
-
	sta $2007
	iny
	bne -
	dex
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
	cmp #$20
	beq skip
	cmp #$21
	beq skip
	cmp #$10
	beq skip
	cmp #$FF
	beq end
	sta $400,y
	and #$F0
	sta $A0
	lda $A0
	cmp #$30
	bne +
	lda #$0A
	sta $31,y
	jmp ++
+
	lda puzzle.w,x
	sta $31,y
++
	inx
	iny
	jmp -
end:
	rts

skip:
	inx
	jmp -


Puzzler:
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
	and #$F0
	sta $A0
	lda $A0
	cmp #$30
	bne +
	lda #$0A
	sta $2007
	jmp ++
+
	lda puzzle.w,x
	sta $2007
++
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
	lda #$20
	sta $2007
	lda #$22
	sta $2006
	lda #$CC
	sta $2006

	ldx #8
	ldy #$0C
-
	sty $2007.w
	dex
	bne -
	lda #$10
	sta $2007
	rts


loadname:
	lda #<Sudoku
	sta $1A
	lda #>Sudoku
	sta $1B
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	ldx #4
	ldy #0
-
	lda ($1A),y
	sta $2007
	iny
	bne -
	inc $1B
	dex
	bne -
	rts



turnonscreen:
	lda #$00
	sta $2005
	sta $2005
	jsr wait3vbls
	lda #$1E
	sta $2001
	lda #$80
	sta $2000
	rts

clear_ram:
	ldx #0
	txa
-
	sta $0,x
	sta $200,x
	sta $300,x
	sta $400,x
	sta $500,x
	sta $600,x
	sta $700,x
	inx
	bne -
	rts

solve:
	lda $A2
	beq +
	rts
+
	
	lda #$20
	sta $2006
	sta $11
	lda #$EA
	sta $2006
	sta $10
	ldy #0
	ldx #0
-
	lda $31,y
	sta $A3
	lda $400,y
	cmp $A3
	bne +
	iny
	inx
	txa
	and #$03
	sta $A4
	lda $A4
	cmp #3
	bne -
	inc $10
	
	
+

pal:
	.db $3F,$05,$02,$22,$3F,$03,$33,$32,$3F,$05,$15,$35,$3F,$05,$10,$28
	.db $3F,$00,$15,$27,$3F,$00,$10,$30,$3F,$00,$10,$30,$3F,$00,$10,$30

text:
	.db "HELLO",$5E,"WORLD",$3B

puzzle:
.incdir "data/puzzles"
	.include "puzzles.asm"

.incdir "code"
	.include "joy.asm"
.ends

.bank 2 SLOT 2
.section "graph" FREE
.incdir "data/graphics"
.incbin "graphics.chr"
.ends

.bank 1 SLOT 1
.orga $FFFA
.section "vectors" FORCE
.dw nmi
.dw reset
.dw irq
.ends