LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY muxGenerico4x1 IS
  -- Total de bits das entradas e saidas
  GENERIC (larguraDados : NATURAL := 8);
  PORT (
    entradaA_MUX, entradaB_MUX, entradaC_MUX, entradaD_MUX : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0) := (OTHERS => '0');
    seletor_MUX : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    saida_MUX : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0) := (OTHERS => '0')
  );
END ENTITY;

ARCHITECTURE comportamento OF muxGenerico4x1 IS
BEGIN
  saida_MUX <= entradaD_MUX WHEN (seletor_MUX = "11") ELSE
    entradaC_MUX WHEN (seletor_MUX = "10") ELSE
    entradaB_MUX WHEN (seletor_MUX = "01") ELSE
    entradaA_MUX;
END ARCHITECTURE;