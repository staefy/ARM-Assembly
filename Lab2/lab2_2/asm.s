;===========================================================================
; Lab 2.2-2.4 2014-05 Using chip SAM3UE4 on SAM3U-EK
;
; Goal is to create a _flowing_ LED that moves over three on board LEDS
; One button moves one way, the other the other way and both buttons light
; While no buttons pressed keeps them off
;
; One LED is active high and two are active LOW
;
; Dependent on 3 other files, exceptions, vector_table and sam3u_init_ek
; Uses polling technique. No interrupts enabled.
;
; Be advised: Using synchronous writing to ODSR, instead of
; regular SODR/CODR!
;
; Be advised: This program contains two _main_ programs
; One for testing, toggling leds on and off with the buttons led_toggle
; And one for actually doing the flowing light. led_flow 
;===========================================================================
        NAME    MAIN
        PUBLIC  main
        
        SECTION .text : CODE (2)
        THUMB

;===========================================================================
; Useful definitions
PIOA_PER  EQU   0X400E0C00	
PIOA_ODR  EQU   0X400E0C14 
PIOA_PUER EQU   0X400E0C64
PIOA_PDSR EQU   0X400E0C3C 

PIOB_PER  EQU   0X400E0E00
PIOB_OER  EQU   0X400E0E10
PIOB_PUDR EQU   0X400E0E60 
PIOB_OWER EQU   0X400E0EA0	;Enables synchronous writing to ODSR
PIOB_ODSR EQU	0x400E0E38	

MCLK	  EQU	48000          ; KHz, clock modifier

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

; Initialization OutPort
	LDR R0, =PIOB_PER
	STR R1, [R0]
	
	LDR R0, =PIOB_OER
	MOV R1, #0x7
	STR R1, [R0]
	
	LDR R0, =PIOB_PUDR
	STR R1, [R0]
	
	LDR R0, =PIOB_OWER	;Sync write to ODSR enabled on 3 bits
	STR R1, [R0]
;===========================================================================	
;Cleanup of memory and registers and start
	
	LDR R0, =PIOB_ODSR	
	MOV R1, #3
	STR R1, [R0]
	B	led_flow	;Branch to either led_flow or main_loop
				;dependent on which lab assignemnt

;===========================================================================
; Main that makes flowing light right or left dependenet on R7 and R8
led_flow
	BL	check_buttons	;Leaves us with R7, R8 one and&or zero
	CMP	R7, #1
	BNE	right_off	;This means either none or only left
	CMP	R8, #1
	BEQ	both_on		;this means both buttons had 1 and we flash all
	
only_right
	LDR R0, =PIOB_ODSR	;Only right button pressed if we get here
	LDR R7,	[R0]
	EOR R7, R7, #3
	LSL R7, R7, #1
	CMP R7, #0		;if value is 8 it should be 1, rotated
	BNE to_led
	MOV R7, #1
to_led	BL led			;mini sub that links us to led and delays
	B delay			;--------FINISHED!	
	
right_off
	CMP	R8, #1		; Check if left is also off
	BNE	both_off	; else if only left it continues downard
only_left	
	LDR R0, =PIOB_ODSR
	LDR R7,	[R0]
	EOR R7, R7, #3
	LSR R7, R7, #1		;Very similar but here we shift other way
	CMP R7, #0
	BNE to_led
	MOV R7, #4
	B to_led		

both_on
	MOV R7, #7		; Both buttons pressed, we want light (111)
	BL to_led		

both_off
	MOV R7, #0		;Both buttons off, we want no light (000)
	BL	to_led		
	
delay	MOV	R7, #200	;Delay so lights doesnt change too quickly
	BL	Delay_ms

	B	led_flow	;Restart loop

;===========================================================================
; Subroutine check_buttons
;
; Purpose: Read the status of the two buttons USR_right and _left
;
; Initial Condition
;   -
; Final Condition
;   R7 and R8 contains either 1 or 0 depending on button status.
; Registers changed: R7 and R8
; Example Call:
;	BL	 check_buttons	;Now both R7 and R8 will be returned
;	CMP R7, #1		;Check if button is pressed then branch
;	BEQ btn1_handler

check_buttons
	PUSH	{R0-R3,LR}	;Saving registers to stack
	MOV R7, #0		;Clear R7
	MOV R8, #0		;Clear R8
	LDR R0, =PIOA_PDSR	
	LDR R1,	[R0]		;Fetch button statuses
	AND R1, R1, #0x000C0000	;Mask out the two we want
	LSR R1, R1, #18		;Shift them to become smaller number
	EOR R1, R1, #3		;Invert, because press=low
	AND R7, R1, #1		;Separate the pin statuses into two regs
	LSR R8, R1, #1		;...and shift second bit into first place
	
	POP	{R0-R3, LR}	;Recover registers
	BX	LR		;Return

;===========================================================================
; Subroutine led
;
; Purpose: Control the 3 onboard leds, 
;
; WARNING: Writing directly to ODSR!
;
; Initial Condition
;   R7 contains number between 0-7
; Final Condition
;   -
; Registers changed: No register are affected
; Example Call:
;	MOV	R7,#5		;We have a value of 5 (101) 
;	BL 	led		;Turn on led 0 and led 2

led	PUSH	{R0-R3,R7,LR}	;Save registers on stack
	EOR	R7, R7, #3	;since 2 leds are active low we xor on 2 bits
	LDR R0, =PIOB_ODSR
	LDR R2,	[R0]		;fetch whats in the register now
	BIC R2, R2, #7		;Clear the three bits we care about
	ORR R2, R2, R7		;Inject our bits into the three we cleared
	STR R2, [R0]		;Turn on and off leds by writing to ODSR	
	
	POP	{R0-R3,R7,LR}	;restore registers and return
	BX	LR

;===========================================================================
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
	
;========== NOT USED! ======================================================
; Main program for lab 2_2 where one button lights all and another turns off
led_toggle
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
Endif:	B	led_toggle

;===========================================================================
        END
