;---------------------------------------------------
; Programa: Questao 3 - Trab 2 - Multiplicar 2 int 8bit
; Autor:
; Data:
;---------------------------------------------------

; Definicoes
CLEAR EQU 3
PRINT EQU 2

ORG 128
INT_1:  DB -5  ; OPERANDO 1
INT_2:  DB -10 ; OPERANDO 2
RESULT: DW 0   ; VARIAVEL P/ GUARDAR VALOR DA OPERACAO

;---------------------------------------------------

ORG 0
    OUT CLEAR

Get_Sign:
    LDA INT_1     ; CARREGA INT_1 NO ACC
    JP  Loop_Pos  ; SE INT_1 > 0
    LDA INT_2     ; CARREGA INT_2 NO ACC
    JP  Loop_1Neg ; SE INT_2 > 0
    JN  Loop_2Neg ; SE INT_2 < 0

Loop_1Neg:
    LDA INT_1     ; CARREGA INT_1 NO ACC
    ADD RESULT    ; SOMA O RESULTADO AO ACC
    STA RESULT    ; RESULT += INT_1
    LDA INT_2     ; CARREGA INT_2 NO ACC
    SUB #1        ; SUBTRAI 1 DO ACC
    STA INT_2     ; INT_2 -= 1
    JNZ Loop_1Neg ; RECOMECA O LOOP SE INT_2 != 0
    JZ  Fim       ; VAI AO FIM DO PROGRAMA

Loop_2Neg:
    LDA INT_2     ; CARREGA INT_2 NO ACC
    NOT           ; INVERTE OS BITS DE INT_2  | BLOCO PARA FAZER A CONVERSAO DE NEGATIVO
    ADD #1        ; SOMA 1                    | PARA POSITIVO EM COMPLEMENTO A DOIS
    ADD RESULT    ; RESULT += -INT_2
    STA RESULT    ; GUARDA INT_2 POSITIVO
    LDA INT_1     ; CARREGA INT_1 NO ACC
    ADD #1        ; ADICIONA 1 AO ACC
    STA INT_1     ; INT_1 += 1
    JNZ Loop_2Neg ; RECOMECA O LOOP SE INT_1 != 0
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

