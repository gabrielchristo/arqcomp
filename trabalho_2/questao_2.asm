;
; Ler valor de 16 bits em complemento a dois do teclado virtual
; Em seguida mostrar seu valor em decimal no banner
; * - eh negativo
; # - fim do input
;

ORG 128
  EH_NEGATIVO: DB 0     ; booleano que indica se o valor eh negativo
  PILHA: DW 0        ;  pilha com N bytes
  ULTIMO_CHAR: DB 0     ;
  CONTADOR_BITS: DB 0   ;
  CONTADOR_SHIFT: DB 0   ;
  VALOR_FINAL: DB 0     ;
  TEMP: DB 0          ;

ORG 0
  OUT 3            ; limpa o banner
  
  LDS #00B0H          ; inicializa pilha com # na base
  LDA #HASHTAG_ASCII
  PUSH
  STS PILHA

ESPERA_INPUT:
  IN 3             ; verifica se tecla foi pressionada
  ADD #0            ; soma 0 ao acumulador
  JZ ESPERA_INPUT   ; se for zero volta a esperar input
  IN 2               ; se teve input carrego o valor ascii correspondente no acumulador
  STA ULTIMO_CHAR
  JMP CHECA_ENTRADA
  
CHECA_ENTRADA:
  LDA ULTIMO_CHAR            ; se for * eh negativo
  SUB #ESTRELA_ASCII
  JZ INPUT_ESTRELA
  LDA ULTIMO_CHAR             ; se for # finalizo input e inicio conversao
  SUB #HASHTAG_ASCII
  JZ SAIR
  LDA ULTIMO_CHAR            ; caso contrario adiciono o numero na pilha e printo o mesmo
  PUSH
  OUT 2
  LDA CONTADOR_BITS
  ADD #1
  STA CONTADOR_BITS
  JMP ESPERA_INPUT

INPUT_ESTRELA:
  LDA #1
  STA EH_NEGATIVO
  JMP ESPERA_INPUT




;-----------------------------
; essa parte aqui é experimental
; a parte de cima efetivamente pega o input do numero binario
CONVERTER:
  POP
  SUB #ZERO_ASCII
  STA TEMP
  LDA CONTADOR_SHIFT
  ADD #0
  JNZ SHIFT
  LDA VALOR_FINAL
  ADD TEMP
  STA VALOR_FINAL
SHIFT:
  ;LDA CONTADOR_SHIFT
  JMP PRINTA_VALOR_FINAL
PRINTA_VALOR_FINAL:
  OUT 3             ; 
  LDA EH_NEGATIVO
  ADD #0
  JZ SOMENTE_VALOR
  LDA #TRACO_ASCII
  OUT 2
SOMENTE_VALOR:
  LDA VALOR_FINAL
  OUT 0
  JMP SAIR
;--------------------------------------------------


SAIR:
  HLT


ZERO_ASCII EQU 49 ; 31H
UM_ASCII EQU 50    ; 32H
ESTRELA_ASCII EQU 42 ; 2AH
HASHTAG_ASCII EQU 35 ; 23H
TRACO_ASCII EQU 45 ; 2DH