InitialStackPointer 	EQU	0x20008000
	  NAME    InterruptVectors
	  PUBLIC	__iar_program_start
	  SECTION .intvec : CODE (2)
	  THUMB
	  DATA    
__vector_table        
	  DCD     InitialStackPointer
	  DCD     __iar_program_start

__iar_program_start
; SAM3X8E - On arduino due definitions
;===========================================================================
; PIO ENABLE DISABLE AND STATUS Registers
PIOA_PER  EQU   0x400E0E00
PIOA_PDR  EQU   0x400E0E04
PIOA_PSR  EQU   0x400E0E08

PIOB_PER  EQU   0x400E1000
PIOB_PDR  EQU   0x400E1004
PIOB_PSR  EQU   0x400E1008

PIOC_PER  EQU   0x400E1200
PIOC_PDR  EQU   0x400E1204
PIOC_PSR  EQU   0x400E1208
; OUTPUT ENABLE DISABLE AND STATUS Registers
PIOA_OER  EQU   0x400E0E10
PIOA_ODR  EQU   0x400E0E14
PIOA_OSR  EQU   0x400E0E18

PIOB_OER  EQU   0x400E1010
PIOB_ODR  EQU   0x400E1014
PIOB_OSR  EQU   0x400E1018

PIOC_OER  EQU   0x400E1210
PIOC_ODR  EQU   0x400E1214
PIOC_OSR  EQU   0x400E1218

; CONTROLLER PIN DATA STATUS Registers
PIOA_PDSR EQU   0x400E0E3C
PIOB_PDSR EQU   0x400E103C
PIOC_PDSR EQU   0x400E123C

; CONTROLLER INTERRUPT ENABLE DISABLE, MASK AND STATUS Registers
PIOA_IER  EQU   0x400E0E40
PIOA_IDR  EQU   0x400E0E44
PIOA_IMR  EQU   0x400E0E48
PIOA_ISR  EQU   0x400E0E4C

PIOB_IER  EQU   0x400E1040
PIOB_IDR  EQU   0x400E1044
PIOB_IMR  EQU   0x400E1048
PIOB_ISR  EQU   0x400E104C

PIOC_IER  EQU   0x400E1240
PIOC_IDR  EQU   0x400E1244
PIOC_IMR  EQU   0x400E1248
PIOC_ISR  EQU   0x400E124C

; PULL UP ENABLE DISABLE AND STATUS Registers
PIOA_PUER EQU   0x400E0E64
PIOA_PUDR EQU   0x400E0E60
PIOA_PUSR EQU   0x400E0E68

PIOB_PUER EQU   0x400E1064
PIOB_PUDR EQU   0x400E1060
PIOB_PUSR EQU   0x400E0E68

PIOC_PUER EQU   0x400E1264
PIOC_PUDR EQU   0x400E1260
PIOC_PUSR EQU   0x400E1268

; OUTPUT DATA SET CLEAR AND STATUS Registers
PIOA_SODR EQU   0x400E0E30
PIOA_CODR EQU   0x400E0E34
PIOA_ODSR EQU   0x400E0E38

PIOB_SODR EQU   0x400E1030
PIOB_CODR EQU   0x400E1034
PIOB_ODSR EQU   0x400E1038

PIOC_SODR EQU   0x400E1230
PIOC_CODR EQU   0x400E1234
PIOC_ODSR EQU   0x400E1238
;===========================================================================
; Peripheral clock enable disable and status Registers
PMC_PCER EQU   0x400E0410 ; Peripheral Clock Enable Register 
PMC_PCDR EQU   0x400E0414 ; Peripheral Clock Disable Register
PMC_PCSR EQU   0x400E0418 ; Peripheral Clock Status Register

MCLK	EQU	48000          ; in Khz, used  for clock

	  B       main
;==================Declaration complete, now init starts=====================
	SECTION .text : CODE (2)
	THUMB

main	NOP

;===========================================================================
; Initialization of Peripheral Clock
	LDR	R0,=PMC_PCER
	MOV	R1, #0XC00
	STR	R1,[R0]
;===========================================================================
; Initialization InPort on arduino pin 7, 
	LDR	R0, =PIOC_PER
	LDR	R1, =0x1000000	;LDR because number is too large i think
	STR	R1, [R0]

	LDR	R0, =PIOC_ODR
	STR	R1, [R0]
	
	LDR	R0, =PIOC_PUER
	STR	R1, [R0]
;===========================================================================
; Initialization OutPort on arduino pin 13
	LDR	R0,=PIOB_PER
	LDR	R1,=0X08000000	;Pin enable
	STR	R1,[R0]

	LDR	R0,=PIOB_OER     ;Output enable 
	STR	R1,[R0]

	LDR	R0,=PIOB_PUDR   ;Pullup disable
	STR	R1,[R0]
	
	
	LDR R1, =PIOB_SODR  ;remove this line when you see it used fo uppg 4
	
	
	B	read
	
;===========Init complete, now subroutine declarations start================
	
	
;===========================================================================
; Subroutine to turn LED on

led_off	PUSH	{R0-R1}
	
	LDR	R0, =PIOB_SODR
	LDR	R1, =0x08000000
	STR	R1, [R0]	;Turn off on
	
	POP	{R0-R1}
	
	BX	LR		;Return to value in LR
	
;===========================================================================
; Subroutine to turn led off

led_on	PUSH	{R0-R1}
	LDR	R0,=PIOB_CODR   
	LDR	R1,=0X08000000
	STR	R1,[R0]
	POP	{R0-R1}
	BX	LR





;===========================================================================
; Subroutine Read_p0
;
; Purpose: Read button
;
; Initial Condition
;   PIOA needs to be initiated correctly
; Final Condition
;   R0 contains 0x0 if button pressed otherwise 0x00080000
; Registers changed: No register, besides R0 are affected
; Example Call:
;     BL	 Read_p0            ; Call to read button
;     CMP    R0,#0              ; Set Z-flag according to button press
;     BNZ	 ButtonPressed      ; Jump if button pressed
Read_p0
	  STMFD   SP!,{R1}

; LDR    	R1,=PIOA_PDSR
; LDR   	R0,[R1]
;  AND     R0,R0,#0x00080000  ; bit mask to get button

	  LDMFD   SP!,{R1}        
	  MOV     PC,LR            ; Return
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
	MOV     R1,R7  

do_delay_ms
	LDR     R1,=DELAY_CALIB ; Read right constant for one ms
loop_ms
	SUBS    R1,R1,#1        
	BNE     loop_ms         ; loop for one ms

	SUBS    R0,R0,#1	
	BNE     do_delay_ms     ; loop for right number of ms

	LDMFD   SP!,{R0,R1}     ; Restore registers 
	MOV     PC,LR           ; Return   
	
avbrott	
	LDR R0,=PIOB_SODR 
	MOV R7,#0 
	STRb R7,[R0] ; PIOB_SODR 
	EOR R7,R7,#0xFF 
	STRb R7,[R0,#4] ; PIOB_CODR 
	
	MOV PC, LR ; återgång från avbrott. 

;=========Subroutines declaration complete, now main starts================
; Main program

read	LDRb R7,[R1,#8] ; PIOB_ODSR
	PUSH {R7}
	;Interrupt simulation
	CMP R5, #2
	MOV	LR, PC
	BEQ	avbrott
	
	
	ADD R7,R7, #1 
	STRb R7,[R1] ; PIOB_SODR 
	EOR R7,R7,#0xFF 
	STRb R7,[R1,#4] ; PIOB_CODR  	
	;BL Delay_ms 
	B read
loop 	B loop  

	END
