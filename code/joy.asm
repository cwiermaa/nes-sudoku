keypad:
	ldx #1
	stx $4016.w
	dex
	stx $4016.w

	lda $4016
	and #1
	bne ak
	lda $4016
	and #1
	bne bk
	lda $4016
	and #1
	bne sel
	lda $4016
	and #1
	bne st

	lda $4016
	and #1
	bne up
	lda $4016
	and #1
	bne dn
	lda $4016
	and #1
	bne lf
	lda $4016
	and #1
	bne rt
	lda #0
	sta $14
	sta $15
	sta $16
	sta $17
	sta $18
	sta $19
	sta $1A
	sta $1B
	rts

;***************************************************************
st:
	jmp start
up:
	jmp up1
dn:
	jmp dn1
lf:
	jmp lf1
rt:
	jmp rt1
ak:
	jmp akey

bk:
	jmp bkey


sel:
	jmp select

up1:
	lda $14
	bpl +
	rts

+
	lda $600
	cmp #56
	bne +
	rts

+				;144, 88
	sec			;152, 80
	lda $600
	sbc #8
	sta $600
	sec
	lda $30
	sbc #9
	sta $30
	sec
	lda $10
	sbc #$20
	sta $10
	lda $11
	sbc #$00
	sta $11
	dec $14
	dec $20
	bpl +
	sec
	lda $600
	sbc #8
	sta $600
	lda #2
	sta $20
	sec
	lda $10
	sbc #$20
	sta $10
	lda $11
	sbc #$00
	sta $11
+
	rts

;***************************************************************
dn1:
	lda $15
	bpl +
	rts

+
	lda $600
	cmp #136
	bne +
	rts

+				;144, 88
	clc			;152, 80
	lda $600
	adc #8
	sta $600
	clc
	lda $30
	adc #9
	sta $30
	clc
	lda $10
	adc #$20
	sta $10
	lda $11
	adc #$00
	sta $11
	dec $15
	inc $20
	lda $20
	cmp #3
	bne +
	clc
	lda $600
	adc #8
	sta $600
	lda #$00
	sta $20
	clc
	lda $10
	adc #$20
	sta $10
	lda $11
	adc #$00
	sta $11
+
	rts


;***************************************************************
lf1:
	lda $16
	bpl +
	rts

+
	lda $603
	cmp #80
	bne +
	rts

+				;144, 88
	sec			;152, 80
	lda $603
	sbc #8
	sta $603
	dec $10
	dec $30
	dec $16
	dec $21
	bpl +
	sec
	lda $603
	sbc #8
	sta $603
	lda #2
	sta $21
	dec $10
+
	rts

;***************************************************************
rt1:
	lda $17
	bpl +
	rts

+
	lda $603
	cmp #160
	bne +
	rts

+				;144, 88
	clc			;152, 80
	lda $603
	adc #8
	sta $603
	inc $10
	inc $30
	dec $17
	inc $21
	lda $21
	cmp #3
	bne +
	clc
	lda $603
	adc #8
	sta $603
	lda #$00
	sta $21
	inc $10
+
	rts

;***************************************************************
select:
	lda $18
	bpl +
	rts

+
	inc $22
	lda $22
	cmp #10
	bne +
	lda #88
	sta $607
	lda #1
	sta $22
	dec $18
	rts
+
	clc
	lda $607
	adc #8
	sta $607
	dec $18
	rts
;***************************************************************
akey:
	lda $19
	bpl +
	rts

+
	ldx $30
	lda $31,x
	bpl +
	rts
+
	lda $11
	sta $2006
	lda $10
	sta $2006
	lda $22
	sta $2007
	lda #$00
	sta $2005
	sta $2005
	lda $22
	sta $31,x
	dec $19
	rts
;***************************************************************
bkey:
	lda $1A
	bpl +
	rts
+
	
	ldx $30
	lda $31,x
	bpl +
	rts
+
	lda $11
	sta $2006
	lda $10
	sta $2006
	lda #$0A
	sta $2007
	lda #$00
	sta $2005
	sta $2005
	lda #$0A
	sta $31,x
	dec $1A
	rts
;***************************************************************
start:
	lda $1B
	bpl +
	rts

	dec $95
	dec $1B
	rts
;********************************************************************************************************
;********************************************************************************************************
MenuPad:
	ldx #1
	stx $4016.w
	dex
	stx $4016.w

	lda $4016
	lda $4016
	lda $4016
	lda $4016
	and #1
	bne Tst

	lda $4016
	and #1
	bne Tup
	lda $4016
	and #1
	bne Tdn
	lda $4016
	lda $4016
	lda #$00
	sta $14
	sta $15
	sta $16
	sta $17
	sta $18
	sta $19
	sta $1A
	sta $1B
	rts

;************************************************
Tup:
	jmp Tup1

Tdn:
	jmp Tdn1

Tst:
	jmp Tst1

;************************************************
Tup1:
	lda $1B
	bpl +
	rts

+
	lda $1E
	bne +
	rts

+
	sec
	lda $600
	sbc #16
	sta $600
	dec $1E
	dec $1B
	rts


;************************************************
Tdn1:
	lda $1A
	bpl +
	rts

+
	lda $1E
	cmp #2
	bne +
	rts

+
	clc
	lda $600
	adc #16
	sta $600
	inc $1E
	dec $1A
	rts

;************************************************
Tst1:
	lda $19
	bpl +
	rts

+

	ldx $1E
	dec $11,x
	dec $19
	rts
	
