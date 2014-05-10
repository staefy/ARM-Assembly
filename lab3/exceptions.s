;===========================================================================
; exceptions.s - Declares (dummy) handleres for exceptions
;
; Description   : This file declares dummy handlers for all interrupts of the
;                 sam3u MCU. To declare your own handler in another file declare
;                 the handler as "PUBLIC Handler_name" where "Handler_name" is
;                 one of the labels from the list below.
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

        NAME    DummyHandlers

        PUBWEAK __iar_program_start
        PUBWEAK HardFault_Handler
        PUBWEAK MemoryManagmentFault_Handler
        PUBWEAK BusFault_Handler
        PUBWEAK UsageFault_Handler
        PUBWEAK SVCall_Handler
        PUBWEAK PendSV_Handler
        PUBWEAK Systick_Handler
        PUBWEAK SUPC_Handler
        PUBWEAK RSTC_Handler
        PUBWEAK RTC_Handler
        PUBWEAK RTT_Handler
        PUBWEAK WDT_Handler
        PUBWEAK PMC_Handler
        PUBWEAK EEFC0_Handler
        PUBWEAK EEFC1_Handler
        PUBWEAK UART_Handler
        PUBWEAK SMC_Handler
        PUBWEAK PIOA_Handler
        PUBWEAK PIOB_Handler
        PUBWEAK PIOC_Handler
        PUBWEAK USART0_Handler
        PUBWEAK USART1_Handler
        PUBWEAK USART2_Handler
        PUBWEAK USART3_Handler
        PUBWEAK HSMCI_Handler
        PUBWEAK TWI0_Handler
        PUBWEAK TWI1_Handler
        PUBWEAK SPI_Handler
        PUBWEAK TC0_Handler
        PUBWEAK TC1_Handler
        PUBWEAK TC2_Handler
        PUBWEAK PWM_Handler
        PUBWEAK ADC12B_Handler
        PUBWEAK ADC_Handler
        PUBWEAK DMAC_Handler
        PUBWEAK UDPHS_Handler
	
        SECTION .text : CODE (2)
        THUMB
        
__iar_program_start    
        NOP
        B       __iar_program_start
        
HardFault_Handler
        NOP
        B       HardFault_Handler
        
MemoryManagmentFault_Handler
        NOP
        B       MemoryManagmentFault_Handler
        
BusFault_Handler
        NOP
        B       BusFault_Handler
        
UsageFault_Handler
        NOP
        B       UsageFault_Handler
        
SVCall_Handler
        NOP
        B       SVCall_Handler
        
PendSV_Handler
        NOP
        B       PendSV_Handler
        
Systick_Handler
        NOP
        B       Systick_Handler
        
SUPC_Handler
        NOP
        B       SUPC_Handler
        
RSTC_Handler
        NOP
        B       RSTC_Handler
        
RTC_Handler
        NOP
        B       RTC_Handler
        
RTT_Handler     
        NOP
        B       RTT_Handler
        
WDT_Handler
        NOP
        B       WDT_Handler
        
PMC_Handler
        NOP
        B       PMC_Handler
        
EEFC0_Handler
        NOP
        B       EEFC0_Handler
        
EEFC1_Handler
        NOP
        B       EEFC1_Handler
        
UART_Handler
        NOP
        B       UART_Handler
        
SMC_Handler
        NOP
        B       SMC_Handler
        
PIOA_Handler
        NOP
	;DO THINGS
        B       PIOA_Handler
        
PIOB_Handler
        NOP
        B       PIOB_Handler
        
PIOC_Handler
        NOP
        B       PIOC_Handler
        
USART0_Handler
        NOP
        B       USART0_Handler
        
USART1_Handler
        NOP
        B       USART1_Handler
        
USART2_Handler
        NOP
        B       USART2_Handler
        
USART3_Handler
        NOP
        B       USART3_Handler
        
HSMCI_Handler
        NOP
        B       HSMCI_Handler
        
TWI0_Handler
        NOP
        B       TWI0_Handler
        
TWI1_Handler
        NOP
        B       TWI1_Handler
        
SPI_Handler
        NOP
        B       SPI_Handler
        
TC0_Handler
        NOP
        B       TC0_Handler
        
TC1_Handler
        NOP
        B       TC1_Handler
        
TC2_Handler
        NOP
        B       TC2_Handler
        
PWM_Handler
        NOP
        B       PWM_Handler
        
ADC12B_Handler
        NOP
        B       ADC12B_Handler
        
ADC_Handler
        NOP
        B       ADC_Handler
        
DMAC_Handler
        NOP
        B       DMAC_Handler
        
UDPHS_Handler
        NOP
        B       UDPHS_Handler
	
        
        END
