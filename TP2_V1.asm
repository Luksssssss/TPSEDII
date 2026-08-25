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
    DELAy3
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
    ENDM
CFG_LEDS MACRO
    BSF STATUS,RP0
    BCF STATUS, RP1
    CLRF TRISD
    ENDM
CFG_BUZZER MACRO
    ENDM
CFG_SECUENCES MACRO
    ENDM
BUZZER_OFF MACRO
    ENDM
CFG_DELAY_1s MACRO ; Para delay de 1seg
    ENDM
LEDS_ON MACRO ; Macro para encender todos los LEDs de una
    MOVLW .1
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

		
;===============================================================================
; INICIO PROGRAMA PRINCIPAL
;===============================================================================						
   CALL TEST_LEDS

MAIN_LOOP
    GOTO    MAIN_LOOP	
	
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

DELAY_3LOOP
    RETURN
;===============================================================================		
    END
;===============================================================================
