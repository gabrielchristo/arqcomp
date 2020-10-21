;---------------------------------------------------
; Program: Calculadora Simples
; Author:  Vinícius Lima Medeiros
; Date:    05/10/2020
;---------------------------------------------------
; formato de entrada do console da calculadora exemplos:
;   +n1*+n2=
;   +n1-n2=
;   -n1-n2=
;   -n1*-n2=
;   sinal numero1 sinal numero2 (sinal de igual) para soma
;   sinal numero1 (sinal de multiplicação) sinal numero2 (sinal de igual) para soma
ORG 500
cont_sinal: DS 1        ; quantas vezes o sinal de mais ou menos apareceu no console
digito: DS 1         ; caractere que foi recém digitado no console


; sinal + = 0 sinal - = 1   , multi = 1 se for achado o * e multi = 0 se não for encontrado
sinal1 : DS 1           ; para saber o sinal da 1 parcela
sinal2 : DS 1           ; para saber o sinal da 2 parcela
multi  : DS 1           ; para saber se a conta será de multiplicação
qtd_sinal : DS 1        ; para saber a quantidade de sinais já lidos
; pilha 1 serve para por a primeira parcela da conta
; pilha 2 serve para por a segunda parcela da conta
; pilha 3 serve para por o resultado da operação

top1: DW 0   ; guarda o topo da pilha1
top2: DW 0   ; guarda o topo da pilha2
top3: DW 0   ; guarda o topo da pilha3

ORG 0
inicio:
      LDS #0AAAAh ; endereco do topo inicial da pilha3
      LDA #35     ; seta o caracter # no acumulador (esse será o meu caráctere de final da string)
      PUSH        ; coloca o caractere # na pilha
      STS top3    ; seta na variavel com o endereco do SP


      LDS #08000h           ; endereco do topo inicial da pilha2
      LDA #35               ; seta o caracter # no acumulador (esse será o meu caráctere de final da string)
      PUSH                  ; coloca o caractere # na pilha
      STS top2              ; seta na variavel com o endereco do SP

      LDS #0FFFFh           ; seta o endereço do topo inicial da pilha1 em SP
      LDA #35               ; seta o caracter # no acumulador (esse será o meu caráctere de final da string)
      PUSH                  ; coloca o caractere # na pilha
      STS top1              ; seta na variavel com o endereco do SP

      LDA #0         ; seta 0 no acumulador
      STA cont_sinal ; passa esse valor para o contador de sinal

      LDA #0         ; seta 0 no acumulador
      STA sinal1     ; passa esse valor para o sinal1 (iniciado como positivo: 0)

      LDA #0         ; seta 0 no acumulador
      STA sinal2     ; passa esse valor para o sinal2 (iniciado como positivo: 0)

      LDA #0         ; seta 0 no acumulador
      STA multi      ; passa esse valor para o multi

      LDA #0         ; seta 0 no acumulador
      STA qtd_sinal  ; quantidade de mais ou menos lidos (para controlar entrada das parcelas)

le_parcela:
      LDA    #1         ; parâmetro adicional do trap (passado pelo acumulador)
      TRAP   0          ; chama trap com argumentos 1 (ler console)
                        ; e 0 (nenhum endereço)
      OR     #0         ; faz or bit a bit com o acumulador, ligando a flag z se nada for digitada
      JZ     le_parcela ; voltar a ler se nenhuma letra foi digitada

identifica_sinal:
      STA    digito     ; guarda o valor digitado em digito
      SUB    #45        ; diminuir 45 do acumulador (ascii do "-" em decimal)
      JZ     seta_neg   ; se o valor no acumulador antes da subtração era 45, então a flag z será
                        ; setada após o SUB e o caractere do console será ignorado voltando para a flag leitura
      ADD    #45        ; desfazendo o SUB #45 já que não era o "-" o caractere de entrada
                        ; recuperando o valor do acumulador


      SUB    #43          ; diminuir 43 do acumulador (ascii do "+" em decimal)
      JZ     seta_pos     ; se o valor no acumulador antes da subtração era 43, então a flag z será
                          ; setada após o SUB e o caractere do console será ignorado voltando para a flag leitura
      ADD    #43          ; desfazendo o SUB #43 já que não era o "+" o caractere de entrada
                          ; recuperando o valor do acumulador

      SUB    #42          ; diminuir 42 do acumulador (ascii do "*" em decimal)
      JZ     seta_mult    ; se o valor no acumulador antes da subtração era 42, então a flag z será
                          ; setada após o SUB e o caractere do console será ignorado voltando para a flag leitura
      ADD    #42          ; desfazendo o SUB #42 já que não era o "+" o caractere de entrada

      SUB    #61          ; diminuir 61 do acumulador (ascii do "=" em decimal)
      JZ     igual        ; se o valor no acumulador antes da subtração era 61, então a flag z será
                          ; setada após o SUB e o caractere do console será ignorado voltando para a flag leitura
      ADD    #61          ; desfazendo o SUB #61 já que não era o "+" o caractere de entrada



