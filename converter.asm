; Async->Sync PPP converter. CPU@16.0Mhz, 85c30@7.3728Mhz
; � The Serial Port 1996
;
; v0.01 19/04/96 Hugo Fiennes
; v0.02 20/04/96 Hugo Fiennes - Working! With flow control & all!
;

	.avsym 
				;*** Constants ***
RAMBASE		.equ 4000H      ; base address of external data/program RAM
ADATA		.equ 0C300H	; 8052
ACOMMAND	.equ 0C200H	; 8052
BDATA		.equ 0C100H	; 8052
BCOMMAND	.equ 0C000H	; 8052

BAUDRATE        .equ 000H       ; Async rate to set (0e=57600, 1e=115200)
DIVISOR         .equ 040H       ; Divisor (0=x1, 40=x16, 80=x32, c0=x64)
				;*** Registers ***

R0		.equ 0000H 
R1		.equ 0001H
R2		.equ 0002H
R3		.equ 0003H
R4		.equ 0004H
R5		.equ 0005H
R6		.equ 0006H
R7		.equ 0007H

				;*** Memory Variables ***

;locations 0000 to 0007 are registers R0 to R7
;locations 0008 to 001F are stack (increments)
;locations 0030 to 007F are directly addressably user ram
;locations 0080 to 00FF are indirectly addressably user ram,
;and directly addressable special function registers

ARXHEADL        .equ 0030H
ARXHEADH	.equ 0031H
ARXTAILL	.equ 0032H
ARXTAILH	.equ 0033H
ARXUSEDL	.equ 0034H
ARXUSEDH	.equ 0035H
ARXPACKETS	.equ 0036H

PAUSE           .equ 0037H
RTSISLOW	.equ 0038H

				;*** Special Function Registers ***

SP		.equ 0081H
DPL		.equ 0082H
DPH		.equ 0083H
PCON		.equ 0087H
TCON		.equ 0088H
TMOD		.equ 0089H
TL0		.equ 008AH
TL1		.equ 008BH
TH0		.equ 008CH
TH1		.equ 008DH
P1		.equ 0090H
S0CON		.equ 0098H
S0BUF		.equ 0099H
IEN0		.equ 00A8H
;CML0		.equ 00A9H
;CML1		.equ 00AAH
;CML2		.equ 00ABH
;CTL0		.equ 00ACH
;CTL1		.equ 00ADH
;CTL2		.equ 00AEH
;CTL3		.equ 00AFH
P3		.equ 00B0H
IP0		.equ 00B8H
;P4		.equ 00C0H
;P5		.equ 00C4H
;ADCON		.equ 00C5H
;ADCH		.equ 00C6H
TM2IR		.equ 00C8H
;CMH0		.equ 00C9H
;CMH1		.equ 00CAH
;CMH2		.equ 00CBH
CTH0		.equ 00CCH
CTH1		.equ 00CDH
;CTH2		.equ 00CEH
;CTH3		.equ 00CFH
PSW		.equ 00D0H
;S1CON		.equ 00D8H
;S1STA		.equ 00D9H
;S1DAT		.equ 00DAH
;S1ADR		.equ 00DBH
ACC		.equ 00E0H
;IEN1		.equ 00E8H
;TM2CON		.equ 00EAH
;TML2		.equ 00ECH
;TMH2		.equ 00EDH
;CTCON		.equ 00EBH
;STE		.equ 00EEH
;RTE		.equ 00EFH
B		.equ 00F0H
;IP1		.equ 00F8H
;PWM0		.equ 00FCH
;PWM1		.equ 00FDH
;PWMP		.equ 00FEH
;T3		.equ 00FFH

				;*** Bit Variables ***

