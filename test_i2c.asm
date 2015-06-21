
    LIST    P = 16f877a
    INCLUDE <p16f877a.inc>

    __CONFIG _CP_OFF & _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _LVP_OFF

ZERO    EQU D'0'
ONE     EQU D'1'
TWO     EQU D'2'
THREE   EQU D'3'
FOUR    EQU D'4'
FIVE    EQU D'5'
SIX     EQU D'6'
SEVEN   EQU D'7'
EIGHT   EQU D'8'
NINE    EQU D'9'

    CBLOCK  H'70'
        byte1
        byte2
        byte3
        byteW
    ENDC

    CBLOCK  h'20'
    d1
    d2
    d3
    d4
    operation
    ENDC


 ORG     H'0000'
Start
     banksel OPTION_REG
     movlw   B'11010111'
     movwf   OPTION_REG

     banksel TRISB
     movlw   B'00000000'
     movwf   TRISB

     banksel TRISA
     movlw   B'00000000'
     movwf   TRISA

     movlw  b'00000000'
     banksel PORTA
     movwf   PORTA

     movlw  b'11111111'
     banksel PORTB
     movwf   PORTB

    ;timer1 setup

    movlw       b'00110001'   ;bit 5-4 -> 00 prescaler = 1:1 bit 1-0 ->
    banksel     T1CON         ; -> internal clock enable timer 1
    movwf       T1CON
    banksel     PIR1
    clrf        PIR1
    clrf        PIR2
    movlw       b'00000000'  ;RCIF enable bit <5> and timer overflow ir
    banksel     PIE1
    movwf       PIE1
    clrf        PIE2
    clrf        INTCON
    banksel     TMR1H
    clrf        TMR1H
    clrf        TMR1L

;open i2c
    movlw       b'10000000'
    banksel     SSPSTAT
    movwf       SSPSTAT

    movlw       b'00101000'
    banksel     SSPCON
    movwf       SSPCON

    movlw       0x09
    banksel     SSPADD
    movwf       SSPADD

    movlw       b'00011000'   ;usart and i2c set
    banksel     TRISC
    movwf       TRISC
    banksel     PORTC
    bsf         PORTC,3
    bsf         PORTC,4


loop    nop


    banksel SSPCON2
    bsf	SSPCON2,SEN	; Send start bit
p0	btfsc	SSPCON2,SEN	; Has SEN cleared yet?
	goto	p0		; No, loop back to test.

;transmit first byte
    banksel PIR1
    bcf	PIR1,SSPIF

    banksel SSPBUF
    movlw   b'10010000'
    movwf   SSPBUF
   
    banksel PIR1
p1  btfss	PIR1,SSPIF	; has SSP completed sending EEPROM Address?
	goto	p1


    banksel SSPCON2
p2  btfsc   SSPCON2,ACKSTAT
    goto    p2


    banksel PIR1
    bcf     PIR1,SSPIF

    banksel SSPBUF
    movlw   0x00
    movwf   SSPBUF

    banksel PIR1
p4  btfss	PIR1,SSPIF
	goto	p4

    banksel SSPCON2
p5  btfsc   SSPCON2,ACKSTAT
    goto    p5

	bsf	SSPCON2,PEN	; send stop bit
p6	btfsc	SSPCON2,PEN	; has stop bit been sent?
	goto	p6		; no, loop back to test


banksel SSPCON2
    bsf	SSPCON2,SEN         ; Send start bit
    p7	btfsc	SSPCON2,SEN	; Has SEN cleared yet?
	goto	p7              ; No, loop back to test.

    banksel PIR1
    bcf	PIR1,SSPIF
    banksel SSPBUF
    movlw   b'10010001'
    movwf   SSPBUF
    banksel PIR1
p8  btfss	PIR1,SSPIF	; has SSP completed sending EEPROM Address?
	goto	p8

    banksel SSPCON2
p9  btfsc   SSPCON2,ACKSTAT
    goto    p9


;master switched to receiver
    banksel PIR1
    bcf	PIR1,SSPIF

    banksel SSPCON2
    bsf     SSPCON2,RCEN
    banksel PIR1
p10 btfss	PIR1,SSPIF	; has SSP received a data byte?
	goto	p10		; no, loop back to test

;ack first byte
    banksel SSPCON2
    bcf	SSPCON2,ACKDT	; no ACK
	bsf	SSPCON2,ACKEN	; send ACKDT bit

p11 btfsc	SSPCON2,ACKEN	; has ACKDT bit been sent yet?
	goto	p11

    banksel SSPBUF
    movfw   SSPBUF
    movwf   byte1

    banksel PIR1
    bcf	PIR1,SSPIF

    banksel SSPCON2
    bsf     SSPCON2,RCEN
    banksel PIR1
p12 btfss	PIR1,SSPIF	; has SSP received a data byte?
	goto	p12		; no, loop back to test


    banksel SSPBUF
    movfw   SSPBUF
    movwf   byte2

;ack second byte
    banksel SSPCON2
    bcf	SSPCON2,ACKDT	; no ACK
	bsf	SSPCON2,ACKEN	; send ACKDT bit

p13 btfsc	SSPCON2,ACKEN	; has ACKDT bit been sent yet?
	goto	p13

    bsf	SSPCON2,PEN	; send stop bit
p14	btfsc	SSPCON2,PEN	; has stop bit been sent?
	goto	p14





    banksel PORTA
    movlw   b'00000001'
    movwf   PORTA

    banksel PORTB
    movfw   byte1
    movwf   PORTB

    banksel d1
    movlw	0x08
	movwf	d1
	movlw	0x2F
	movwf	d2
	movlw	0x03
	movwf	d3
Delay_0
	decfsz	d1, f
	goto	$+2
	decfsz	d2, f
	goto	$+2
	decfsz	d3, f
	goto	Delay_0

			;3 cycles
	goto	$+1
	nop


    banksel PORTA
    movlw   b'00000010'
    movwf   PORTA

    banksel PORTB
    movfw   byte2
    movwf   PORTB


    banksel d1
    movlw	0x08
	movwf	d1
	movlw	0x2F
	movwf	d2
	movlw	0x03
	movwf	d3
Delay_1
	decfsz	d1, f
	goto	$+2
	decfsz	d2, f
	goto	$+2
	decfsz	d3, f
	goto	Delay_1



        goto loop

    END

