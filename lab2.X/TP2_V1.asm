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
    ENDM
BUZZER_OFF MACRO
    MOVLW .0
    MOVWF RC0
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
    CFG_DELAY_100ms
        CALL TEST_LEDS
	BTFSC SWITCH ; si no se presiona esta en 1
	GOTO MAIN_LOOP
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