WBOOT		.equ 0020H
TCON.0		.equ 0088H
TCON.1		.equ 0089H
TCON.2		.equ 008AH
TCON.3		.equ 008BH
TCON.4		.equ 008CH
TCON.5		.equ 008DH
TCON.6		.equ 008EH
TCON.7		.equ 008FH
P1.0		.equ 0090H
P1.1		.equ 0091H
P1.2		.equ 0092H
P1.3		.equ 0093H
P1.4		.equ 0094H
P1.5		.equ 0095H
P1.6		.equ 0096H
P1.7		.equ 0097H
S0CON.0		.equ 0098H
S0CON.1		.equ 0099H
S0CON.2		.equ 009AH
S0CON.3		.equ 009BH
S0CON.4		.equ 009CH
S0CON.5		.equ 009DH
S0CON.6		.equ 009EH
S0CON.7		.equ 009FH
IEN0.0		.equ 00A8H
IEN0.1		.equ 00A9H
IEN0.2		.equ 00AAH
IEN0.3		.equ 00ABH
IEN0.4		.equ 00ACH
IEN0.5		.equ 00AFH
IEN0.6		.equ 00ACH
IEN0.7		.equ 00AFH
P3.0		.equ 00B0H
P3.1		.equ 00B1H
P3.2		.equ 00B2H
P3.3		.equ 00B3H
P3.4		.equ 00B4H
P3.5		.equ 00B5H
P3.6		.equ 00B6H
P3.7		.equ 00B7H
IP0.0		.equ 00B8H
IP0.1		.equ 00B9H
IP0.2		.equ 00BAH
IP0.3		.equ 00BBH
IP0.4		.equ 00BCH
IP0.5		.equ 00BDH
IP0.6		.equ 00BEH 
;P4.0		.equ 00C0H
;P4.1		.equ 00C1H
;P4.2		.equ 00C2H
;P4.3		.equ 00C3H
;P4.4		.equ 00C4H
;P4.5		.equ 00C5H
;P4.6		.equ 00C6H
;P4.7		.equ 00C7H
TM2IR.0		.equ 00C8H
TM2IR.1		.equ 00C9H
TM2IR.2		.equ 00CAH
TM2IR.3		.equ 00CBH
TM2IR.4		.equ 00CCH
TM2IR.5		.equ 00CDH
TM2IR.6		.equ 00CEH
TM2IR.7		.equ 00CFH
PSW.0		.equ 00D0H
PSW.1		.equ 00D1H
PSW.2		.equ 00D2H
PSW.3		.equ 00D3H
PSW.4		.equ 00D4H
PSW.5		.equ 00D5H
PSW.6		.equ 00D6H
PSW.7		.equ 00D7H
;S1CON.0		.equ 00D8H
;S1CON.1		.equ 00D9H
;S1CON.2		.equ 00DAH
;S1CON.3		.equ 00DBH
;S1CON.4		.equ 00DCH
;S1CON.5		.equ 00DDH
;S1CON.6		.equ 00DEH
;S1CON.7		.equ 00DFH
ACC.0		.equ 00E0H
ACC.1		.equ 00E1H
ACC.2		.equ 00E2H
ACC.3		.equ 00E3H
ACC.4		.equ 00E4H
ACC.5		.equ 00E5H
ACC.6		.equ 00E6H
ACC.7		.equ 00E7H
;IEN1.0		.equ 00E8H
;IEN1.1		.equ 00E9H
;IEN1.2		.equ 00EAH
;IEN1.3		.equ 00EBH
;IEN1.4		.equ 00ECH
;IEN1.5		.equ 00EFH
;IEN1.6		.equ 00ECH
;IEN1.7		.equ 00EFH
B.0		.equ 00F0H 
B.1		.equ 00F1H
B.2		.equ 00F2H
B.3		.equ 00F3H
B.4		.equ 00F4H
B.5		.equ 00F5H
B.6		.equ 00F6H
B.7		.equ 00F7H
;IP1.0		.equ 00F8H
;IP1.1		.equ 00F9H
;IP1.2		.equ 00FAH
;IP1.3		.equ 00FBH
;IP1.4		.equ 00FCH
;IP1.5		.equ 00FDH
;IP1.6		.equ 00FEH
;IP1.7		.equ 00FFH

				;*** vectors ***

	.org	0000H

RESET:

	LJMP	START		;Reset vector jumps to program start

	.org	0003H

EXTINT0:

	LJMP	EXTINT0		;jump to equivalent ram vector

	.org	000BH

TIMER0:      

	LJMP	TIMER0		;jump to equivalent ram vector

	.org	0013H

EXTINT1:

	LJMP	EXTINT1		;jump to equivalent ram vector

	.org	001BH

TIMER1:

	LJMP	TIMER1		;jump to equivalent ram vector

	.org	0023H

