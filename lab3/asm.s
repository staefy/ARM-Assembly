;===========================================================================
; asm.s - Template for DAT Lab 3
;                  
; Description   : A template for Lab 3
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
      NAME     MAIN
        
      PUBLIC  main
	  PUBLIC  Systick_Handler
	  PUBLIC PIOA_Handler
        
      SECTION .text : CODE (2)
      THUMB

;===========================================================================
; Useful definitions
; Port A Registers -------------------------------------
PIOA_PER  EQU   0X400E0C00   
PIOA_ODR  EQU   0X400E0C14 
PIOA_IER  EQU   0X400E0C40        ; Interrupt Enable Register
PIOA_IDR  EQU   0X400E0C44        ; Interrupt Disable Register
PIOA_IMR  EQU   0X400E0C48        ; Interrupt Mask register
PIOA_ISR  EQU   0X400E0C4C        ; Interrupt Status Register
PIOA_PUER EQU   0X400E0C64
PIOA_PDSR EQU   0X400E0C3C
PIOA_AIMER EQU   0X400E0CB0	; Additional interrupt modes enable
PIOA_ESR EQU   0X400E0CC0	; Edge selct register
PIOA_FELLSR EQU   0X400E0CD0	; falling edge (or low level) select reg
; Port B Registers ------------------------------------        
PIOB_PER  EQU   0X400E0E00
PIOB_OER  EQU   0X400E0E10
PIOB_SODR EQU   0X400E0E30
PIOB_PUDR EQU   0X400E0E60
PIOB_CODR EQU   0X400E0E34
PIOB_ODSR EQU   0x400E0E38
PIOB_OWER EQU   0x400E0EA0	;Synced Output write enable register

; NVIC Registers ---------------------------------------
SETENA0   EQU   0xE000E100        ; Interrupt Set Enable Register 0
CLRENA0   EQU   0xE000E180        ; Interrupt Clear Enable Register 0
CLRPEND0  EQU   0xE000E280        ; Interrupt Clear Pending Register 0 
ACTIVE0   EQU   0XE000E000        ; Interrupt Active Status Register 0

; Peripheral Clock Registers ---------------------------
PMC_PCER  EQU   0x400E0410        ; Peripheral Clock Enable Register 

; Configure Interrupt SYSTICK Table 13-33 ---------------
CTRL      EQU 0xE000E010          ; SYSTICK Control and Status Register
LOAD      EQU 0xE000E014          ; SYSTICK Reload Value Register
VAL       EQU 0xE000E018          ; SYSTICK Current Value Register
CALIB     EQU 0xE000E01C          ; SYSTICK Calibration Value Register

;===========================================================================
; Initialization of Peripheral Clock
main     LDR   R0,=PMC_PCER
         LDR   R1,=0XC00          ; Peripheral Identifier: bit10=PIOA, bit11=PIOB
         STR   R1,[R0]
         
;===========================================================================
; Initialization OutPort (PIOB)

	LDR	R0, =PIOB_PER
	MOV	R1, #7
	STR	R1, [R0]
	
	LDR	R0, =PIOB_OER
	STR	R1, [R0]
	
	LDR	R0, =PIOB_PUDR
	STR	R1, [R0]
	
	LDR	R0, =PIOB_OWER
	MOV	R1, #4
	STR	R1, [R0]		;Enabling sync write on pin 2


;===========================================================================
; Initialization InPort (PIOA)
	MOV	R1, #0XC0000		;We use both buttons, pin 18 19
	LDR	R0, =PIOA_PER		;Pio enable
	STR	R1, [R0]
	
	LDR	R0, =PIOA_ODR		;Outpud disable
	STR	R1, [R0]
	
	LDR	R0, =PIOA_PUER		;Pullup enable
	STR	R1, [R0]
	
; Set up so that input is generating interrupt
	MOV	R1, #0x40000
	LDR	R0, =PIOA_IER		;Interrupt enable register
	STR	R1, [R0]
	
	LDR	R0, =PIOA_AIMER		; Additional int. mode enable register
	STR	R1, [R0]
	
	LDR	R0, =PIOA_ESR		;Edge select register
	STR	R1, [R0]
	
	LDR	R0, =PIOA_FELLSR	;Falling/Low edge/level select register
	STR	R1, [R0]
	

	MOV	R1, #0x400		;NVIC number
	LDR	R0, =CLRPEND0		;Clear if any pending interrupts
	STR	R1, [R0]

	LDR	R0, =SETENA0		; Enabling NVIC interrupt
	STR	R1, [R0]	

                                                   
;===========================================================================
; Configure SysTick Timer

	LDR	R3, =CTRL
	MOV	R1, #0
	STR	R1, [R3]	; Disable the timer for now
	
	LDR	R0, =LOAD
	LDR	R1, =3000000	; 48M / 8 = 6M
	STR	R1, [R0]	; Counter starting value, should be 1hz init
	
	LDR	R0, =VAL
	MOV	R1, #0		
	STR	R1, [R0]	;Reset current value (any write value works)
                             
	MOV	R1, #3		;Set first 3 bits to (011)
	STR	R1, [R3]	;Start timer!
