InitialStackPointer     EQU     0x20080000
Reserved                EQU     0x00      

	NAME    main
	PUBLIC  __iar_program_start
	SECTION .text : CODE (2)
	THUMB

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

MCLK	  EQU	48000          ; Anges i kHz

PMC_PCER  EQU   0x400E0410 ; Peripheral Clock Enable Register 
PMC_PCDR  EQU   0x400E0414 ; Peripheral Clock Disable Register
PMC_PCSR  EQU   0x400E0418 ; Peripheral Clock Status Register

	B       main


	SECTION .text : CODE (2)
	THUMB

main    NOP
;===========================================================================
; Initialization of Peripheral Clock
	LDR   R0,=PMC_PCER
	LDR   R1,=0XC00
	STR   R1,[R0]

; Initialization InPort  
;InPort  NOT NEEDED BECAUSE BUTTONS ARE ON BY DEFAULT

;===========================================================================
; Initialization OutPort
	LDR   R0,=PIOB_PER
	LDR   R1,=0X08000000	;Pin enable
	STR   R1,[R0]

	LDR   R0,=PIOB_OER     ;Output enable
	LDR   R1,=0X08000000 
	STR   R1,[R0]

	LDR   R0,=PIOB_PUDR   ;Pullup disable
	LDR   R1,=0X08000000
	STR   R1,[R0]
	B     read
;===========================================================================
; Turn LED off 
; TODO: Write your code here

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
; --------------------------------------------------------
; Main program
read 
	BL Read_p0 
	CMP R0, #0 ; Ej tryckt => 1:a 

	LDR   R0,=PIOB_SODR   ;light led
	LDR   R1,=0X08000000
	STR   R1,[R0]

	LDR   R0,=PIOB_CODR   ;light led
	LDR   R1,=0X08000000
	STR   R1,[R0]


	BNE read 
	LDR R7,=1000 
	MOV     R0, #0x66666666
	MOV     R1, #0x77777777
	BL Delay_ms 

loop 
	B loop  

	END
