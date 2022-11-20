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

    tmp(0) := x"8C0C0000";
    tmp(1) := x"11090003";
    tmp(2) := x"11090003";
    tmp(3) := x"AD0A0000";
    tmp(4) := x"8C0B0000";
    tmp(5) := x"114B0002";
    tmp(6) := x"11090003";
    tmp(7) := x"11090003";
    tmp(8) := x"01285820";
    tmp(9) := x"012B4020";
    tmp(10) := x"08000008";

    -- 0    :   8C0C0000;    -- lw   $t4,  0x0($zero)
    -- 1    :   11090003;    -- beq  $t0, $t1, 0x3
    -- 2    :   11090003;    -- beq  $t0, $t1, 0x3
    -- 3    :   AD0A0000;    -- sw   $t2,  0x0($t0)
    -- 4    :   8C0B0000;    -- lw   $t3,  0x0($zero)
    -- 5    :   114B0002;    -- beq  $t2, $t3, 0x2
    -- 6    :   11090003;    -- beq  $t0, $t1, 0x3
    -- 7    :   11090003;    -- beq  $t0, $t1, 0x3
    -- 8    :   01285820;    -- add  $t3, $t1, $t0
    -- 9    :   012B4020;    -- add  $t0, $t1, $t3
    -- 10   :   08000008;    -- j    0x08

    RETURN tmp;
  END initMemory;

  SIGNAL memROM : blocoMemoria := initMemory;

  -- Utiliza uma quantidade menor de endereços locais:
  SIGNAL EnderecoLocal : STD_LOGIC_VECTOR(5 DOWNTO 0);

BEGIN
  EnderecoLocal <= Endereco(7 DOWNTO 2);
  Dado <= memROM (to_integer(unsigned(EnderecoLocal)));
END ARCHITECTURE;