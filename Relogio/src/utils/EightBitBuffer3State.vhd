LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY EightBitBuffer3State IS
  PORT (
    entrada : IN STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    habilita : IN STD_LOGIC := '0';
    saida : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0')
  );
END ENTITY;

ARCHITECTURE arch OF EightBitBuffer3State IS
BEGIN
  -- A saida esta ativa quando o habilita = 1.
  saida <= "ZZZZZZZZ" WHEN (habilita = '0') ELSE
    entrada;
END ARCHITECTURE;