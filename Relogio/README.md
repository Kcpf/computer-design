# Código Assembly

## Intruções

```
NOP - No Operation
LDA - Load Accumulator
SOMA - Add
SUB - Subtract
LDI - Load Immediate
STA - Store Accumulator
JMP - Jump
JEQ - Jump if Equal
CEQ - Compare if Equal
JSR - Jump to Subroutine
RET - Return from Subroutine
```

## Mapa de memória

```
RAM:
  MEM[0] = Constante 0
  MEM[1] = Constante 1
  MEM[2] = Constante 2
  MEM[3] = Constante 4
  MEM[4] = Constante 6
  MEM[5] = Constante 10

  MEM[6] = Segundos Unidade
  MEM[7] = Segundos Decimal
  MEM[8] = Minutos Unidade
  MEM[9] = Minutos Decimal
  MEM[10] = Horas Unidade
  MEM[11] = Horas Decimal
  MEM[12] = Flag Rapido

LEDR:
  MEM[256] = LEDR0 - LEDR7
  MEM[257] = LEDR8 (inibe contagem)
  MEM[258] = LEDR9 (overflow)

HEX:
  MEM[288] = HEX0 (unidade)
  MEM[289] = HEX1 (dezena)
  MEM[290] = HEX2 (centena)
  MEM[291] = HEX3 (unidade limite)
  MEM[292] = HEX4 (dezena limite)
  MEM[293] = HEX5 (centena limite)

SW:
  MEM[320] = SW0 - SW7
  MEM[321] = SW8
  MEM[322] = SW9

KEY:
  MEM[352] = KEY0 (incrementa contador)
  MEM[353] = KEY1 (configura limite)
  MEM[354] = KEY2
  MEM[355] = KEY3
  MEM[356] = FPGA_RESET
  MEM[357] = RELOGIO 1S
  MEM[358] = RELOGIO 1S FAST

LIMPA:
  MEM[505] = Limpa RELOGIO 1S FAST
  MEM[506] = Limpa RELOGIO 1S
  MEM[507] = Limpa FPGA_RESET
  MEM[508] = Limpa KEY3
  MEM[509] = Limpa KEY2
  MEM[510] = Limpa KEY1
  MEM[511] = Limpa KEY0
```

## Setup

```
SETUP:
  LDI $0

  // Reseta os LEDS
  STA @256
  STA @257
  STA @258

  // Reseta os HEX
  STA @288
  STA @289
  STA @290
  STA @291
  STA @292
  STA @293


  STA @0 // Inicializa contante 0 na posição 0

  LDI $1
  STA @1 // Inicializa contante 1 na posição 1

  LDI $10
  STA @2 // Inicializa contante 10 na posição 2

  LDI $0
  STA @3 // Inicializa unidade contador na posição 3
  STA @4 // Inicializa dezena contador na posição 4
  STA @5 // Inicializa centena contador na posição 5
  STA @6 // Inicializa flag inibe contagem na posição 6

  JSR @CONFIGURA_LIMITE
```

## Loop Principal

```
LOOP:
  LDA @352 // Lê o botão KEY0
  CEQ @0

  LDI $1
  STA @511  // Limpa KEY0

  JEQ @ESCREVE_VALOR // Se KEY0 não estiver pressionado, pula para o label ESCREVE_VALOR
  JSR @INCREMENTO // Incrementa o contador se KEY0 foi pressionado

  ESCREVE_VALOR:
    LDA @3 // Lê unidade contador
    STA @288 // Escreve unidade contador no HEX0

    LDA @4 // Lê dezena contador
    STA @289 // Escreve dezena contador no HEX1

    LDA @5 // Lê centena contador
    STA @290 // Escreve centena contador no HEX2


  LDA @353 // Lê o botão KEY1
  CEQ @0

  JEQ @LINHA_LIMITE // Se KEY1 não estiver pressionado, pula para o label LINHA_LIMITE

  LDI $1
  STA @510  // Limpa KEY1
  JSR @CONFIGURA_LIMITE // Configura o limite do contador se KEY1 foi pressionado
  JSR @RESET // Reseta o contador

  LINHA_LIMITE:
    JSR @LIMITE // Verifica se o contador atingiu o limite

  LDA @356 // Lê o botão FPGA_RESET
  CEQ @0

  JEQ @LOOP // Se FPGA_RESET não estiver pressionado, pula para o label LOOP

  LDI $1
  STA @507  // Limpa FPGA_RESET
  JSR @RESET // Reseta o contador

  JMP @LOOP // Volta para o label LOOP
```

## Sub Rotinas

### Configura Limite de Incremento

