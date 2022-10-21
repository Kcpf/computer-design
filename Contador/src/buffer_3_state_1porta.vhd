LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY buffer_3_state_1porta IS
  PORT (
    entrada : IN STD_LOGIC := '0';
    habilita : IN STD_LOGIC := '0';
    saida : OUT STD_LOGIC := '0'
  );
END ENTITY;

ARCHITECTURE comportamento OF buffer_3_state_1porta IS
BEGIN
  -- A saida esta ativa quando o habilita = 1.
  saida <= 'Z' WHEN (habilita = '0') ELSE
    entrada;
END ARCHITECTURE;