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
    -- SETUP:
    tmp(0) := "00000000000000000010000100001100";
    tmp(1) := "00000000000000000010000101101001";
    tmp(2) := "00000000000000000010000101001000";

    RETURN tmp;
  END initMemory;

  SIGNAL memROM : blocoMemoria := initMemory;

  -- Utiliza uma quantidade menor de endereços locais:
  SIGNAL EnderecoLocal : STD_LOGIC_VECTOR(memoryAddrWidth - 1 DOWNTO 0);

BEGIN
  EnderecoLocal <= Endereco(memoryAddrWidth + 1 DOWNTO 2);
  Dado <= memROM (to_integer(unsigned(EnderecoLocal)));
END ARCHITECTURE;