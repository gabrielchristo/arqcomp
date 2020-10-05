;---------------------------------------------------
; Program: Descobrir palindromo
; Author:  Vinícius Lima Medeiros
; Date:    03/10/2020
;---------------------------------------------------
; OBS: o caractere final ao invés de ser o nulo será a #
ORG 500
letra: DS 1             ; letra que foi recém digitada no console
                        ; pilha 1 serve para por as letras de input do console
                        ; pilha 2 serve para desempilhar a pilha 1 para fazer a comparação com ela com os valores invertidos
top1: DW 0     ; guarda o topo da pilha1
top2: DW 0   ; guarda o topo da pilha2
pos1: DW 0      ; posição que está sendo desempilhada a letra da pilha1
letra1: DW 0    ; letra desempilhada da pilha1
fim1: DB 0
fim2: DB 0
ORG 0
inicio:
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

      SUB    #44      ; diminuir 44 do acumulador (ascii do "," em decimal)
      JZ     leitura  ; se o valor no acumulador antes da subtração era 44, então a flag z será
                      ; setada após o SUB e o caractere do console será ignorado voltando para a flag leitura
      ADD    #44      ; desfazendo o SUB #44 já que não era o "," o caractere de entrada
                      ; recuperando o valor do acumulador

      SUB    #59      ; diminuir 59 do acumulador (ascii do ";" em decimal)
      JZ     leitura  ; se o valor no acumulador antes da subtração era 59, então a flag z será
                      ; setada após o SUB e o caractere do console será ignorado voltando para a flag leitura
      ADD    #59      ; desfazendo o SUB #59 já que não era o ";" o caractere de entrada
                      ; recuperando o valor do acumulador

      SUB    #46      ; diminuir 46 do acumulador (ascii do "." em decimal)
      JZ     leitura  ; se o valor no acumulador antes da subtração era 46, então a flag z será
                      ; setada após o SUB e o caractere do console será ignorado voltando para a flag leitura
      ADD    #46      ; desfazendo o SUB #46 já que não era o "." o caractere de entrada
                      ; recuperando o valor do acumulador

      SUB    #58      ; diminuir 58 do acumulador (ascii do ":" em decimal)
      JZ     leitura  ; se o valor no acumulador antes da subtração era 58, então a flag z será
                      ; setada após o SUB e o caractere do console será ignorado voltando para a flag leitura
      ADD    #58      ; desfazendo o SUB #58 já que não era o ":" o caractere de entrada
                      ; recuperando o valor do acumulador

      SUB    #63      ; diminuir 63 do acumulador (ascii do "?" em decimal)
      JZ     leitura  ; se o valor no acumulador antes da subtração era 63, então a flag z será
                      ; setada após o SUB e o caractere do console será ignorado voltando para a flag leitura
      ADD    #63      ; desfazendo o SUB #63 já que não era o "?" o caractere de entrada
                      ; recuperando o valor do acumulador

      SUB    #33      ; diminuir 33 do acumulador (ascii do "!" em decimal)
      JZ     leitura  ; se o valor no acumulador antes da subtração era 33, então a flag z será
                      ; setada após o SUB e o caractere do console será ignorado voltando para a flag leitura
      ADD    #33      ; desfazendo o SUB #33 já que não era o "!" o caractere de entrada
                      ; recuperando o valor do acumulador

      SUB    #34      ; diminuir 34 do acumulador (ascii do "/"/" em decimal)
      JZ     leitura  ; se o valor no acumulador antes da subtração era 34, então a flag z será
                      ; setada após o SUB e o caractere do console será ignorado voltando para a flag leitura
      ADD    #34      ; desfazendo o SUB #34 já que não era o "/"/" o caractere de entrada
                      ; recuperando o valor do acumulador

      SUB    #40      ; diminuir 40 do acumulador (ascii do "(" em decimal)
      JZ     leitura  ; se o valor no acumulador antes da subtração era 40, então a flag z será
                      ; setada após o SUB e o caractere do console será ignorado voltando para a flag leitura
      ADD    #40      ; desfazendo o SUB #40 já que não era o "(" o caractere de entrada
                      ; recuperando o valor do acumulador

      SUB    #45      ; diminuir 45 do acumulador (ascii do "-" em decimal)
      JZ     leitura  ; se o valor no acumulador antes da subtração era 45, então a flag z será
                      ; setada após o SUB e o caractere do console será ignorado voltando para a flag leitura
      ADD    #45      ; desfazendo o SUB #45 já que não era o "-" o caractere de entrada
                      ; recuperando o valor do acumulador

                          ; se cair aqui o usuário já digitou o caractere final da string o #
      SUB    #35          ; diminuir 35 do acumulador (ascii do "#" em decimal) que será o último caractere da frase (o substituto do caractere nulo)
      JZ     desempilha   ; se o valor no acumulador antes da subtração era 35, então a flag z será
                          ; setada após o SUB e o caractere do console será ignorado indo para a flag desempilha para gerar a pilha com string invertida
      ADD    #35          ; desfazendo o SUB #35 já que não era o "#" o caractere de entrada
                          ; recuperando o valor do acumulador

