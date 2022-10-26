LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY GenericDivisor IS
  GENERIC (divisor : NATURAL := 8);
  PORT (
    clk : IN STD_LOGIC;
    saida_clk : OUT STD_LOGIC);
END ENTITY;

-- O valor "n" do divisor, define a divisao por "2n".
-- Ou seja, n é metade do período da frequência de saída.

ARCHITECTURE arch OF GenericDivisor IS
  SIGNAL tick : STD_LOGIC := '0';
  SIGNAL contador : INTEGER RANGE 0 TO divisor + 1 := 0;
BEGIN
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF contador = divisor THEN
        contador <= 0;
        tick <= NOT tick;
      ELSE
        contador <= contador + 1;
      END IF;
    END IF;
  END PROCESS;
  saida_clk <= tick;
END ARCHITECTURE arch;