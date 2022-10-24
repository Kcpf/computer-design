LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY memoriaROM IS
  GENERIC (
    dataWidth : NATURAL := 4;
    addrWidth : NATURAL := 3
  );
  PORT (
    Endereco : IN STD_LOGIC_VECTOR (addrWidth - 1 DOWNTO 0) := (OTHERS => '0');
    Dado : OUT STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0) := (OTHERS => '0')
  );
END ENTITY;

ARCHITECTURE assincrona OF memoriaROM IS
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

  TYPE blocoMemoria IS ARRAY(0 TO 2 ** addrWidth - 1) OF STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0);

  FUNCTION initMemory
    RETURN blocoMemoria IS VARIABLE tmp : blocoMemoria := (OTHERS => (OTHERS => '0'));
  BEGIN
    -- SETUP:
    tmp(0) := LDI & "00" & "000000001"; -- LDI %R0, 1
    tmp(1) := STA & "00" & "000000000"; -- STA %R0, @0
    tmp(2) := LDI & "01" & "000000010"; -- LDI %R1, 2
    tmp(3) := SOMA & "01" & "000000000"; -- SOMA %R1, @0
    tmp(4) := CGT & "01" & "000000000"; -- CGT %R1, @0
    tmp(5) := JGT & "00" & "000001000"; -- JGT @0
    tmp(6) := LDI & "01" & "000001001"; -- LDI %R1, 0
    tmp(7) := SOMA & "01" & "000000000"; -- SOMA %R1, @0

    tmp(8) := NOP & "00" & "000000000"; -- NOP

    RETURN tmp;
  END initMemory;

  SIGNAL memROM : blocoMemoria := initMemory;

BEGIN
  Dado <= memROM (to_integer(unsigned(Endereco)));
END ARCHITECTURE;