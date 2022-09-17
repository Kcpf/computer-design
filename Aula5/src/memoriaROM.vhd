LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY memoriaROM IS
  GENERIC (
    dataWidth : NATURAL := 4;
    addrWidth : NATURAL := 3
  );
  PORT (
    Endereco : IN STD_LOGIC_VECTOR (addrWidth - 1 DOWNTO 0);
    Dado : OUT STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE assincrona OF memoriaROM IS

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

  TYPE blocoMemoria IS ARRAY(0 TO 2 ** addrWidth - 1) OF STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0);

  FUNCTION initMemory
    RETURN blocoMemoria IS VARIABLE tmp : blocoMemoria := (OTHERS => (OTHERS => '0'));
  BEGIN
    tmp(0) := JSR & "0" & x"0E";
    tmp(1) := JMP & "0" & x"05";
    tmp(2) := JEQ & "0" & x"09";
    tmp(3) := NOP & "0" & x"00";
    tmp(4) := NOP & "0" & x"00";
    tmp(5) := LDI & "0" & x"05";
    tmp(6) := STA & "1" & x"00";
    tmp(7) := CEQ & "1" & x"00";
    tmp(8) := JMP & "0" & x"02";
    tmp(9) := NOP & "0" & x"00";
    tmp(10) := LDI & "0" & x"04";
    tmp(11) := CEQ & "1" & x"00";
    tmp(12) := JEQ & "0" & x"03";
    tmp(13) := JMP & "0" & x"0D";
    tmp(14) := NOP & "0" & x"00";
    tmp(15) := RET & "0" & x"00";

    RETURN tmp;
  END initMemory;

  SIGNAL memROM : blocoMemoria := initMemory;

BEGIN
  Dado <= memROM (to_integer(unsigned(Endereco)));
END ARCHITECTURE;