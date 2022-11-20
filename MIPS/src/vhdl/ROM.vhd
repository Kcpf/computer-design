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

    tmp(0) := x"AC090008";
    tmp(1) := x"8C080008";
    tmp(2) := x"012A4022";
    tmp(3) := x"012A4024";
    tmp(4) := x"012A4025";
    tmp(5) := x"012A402A";
    tmp(6) := x"010A4020";
    tmp(7) := x"110BFFFE";
    tmp(8) := x"08000000";

    RETURN tmp;
  END initMemory;

  SIGNAL memROM : blocoMemoria := initMemory;

  -- Utiliza uma quantidade menor de endereços locais:
  SIGNAL EnderecoLocal : STD_LOGIC_VECTOR(5 DOWNTO 0);

BEGIN
  EnderecoLocal <= Endereco(7 DOWNTO 2);
  Dado <= memROM (to_integer(unsigned(EnderecoLocal)));
END ARCHITECTURE;