RXTX:          

	LJMP	RXTX		;jump to equivalent ram vector

	.org	002BH

IIC:

	LJMP	IIC		;jump to equivalent ram vector  

	.org	0033H

T2CAP0:

	LJMP	T2CAP0		;jump to equivalent ram vector    

	.org	003BH

T2CAP1:

	LJMP	T2CAP1		;jump to equivalent ram vector

	.org	0043H

T2CAP2:

	LJMP	T2CAP2		;jump to equivalent ram vector

	.org	004BH

T2CAP3:

	LJMP	T2CAP3		;jump to equivalent ram vector 

	.org	0053H

ADC:

	LJMP	ADC		;jump to equivalent ram vector

	.org	005BH

T2COM0:

	LJMP	T2COM0		;jump to equivalent ram vector

	.org	0063H

T2COM1:

	LJMP	T2COM1		;jump to equivalent ram vector

	.org	006BH

T2COM2:

	LJMP	T2COM2		;jump to equivalent ram vector

	.org	0073H

T2OVER:

	LJMP	T2OVER		;jump to equivalent ram vector

				;*** program starts here, finally!!! ***

	.org	0100H

; uart mapping:
; a8=d/-c
; a9=a/-b
;
; so: $C000=command b
;     $C100=data b
;     $C200=command a
;     $C300=data a
;
; intack=p1.0

COPYRIGHT:
        .text   "Async to Sync PPP converter. "
        .text   "Set Async to 115200, sync device to 64k, clock on pin 17. "
        .text   "Copyright 1996 Hugo Fiennes of The Serial Port. "
        .text	"email: altman@cryton.demon.co.uk "
START:
	; Clear all IRQ masks
	CLR     IEN0
	CLR	IEN1
	
	MOV	PCON,#80H	;enable baud rate doubling
	MOV	S0CON,#52H	;enable 8 bit uart mode for serial port 0, enable rx
	MOV	TMOD,#20H	;set timer 1 8 bit auto reload, timer 0 13 bit
	MOV	TH1,#0FCH	;set baud rate to 1200 (0F8H for 2400)
	SETB	TCON.6		;start baud rate generator

	; Reset the 8530
	MOV	DPTR,#ACOMMAND
	MOV	A,#009H 	; Access to WR9
	MOVX	@DPTR,A
	MOV	A,#0C0H		; Reset chip
	MOVX	@DPTR,A
	NOP
	NOP
	NOP
	NOP
	MOV	A,#009H 	; Access to WR9
	MOVX	@DPTR,A
	MOV	A,#000H		; Clear reset
	MOVX	@DPTR,A

	MOV	DPTR,#ACOMMAND
	MOV	A,#009H 	; Access to WR9
	MOVX	@DPTR,A
	MOV	A,#080H		; Reset A
	MOVX	@DPTR,A
	NOP
	NOP
	NOP
	NOP
	MOV	A,#009H 	; Access to WR9
	MOVX	@DPTR,A
	MOV	A,#000H		; Clear reset
	MOVX	@DPTR,A
	
	MOV	DPTR,#ACOMMAND
	MOV	A,#009H 	; Access to WR9
	MOVX	@DPTR,A
	MOV	A,#040H		; Reset B
	MOVX	@DPTR,A
	NOP
	NOP
	NOP
	NOP
	MOV	A,#009H 	; Access to WR9
	MOVX	@DPTR,A
	MOV	A,#000H		; Clear reset
	MOVX	@DPTR,A

	;--- Channel B setup -------------------------
	; Do some setup on channel A
	MOV	DPTR,#BCOMMAND

	; Time constant
	MOV	A,#00CH
	MOVX	@DPTR,A
	MOV	A,#BAUDRATE
	MOVX	@DPTR,A
	MOV	A,#00DH
	MOVX	@DPTR,A
	MOV	A,#000H
	MOVX	@DPTR,A

	MOV	A,#001H		; Access to WR1
	MOVX	@DPTR,A
	MOV	A,#003H         ; Enable TX IRQs
	MOVX	@DPTR,A

	MOV	A,#003H		; Access to WR3
	MOVX	@DPTR,A
	MOV	A,#0C1H		; Rx 8 bits, Rx enable
	MOVX	@DPTR,A

	MOV	A,#004H		; Access to WR4
	MOVX	@DPTR,A
	MOV	A,#(004H+DIVISOR); 1 stop bit, no parity
	MOVX	@DPTR,A
	
	MOV	A,#005H		; Access to WR5
	MOVX	@DPTR,A
	MOV	A,#0EAH		; DTR, RTS, Tx 8 bits, Tx enable
	MOVX	@DPTR,A
	
	MOV	A,#009H		; Access to WR9
	MOVX	@DPTR,A
	MOV	A,#000H		; Master IE (=8)
	MOVX	@DPTR,A

	MOV	A,#00BH		; Access to WR11
	MOVX	@DPTR,A
	MOV	A,#050H		; Use baud generator
	MOVX	@DPTR,A

	MOV	A,#00EH		; Access to WR14
	MOVX	@DPTR,A
	MOV	A,#003H		; Baud generator enable
	MOVX	@DPTR,A

	; Enable IRQs
	MOV	IEN0,#000H      ; Enable EXT0
		
	; LED outputs
	MOV 	P1,#0		; Enable all P1 outputs
 	CLR	P1.0		; 0=sync mode
 	CLR	P1.1            ; 1=packet out
 	CLR	P1.2            ; 2=packet in
 	
 	; Do a steppy thing with leds for check
 	MOV     R2,#6
