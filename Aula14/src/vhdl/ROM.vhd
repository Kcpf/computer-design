LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ROM IS
  GENERIC (
    dataWidth : NATURAL := 32;
    addrWidth : NATURAL := 32;
    memoryAddrWidth : NATURAL := 6); -- 64 posicoes de 32 bits cada
  PORT (
    Endereco : IN STD_LOGIC_VECTOR (addrWidth - 1 DOWNTO 0);
    Dado : OUT STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0));
END ENTITY;

ARCHITECTURE assincrona OF ROM IS
  TYPE blocoMemoria IS ARRAY(0 TO 2 ** memoryAddrWidth - 1) OF STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0);

  FUNCTION initMemory
    RETURN blocoMemoria IS VARIABLE tmp : blocoMemoria := (OTHERS => (OTHERS => '0'));
  BEGIN
    -- OPCODE & RS & RT & RD & SHAMT & FUNCT (TIPO R)
    -- OPCODE & RS & RT & IMMEDIATE (TIPO I)
    tmp(0) := "000000" & "01000" & "01100" & "0000000000010001"; -- SW T4, @(T0 + 17)
    tmp(1) := "000000" & "00000" & "01101" & "0000000000010001"; -- LW @(ZERO + 17), T5
    tmp(2) := "000000" & "01101" & "01100" & "01101" & "00000" & "000000"; -- ADD (T4 + T5), T5
    tmp(3) := "000000" & "00000" & "01010" & "0000000000010001"; -- LW @(ZERO + 17), T2
    tmp(4) := "000000" & "00000" & "01011" & "0000000000010001"; -- LW @(ZERO + 17), T3
    tmp(5) := "000000" & "01010" & "01011" & "1111111111111110";

    RETURN tmp;
  END initMemory;

  SIGNAL memROM : blocoMemoria := initMemory;

  -- Utiliza uma quantidade menor de endereços locais:
  SIGNAL EnderecoLocal : STD_LOGIC_VECTOR(memoryAddrWidth - 1 DOWNTO 0);

BEGIN
  EnderecoLocal <= Endereco(memoryAddrWidth + 1 DOWNTO 2);
  Dado <= memROM (to_integer(unsigned(EnderecoLocal)));
END ARCHITECTURE;