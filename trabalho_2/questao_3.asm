;---------------------------------------------------
; Programa: Questao 3 - Trab 2 - Multiplicar 2 int 8bit
; Autor:
; Data:
;---------------------------------------------------
; Definicoes
CLEAR EQU 3
PRINT EQU 2

ORG 128
INT_1:  DB -2
INT_2:  DB -5
RESULT: DW 0   ; VARIAVEL P/ GUARDAR VALOR DA OPERACAO

;---------------------------------------------------

ORG 0
    OUT CLEAR

Get_Sign:
    LDA INT_1     ; CARREGA INT_1 NO ACC
    JN  Loop_Neg  ; SE INT < 0
    JP  Loop_Pos  ; SE INT > 0

Loop_Neg:
    LDA INT_2     ; CARREGA INT_2 NO ACC
    ADD RESULT    ; SOMA O RESULTADO AO ACC
    STA RESULT    ; RESULT += INT_2
    LDA INT_1     ; CARREGA INT_1 NO ACC
    ADD #1        ; SUBTRAI 1 DO ACC
    STA INT_1     ; INT_1 += 1
    JNZ Loop_Neg  ; RECOMECA O LOOP SE INT_1 == 0
    JZ  Fim       ; VAI AO FIM DO PROGRAMA

Loop_Pos:
    LDA INT_2     ; CARREGA INT_2 NO ACC
    ADD RESULT    ; SOMA O RESULTADO AO ACC
    STA RESULT    ; RESULT += INT_2
    LDA INT_1     ; CARREGA INT_1 NO ACC
    SUB #1        ; SUBTRAI 1 DO ACC
    STA INT_1     ; INT_1 -= 1
    JNZ Loop_Pos  ; RECOMECA O LOOP SE INT_1 == 0
    JZ  Fim       ; VAI AO FIM DO PROGRAMA

Fim:
    LDA RESULT
    HLT

