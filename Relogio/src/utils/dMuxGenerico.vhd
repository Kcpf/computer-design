LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY dMuxGenerico IS
  -- Total de bits das entradas e saidas
  GENERIC (larguraDados : NATURAL := 8);
  PORT (
    entrada_DMUX : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0) := (OTHERS => '0');
    seletor_DMUX : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    saidaA_DMUX, saidaB_DMUX, saidaC_DMUX, saidaD_DMUX : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0) := (OTHERS => '0')
  );
END ENTITY;

ARCHITECTURE comportamento OF dMuxGenerico IS
BEGIN
  saidaA_DMUX <= entrada_DMUX WHEN seletor_DMUX = "00" ELSE
    (OTHERS => '0');
  saidaB_DMUX <= entrada_DMUX WHEN seletor_DMUX = "01" ELSE
    (OTHERS => '0');
  saidaC_DMUX <= entrada_DMUX WHEN seletor_DMUX = "10" ELSE
    (OTHERS => '0');
  saidaD_DMUX <= entrada_DMUX WHEN seletor_DMUX = "11" ELSE
    (OTHERS => '0');
END ARCHITECTURE;