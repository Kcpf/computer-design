LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ROM IS
  GENERIC (
    dataWidth : NATURAL := 4;
    addrWidth : NATURAL := 3
  );
  PORT (
    Endereco : IN STD_LOGIC_VECTOR (addrWidth - 1 DOWNTO 0) := (OTHERS => '0');
    Dado : OUT STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0) := (OTHERS => '0')
  );
END ENTITY;

ARCHITECTURE assincrona OF ROM IS

  TYPE blocoMemoria IS ARRAY(0 TO 2 ** addrWidth - 1) OF STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0);

  FUNCTION initMemory
    RETURN blocoMemoria IS VARIABLE tmp : blocoMemoria := (OTHERS => (OTHERS => '0'));
  BEGIN
    -- SETUP:
    tmp(0) := "00000000000000000" & "00000" & "00010" & "00001";

    RETURN tmp;
  END initMemory;

  SIGNAL memROM : blocoMemoria := initMemory;

BEGIN
  Dado <= memROM (to_integer(unsigned(Endereco)));
END ARCHITECTURE;