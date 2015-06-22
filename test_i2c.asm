
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

    CBLOCK  0x70
        byte1
        byte2
        byte3
        byteW
    ENDC

    CBLOCK  0x20
    d1
    d2
    d3
    d4
    operation
    ENDC

org 0x0800
i2c
    nop
    nop
    nop

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

    nop
    nop
    nop
    nop

; check for idle

    banksel SSPCON2
    btfsc   SSPCON2,ACKEN
    goto    $-1
    btfsc   SSPCON2,RCEN
    goto    $-3
    btfsc   SSPCON2,PEN
    goto    $-5
    btfsc   SSPCON2,RSEN
    goto    $-7
    btfsc   SSPCON2,SEN
    goto    $-9

; [start] address [wait for ack] address [wait for ack] [stop]

    banksel     SSPCON2     
    bsf         SSPCON2,SEN 
    btfsc       SSPCON2,SEN 
    goto        $-1

    banksel     SSPBUF
    movlw       b'10010000'
    movwf       SSPBUF

    banksel     PIR1        
    bcf         PIR1,SSPIF
    btfss       PIR1,SSPIF 
    goto        $-1
    bcf         PIR1,SSPIF

    banksel     SSPCON2
    btfsc       SSPCON2, ACKSTAT
    goto        $-1

    banksel PIR1
    bcf     PIR1,SSPIF

    banksel     SSPBUF
    movlw       b'00000000'
    movwf       SSPBUF

    banksel     PIR1                     
    btfss       PIR1,SSPIF               
    goto        $-1
    bcf         PIR1,SSPIF

    
    banksel     SSPCON2
    btfsc       SSPCON2, ACKSTAT
    goto        $-1
    

    



    ; check for idle

    banksel SSPCON2
    btfsc   SSPCON2,ACKEN
    goto    $-1
    btfsc   SSPCON2,RCEN
    goto    $-3
    btfsc   SSPCON2,PEN
    goto    $-5
    btfsc   SSPCON2,RSEN
    goto    $-7
    btfsc   SSPCON2,SEN
    goto    $-9


;repeated start
    banksel     SSPCON2
    bsf         SSPCON2,RSEN
    btfsc       SSPCON2,RSEN
    goto        $-1

    banksel     SSPBUF
    movlw       b'10010001'
    movwf       SSPBUF

    banksel     SSPSTAT
    btfss       SSPSTAT,BF
    goto        $-1
    btfsc       SSPSTAT,BF
    goto        $-1


    banksel     SSPCON2
    btfsc       SSPCON2, ACKSTAT
    goto        $

; check for idle

    banksel SSPCON2
    btfsc   SSPCON2,ACKEN
    goto    $-1
    btfsc   SSPCON2,RCEN
    goto    $-3
    btfsc   SSPCON2,PEN
    goto    $-5
    btfsc   SSPCON2,RSEN
    goto    $-7
    btfsc   SSPCON2,SEN
    goto    $-9


;enable receiver mode
;first byte
    bsf         SSPCON2, RCEN
    btfsc       SSPCON2, RCEN
    goto $-1

    banksel PIR1
    btfss   PIR1,SSPIF
    goto    $-1
    bcf     PIR1,SSPIF


    banksel SSPBUF
    movfw   SSPBUF
    banksel byte1
    movwf   byte1


    banksel     SSPCON2
    bcf         SSPCON2, ACKDT
    bsf         SSPCON2, ACKEN
    btfsc       SSPCON2, ACKEN
    goto        $-1

    banksel PIR1
    bcf     PIR1,SSPIF

    ; check for idle

    banksel SSPCON2
    btfsc   SSPCON2,ACKEN
    goto    $-1
    btfsc   SSPCON2,RCEN
    goto    $-3
    btfsc   SSPCON2,PEN
    goto    $-5
    btfsc   SSPCON2,RSEN
    goto    $-7
    btfsc   SSPCON2,SEN
    goto    $-9

;seconde byte
    bsf         SSPCON2, RCEN
    btfsc       SSPCON2, RCEN
    goto        $-1

    banksel PIR1
    btfss   PIR1,SSPIF
    goto    $-1
    bcf     PIR1,SSPIF

    banksel SSPBUF
    movfw   SSPBUF
    banksel byte2
    movwf   byte2


    banksel     SSPCON2
    bsf         SSPCON2, ACKDT
    bsf         SSPCON2, ACKEN
    btfsc       SSPCON2, ACKEN
    goto        $-1

    
;stop bit
    banksel    PIR1              
    bcf        PIR1,SSPIF
    banksel    SSPCON2           
    bsf        SSPCON2,PEN       
    banksel    PIR1              
    btfss      PIR1,SSPIF 
    goto       $-1


    goto    $

    return



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

     movlw  b'11100011'
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

    pagesel i2c
    call    i2c


