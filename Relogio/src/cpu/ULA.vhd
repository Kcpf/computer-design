LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; -- Biblioteca IEEE para funções aritméticas

ENTITY ULA IS
  GENERIC (larguraDados : NATURAL := 4);
  PORT (
    entradaA, entradaB : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0) := (OTHERS => '0');
    seletor : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    saida : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0) := (OTHERS => '0');
    saida_flagzero : OUT STD_LOGIC := '0';
    saida_flag_greater : OUT STD_LOGIC := '0';
    saida_flag_lesser : OUT STD_LOGIC := '0'
  );
END ENTITY;

ARCHITECTURE arch OF ULA IS
  SIGNAL soma : STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
  SIGNAL subtracao : STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
BEGIN
  soma <= STD_LOGIC_VECTOR(unsigned(entradaA) + unsigned(entradaB));
  subtracao <= STD_LOGIC_VECTOR(unsigned(entradaA) - unsigned(entradaB));
  saida <= soma WHEN (seletor = "00") ELSE
    subtracao WHEN (seletor = "01") ELSE
    entradaB WHEN (seletor = "10") ELSE
    entradaA;
  saida_flagzero <= '1' WHEN (seletor = "01" AND subtracao = "00000000") ELSE
    '0';
  saida_flag_greater <= '1' WHEN (entradaA > entradaB) ELSE
    '0';
  saida_flag_lesser <= '1' WHEN (entradaA < entradaB) ELSE
    '0';
END ARCHITECTURE;