guarda_caracter:
      STA    letra    ; guarda o caractér na memoria
      LDA    #2       ; parâmetro adicional do trap
      TRAP   letra    ; printa o endereço em "letra" no console (acumulador = 2)
      LDA    letra    ; Coloca a letra no acumulador
      PUSH            ; Coloca a letra que está no acumulador na pilha1
      STS top1  ; Salva o topo da pilha1 na variavel
      STS pos1   ; Por enquanto a posicao do valor da pilha a ser desempilhado vai ser o topo até chegar no loop do desempilha
      JMP    leitura     ; Continua lendo

desempilha:                ; só dá push na segunda pilha com os valores do pop da primeira (salvar invertido na segunda pilha)
      POP                  ; da pop na pilha1 e guarda o valor no acumulador
      SUB #35              ; diminuir 35 do acumulador (ascii do "#" em decimal) que será o último caractere da frase (o substituto do caractere nulo)
      JZ  testa_fim1       ; se foi igual a # segunda e primeira pilha já estão prontas para o teste de palíndromo
      ADD #35              ; desfazendo o SUB #35 já que não era o "#" o caractere de entrada
                           ; recuperando o valor do acumulador
      STS pos1     ; salva a posicao de desempilhamento de letra da pilha1 (após o pop)
      LDS top2  ; seta o endereco da pilha2 em SP para desempilhar os valores da pilha1 nela
      PUSH                 ; guarda o valor desempilhado da pilha1 na 2 que estava no acumulador após o pop
      STS top2  ; salva o novo topo da pilha_dois após o push
      LDS pos1     ; seta SP com a posicao antiga da pilha1
      JMP desempilha ; se não encontrou o caractere # volta a desempilhar

testa_fim1:          ; testa se o caractere # vai ser desempilhado da pilha1
      LDS top1       ; recupera o topo da pilha1 original (não é a posição do desempilha pos1)
                     ; e sim o da última letra que foi colocada após a leitura)
      POP            ; coloca esse valor no acumulador
      PUSH           ; restaura o topo original (pois a comparação aqui é só se acabou ou nao)
      SUB #35        ; diminuir 35 do acumulador (ascii do "#" em decimal) que será o último caractere da frase (o substituto do caractere nulo)
      JNZ testa_fim2 ; se o caractere nulo não foi achado, pular para o teste_fim2 e não setar fim1 (continuar 0)
      LDA #1         ; se tiver achado então setar na variavel fim1 que a pilha1 já chegou ao final
      STA fim1       ; com o valor #1


testa_fim2:          ; testa se o caractere # vai ser desempilhado da pilha2
      LDS top2       ; recupera o topo da pilha2 original
                     ; e sim o da última letra que foi colocada após a leitura)
      POP            ; coloca esse valor no acumulador
      PUSH           ; restaura o topo original (pois a comparação aqui é só se acabou ou nao)
      SUB #35        ; diminuir 35 do acumulador (ascii do "#" em decimal) que será o último caractere da frase (o substituto do caractere nulo)
      JNZ testa      ; se o caractere nao foi achado, voltar para o teste de palindromo e nao setar fim2 (continuar 0)
      LDA #1         ; se tiver então setar na variavel fim2 que a pilha2 já chegou ao final
      STA fim2       ; com o valor #1

testa:               ; aqui será testado a partir de pops das duas pilhas se a string digitada foi palindroma ou não
      LDA fim1       ; coloca o valor de fim1 no acumulador
      XOR fim2       ; XOR com fim2, se forem diferentes, então não é palindromo pois um acabou antes do outro achar o caractere final
      JNZ n_pali     ; se o xor der 1 ou seja uma pilha chegou ao final e a outra nao, certamente nao sao palindromos

                     ; se não deu jump no comando acima, então so podemos ter a combinação 0 xor 0 e 1 xor 1.
      LDA fim1       ; guardar fim1 no acumulador
      ADD fim2       ; somar com fim2
      SUB #2         ; se fim1 e fim2 forem iguais a 1, então a soma dará 2
      JZ  pali       ; se a subtração der 0 será palindromo, pois ambas chegaram ao final ao mesmo tempo
                     ; sem ter letras diferentes em nenhum caso
                     ; se não então continuaremos a comparar as letras do topo das duas pilhas

      LDS top1       ; carrega o topo da pilha1 um em sp
      POP            ; pega o valor do topo da pilha2 e põe no acumulador
      STA letra      ; joga esse valor pra variável auxiliar letra
      STS top1       ; salva o novo topo da pilha1 após o pop

      LDS top2       ; carrega o topo da pilha2 um em sp
      POP            ; pega o valor do topo da pilha2 e põe no acumulador
      STS top2       ; salva o novo topo da pilha2 após o pop
      SUB letra      ; subtrai o valor do acumulador que é a letra do topo da pilha2 (após o pop)
                     ; com a letra do topo da pilha1 que está armazenada na variável auxiliar letra
      JNZ n_pali     ; se a subtração não der zero, ou seja as letras não forem iguais, certamente não é palíndromo
      JMP testa_fim1 ; se são iguais continuar buscando o caractere final para só assim saber se todas as letras das pilhas são iguais

pali:
       LDA #0
       HLT
n_pali:
       LDA #1
       HLT


