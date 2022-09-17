LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decoderGeneric IS
  PORT (
    entrada : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    saida : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
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

BEGIN
  saida <=
    '0' & '0' & '0' & '0' & '0' & '0' & '0' & "00" & '0' & '0' & '0' WHEN entrada = NOP ELSE
    '0' & '0' & '0' & '0' & '0' & '0' & '1' & "10" & '0' & '1' & '0' WHEN entrada = LDA ELSE
    '0' & '0' & '0' & '0' & '0' & '0' & '1' & "00" & '0' & '1' & '0' WHEN entrada = SOMA ELSE
    '0' & '0' & '0' & '0' & '0' & '0' & '1' & "01" & '0' & '1' & '0' WHEN entrada = SUB ELSE
    '0' & '0' & '0' & '0' & '0' & '1' & '1' & "10" & '0' & '0' & '0' WHEN entrada = LDI ELSE
    '0' & '0' & '0' & '0' & '0' & '0' & '0' & "00" & '0' & '0' & '1' WHEN entrada = STA ELSE
    '0' & '1' & '0' & '0' & '0' & '0' & '0' & "00" & '0' & '0' & '0' WHEN entrada = JMP ELSE
    '0' & '0' & '0' & '0' & '1' & '0' & '0' & "00" & '0' & '0' & '0' WHEN entrada = JEQ ELSE
    '0' & '0' & '0' & '0' & '0' & '0' & '0' & "00" & '1' & '1' & '0' WHEN entrada = CEQ ELSE
    '1' & '0' & '0' & '1' & '0' & '0' & '0' & "00" & '0' & '0' & '0' WHEN entrada = JSR ELSE
    '0' & '0' & '1' & '0' & '0' & '0' & '0' & "00" & '0' & '0' & '0' WHEN entrada = RET ELSE
    '0' & '0' & '0' & '0' & '0' & '0' & '0' & "00" & '0' & '0' & '0';

END ARCHITECTURE;