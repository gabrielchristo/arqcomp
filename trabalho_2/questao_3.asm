ORG 256

INT_1:  DB 3      ; OPERANDO 1
INT_2:  DB 22     ; OPERANDO 2
RESULT: DW 0      ; VARIAVEL P/ GUARDAR VALOR DA OPERACAO
OF:     DB 0      ; VARIAVEL P/ CAPTURAR A CARRY FLAG QUANDO OCORRER

;---------------------------------------------------

ORG 0

Is_Zero:
; Checando se algum dos operandos eh 0
    LDA INT_1     ; CARREGA INT_1
    OR  #0        ; CHECA SE EH 0
    JZ  Fim       ; TERMINA SE FOR 0
    LDA INT_2     ; CARREGA INT_2
    OR  #0        ; CHECA SE EH 0
    JZ  Fim       ; TERMINA SE FOR 0

Get_Sign:
; Caso nenhuma das entradas seja zero, segue
    LDA INT_1     ; CARREGA INT_1 NO ACC
    JP  Loop_Pos  ; SE INT_1 > 0
    LDA INT_2     ; CARREGA INT_2 NO ACC
    JP  Loop_1Neg ; SE INT_2 > 0
    JN  Loop_2Neg ; SE INT_2 < 0

OF_Flag:
    LDA #1        ; CARREGA 1 NO ACC
    STA OF        ; GUARDA O 1 EM OF
    JMP Fim       ; PULA PARA O FIM DA EXECUCAO

Loop_1Neg:
; Loop para quando o segundo operando eh negativo
    LDA INT_1     ; CARREGA INT_1 NO ACC
    ADC RESULT    ; SOMA O RESULTADO AO ACC
    STA RESULT    ; RESULT += INT_1
    JC  OF_Flag   ; SE TIVER OVERFLOW, DESVIA
    LDA INT_2     ; CARREGA INT_2 NO ACC
    SUB #1        ; SUBTRAI 1 DO ACC
    STA INT_2     ; INT_2 -= 1
    JNZ Loop_1Neg ; RECOMECA O LOOP SE INT_2 != 0
    JZ  Fim       ; VAI AO FIM DO PROGRAMA

Loop_2Neg:
; Loop para quando ambos operando sao negativos
    LDA INT_2     ; CARREGA INT_2 NO ACC
    NOT           ; INVERTE OS BITS DE INT_2  | BLOCO PARA FAZER A CONVERSAO DE NEGATIVO
    ADD #1        ; SOMA 1                    | PARA POSITIVO EM COMPLEMENTO A DOIS
    ADC RESULT    ; RESULT += -INT_2
    JC  OF_Flag   ; SE TIVER OVERFLOW, DESVIA
    STA RESULT    ; GUARDA INT_2 POSITIVO
    LDA INT_1     ; CARREGA INT_1 NO ACC
    ADD #1        ; ADICIONA 1 AO ACC
    STA INT_1     ; INT_1 += 1
    JNZ Loop_2Neg ; RECOMECA O LOOP SE INT_1 != 0
    JZ  Fim       ; VAI AO FIM DO PROGRAMA

Loop_Pos:
; Loop para quando o primeiro operando eh positivo
    LDA INT_2     ; CARREGA INT_2 NO ACC
    ADC RESULT    ; SOMA O RESULTADO AO ACC
    STA RESULT    ; RESULT += INT_2
    JC  OF_Flag   ; SE TIVER OVERFLOW, DESVIA
    LDA INT_1     ; CARREGA INT_1 NO ACC
    SUB #1        ; SUBTRAI 1 DO ACC
    STA INT_1     ; INT_1 -= 1
    JNZ Loop_Pos  ; RECOMECA O LOOP SE INT_1 == 0
    JZ  Fim       ; VAI AO FIM DO PROGRAMA

Fim:
    LDA OF
    HLT

