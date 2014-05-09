;===========================================================================
; sam3u_ek_init.inc - Defines constants and registers for the initialization code
;                  
; Description   : Contains definitions for registers and constants used by
;                 sam3u_ek_init.s
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

SCB_VTOR                        EQU             0xE000ED08

WDTC_WDMR			EQU		0x400E1254		;	Watchdog Mode Register
WDTC_WDDIS			EQU		(1 << 15)		;	Disable Watchdog bit

SUPC_SR				EQU		0x400E1224		;	Supply Controller Status Register
SUPC_SR_OSCSEL_CRYST		EQU		(1 << 7)		;	32Khz oscillator selection status

SUPC_CR			        EQU		0x400E1210		;	Supply Controller Control Register
SUPC_CR_XTALSEL_CRYSTAL_SEL     EQU		(1 << 3)		;	Switch from RC to Crystal 32kHz oscillator 
SUPC_CR_WRITE_KEY		EQU		(0xA5 << 24)	        ;	Write enable key for Supply Controller Control Register

PMC_MOR				EQU		0x400E0420		;	PMC Main Oscillator Register
PMC_MOR_MOSCSEL			EQU		(1 << 24)		;	Select external crystal as main oscillator
PMC_MOR_WRITE_KEY		EQU		(0x37 << 16)	        ;	Write enable key for PMC Main Oscillator Register
PMC_MOR_MOSCRCEN		EQU		(1 << 3)		;	On-Chip RC oscillator enable bit
PMC_MOR_MOSCXTEN		EQU		(1 << 0)		;	External srystal enable bit
PMC_MOR_MOSCXTST		EQU		(0xFF << 8)		;	External crystal start-up time mask
PMC_MOR_MOSCXTST_SHIFT		EQU		8			;	Extrenal crystal start-up time shift

PMC_SR				EQU		0x400E0468		;	PMC Status Register
PMC_SR_MOSCXTS			EQU		(1 << 0)		;	Main XTAL oscillator stable status
PMC_SR_MOSCSELS			EQU		(1 << 16)		;	Main oscillator selection/switch status
PMC_SR_MCKRDY			EQU		(1 << 3)		; 	Master clock ready status
PMC_SR_LOCKA			EQU		(1 << 1)		;	PLLA locked

PMC_MCKR			EQU		0x400E0430		;	PMC Master Clock Register
PMC_MCKR_CSS			EQU		(0x03 << 0)		; 	Master clock source selection mask
PMC_MCKR_CSS_MAIN_CLK		EQU		(0x01 << 0)		;  	Main oscillator select
PMC_MCKR_CSS_PLLA_CLK		EQU		(0x02 << 0)		;	PLLA oscillator select
PMC_MCKR_PRES			EQU		(0x07 << 4)		;	Processor clock prescaler mask
;PMC_MCKR_PRES_CLK_2		EQU		(0x01 << 4)		;	Selected clock divided by 2 prescaler
PMC_MCKR_PRES_SHIFT		EQU		4			;  	Shift bit for prescaler

PMC_PLLAR			EQU		0x400E0428		;	PMC PPLA Register
PMC_PLLAR_MULA			EQU		(0x07FF << 16)	        ;  	PLLA multiplier mask
PMC_PLLAR_DIVA			EQU		(0xFF << 0)		;  	PLLA divider mask
PMC_PLLAR_PLLACOUNT		EQU		(0x3F << 8)		; 	PLLA stable time
PMC_PLLAR_REQUIRED		EQU		(1 << 29)		;	Must be set when writing to PLLAR
PMC_PLLAR_DIVA_SHIFT		EQU		0			;	PLLA divider shift
PMC_PLLAR_MULA_SHIFT		EQU		16			;	PLLA multiplier shift
PMC_PLLAR_PLLACOUNT_SHIFT	EQU		8			;	PLLA stable time shift

BOARD_OSCOUNT			EQU		((EXTERNAL_OSC_STABLE_TIME << PMC_MOR_MOSCXTST_SHIFT) & PMC_MOR_MOSCXTST)		
BOARD_PLLR			EQU		(PMC_PLLAR_REQUIRED | (((PLLA_MULTIPLIER - 1) << PMC_PLLAR_MULA_SHIFT) & PMC_PLLAR_MULA) | (((PLLA_DIVIDER + 1) << PMC_PLLAR_DIVA_SHIFT) & PMC_PLLAR_DIVA) | ((PLLA_STABLE_TIME << PMC_PLLAR_PLLACOUNT_SHIFT) & PMC_PLLAR_PLLACOUNT))
BOARD_MCKR			EQU		((((MASTER_CLOCK_PRESCALER - 1) << PMC_MCKR_PRES_SHIFT) & PMC_MCKR_PRES) | PMC_MCKR_CSS_PLLA_CLK)