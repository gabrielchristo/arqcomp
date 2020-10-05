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
caractere: DS 1         ; caractere que foi recém digitado no console
                        ; pilha 1 serve para por a primeira parcela da conta
                        ; pilha 2 serve para por a segunda parcela da conta
                        ; pilha 3 serve para por o resultado da operação

top1: DW 0   ; guarda o topo da pilha1
top2: DW 0   ; guarda o topo da pilha2
top3: DW 0   ; guarda o topo da pilha3
inicio:
      LDS #0AAAAh ; endereco do topo inicial da pilha3
      LDA #35     ; seta o caracter # no acumulador (esse será o meu caráctere de final da string)
      PUSH        ; coloca o caractere # na pilha
      STS top3    ; seta na variavel com o endereco do SP


      LDS #08000h           ; endereco do topo inicial da pilha2
      LDA #35               ; seta o caracter # no acumulador (esse será o meu caráctere de final da string)
      PUSH                  ; coloca o caractere # na pilha
      STS top2   ; seta na variavel com o endereco do SP

      LDS #0FFFFh           ; seta o endereço do topo inicial da pilha1 em SP
      LDA #35               ; seta o caracter # no acumulador (esse será o meu caráctere de final da string)
      PUSH                  ; coloca o caractere # na pilha
      STS top1     ; seta na variavel com o endereco do SP
leitura:
      LDA    #1       ; parâmetro adicional do trap (passado pelo acumulador)
      TRAP   0        ; chama trap com argumentos 1 (ler console)
                      ; e 0 (nenhum endereço)
      OR     #0       ; faz or bit a bit com o acumulador, ligando a flag z se nada for digitada
      JZ     leitura  ; voltar a ler se nenhuma letra foi digitada

ignorar_caracter:
      SUB    #32      ; diminuir 32 do acumulador (ascii do " " em decimal)
      JZ     leitura  ; se o valor no acumulador antes da subtração era 32, então a flag z será
                      ; setada após o SUB e o caractere do console será ignorado voltando para a flag leitura
      ADD    #32      ; desfazendo o SUB #32 já que não era o " " o caractere de entrada
                      ; recuperando o valor do acumulador


