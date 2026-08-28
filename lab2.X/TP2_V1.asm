;===============================================================================
; @file       Gx_TPL2_ED2.asm
;
; @author     ToconásLiendro_Carlos
;	      Goldaraz_Juan
;	      Vaca_Fernando
;	      OliverosPagotto_Lucas
;	      Fontana_Mateo
;
; @date       31/08/2026
;
; @version    1.00
;===============================================================================

;===============================================================================
; DIRECTIVAS DE INCLUSIÓN
;===============================================================================
    LIST P=16F887			
    #include "p16f887.inc"	
	
;===============================================================================
; CONFIGURACIÓN GENERAL DEL MCU
;=============================================================================== 	
    __CONFIG _CONFIG1, _XT_OSC & _WDTE_OFF & _MCLRE_ON & _LVP_OFF

;===============================================================================
; DEFINICIÓN DE CONSTANTES
;===============================================================================     
#DEFINE SWITCH PORTE,RE0
#DEFINE BUZZER PORTC,RC0
#DEFINE LED0 PORTD,RD0
#DEFINE LED1 PORTD,RD1
#DEFINE LED2 PORTD,RD2
#DEFINE LED3 PORTD,RD3
#DEFINE LED4 PORTD,RD4
#DEFINE LED5 PORTD,RD5
#DEFINE LED6 PORTD,RD6
#DEFINE LED7 PORTD,RD7

;===============================================================================
; DEFINICIÓN DE VARIABLES
;=============================================================================== 
    CBLOCK 0x20
    DELAY1_Init
    DELAY2_Init
    DELAY3_Init
    DELAY1
    DELAY2
    DELAY3
    COUNTER_LED
    COUNTER_SECUENCES
    ENDC
;===============================================================================
; DECLARACIÓN DE MACROS PARA CONFIGURACIÓN DE REGISTROS
;===============================================================================
CFG_SWITCH MACRO
    BSF STATUS, RP0	  ; pongo RP0 en 1
    BSF STATUS, RP1       ; Banco 3  ->  RP1=1 ; RP0=1
    BCF ANSEL, ANS5          ; Configuramos RE0 como digital

    BCF STATUS,RP1	  ; Banco 1 -> RP1=0 ; RP0=1
    BSF TRISE,TRISE0 ; Configuramos RE0 como pin de entrada 
    BCF STATUS,RP0
    BCF STATUS,RP1
    ENDM
CFG_LEDS MACRO
    BSF STATUS,RP0
    BCF STATUS,RP1
    CLRF PORTD
    CLRF TRISD
    BCF STATUS,RP0
    ENDM
CFG_BUZZER MACRO
    BSF STATUS,RP0
    BCF STATUS,RP1
    BCF TRISC,TRISC0
    BCF STATUS,RP0
    ENDM
CFG_SECUENCES MACRO
    BCF STATUS,RP0
    BCF STATUS,RP1
    CLRF COUNTER_LED
    MOVLW .3
    MOVWF COUNTER_SECUENCES
    ENDM
CFG_DELAY_1s MACRO ; Para delay de 1seg
    MOVLW   D'255'
    MOVWF DELAY1_Init
    MOVLW D'245'
    MOVWF DELAY2_Init
    MOVLW D'4'
    MOVWF DELAY3_Init
    ENDM
CFG_DELAY_100ms MACRO
    MOVLW   D'26'
    MOVWF DELAY1_Init
    MOVLW D'241'
    MOVWF DELAY2_Init
    MOVLW D'4'
    MOVWF DELAY3_Init
    ENDM
CFG_DELAY_200ms MACRO
    MOVLW D'60'
    MOVWF DELAY1_Init
    MOVLW D'209'
    MOVWF DELAY2_Init
    MOVLW D'4'
    MOVWF DELAY3_Init
    ENDM
CFG_DELAY_300ms MACRO
    MOVLW D'90'
    MOVWF DELAY1_Init
    MOVLW D'208'
    MOVWF DELAY2_Init
    MOVLW D'4'
    MOVWF DELAY3_Init
    ENDM
LEDS_ON MACRO ; Macro para encender todos los LEDs de una
    MOVLW .255
    MOVWF PORTD
    ENDM
LEDS_OFF MACRO ; Macro para apagar todos los LEDs de una
    CLRF PORTD
    ENDM
BUZZER_ON MACRO ; Macro para encender el buzzer
    BCF BUZZER
    ENDM
BUZZER_OFF MACRO ; Macro para apaga el buzzer
    BSF BUZZER
    ENDM
LEDS_RLF MACRO
    BTFSC   LED0 ; skip si esta en 0
    BCF     STATUS, C
    RLF     COUNTER_LED, F  
    MOVF    COUNTER_LED, W   
    MOVWF   PORTD           
    ENDM
LEDS_RRF MACRO
    RRF     COUNTER_LED, F
    MOVF    COUNTER_LED, W   
    MOVWF   PORTD
    ENDM
;===============================================================================
; INICIALIZACIÓN DEL MCU (CÓDIGO ABSOLUTO)
;===============================================================================    
    ORG     0x00	;Vector de Reset
    GOTO    INICIO	;Salto al inicio del programa principal
    ORG     0x05	;Ubicación Programa Principal en la memoria 
			;de programa
		