FLASHY:
 	MOV     R0,#0
 	MOV     R1,#200
      	SETB    P1.0
L1:     DJNZ	R0,L1
	DJNZ	R1,L1
 	MOV     R1,#200
        SETB	P1.1
L2:     DJNZ	R0,L2
	DJNZ	R1,L2
 	MOV     R1,#200
        SETB	P1.2
L3:     DJNZ	R0,L3
	DJNZ	R1,L3
 	MOV     R1,#200
 	CLR     P1.0
L4:     DJNZ	R0,L4
	DJNZ	R1,L4
 	MOV     R1,#200
        CLR	P1.1
L5:     DJNZ	R0,L5
	DJNZ	R1,L5
 	MOV     R1,#200
        CLR	P1.2
L6:     DJNZ	R0,L6
	DJNZ	R1,L6
	DJNZ	R2,FLASHY

	; Async->Sync buffer pointers
	MOV     A,#0
	MOV	ARXHEADL,A
	MOV	ARXTAILL,A
	MOV	ARXUSEDL,A
	MOV	ARXUSEDH,A
	MOV	ARXPACKETS,A
	MOV	A,#(ARXBUFFER>>8)
	MOV	ARXHEADH,A
	MOV	ARXTAILH,A

	; R2=sync tx state
	; R3=async 'data in this packet' flag
	; R4=async rx state
	; R5=frame in progress flag (1=in progress)
        ; R6=async tx head
        ; R7=async tx tail	        
        MOV     R1,#0
        MOV     R2,#0
        MOV     R3,#0
        MOV     R4,#0
        MOV     R5,#0
        MOV     R6,#0
        MOV	R7,#0

LOOP_ASYNC_START:
	; Initialise A as async port
	ACALL   SETUP_ASYNC
	CLR	P1.0
	MOV	PAUSE,#255	

	; Turn on RTS
	MOV	DPTR,#BCOMMAND
	MOV	A,#005H		; Access to WR5
	MOVX	@DPTR,A
	MOV	A,#0EAH		; DTR, RTS, Tx 8 bits, Tx enable
	MOVX	@DPTR,A

LOOP_ASYNC:
	; Check DCD, switch if necessary
        MOV     DPTR,#ACOMMAND
        MOV	A,#010H         ; Reset DCD/CTS status
	MOVX	@DPTR,A

        MOVX	A,@DPTR         ; Get status
        ANL	A,#(1<<3)	; DCD?
        JZ	ZARX

        ; DCD has gone high - wait a bit before going into sync mode
        DJNZ    PAUSE,ZARX
        
        ; Enter sync mode
        AJMP    LOOP_SYNC_START

ZARX:   ; Simply copy data from A to B, and vice-versa
	MOV     DPTR,#ACOMMAND
	MOVX	A,@DPTR
	ANL	A,#1            ; Any data?
	JZ      ZBRX
	
	MOV     DPTR,#ADATA
	MOVX	A,@DPTR         ; Get byte
	MOV	DPTR,#BDATA
	MOVX	@DPTR,A         ; Put byte
	
