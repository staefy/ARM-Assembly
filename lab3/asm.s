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
; Port B Registers ------------------------------------        
PIOB_PER  EQU   0X400E0E00
PIOB_OER  EQU   0X400E0E10
PIOB_SODR EQU   0X400E0E30
PIOB_PUDR EQU   0X400E0E60
PIOB_CODR EQU   0X400E0E34
PIOB_ODSR EQU   0x400E0E38

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
; TODO: Write your code here

;===========================================================================
; Initialization InPort (PIOA)
; TODO: Write your code here
; TODO: Set up so that input is generating interrupt
                                                   
;===========================================================================
; Configure SysTick Timer
; TODO: Write your code here

                             
;===========================================================================
; Core of your program
; TODO: Write your code here

STOP    B       STOP
 

; ========================
; Systick_Handler - Interrupt handler for Systick
;
; Purpose:           Interupt handler for Systick timer
; Initial Condition: Systick needs to be initiated correctly
; Registers changed: None
Systick_Handler
        ; TODO: Write your code here
        BX    LR                    ; Return interrupt
        B Systick_Handler

		
        END