```
CONFIGURA_LIMITE:
  LDA @320  // Ler valor das chaves
  STA @7  // Salva valor das chaves no limite unidade
  STA @291  // Escreve valor das chaves no HEX3

  LDA @353 // Verifica se o KEY 1 foi pressionado
  CEQ @0
  JEQ @CONFIGURA_LIMITE  // Se KEY 1 não foi pressionado, volta para o label CONFIGURA_LIMITE

  // Se sim, limpa o valor do KEY 1
  LDI $1
  STA @510

  CONFIGURA_LIMITE_2:
    LDA @320  // Ler valor das chaves
    STA @8  // Salva valor das chaves no limite dezena
    STA @292  // Escreve valor das chaves no HEX4

    LDA @353  // Verifica se o KEY 1 foi pressionado
    CEQ @0
    JEQ @CONFIGURA_LIMITE_2  // Se KEY 2 não foi pressionado, volta para o label CONFIGURA_LIMITE_2

    // Se sim, limpa o valor do KEY 1
    LDI $1
    STA @510

  CONFIGURA_LIMITE_3:
    LDA @320  // Ler valor das chaves
    STA @9  // Salva valor das chaves no limite centena
    STA @293 // Escreve valor das chaves no HEX5

    LDA @353  // Verifica se o KEY 1 foi pressionado
    CEQ @0
    JEQ @CONFIGURA_LIMITE_3 // Se KEY 3 não foi pressionado, volta para o label CONFIGURA_LIMITE_3

    // Se sim, limpa o valor do KEY 1
    LDI $1
    STA @510

  RET
```

### Incremento do contador

```
INCREMENTO:
  LDA @6  // Lê flag inibe contagem
  CEQ @1
  JEQ @INCREMENTO_FINAL  // Se flag inibe contagem for 1, pula para o fim da rotina

  LDA @3  // Lê unidade contador
  SOMA @1
  CEQ @2  // Verifica se o valor somado é igual a 10
  JEQ @INCREMENTO_DEZENA  // Se sim, pula para o label INCREMENTO_DEZENA
  STA @3  // Se não, salva o valor somado na unidade contador
  JMP @INCREMENTO_FINAL  // Pula para o fim da rotina

  INCREMENTO_DEZENA:
    LDI $0
    STA @3  // Reseta unidade contador para 0
    LDA @4  // Lê dezena contador
    SOMA @1
    CEQ @2  // Verifica se o valor somado é igual a 10
    JEQ @INCREMENTO_CENTENA  // Se sim, pula para o label INCREMENTO_CENTENA
    STA @4  // Se não, salva o valor somado na dezena contador
    JMP @INCREMENTO_FINAL   // Pula para o fim da rotina

  INCREMENTO_CENTENA:
    LDI $0
    STA @4  // Reseta dezena contador para 0
    LDA @5  // Lê centena contador
    SOMA @1
    CEQ @2  // Verifica se o valor somado é igual a 10
    JEQ @INCREMENTO_OVERFLOW  // Se sim, pula para o label INCREMENTO_OVERFLOW
    STA @5  // Se não, salva o valor somado na centena contador
    JMP @INCREMENTO_FINAL  // Pula para o fim da rotina

  INCREMENTO_OVERFLOW:
    LDI $0
    STA @5  // Reseta centena contador para 0
    LDI $1
    STA @6  // Seta flag inibe contagem para 1
    STA @258  // Acende o LED 9

  INCREMENTO_FINAL:
    RET
```

### Verifica Limite do Contador

```
LIMITE:
  LDA @3  // Lê unidade contador
  CEQ @7  // Verifica se o valor da unidade contador é igual ao limite unidade
  JEQ @LIMITE_DEZENA  // Se sim, pula para o label LIMITE_DEZENA
  RET   // Se não, finaliza a rotina

  LIMITE_DEZENA:
    LDA @4  // Lê dezena contador
    CEQ @8  // Verifica se o valor da dezena contador é igual ao limite dezena
    JEQ @LIMITE_CENTENA   // Se sim, pula para o label LIMITE_CENTENA
    RET   // Se não, finaliza a rotina

  LIMITE_CENTENA:
    LDA @5  // Lê centena contador
    CEQ @9  // Verifica se o valor da centena contador é igual ao limite centena
    JEQ @LIMITE_COMPARACAO  // Se sim, pula para o label LIMITE_COMPARACAO
    RET  // Se não, finaliza a rotina

  LIMITE_COMPARACAO:
    LDI $1
    STA @6  // Seta flag inibe contagem para 1
    STA @257  // Acende o LED 8

  RET
```

## Reinicia o contador

```
RESET:
  LDI $0

  STA @3  // Reseta unidade contador
  STA @4  // Reseta dezena contador
  STA @5  // Reseta centena contador
  STA @6  // Reseta flag inibe contagem
  STA @257  // Apaga o LED 8
  STA @258  // Apaga o LED 9

  RET
```