ZBRX:   
	MOV     DPTR,#BCOMMAND
	MOVX	A,@DPTR
	ANL	A,#1            ; Any data?
	JZ      ZEND
	
	MOV     DPTR,#BDATA
	MOVX	A,@DPTR         ; Get byte
	MOV	DPTR,#ADATA
	MOVX	@DPTR,A         ; Put byte

ZEND:
        AJMP    LOOP_ASYNC
        
LOOP_SYNC_START:
	; Initialise A as sync port
	ACALL   SETUP_SYNC	
	SETB	P1.0

	; Turn on RTS
	MOV	DPTR,#BCOMMAND
	MOV	A,#005H		; Access to WR5
	MOVX	@DPTR,A
	MOV	A,#0EAH		; DTR, RTS, Tx 8 bits, Tx enable
	MOVX	@DPTR,A

LOOP_SYNC:
	; Check DCD, do sync/async accordingly
        MOV     DPTR,#ACOMMAND
        MOV	A,#010H         ; Reset DCD/CTS status
	MOVX	@DPTR,A

        MOVX	A,@DPTR         ; Get status
        ANL	A,#(1<<3)	; DCD?
        JNZ	ARX

        ; Lost carrier! Back to russia!
        AJMP    LOOP_ASYNC_START
	
ARX:	;--- Poll async RX
	MOV     DPTR,#BCOMMAND
	MOVX	A,@DPTR         ; Read RR0
	ANL	A,#1		; Any data?
	JZ	ARX_EXIT       	; No...
	
        MOV     DPTR,#BDATA     ; Get data
        MOVX	A,@DPTR
        MOV	R0,A            ; Save it
        
        ; Check state
        CJNE	R4,#0,ARX_S1

        ; R4=0, looking for a flag
	CJNE	R0,#07EH,ARX_EXIT ; A flag? If not, exit
	MOV	R4,#1           ; 'We got a flag' state
	MOV	R3,#0		; Reset data count
	AJMP	ARX_EXIT	; Go away!
	
ARX_S1: CJNE	R0,#07EH,ARX_BUFFER ; Buffer it if it isn't a flag

        ; Second flag: got anything yet?
        CJNE    R3,#1,ARX_EXIT  ; If no data, might have been false start.
                                ; Carry on in this state
        
        ; We've got a full packet: note this and buffer a zero to indicate end
        MOV	R0,#0           ; (will get buffered next)
        MOV	R4,#0
        INC	ARXPACKETS	; Inc packet count in buffer

ARX_BUFFER:
        ; Check used pointer
	MOV	A,ARXUSEDH      ; Get high byte of used
	CJNE	A,#(ARXSIZE>>8),ARX_ROOM ; Room in buffer?
	AJMP	ARX_EXIT        ; No room - junk it!
	
ARX_ROOM:
	MOV     R3,#1           ; We have had some data!

	; Just store byte
	INC     ARXUSEDL        ; Increment used count
	MOV	A,ARXUSEDL      ; Wrapped?
	JNZ	ARX_1		; No
	INC	ARXUSEDH        ; Inc high byte
	
	; Flow control! If we have reached the high-water-mark, turn off B's RTS
	MOV     A,ARXUSEDH      ; Reached it?
	CJNE	A,#(ARXHIGH>>8),ARX_1 ; No.
	
	; Reached it - turn off RTS
	MOV	DPTR,#BCOMMAND
	MOV	A,#005H		; Access to WR5
	MOVX	@DPTR,A
	MOV	A,#0E8H		; DTR, no RTS, Tx 8 bits, Tx enable
	MOVX	@DPTR,A
 
ARX_1:  MOV	DPL,ARXHEADL	; Set up DPTR
	MOV	DPH,ARXHEADH
	MOV	A,R0            ; Get data
	MOVX	@DPTR,A         ; Store it
	INC	ARXHEADL	; Bump head pointer
	MOV	A,ARXHEADL	; Wrapped?
	JNZ	ARX_EXIT
	INC	ARXHEADH        ; Inc high
	MOV	A,ARXHEADH	; Looped?
	CJNE	A,#((ARXSIZE>>8)+(ARXBUFFER>>8)),ARX_EXIT
	MOV	ARXHEADH,#(ARXBUFFER>>8) ; Looped!