;===========================================================================
; Core of your program

main_loop
	LDR	R1, =PIOA_PDSR
	LDR	R2, [R1]
	AND	R2, R2, #0x80000
	EOR	R2, R2, #0x80000	;Invert bits for friendly format
	CMP	R2, #0x0		
	BEQ	delay			;Zero means not pressed
	
	
	
	
	B       main_loop

;Subroutine to handle counting and lighting of green ones
countup
	LDR	R0, =CLRENA0		; DISABLING NVIC interrupt
	STR	R1, [R0]
	
	PUSH	{R0-R3, LR}
	LDR	R1, =PIOB_ODSR
	LDR	R0, [R1]
	AND	R0, R0, #3
	EOR	R0, R0, #3
	ADD	R0, R0, #1
	CMP	R0, #4
	BNE	no_reset
	MOV	R0, #0
no_reset
	EOR	R0, R0, #3
	LDR	R1, =PIOB_ODSR
	STR	R0, [R1]
	
	MOV	R1, #0x400
	LDR	R0, =SETENA0		; Enabling NVIC interrupt again
	STR	R1, [R0]
	
	POP	{R0-R3, LR}
	BX 	LR


; ========================
; Systick_Handler - Interrupt handler for Systick
;
; Purpose:           Interupt handler for Systick timer
; Initial Condition: Systick needs to be initiated correctly
; Registers changed: None

Systick_Handler
	LDR	R0, =PIOB_ODSR
	LDR	R1, [R0]
	EOR	R1, R1, #4	;Inverting bit 2 (red led)
	STR	R1, [R0]		;Sync write
        BX    LR                    ; Return interrupt

; ========================
; PIOA_Handler - Interrupt handler for button press
; Purpose:           Interupt handler for left button
; Initial Condition: PIOA interrupt onfalling flank myst be on
; Registers changed: 

PIOA_Handler
	MOV	R0, #0xC0000		;Flag register to show wich buttons
btn_loop
	LDR	R1, =PIOA_PDSR
	LDR	R2, [R1]
	AND	R2, R2, #0xC0000
	EOR	R2, R2, #0xC0000	;Invert bits
	BIC	R0, R0, R2		;Update our own flag register
	CMP	R2, #0x0		;Check if buttons are unpressed yet
	BNE	btn_loop

	MOV	R1, #0x400		
	LDR	R2, =CLRPEND0	;Clear if any pending interrupts
	STR	R1, [R2]

	AND	R0, R0, #0x80000
	CMP	R0, #0
	BEQ	both		;If its zero then both are pressed
	
left_only			;Update frequency with value in counter!
	LDR	R0, =PIOB_ODSR
	LDR	R1, [R0]
	MOV	R0, #3
	AND	R1, R0, R1 	;Now we should have only the binary value left
	EOR	R1, R1, R0
	LDR	R0, =LOAD	;Get counter load adress for use in switch
	
	;Table structure for translating binary 0-3 into freq			
	LDR R2, =TABLE
	MOV R1, R1, LSL #2 
	LDR R2, [R2,R1] 	;Load the value from table at R2 offset by R3
	STR	R2, [R0]	;Set reload for counter
	BX	LR


both				;If both then we reset everything
	LDR	R0, =PIOB_SODR
	MOV	R1, #3
	STR	R1,[R0]		;Clear green leds
	
	LDR	R0, =LOAD		
	LDR	R1, =3000000
	STR	R1, [R0]	;Load 1Hz red light blink freq
        BX    LR                    ; Return interrupt
; ========================
		
	 DATA 

TABLE	DCD	6000000, 3000000, 1500000, 750000
	
        END






//;========================= MIGHT BE UNNECESSARY=================
//
//	TBB.W	[PC, R1]	; PC = table start and R0 is the index of the
//branchtable
//	DATA
//;.. table ERGO the CASE 0 or 1 or 2 etc.
//	DCB	((case0 - branchtable)/2)	;Adresses to cases shifted right
//	DCB	((case1 - branchtable)/2)
//	DCB	((case2 - branchtable)/2)
//	DCB	((case3 - branchtable)/2)
//	
//case0		;If R0 is zero we set to 0.5 hz
//	LDR	R1, =6000000
//	STR	R1, [R0]
//	BX	LR
//case1		;If R0 is one we set to 1 hz
//	LDR	R1, =3000000
//	STR	R1, [R0]
//	BX	LR
//case2		;If R0 is two we set to 2 hz
//	LDR	R1, =1500000
//	STR	R1, [R0]
//	BX	LR
//case3		;If R0 is three we set to 4 hz
//	LDR	R1, =750000
//	STR	R1, [R0]
//	BX	LR
//;======================= ????? ==================================
