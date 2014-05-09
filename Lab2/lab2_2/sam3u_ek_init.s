;===========================================================================
; sam3u_ek_init.s - Initialization code for our SAM3U-EK
;
; Description   : This file/code will run before entering the main routine. After
;                 this routine the master clock(CPU clock) will run at 48Mhz using
;                 the on-board crystal, watchdog timer will be disabled and the 
;                 vector table pointer will be set to SRAM0
; Reference(s)  : Atmel AT91SAM ARM-based Flash MCU Manual; 
;                 ARM IAR Assembler Reference Guide
; Course        : DO2005
;    
; Copyright (C) : 2013-2014 by Halmstad University, Sweden;    All rights reserved.
;
; Author(s)     : Andreas Johansson (andrjo11@student.hh.se)
;               : Tomas Nordstrom (Tomas.Nordstrom@hh.at)
;
; CVS:       $Id: $
; Change History:
;      2013-03-21 (AJ)   Created
;      2014-03-21 (ToNo) Updated header
;===========================================================================


EXTERNAL_OSC_STABLE_TIME    EQU  0x3F        ; Delay time for the on-board crystal to become stable
MASTER_CLOCK_PRESCALER      EQU  2           ; 
PLLA_DIVIDER                EQU  0           ; Master clock = ((Main clock) * PLLA_MULTIPLIER / PLLA_DIVIDER)/MASTER_CLOCK_PRESCALER
PLLA_MULTIPLIER             EQU  8           ; Multiplier 8, Divider 0, Main clock 12MHz, PRESCALER 2 gives 48Mhz Cpu clock.
PLLA_STABLE_TIME            EQU  0x3F        ; Delay time for PLLA to become stable
VECTOR_TABLE_OFFSET         EQU  0x20000000  ; Vector table offset

#include "sam3u_ek_init.inc"

;===========================================================================

    PUBWEAK main    
    SECTION .text : CODE(2)
    THUMB 
main    
    NOP
    B       main
    
    NAME    Sam3uInit
    PUBLIC    __iar_program_start
    EXTERN  main
    SECTION .text : CODE(2)
    THUMB

;===========================================================================
__iar_program_start
    B       sam3u_ek_init
sam3u_ek_init

;===========================================================================
; Turn off watchdog timer
    LDR    R0, =WDTC_WDMR
    LDR    R1, =WDTC_WDDIS
    STR    R1, [R0]
    
;===========================================================================
; Change slow clock from internal RC to external crystal oscillator, 32kHz
    LDR    R0, =SUPC_SR
    LDR     R0, [R0]
    LDR    R1, =SUPC_SR_OSCSEL_CRYST
    ANDS    R0, R0, R1
    BNE    sam3u_ek_init_slow_clock_done
    LDR    R0, =SUPC_CR
    LDR    R1, =(SUPC_CR_XTALSEL_CRYSTAL_SEL | SUPC_CR_WRITE_KEY)
    STR    R1, [R0]

sam3u_ek_init_slow_clock_loop
    LDR    R0, =SUPC_SR
    LDR    R0, [R0]
    LDR    R1, =SUPC_SR_OSCSEL_CRYST
    ANDS    R2, R0, R1
    BEQ    sam3u_ek_init_slow_clock_loop
sam3u_ek_init_slow_clock_done

;===========================================================================
; Initialize external crystal oscillator, 12Mhz
    LDR     R0, =PMC_MOR
    LDR     R0, [R0]
    LDR     R1, =PMC_MOR_MOSCSEL
    ANDS    R0, R0, R1
    BNE     sam3u_ek_init_ext_clock_done
    LDR     R0, =PMC_MOR
    LDR     R1, =(PMC_MOR_WRITE_KEY | BOARD_OSCOUNT | PMC_MOR_MOSCRCEN | PMC_MOR_MOSCXTEN)
    STR     R1, [R0]
sam3u_ek_init_ext_clock_loop
    LDR     R0, =PMC_SR
    LDR     R0, [R0]
    LDR     R1, =PMC_SR_MOSCXTS
    ANDS    R0, R0, R1
    BEQ     sam3u_ek_init_ext_clock_loop
sam3u_ek_init_ext_clock_done    

;===========================================================================
; Switch Main oscillator to external crystal
    LDR     R0, =PMC_MOR
    LDR     R1, =(PMC_MOR_WRITE_KEY | BOARD_OSCOUNT | PMC_MOR_MOSCRCEN | PMC_MOR_MOSCXTEN | PMC_MOR_MOSCSEL)
    STR     R1, [R0]
sam3u_ek_switch_main_clock_loop
    LDR     R0, =PMC_SR
    LDR     R0, [R0]
    LDR     R1, =PMC_SR_MOSCSELS
    ANDS    R0, R0, R1
    BEQ     sam3u_ek_switch_main_clock_loop
    
    LDR     R0, =PMC_MCKR
    LDR     R1, [R0]
    LDR     R2, =(~PMC_MCKR_CSS)
    AND     R1, R1, R2
    LDR     R2, =PMC_MCKR_CSS_MAIN_CLK
    ORR     R1, R1, R2
    STR     R1, [R0]
sam3u_ek_switch_master_clock_loop    
    LDR     R0, =PMC_SR
    LDR     R0, [R0]
    LDR     R1, =PMC_SR_MCKRDY
    ANDS    R0, R0, R1
    BEQ     sam3u_ek_switch_master_clock_loop
    
;===========================================================================
; Initialise PLLA
    LDR     R0, =PMC_PLLAR
    LDR     R1, =BOARD_PLLR
    STR     R1, [R0]
sam3u_ek_switch_plla_loop
    LDR     R0, =PMC_SR
    LDR     R0, [R0]
    LDR     R1, =PMC_SR_LOCKA
    ANDS    R0, R0, R1
    BEQ     sam3u_ek_switch_plla_loop
    
;===========================================================================
; Switch to PLLA clock
    LDR     R0, =PMC_MCKR
    LDR     R1, =BOARD_MCKR
    LDR     R2, =(~PMC_MCKR_CSS)
    AND     R1, R1, R2
    LDR     R2, =PMC_MCKR_CSS_MAIN_CLK
    ORR     R1, R1, R2
    STR     R1, [R0]
sam3u_ek_switch_master_clock_plla_loop
    LDR     R0, =PMC_SR
    LDR     R0, [R0]
    LDR     R1, =PMC_SR_MCKRDY
    ANDS    R0, R0, R1
    BEQ     sam3u_ek_switch_master_clock_plla_loop
    LDR     R0, =PMC_MCKR
    LDR     R1, =BOARD_MCKR
    STR     R1, [R0]
sam3u_ek_switch_master_clock_plla_loop2
    LDR     R0, =PMC_SR
    LDR     R0, [R0]
    LDR     R1, =PMC_SR_MCKRDY
    ANDS    R0, R0, R1
    BEQ     sam3u_ek_switch_master_clock_plla_loop2
    
;===========================================================================
; Move vector table pointer to SRAM0
    LDR     R0, =SCB_VTOR
    LDR     R1, =VECTOR_TABLE_OFFSET
    STR     R1, [R0]
    
    B main
    
    END
