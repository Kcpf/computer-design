LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; -- Biblioteca IEEE para funções aritméticas

ENTITY ULA IS
  GENERIC (larguraDados : NATURAL := 4);
  PORT (
    entradaA, entradaB : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0) := (OTHERS => '0');
    seletor : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    saida : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0) := (OTHERS => '0');
    saida_flagzero : OUT STD_LOGIC := '0';
    saida_flag_greater : OUT STD_LOGIC := '0';
    saida_flag_lesser : OUT STD_LOGIC := '0'
  );
END ENTITY;

ARCHITECTURE arch OF ULA IS
  SIGNAL sum, sub, modulus, division : STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
BEGIN
  sum <= STD_LOGIC_VECTOR(unsigned(entradaA) + unsigned(entradaB));
  sub <= STD_LOGIC_VECTOR(unsigned(entradaA) - unsigned(entradaB));
  modulus <= STD_LOGIC_VECTOR(unsigned(entradaA) MOD unsigned(entradaB)) WHEN entradaB /= "00000000" ELSE
    "00000000";
  division <= STD_LOGIC_VECTOR(unsigned(entradaA) / unsigned(entradaB)) WHEN entradaB /= "00000000" ELSE
    "00000000";

  saida <= sum WHEN (seletor = "000") ELSE
    sub WHEN (seletor = "001") ELSE
    entradaB WHEN (seletor = "010") ELSE
    entradaA WHEN (seletor = "011") ELSE
    modulus WHEN (seletor = "100") ELSE
    division WHEN (seletor = "101") ELSE
    "00000000";

  saida_flagzero <= '1' WHEN (entradaA = entradaB) ELSE
    '0';
  saida_flag_greater <= '1' WHEN (entradaA > entradaB) ELSE
    '0';
  saida_flag_lesser <= '1' WHEN (entradaA < entradaB) ELSE
    '0';
END ARCHITECTURE;