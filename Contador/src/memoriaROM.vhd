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
    -- SETUP:
    tmp(0) := "0100" & "000000000"; -- LDI $0
    tmp(1) := "0101" & "100000000"; -- STA @256
    tmp(2) := "0101" & "100000001"; -- STA @257
    tmp(3) := "0101" & "100000010"; -- STA @258
    tmp(4) := "0101" & "100100000"; -- STA @288
    tmp(5) := "0101" & "100100001"; -- STA @289
    tmp(6) := "0101" & "100100010"; -- STA @290
    tmp(7) := "0101" & "100100011"; -- STA @291
    tmp(8) := "0101" & "100100100"; -- STA @292
    tmp(9) := "0101" & "100100101"; -- STA @293
    tmp(10) := "0101" & "000000000"; -- STA @0
    tmp(11) := "0101" & "000000011"; -- STA @3
    tmp(12) := "0101" & "000000100"; -- STA @4
    tmp(13) := "0101" & "000000101"; -- STA @5
    tmp(14) := "0101" & "000000110"; -- STA @6
    tmp(15) := "0100" & "000000001"; -- LDI $1
    tmp(16) := "0101" & "000000001"; -- STA @1
    tmp(17) := "0100" & "000001010"; -- LDI $10
    tmp(18) := "0101" & "000000010"; -- STA @2

    -- MAIN:
    tmp(19) := "0001" & "101100000"; -- LDA @352
    tmp(20) := "1000" & "000000000"; -- CEQ @0
    tmp(21) := "0111" & "000010011"; -- JEQ @MAIN
    tmp(22) := "1001" & "000011000"; -- JSR @INCREMENTA
    tmp(23) := "0110" & "000010011"; -- JMP @MAIN

    -- INCREMENTA:
    tmp(24) := "0100" & "000000001"; -- LDI $1
    tmp(25) := "0101" & "111111111"; -- STA @511
    tmp(26) := "0001" & "000000011"; -- LDA @3
    tmp(27) := "0010" & "000000001"; -- SOMA @1
    tmp(28) := "0101" & "000000011"; -- STA @3
    tmp(29) := "0001" & "000000010"; -- LDA @2
    tmp(30) := "1000" & "000000011"; -- CEQ @3
    tmp(31) := "0111" & "000100011"; -- JEQ @INCREMENTA_DEC
    tmp(32) := "0101" & "000000011"; -- STA @3
    tmp(33) := "0101" & "100100000"; -- STA @288
    tmp(34) := "1010" & "000000000"; -- RET

    -- INCREMENTA_DEC:
    tmp(35) := "0100" & "000000000"; -- LDI $0
    tmp(36) := "0101" & "000000011"; -- STA @3
    tmp(37) := "0101" & "100100000"; -- STA @288
    tmp(38) := "0001" & "000000100"; -- LDA @4
    tmp(39) := "0010" & "000000001"; -- SOMA @1
    tmp(40) := "0101" & "000000100"; -- STA @4
    tmp(41) := "0101" & "100100001"; -- STA @289
    tmp(42) := "1010" & "000000000"; -- RET

    RETURN tmp;
  END initMemory;

  SIGNAL memROM : blocoMemoria := initMemory;

BEGIN
  Dado <= memROM (to_integer(unsigned(Endereco)));
END ARCHITECTURE;