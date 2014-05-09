;===========================================================================
; vector_table.inc - Extern declaration for sam3u vector table
;                  
; Description   : Extern declaration for sam3u vector table
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

        EXTERN __iar_program_start
        EXTERN HardFault_Handler
        EXTERN MemoryManagmentFault_Handler
        EXTERN BusFault_Handler
        EXTERN UsageFault_Handler
        EXTERN SVCall_Handler
        EXTERN PendSV_Handler
        EXTERN Systick_Handler
        EXTERN SUPC_Handler
        EXTERN RSTC_Handler
        EXTERN RTC_Handler
        EXTERN RTT_Handler
        EXTERN WDT_Handler
        EXTERN PMC_Handler
        EXTERN EEFC0_Handler
        EXTERN EEFC1_Handler
        EXTERN UART_Handler
        EXTERN SMC_Handler
        EXTERN PIOA_Handler
        EXTERN PIOB_Handler
        EXTERN PIOC_Handler
        EXTERN USART0_Handler
        EXTERN USART1_Handler
        EXTERN USART2_Handler
        EXTERN USART3_Handler
        EXTERN HSMCI_Handler
        EXTERN TWI0_Handler
        EXTERN TWI1_Handler
        EXTERN SPI_Handler
        EXTERN TC0_Handler
        EXTERN TC1_Handler
        EXTERN TC2_Handler
        EXTERN PWM_Handler
        EXTERN ADC12B_Handler
        EXTERN ADC_Handler
        EXTERN DMAC_Handler
        EXTERN UDPHS_Handler  