LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ROM IS
  PORT (
    Endereco : IN STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
    Dado : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE assincrona OF ROM IS
  TYPE blocoMemoria IS ARRAY(0 TO 63) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

  FUNCTION initMemory
    RETURN blocoMemoria IS VARIABLE tmp : blocoMemoria := (OTHERS => (OTHERS => '0'));
  BEGIN

    tmp(0) := x"012A4020";
    tmp(1) := x"01495820";
    tmp(2) := x"010B6024";
    tmp(3) := x"010B6825";

    -- 0    :   012A4020;    -- add t0, t1, t2
    -- 1    :   01495820;    -- sub t3, t2, t1
    -- 1    :   010B6024;    -- and t4, t0, t3
    -- 1    :   010B6825;    -- or t5, t0, t3

    RETURN tmp;
  END initMemory;

  SIGNAL memROM : blocoMemoria := initMemory;

  -- Utiliza uma quantidade menor de endereços locais:
  SIGNAL EnderecoLocal : STD_LOGIC_VECTOR(5 DOWNTO 0);

BEGIN
  EnderecoLocal <= Endereco(7 DOWNTO 2);
  Dado <= memROM (to_integer(unsigned(EnderecoLocal)));
END ARCHITECTURE;