loop    nop

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


    banksel     PIR1                                     ;bank0 (bank0? names) be sure
    bcf         PIR1,SSPIF
    banksel     SSPCON2                                    ;bank1
    bsf         SSPCON2,SEN     ;send i2c START [S] bit
    banksel     PIR1                                 ;bank0
r1  btfss       PIR1,SSPIF         ;start bit cycle complete?
    goto        r1               ; No, loop back to test.

    banksel     SSPBUF
    movlw       b'10010000'
    movwf       SSPBUF

    banksel     PIR1                     ;bank0
    bcf         PIR1,SSPIF
r2  btfss       PIR1,SSPIF                 ;ACK received?
    ;pagesel     r2
    goto        r2

    banksel     SSPBUF
    movlw       b'00000000'   ; last two bits indicate register to read 0 0 -> t reg 0 1 -> conf reg
    movwf       SSPBUF

    banksel        PIR1                     ;bank0
    bcf            PIR1,SSPIF
r3  btfss          PIR1,SSPIF                 ;ACK received?
    ;pagesel     r3
    goto        r3

    banksel    PIR1                                           ;bank0
    bcf        PIR1,SSPIF
    banksel    SSPCON2                                     ;bank1
    bsf        SSPCON2,PEN         ;send i2c STOP [P] bit
    banksel    PIR1                                           ;bank0
r4  btfss      PIR1,SSPIF             ;stop bit cycle completed?
    ;pagesel    r4
    goto       r4


    banksel     PIR1                                     ;bank0 (bank0? names) be sure
    bcf         PIR1,SSPIF
    banksel     SSPCON2                                    ;bank1
    bsf         SSPCON2,SEN     ;send i2c START [S] bit
    banksel     PIR1                                 ;bank0
r5  btfss       PIR1,SSPIF         ;start bit cycle complete?
    ;pagesel     r5
    goto        r5               ; No, loop back to test.

    banksel     SSPBUF
    movlw       b'10010001'
    movwf       SSPBUF

;wait for ack i2c
    banksel        PIR1                     ;bank0
    bcf            PIR1,SSPIF
r6  btfss          PIR1,SSPIF                 ;ACK received?
    ;pagesel     r6
    goto           r6

;repeated start - enable receiving
    banksel        SSPCON2                                   ;bank1
    bsf            SSPCON2,RCEN     ;enable receiving at master 16f877

;receive
    banksel     PIR1
r7  nop
    pagesel     r7
    btfss       PIR1,SSPIF
    ;pagesel     r7
    goto        r7
    bcf         PIR1,SSPIF
    banksel     SSPBUF
    movfw       SSPBUF

;send ack

    banksel     SSPCON2
    bcf         SSPCON2,ACKDT
    bsf         SSPCON2,ACKEN
r8  btfsc       SSPCON2,ACKEN
    ;pagesel     r8
    goto        r8
    bsf         SSPCON2,RCEN

    banksel     byte1
    movwf       byte1

    banksel     PIR1
r9  nop
    pagesel     r9
    btfss       PIR1,SSPIF
    goto        r9
    bcf         PIR1,SSPIF
   
;send ack

    banksel     SSPCON2
    bcf         SSPCON2,ACKDT
    bsf         SSPCON2,ACKEN
r10 btfsc       SSPCON2,ACKEN
    goto        r10
    bsf         SSPCON2,RCEN

    banksel     SSPBUF
    movfw       SSPBUF

    banksel     byte2
    movwf       byte2

;--------
    banksel     PIR1
r19  nop
    pagesel     r19
    btfss       PIR1,SSPIF
    goto        r19
    bcf         PIR1,SSPIF
    
;send ack

    banksel     SSPCON2
    bsf         SSPCON2,ACKDT
    bsf         SSPCON2,ACKEN
r110 btfsc       SSPCON2,ACKEN
    goto        r110

    banksel     SSPBUF
    movfw       SSPBUF

    banksel     byte3
    movwf       byte3
    ;bsf         SSPCON2,RCEN
;-----
    ;banksel     SSPBUF
   ; movfw       SSPBUF

   ; banksel     byte3
   ; movwf       byte3

    banksel    PIR1                                           ;bank0
    bcf        PIR1,SSPIF
    banksel    SSPCON2                                     ;bank1
    bsf        SSPCON2,PEN         ;send i2c STOP [P] bit
    banksel    PIR1                                           ;bank0
r11 btfss      PIR1,SSPIF             ;stop bit cycle completed?
    ;pagesel    r11
    ;goto       r11



    banksel PORTA
    movlw   b'00000001'
    movwf   PORTA

    banksel byte2
    movfw   byte2
    banksel PORTB
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

    banksel byte3
    movfw   byte3
    banksel PORTB
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

