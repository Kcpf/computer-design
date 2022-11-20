LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; -- Biblioteca IEEE para funções aritméticas

ENTITY Adder IS
  PORT (
    entradaA, entradaB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    saida : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE arch OF Adder IS
BEGIN
  saida <= STD_LOGIC_VECTOR(unsigned(entradaA) + unsigned(entradaB));
END ARCHITECTURE;