ARX_EXIT:
        
STX:	;--- Poll sync TX
	MOV     DPTR,#ACOMMAND
	MOVX	A,@DPTR         ; Read RR0
	ANL	A,#4		; Can we send?
	JNZ	STX_0       	; Yes!
	AJMP    STX_EXIT        ; No - exit

STX_0:
	CJNE    R2,#0,STX_S1    ; Waiting for packet to send?
	
        MOV     A,ARXPACKETS    ; Anything in tx buffer?
        JNZ	STX_0A          ; Yep, send them!
        AJMP    STX_EXIT        ; Nope, exit
        
STX_0A:
        MOV	R2,#1           ; Now in 'send packet' state!
        MOV	R1,#0		; Mental note to clear tx underrun on 1st byte
        
        SETB    P1.1            ; Sending a packet
STX_S1: CJNE    R2,#1,STX_S2    ; Waiting for TX underrun?

	MOV     A,ARXUSEDL      ; Dec used count
	DEC	ARXUSEDL        ; Wrapped?
	JNZ	STX_S1A         ; No
	DEC	ARXUSEDH	; Dec high count

	; Flow control! If we have reached the low-water-mark, turn on B's RTS
	MOV     A,ARXUSEDH      ; Reached it?
	CJNE	A,#(ARXLOW>>8),STX_S1A ; No.
	
	; Reached it - turn on RTS
	MOV	DPTR,#BCOMMAND
	MOV	A,#005H		; Access to WR5
	MOVX	@DPTR,A
	MOV	A,#0EAH		; DTR, RTS, Tx 8 bits, Tx enable
	MOVX	@DPTR,A
 
STX_S1A:
        MOV	DPL,ARXTAILL	; Setup DPTR
	MOV	DPH,ARXTAILH
	MOVX	A,@DPTR         ; Get byte from buffer
	MOV	R0,A
	INC	ARXTAILL        ; Bump tail
	MOV	A,ARXTAILL	; Wapped?
	JNZ     STX_2		; No...
	INC	ARXTAILH        ; Inc high
	MOV	A,ARXTAILH      ; Looped?
	CJNE	A,#((ARXSIZE>>8)+(ARXBUFFER>>8)),STX_2
	MOV	ARXTAILH,#(ARXBUFFER>>8) ; Looped!

STX_2:  CJNE    R0,#07DH,STX_3  ; Escape?

	; Was escape, get next character, process & send	
	MOV     A,ARXUSEDL      ; Dec used count
	DEC	ARXUSEDL        ; Wrapped?
	JNZ	STX_2A          ; No
	DEC	ARXUSEDH	; Dec high count

	; Flow control! If we have reached the low-water-mark, turn on B's RTS
	MOV     A,ARXUSEDH      ; Reached it?
	CJNE	A,#(ARXLOW>>8),STX_2A ; No.
	
	; Reached it - turn on RTS
	MOV	DPTR,#BCOMMAND
	MOV	A,#005H		; Access to WR5
	MOVX	@DPTR,A
	MOV	A,#0EAH		; DTR, RTS, Tx 8 bits, Tx enable
	MOVX	@DPTR,A
 
STX_2A:
        MOV	DPL,ARXTAILL	; Setup DPTR
	MOV	DPH,ARXTAILH
	MOVX	A,@DPTR         ; Get byte from buffer
	XRL	A,#020H		; EOR bits as preceded by flag
	MOV	R0,A
	INC	ARXTAILL        ; Bump tail
	MOV	A,ARXTAILL	; Wapped?
	JNZ     STX_4		; No...
	INC	ARXTAILH        ; Inc high
	MOV	A,ARXTAILH      ; Looped?
	CJNE	A,#((ARXSIZE>>8)+(ARXBUFFER>>8)),STX_4
	MOV	ARXTAILH,#(ARXBUFFER>>8) ; Looped!
	AJMP	STX_4           ; Send it  
	
STX_3:  CJNE    R0,#0,STX_4     ; End of packet?

        ; End of packet - dec packet count & go back to state 0
        DEC     ARXPACKETS
        MOV	R2,#2
        AJMP	STX_EXIT        ; All done
	
