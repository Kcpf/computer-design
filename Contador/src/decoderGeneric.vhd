LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decoderGeneric IS
  PORT (
    entrada : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    entrada_flagzero : IN STD_LOGIC := '0';
    saida : OUT STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000"
  );
END ENTITY;

ARCHITECTURE comportamento OF decoderGeneric IS

  CONSTANT NOP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
  CONSTANT LDA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
  CONSTANT SOMA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
  CONSTANT SUB : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
  CONSTANT LDI : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
  CONSTANT STA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
  CONSTANT JMP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
  CONSTANT JEQ : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
  CONSTANT CEQ : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000";
  CONSTANT JSR : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001";
  CONSTANT RET : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010";

  -- saida <= soma when (seletor = "00") else
  --          subtracao when (seletor = "01") else
  --          entradaB when (seletor = "10") else
  --          entradaA;

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
  saida <= "000000000000" WHEN entrada = NOP ELSE
    "000000110010" WHEN entrada = LDA ELSE
    "000000100010" WHEN entrada = SOMA ELSE
    "000000101010" WHEN entrada = SUB ELSE
    "000001110000" WHEN entrada = LDI ELSE
    "000000010001" WHEN entrada = STA ELSE
    "010000000000" WHEN entrada = JMP ELSE
    "000010000000" WHEN (entrada = JEQ AND entrada_flagzero = '1') ELSE
    "000000101110" WHEN entrada = CEQ ELSE
    "100100000000" WHEN entrada = JSR ELSE
    "001000000000" WHEN entrada = RET ELSE
    "000000000000"; -- NOP para os entradas Indefinidas
END ARCHITECTURE;