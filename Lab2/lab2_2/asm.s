;===========================================================================
; asm.s - Template for DAT Lab 2
;                  
; Description   : A template for Lab 2
; Reference(s)  : ARM IAR Assembler Reference Guide
; Course        : Datorteknik (DAT) DO2005
;    
; Copyright (C) : 2012-2014 by Halmstad University, Sweden; All rights reserved.
;
; Author(s)     : Börje Dellstrand, Björn Åstrand, 2012
;                 Tomas Nordström (Tomas.Nordstrom@hh.at)
;
; CVS:       $Id: $
; Change History:
;      2012-03-NN (BD) Last update of code for old ARM system
;      2012-03-NN (BÅ) Created a version for SAM3U
;      2013-03-NN (AJ) updates
;      2014-03-21 (ToNo) updates to headers
;===========================================================================
        NAME    MAIN
        PUBLIC  main
        
        SECTION .text : CODE (2)
        THUMB

;===========================================================================
; Useful definitions
PIOA_PER  EQU   0X400E0C00   
PIOA_ODR  EQU   0X400E0C14 
PIOA_IDR  EQU   0X400E0C44 
PIOA_PUER EQU   0X400E0C64
PIOA_PDSR EQU   0X400E0C3C 

PIOB_PER  EQU   0X400E0E00
PIOB_OER  EQU   0X400E0E10
PIOB_SODR EQU   0X400E0E30
PIOB_PUDR EQU   0X400E0E60
PIOB_CODR EQU   0X400E0E34 
PIOB_OWER EQU   0X400E0EA0
PIOB_ODSR EQU	0x400E0E38

MCLK	  EQU	48000          ; Anges i kHz

PMC_PCER  EQU   0x400E0410 ; Peripheral Clock Enable Register 
PMC_PCDR  EQU   0x400E0414 ; Peripheral Clock Disable Register
PMC_PCSR  EQU   0x400E0418 ; Peripheral Clock Status Register

main
;===========================================================================
; Initialization of Peripheral Clock
          LDR   R0,=PMC_PCER
          LDR   R1,=0XC00
          STR   R1,[R0]

; Initialization InPort  
          LDR   R0,=PIOA_PER
	  LDR	R1, =0x00080000
          STR   R1,[R0]
	  
          LDR   R0,=PIOA_PUER
          STR   R1,[R0]
	            
	  LDR   R0,=PIOA_ODR
          STR   R1,[R0]	    
;===========================================================================
; Initialization OutPort

	LDR R0, =PIOB_OER
	MOV R1, #0x7
	STR R1, [R0]
	
	LDR R0, =PIOB_PUDR
	STR R1, [R0]
	
	LDR R0, =PIOB_PER
	STR R1, [R0]
	
	LDR R0, =PIOB_OWER	;Sync write to ODSR enabled on 3 bits
	STR R1, [R0]
	
	B	main_loop
;===========================================================================
; Subroutine that takes R7 cotnaining one value between 0 and 7
led	PUSH	{R0-R3,R7,LR}
	EOR	R7, R7, #3	;after this we have a 1 repr. light
	
	LDR R0, =PIOB_ODSR
	LDR R2,	[R0]		;fetch whats in the register now
	BIC R2, R2, #7
	ORR R2, R2, R7		; now in r2 we should have total
	STR R2, [R0]
	
	POP	{R0-R3,R7, LR}
	BX	LR

;===========================================================================
;===========================================================================
; Subroutine that returns R7 and  R8 containing 1 or 0. 
check_buttons
	PUSH	{R0-R3,LR}
	MOV R7, #0		;Clearing R7 to 0
	MOV R8, #0
	LDR R0, =PIOA_PDSR
	LDR R1,	[R0]		;fetch button statuses
	AND R1, R1, #0x000C0000
	LSR R1, R1, #18		; Shift them to become smaller number
	EOR R1, R1, #3
	AND R7, R1, #1		;Separate the pin statuses into two regs
	LSR R8, R1, #1
	
	POP	{R0-R3, LR}
	BX	LR

;===========================================================================
; Main program
main_loop
	;1 Read input values from buttons, get r7 r8 registers with output
	MOV	R7, #0		;clear R7 R8
	MOV	R8, #0
	BL	check_buttons
	;2 Depending on values, set a register and send that to the LED
	CMP	R7, #1
	BNE	Else
	MOV	R7, #7	;UF button is pressed
	BL	led
	B	Endif	;skip else
Else:	CMP	R8, #1
	BNE	Endif	
	MOV	R7, #0
	BL	led
Endif:	B	main_loop

;	LDR	R7,=1000
;	BL	Delay_ms

; ========================
; Subroutine Delay_ms
;
; Purpose: Wait for the number of ms given by R7
;
; Initial Condition
;   R7 contains delay in ms
; Final Condition
;   -
; Registers changed: No register are affected
; Example Call:
;     MOV    R7,#100            ; Wait for 100 ms
;     BL	 Delay_ms           ; Will return after apprioximately 100 ms

DELAY_CALIB  EQU  MCLK / 9      ; Value that generates one ms delay 
                                ; (depend on MCLK at 48MHz)

Delay_ms
        STMFD   SP!,{R0,R1}     ; Save registers
        MOV     R0,R7        

do_delay_ms
        LDR     R1,=DELAY_CALIB ; Read right constant for one ms
loop_ms
        SUBS    R1,R1,#1        
        BNE     loop_ms         ; loop for one ms
                 
        SUBS    R0,R0,#1	
        BNE     do_delay_ms     ; loop for right number of ms
        
	LDMFD   SP!,{R0,R1}     ; Restore registers 
        MOV     PC,LR           ; Return   
; --------------------------------------------------------
        END
