LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; --Soma (esta biblioteca =ieee)

ENTITY AddConstant IS
  GENERIC (
    larguraDados : NATURAL := 32;
    constante : NATURAL := 4
  );
  PORT (
    entrada : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0) := (OTHERS => '0');
    saida : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0) := (OTHERS => '0')
  );
END ENTITY;

ARCHITECTURE arch OF AddConstant IS
BEGIN
  saida <= STD_LOGIC_VECTOR(unsigned(entrada) + constante);
END ARCHITECTURE;