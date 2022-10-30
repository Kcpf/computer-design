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
  SIGNAL sum, sub, and_op, or_op : STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
BEGIN
  sum <= STD_LOGIC_VECTOR(unsigned(entradaA) + unsigned(entradaB));
  sub <= STD_LOGIC_VECTOR(unsigned(entradaA) - unsigned(entradaB));
  and_op <= entradaA and entradaB;
  or_op <= entradaA or entradaB;

  saida <= sum WHEN (seletor = "000") ELSE
    sub WHEN (seletor = "001") ELSE
    entradaB WHEN (seletor = "010") ELSE
    entradaA WHEN (seletor = "011") ELSE
    and_op WHEN (seletor = "100") ELSE
    or_op WHEN (seletor = "101") ELSE
    "00000000";

  saida_flagzero <= '1' WHEN (entradaA = entradaB) ELSE
    '0';
  saida_flag_greater <= '1' WHEN (entradaA > entradaB) ELSE
    '0';
  saida_flag_lesser <= '1' WHEN (entradaA < entradaB) ELSE
    '0';
END ARCHITECTURE;