guarda_digito:
      LDA    #2           ; parâmetro adicional do trap
      TRAP   digito       ; printa o endereço em "letra" no console (acumulador = 2)
      LDA    qtd_sinal    ; recupera a qtd_sinal no acumulador
      SUB    #1           ; subtrai para fazer o teste
      JZ     empilha1     ; se qtd_sinal era 1 empilhar na parcela1
empilha2:                 ; empilha na pilha da parcela2
      LDS    top2         ; recupera o valor do topo da pilha
      LDA    digito       ; recupera o valor do digito lido no acumulador
      PUSH                ; Coloca a letra que está no acumulador na pilha1
      STS    top2         ; Salva o topo da pilha1 na variavel
      JMP    le_parcela   ; Continua lendo
empilha1:                 ; empilha na pilha da parcela1
      LDS    top1         ; recupera o valor do topo da pilha
      LDA    digito       ; recupera o valor do digito lido no acumulador
      PUSH                ; Coloca a letra que está no acumulador na pilha1
      STS    top1         ; Salva o topo da pilha1 na variavel
      JMP    le_parcela   ; Continua lendo


seta_neg:
      ADD    #45
      STA    digito       ; guarda o caractér na memoria
      LDA    #2           ; parâmetro adicional do trap
      TRAP   digito       ; printa o endereço em "letra" no console (acumulador = 2)

      LDA qtd_sinal   ; seta qtd_sinal no acumulador
      SUB #1          ; diminui 1 para o JZ
      JZ  seta_neg2   ; se a qtd_sinal foi 1 antes da subtracao, então estamos setando o segundo sinal

seta_neg1:            ; seta o primeiro sinal como negativo
      ADD #1          ; recupera a subtração
      ADD #1          ; soma pois achou um sinal
      STA qtd_sinal   ; joga para qtd_sinal
      LDA #1          ; bota o valor do sinal1 no acumulador 1 para negativo
      STA sinal1      ; seta sinal1 como negativo
      JMP le_parcela  ; volta a ler o resto da parcela

seta_neg2:            ; seta o segundo sinal como negativo
      ADD #1          ; recupera a subtração para teste do jz
      ADD #1          ; como foi encontrado mais um sinal então vamos somar
      STA qtd_sinal   ; joga o valor do acumulador para qtd_sinal
      LDA #1          ; seta 1 no acumulador
      STA sinal2      ; marca como um na variavel sinal1 (negativo)
      JMP le_parcela  ; continua lendo a parcela


seta_pos:
      ADD    #43
      STA    digito       ; guarda o caractér na memoria
      LDA    #2           ; parâmetro adicional do trap
      TRAP   digito       ; printa o endereço em "letra" no console (acumulador = 2)
      LDA qtd_sinal   ; seta qtd_sinal no acumulador
      SUB #1          ; diminui 1 para o JZ
      JZ  seta_pos2    ; se a qtd_sinal foi 1 antes da subtracao, então estamos setando o segundo sinal
seta_pos1:
      ADD #1          ; recupera a subtração
      ADD #1          ; soma pois achou um sinal
      STA qtd_sinal   ; joga para qtd_sinal
      JMP le_parcela  ; volta a ler o resto da parcela
seta_pos2:
      ADD #1           ; recupera a subtração
      ADD #1           ; soma pois achou um sinal
      STA qtd_sinal    ; joga para qtd_sinal
      JMP le_parcela   ; continua lendo parcela

seta_mult:
      LDA #1
      STA multi
      JMP le_parcela

igual:
      HLT
