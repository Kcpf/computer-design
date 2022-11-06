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
CLT - Compare if Less Than
CGT - Compare if Greater Than
JLT - Jump if Less Than
JGT - Jump if Greater Than
AND - Logical AND
OR - Logical OR
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

  MEM[14] = Constante 9
  MEM[15] = Constante 5
  MEM[16] = Constante 3

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

## PyFPGA

### Archive project

```
quartus_sh --archive <project name>
```
