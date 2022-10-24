LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY EdgeDetector IS
  PORT (
    clk : IN STD_LOGIC := '0';
    entrada : IN STD_LOGIC := '0';
    saida : OUT STD_LOGIC := '0'
  );
END ENTITY;

ARCHITECTURE bordaSubida OF EdgeDetector IS
  SIGNAL saidaQ : STD_LOGIC;
BEGIN
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      saidaQ <= entrada;
    END IF;
  END PROCESS;
  saida <= entrada AND (NOT saidaQ);
END ARCHITECTURE bordaSubida;