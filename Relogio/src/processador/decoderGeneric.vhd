LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decoderGeneric IS
  PORT (
    entrada : IN STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    entrada_flag_zero : IN STD_LOGIC := '0';
    entrada_flag_greater : IN STD_LOGIC := '0';
    entrada_flag_lesser : IN STD_LOGIC := '0';
    saida : OUT STD_LOGIC_VECTOR(13 DOWNTO 0) := (OTHERS => '0')
  );
END ENTITY;

ARCHITECTURE comportamento OF decoderGeneric IS

  CONSTANT NOP : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000";
  CONSTANT LDA : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00001";
  CONSTANT SOMA : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00010";
  CONSTANT SUB : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00011";
  CONSTANT LDI : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00100";
  CONSTANT STA : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00101";
  CONSTANT JMP : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00110";
  CONSTANT JEQ : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00111";
  CONSTANT CEQ : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01000";
  CONSTANT JSR : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01001";
  CONSTANT RET : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01010";
  CONSTANT CLT : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01011";
  CONSTANT CGT : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01100";
  CONSTANT JLT : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01101";
  CONSTANT JGT : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01110";

  -- saida <= soma when (seletor = "00") else
  --          subtracao when (seletor = "01") else
  --          entradaB when (seletor = "10") else
  --          entradaA;

  -- 13 Hab Flag Less Than
  -- 12 Hab Flag Greater Than
  -- 11 None - Hab escrita retorno
  -- 10 None - JMP
  -- 9 None  - RET
  -- 8 JMP   - JSR
  -- 7 JEQ
  -- 6 Sel MUX
  -- 5 Hab A
  -- 4 e 3 Operancao
  -- 2 Hab Flag Zero
  -- 1 RD
  -- 0 WR
BEGIN
  saida <= "00000000000000" WHEN entrada = NOP ELSE
    "00000000110010" WHEN entrada = LDA ELSE
    "00000000100010" WHEN entrada = SOMA ELSE
    "00000000101010" WHEN entrada = SUB ELSE
    "00000001110000" WHEN entrada = LDI ELSE
    "00000000010001" WHEN entrada = STA ELSE
    "00010000000000" WHEN entrada = JMP ELSE
    "00000010000000" WHEN (entrada = JEQ AND entrada_flag_zero = '1') ELSE
    "00000000001110" WHEN entrada = CEQ ELSE
    "00100100000000" WHEN entrada = JSR ELSE
    "00001000000000" WHEN entrada = RET ELSE
    "10000000001010" WHEN entrada = CLT ELSE
    "01000000001010" WHEN entrada = CGT ELSE
    "00000010000000" WHEN (entrada = JLT AND entrada_flag_lesser = '1') ELSE
    "00000010000000" WHEN (entrada = JGT AND entrada_flag_greater = '1') ELSE
    "00000000000000"; -- NOP para os entradas Indefinidas
END ARCHITECTURE;