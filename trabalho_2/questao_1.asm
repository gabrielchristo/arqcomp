;
; Programa para ordenar vetor com elementos de 16 bits em complemento a dois
; Algoritmo: Bubble sort em ordem crescente
;

;------------------------------------
; definicoes
CLEAR EQU 3
PRINT EQU 2

ORG 128
  TMP_PTR1: DW 0         ; ponteiro temporario para valor de 16 bits
  TMP_PTR2: DW 0         ; ponteiro temporario para valor de 16 bits
  TMP_VALUE: DW 0        ; valor temporario usado para swap dos elementos do vetor
  COUNT: DB 0            ; contador de iteracoes usado no for_loop de ordenacao
  TROCOU: DB 1           ; booleano auxiliar no loop de ordenacao (deve inicializar como true)
     
  LENGTH: DB 30             ; definindo variavel com tamanho do vetor
  VECTOR: DW 30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1 ; elementos do vetor
  VECTOR_PTR: DW VECTOR    ; definindo ponteiro para o vetor
;-------------------------------------

;------------------------------------
; main
ORG 0

  OUT CLEAR                   ; limpando banner
  LDA LENGTH                  ; carregando tamanho do vetor no acumulador
  LDS VECTOR_PTR              ; ponteiro para vetor no apontador de pilha

  LDA VECTOR_PTR              ; carrega ponteiro para vetor no acumulador      
  STA TMP_PTR1                ; PTR1 = &Vetor[0]
  ADD #2                      ; soma 2 bytes ao endereço no acumulador
  STA TMP_PTR2                ; PTR2 = &Vetor[1]
;----------------------------------------

;-----------------------------------------
; Loops de ordenacao
WHILE_LOOP:
  LDA TROCOU             ; carrega booleano trocou no acumulador 
  JZ SAIR                ; se for zero termina o programa (inicializado como true para bypassar isso)
  LDA #0                 ; carrega zero no acumulador
  STA TROCOU             ; salva trocou como false a cada iteracao
  
  LDA VECTOR_PTR         ; resetando ponteiros para inicio do vetor
  STA TMP_PTR1
  ADD #2
  STA TMP_PTR2

  LDA #0                 ; resetando contador do for_loop
  STA COUNT

FOR_LOOP:
  LDA COUNT         ; carregar contador de iteracoes no acumulador
  ADD #1            ; soma 1 ao acumulador
  STA COUNT         ; count += 1
  LDA LENGTH        ; carrega tamanho do vetor no acumulador
  SUB #1            ; subtrai 1
  SUB COUNT         ; acumulador -= count
  JN FIM_FOR_LOOP   ; se for negativo finalizo o for_loop
  JMP COMPARE       ; caso contrario verifico se *ptr1 > *ptr2
;------------------------------------------------------

;------------------------------------------------------
; volta pro loop primario quando acaba o for_loop
FIM_FOR_LOOP:
  JMP WHILE_LOOP
;--------------------------------------------------------

;--------------------------------------------------------
; compara os valores apontados por ptr1 e ptr2
COMPARE:
  LDA @TMP_PTR1       ; carrega valor apontado por ptr1 no acumulador
  SUB @TMP_PTR2       ; *ptr2 - *ptr1
  JP SWAP             ; se for positivo *ptr1 eh maior entao troco as entradas

; indo pra swap ou nao eu incremento os ponteiros para proxima iteracao
INCREMENTA_PTRS:
  LDA TMP_PTR1            ; carrega ptr1 no acumulador   
  ADD #2                  ; soma 2 no acumulador
  STA TMP_PTR1            ; ptr1++
  ADD #2                  ; soma 2 no acumulador
  STA TMP_PTR2            ; ptr2 = ptr1 + 4
  JMP FOR_LOOP            ; volta pro for_loop
;-------------------------------------------------------

;------------------------------------------------------
; troca os valores apontados por ptr1 e ptr2
SWAP:
  LDA @TMP_PTR1                  ; valor apontado de ptr1 no acumulador
  STA TMP_VALUE                  ; temp = *ptr1
  LDA @TMP_PTR2                  ; valor apontado de ptr2 no acumulador
  STA @TMP_PTR1                  ; *ptr1 = *ptr2
  LDA TMP_VALUE                  ; valor temporario (*ptr1) no acumulador
  STA @TMP_PTR2                  ; *ptr2 = *ptr1
  LDA #1                         ; carrega 1 no acumulador
  STA TROCOU                     ; booleano para verificacao de troca de variaveis
  JMP INCREMENTA_PTRS            ; apos trocar os valores incrementos os ponteiros para proxima iteracao
;--------------------------------------------------------

;--------------------------------------------------------
; termina execucao do programa
SAIR:
  HLT
;----------------------------------------------------------
