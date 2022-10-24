LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RAM IS
  GENERIC (
    dataWidth : NATURAL := 8;
    addrWidth : NATURAL := 8
  );
  PORT (
    addr : IN STD_LOGIC_VECTOR(addrWidth - 1 DOWNTO 0) := (OTHERS => '0');
    we, re : IN STD_LOGIC := '0';
    habilita : IN STD_LOGIC := '0';
    clk : IN STD_LOGIC := '0';
    dado_in : IN STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0) := (OTHERS => '0');
    dado_out : OUT STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0) := (OTHERS => '0')
  );
END ENTITY;

ARCHITECTURE rtl OF RAM IS
  -- Build a 2-D array type for the RAM
  SUBTYPE word_t IS STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0);
  TYPE memory_t IS ARRAY((2 ** addrWidth - 1) DOWNTO 0) OF word_t;

  -- Declare the RAM signal.
  SIGNAL ram_mem : memory_t;
BEGIN
  PROCESS (clk)
  BEGIN
    IF (rising_edge(clk)) THEN
      IF (we = '1' AND habilita = '1') THEN
        ram_mem(to_integer(unsigned(addr))) <= dado_in;
      END IF;
    END IF;
  END PROCESS;

  -- A leitura é sempre assincrona e quando houver habilitacao:
  dado_out <= ram_mem(to_integer(unsigned(addr))) WHEN (re = '1' AND habilita = '1') ELSE
    (OTHERS => 'Z');
END ARCHITECTURE;