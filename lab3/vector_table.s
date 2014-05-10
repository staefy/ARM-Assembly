;===========================================================================
; vector_table.s - Vector table definitions for SAM3U
;                  
; Description   : Eector table definitions for SAM3U
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
;      2013-03-15 (AJ)   Created
;      2013-03-21 (AJ)   Added a missing DCD
;      2014-03-21 (ToNo) Updated header
;===========================================================================

InitialStackPointer     EQU     0x20008000
Reserved                EQU     0x00
#include "vector_table.inc"

        NAME    InterruptVectors
        SECTION .intvec : CODE (2)
        THUMB
        DATA    
__vector_table        
        DCD     InitialStackPointer
        DCD     __iar_program_start
        DCD     Reserved
        DCD     HardFault_Handler
        DCD     MemoryManagmentFault_Handler
        DCD     BusFault_Handler
        DCD     UsageFault_Handler
        DCD     Reserved
        DCD     Reserved
        DCD     Reserved
        DCD     Reserved
        DCD     SVCall_Handler
        DCD     Reserved
		DCD		Reserved
        DCD     PendSV_Handler
        DCD     Systick_Handler
        DCD     SUPC_Handler
        DCD     RSTC_Handler
        DCD     RTC_Handler
        DCD     RTT_Handler
        DCD     WDT_Handler
        DCD     PMC_Handler
        DCD     EEFC0_Handler
        DCD     EEFC1_Handler
        DCD     UART_Handler
        DCD     SMC_Handler
        DCD     PIOA_Handler
        DCD     PIOB_Handler
        DCD     PIOC_Handler
        DCD     USART0_Handler
        DCD     USART1_Handler
        DCD     USART2_Handler
        DCD     USART3_Handler
        DCD     HSMCI_Handler
        DCD     TWI0_Handler
        DCD     TWI1_Handler
        DCD     SPI_Handler
        DCD     TC0_Handler
        DCD     TC1_Handler
        DCD     TC2_Handler
        DCD     PWM_Handler
        DCD     ADC12B_Handler
        DCD     ADC_Handler
        DCD     DMAC_Handler
        DCD     UDPHS_Handler
        
        END