;===============================================================================
; INICIALIZACIÓN DE MACROS PARA CONFIGURACIÓN DE REGISTROS
;===============================================================================    	    
INICIO	    ;-----Inicialización de Macros-------
	CFG_SWITCH
	CFG_LEDS
	CFG_BUZZER
	CFG_SECUENCES
	BUZZER_OFF
		
;===============================================================================
; INICIO PROGRAMA PRINCIPAL
;===============================================================================						
    
MAIN_LOOP 
        CALL TEST_LEDS
	BTFSC SWITCH ; si no se presiona esta en 1
	GOTO MAIN_LOOP
	CFG_DELAY_100ms
	CALL DELAY_3LOOP
	BTFSC SWITCH
	GOTO  MAIN_LOOP	
	CALL SECUENCES
	GOTO MAIN_LOOP
;===============================================================================
; SUBRUTINAS
;===============================================================================	 
;*******************************************************************************
; @brief    Descripción general de la subrutina.
;           
; @details  Descripción específica de la subrutina.
;******************************************************************************* 
TEST_LEDS  
    CFG_DELAY_1s
    LEDS_ON
    CALL DELAY_3LOOP
    LEDS_OFF
    CALL DELAY_3LOOP
    RETURN
;*******************************************************************************
; @details  Descripción específica de la subrutina.
;*******************************************************************************    
SECUENCES
    CALL BUZZER_BIP
    CALL RUNNING_LIGHT
    CALL BIDIR_RUNNING_LIGHT
    CALL CRAWLING
    RETURN
;*******************************************************************************
; @details  Descripción específica de la subrutina.
;*******************************************************************************
BUZZER_BIP
    CFG_DELAY_200ms
    BUZZER_ON
    CALL DELAY_3LOOP
    BUZZER_OFF
    RETURN
;*******************************************************************************
; @details  Descripción específica de la subrutina.
;*******************************************************************************
RUNNING_LIGHT
    CFG_DELAY_300ms
    LEDS_OFF
LOOP_RL
    CALL FORWARD_LED
    DECF COUNTER_SECUENCES, F
    BTFSS  STATUS,Z ; Bit Test File, Skip if Set
    GOTO LOOP_RL
    CFG_SECUENCES
    RETURN
;*******************************************************************************
; @details  Descripción específica de la subrutina.
;*******************************************************************************
BIDIR_RUNNING_LIGHT
    CFG_DELAY_200ms
    LEDS_OFF
LOOP_BRL
    CALL FORWARD_LED
    CALL BACKWARD_LED
    DECF COUNTER_SECUENCES, F
    BTFSS  STATUS,Z ; Bit Test File, Skip if Set
    GOTO LOOP_BRL
    CFG_SECUENCES
    RETURN
;*******************************************************************************
; @details  Descripción específica de la subrutina.
;*******************************************************************************
CRAWLING
    CFG_DELAY_100ms
    LEDS_OFF
LOOP_CW
    CALL PROGRESSIVE_LED_ON
    CALL PROGRESSIVE_LED_OFF
    DECF COUNTER_SECUENCES, F
    BTFSS  STATUS,Z ; Bit Test File, Skip if Set
    GOTO LOOP_CW
    CFG_SECUENCES
    RETURN
;*******************************************************************************
; @details  Descripción específica de la subrutina.
;*******************************************************************************
FORWARD_LED
    BSF STATUS,C
FW_LOOP
    LEDS_RLF
    CALL DELAY_3LOOP
    BTFSS LED7 ; Bit Test File, Skip if Set
    GOTO FW_LOOP
    RETURN

BACKWARD_LED
    BCF STATUS,C
BW_LOOP
    LEDS_RRF
    CALL DELAY_3LOOP
    BTFSS LED0 ; Bit Test File, Skip if Set
    GOTO BW_LOOP
    RETURN
    
PROGRESSIVE_LED_ON
    CLRF COUNTER_LED
PROG_LN
    BSF STATUS,C
    RLF COUNTER_LED, F
    MOVFW COUNTER_LED
    MOVWF PORTD
    CALL    DELAY_3LOOP
    BTFSS LED7 ; Bit Test File, Skip if Set
    GOTO PROG_LN
    RETURN
    
PROGRESSIVE_LED_OFF
PROG_LO
    BCF STATUS,C
    RRF COUNTER_LED
    MOVFW COUNTER_LED
    MOVWF PORTD
    CALL    DELAY_3LOOP
    BTFSC LED0 ; Bit Test File, Skip if Zero
    GOTO PROG_LO
    RETURN
;*******************************************************************************
; @details  Descripción específica de la subrutina.
;*******************************************************************************
DELAY_3LOOP
	    MOVFW DELAY1_Init
	    MOVWF DELAY1
LOOP1	MOVFW DELAY2_Init
	MOVWF DELAY2
LOOP2	MOVFW DELAY3_Init
	MOVWF DELAY3
LOOP3	DECFSZ DELAY3,F
	GOTO LOOP3
	DECFSZ DELAY2,F
	GOTO LOOP2
	DECFSZ DELAY1,F
	GOTO LOOP1
	RETURN
;===============================================================================		
    END
;===============================================================================