STX_4: 	MOV	DPTR,#ADATA	; Send to UART
	MOV	A,R0		; Retrieve data
	MOVX	@DPTR,A 	; Send it
	
	CJNE    R1,#0,STX_EXIT  ; Only do this on 1st byte sent
	MOV	R1,#1           ; Dont do it again!
	
	AJMP	STX_EXIT
	
STX_S2: 
	INC     R2
	CJNE	R2,#20,STX_EXIT

	CLR     P1.1            ; Not sending a packet anymore
	MOV     R2,#0           ; We've underrun, can send next packet	
STX_EXIT:

ATX:	;--- Poll async TX
	MOV     DPTR,#BCOMMAND
	MOVX	A,@DPTR         ; Read RR0
	ANL	A,#4		; Can we send?
	JZ	SRX         	; No...
		
	MOV     A,R6            ; Get head...
	XRL	A,R7		; Same as tail?
	JZ	SRX		; If so, buffer empty
	
	MOV     DPTR,#ATXBUFFER ; DPTR->buffer
	MOV	DPL,R7		; DPTR->tail
	MOVX	A,@DPTR		; Get data to send
	MOV	DPTR,#BDATA 	; Data data reg
	MOVX	@DPTR,A		; Send byte
	INC	R7		; Bump tail
	
SRX:    ;--- Poll for sync RX
	MOV     DPTR,#ACOMMAND
	MOVX	A,@DPTR         ; Read RR0
	ANL	A,#1		; Data ready?
	JZ	SRX_EXIT
	
	MOV     DPTR,#ADATA
	MOVX	A,@DPTR         ; Read data
	MOV	R0,A		; Save it
	
	CJNE    R5,#0,ALREADYSTARTED ; Frame started?
	
	; Buffer a flag byte	
	MOV     R5,#1           ; Note start
	MOV	DPTR,#ATXBUFFER ; DPTR->buffer
	MOV	DPL,R6          ; DPTR->head
	MOV	A,#07EH		; Flag
	MOVX	@DPTR,A         ; Data in buffer
	INC	R6              ; Bump head
	
	SETB    P1.2            ; Getting a packet
ALREADYSTARTED:
	MOV     A,R0            ; Get data
	CJNE    A,#07EH,NOT1    ; Sync? Escape it!
	AJMP    ESCIT
NOT1:   CJNE	A,#07DH,NOT2    ; Escape? Escape it!
	AJMP	ESCIT
NOT2:	ANL     A,#0E0H         ; Less than 020H?
	JNZ	NOESC
	
ESCIT:	; Buffer an escape
	MOV	DPTR,#ATXBUFFER ; DPTR->buffer
	MOV	DPL,R6          ; DPTR->head
	MOV	A,#07DH		; Escape
	MOVX	@DPTR,A         ; Data in buffer
	INC	R6              ; Bump head

        MOV     A,R0            ; Get A
        XRL	A,#020H		; EOR with 020H
        MOV	R0,A		; Put it back
        
NOESC:  ; Buffer data
	MOV	DPTR,#ATXBUFFER ; DPTR->buffer
	MOV	DPL,R6          ; DPTR->head
	MOV	A,R0		; Get A
	MOVX	@DPTR,A         ; Data in buffer
	INC	R6              ; Bump head

	AJMP    SRX             ; Try to empty FIFO
        
SRX_EXIT:

EOFCHECK:
        ; Check for end-of-frame
	CJNE    R5,#1,EOFCHECK_EXIT
	                        ; Waiting for end of frame?
	MOV     DPTR,#ACOMMAND
	MOV	A,#1            ; Access RR1
	MOVX	@DPTR,A
	MOVX	A,@DPTR         ; Read RR1
	ANL	A,#080H		; End of frame?
	JZ	EOFCHECK_EXIT	; Nope

        MOVX    A,@DPTR         ; Check data ready
        ANL	A,#1		
        JNZ	EOFCHECK_EXIT   ; Data is ready - probably not actually
        			; EOF yet then!
	
	; Buffer a flag byte	
	MOV     R5,#0           ; Set end of frame
	MOV	DPTR,#ATXBUFFER ; DPTR->buffer
	MOV	DPL,R6          ; DPTR->head
	MOV	A,#07EH		; Flag
	MOVX	@DPTR,A         ; Data in buffer
	INC	R6              ; Bump head

        CLR     P1.2            ; Not receiving anymore	
