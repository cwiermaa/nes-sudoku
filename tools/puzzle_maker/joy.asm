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
	sec
	lda $2A
	sbc #12
	sta $2A
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
	sec
	lda $2A
	sbc #12
	sta $2A
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
	clc
	lda $2A
	adc #12
	sta $2A
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
	clc
	lda $2A
	adc #12
	sta $2A
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
	dec $2A
	dec $21
	bpl +
	sec
	lda $603
	sbc #8
	sta $603
	lda #2
	sta $21
	dec $10
	dec $2A
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
	inc $2A
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
	inc $2A
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
	and #$1F
	sta $2F
	lda $2F
	cmp #$1A
	bne +
	lda #88
	sta $607
	lda #$11
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
	ldx $2A
	sta $6000,x
	dec $19
	rts
;***************************************************************
bkey:
	lda $1A
	bpl +
	rts
+
	
	ldx $30
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
	ldx $2A
	sta $6000,x
	dec $1A
	rts
;***************************************************************
start:
	lda $1B
	bpl +
	rts
+
	lda $22
	eor #$C0
	sta $22
	dec $1B
	rts