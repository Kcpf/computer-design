LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY OneBitDMux IS
  -- Total de bits das entradas e saidas
  PORT (
    entrada_DMUX : IN STD_LOGIC;
    seletor_DMUX : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    saidaA_DMUX, saidaB_DMUX, saidaC_DMUX, saidaD_DMUX : OUT STD_LOGIC
  );
END ENTITY;

ARCHITECTURE comportamento OF OneBitDMux IS
BEGIN
  saidaA_DMUX <= entrada_DMUX WHEN seletor_DMUX = "00" ELSE
    '0';
  saidaB_DMUX <= entrada_DMUX WHEN seletor_DMUX = "01" ELSE
    '0';
  saidaC_DMUX <= entrada_DMUX WHEN seletor_DMUX = "10" ELSE
    '0';
  saidaD_DMUX <= entrada_DMUX WHEN seletor_DMUX = "11" ELSE
    '0';
END ARCHITECTURE;