EOFCHECK_EXIT:
	AJMP    LOOP_SYNC

SETUP_SYNC:
	;--- Channel A setup -------------------------
	; Do some setup on channel A
	MOV	DPTR,#ACOMMAND

	MOV	A,#001H		; Access to WR1
	MOVX	@DPTR,A
	MOV	A,#000H		; No RX irqs
	MOVX	@DPTR,A

	MOV	A,#004H		; Access to WR4
	MOVX	@DPTR,A
	MOV	A,#020H		; SDLC, Sync mode enable
	MOVX	@DPTR,A
	
	MOV	A,#005H		; Access to WR5
	MOVX	@DPTR,A
	MOV	A,#068H		; TX enable
	MOVX	@DPTR,A		
	
	MOV	A,#007H		; Access to WR7
	MOVX	@DPTR,A
	MOV	A,#07EH		; 01111110
	MOVX	@DPTR,A

	MOV	A,#00AH		; Access to WR10
	MOVX	@DPTR,A
	MOV	A,#080H
	MOVX	@DPTR,A

	MOV	A,#00BH		; Access to WR11
	MOVX	@DPTR,A
	MOV	A,#000H		; External tx/rx clock on RTxC
	MOVX	@DPTR,A

	MOV	A,#00EH		; Access to WR14
	MOVX	@DPTR,A
	MOV	A,#000H		; Source = RTxC 0A0
	MOVX	@DPTR,A

	MOV	A,#00FH		; Access to WR15
	MOVX	@DPTR,A
	MOV	A,#041H
	MOVX	@DPTR,A
	
	MOV	A,#007H		; Access to WR7'
	MOVX	@DPTR,A
	MOV	A,#020H         ; was 22
	MOVX	@DPTR,A
	
	MOV	A,#003H		; Access to WR3
	MOVX	@DPTR,A
	MOV	A,#0C1H		; Rx 8 bits, Rx enable
	MOVX	@DPTR,A

	MOV	A,#080H		; Reset TX crc gen
	MOVX	@DPTR,A

	MOV     DPTR,#ACOMMAND  ; Clear underrun command
	MOV	A,#0C0H
	MOVX	@DPTR,A

	RET

SETUP_ASYNC:
	;--- Channel A setup -------------------------
	; Setup A to be async
	MOV	DPTR,#ACOMMAND

	; Time constant
	MOV	A,#00CH
	MOVX	@DPTR,A
	MOV	A,#BAUDRATE
	MOVX	@DPTR,A
	MOV	A,#00DH
	MOVX	@DPTR,A
	MOV	A,#000H
	MOVX	@DPTR,A

	MOV	A,#001H		; Access to WR1
	MOVX	@DPTR,A
	MOV	A,#003H         ; Enable TX IRQs
	MOVX	@DPTR,A

	MOV	A,#003H		; Access to WR3
	MOVX	@DPTR,A
	MOV	A,#0C1H		; Rx 8 bits, Rx enable
	MOVX	@DPTR,A

	MOV	A,#004H		; Access to WR4
	MOVX	@DPTR,A
	MOV	A,#(004H+DIVISOR) ; 1 stop bit, no parity
	MOVX	@DPTR,A
	
	MOV	A,#005H		; Access to WR5
	MOVX	@DPTR,A
	MOV	A,#0E8H		; DTR, Tx 8 bits, Tx enable
	MOVX	@DPTR,A
	
	MOV	A,#009H		; Access to WR9
	MOVX	@DPTR,A
	MOV	A,#000H		; Master IE (=8)
	MOVX	@DPTR,A

	MOV	A,#00BH		; Access to WR11
	MOVX	@DPTR,A
	MOV	A,#050H		; Use baud generator
	MOVX	@DPTR,A

	MOV	A,#00EH		; Access to WR14
	MOVX	@DPTR,A
	MOV	A,#003H		; Baud generator enable
	MOVX	@DPTR,A

        RET
        
ATXBUFFER .equ 04500H ; 256 bytes

ARXSIZE   .equ 8192   ; 8k rx buffer
ARXHIGH   .equ 7168   ; 7k high-water-mark
ARXLOW    .equ 5120   ; 5k low-water-mark
ARXBUFFER .equ 04600H ;

	.end
