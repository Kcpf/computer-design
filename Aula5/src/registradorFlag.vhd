LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY registradorFlag IS
  PORT (
    DIN : IN STD_LOGIC := '0';
    DOUT : OUT STD_LOGIC := '0';
    ENABLE : IN STD_LOGIC;
    CLK, RST : IN STD_LOGIC
  );
END ENTITY;

ARCHITECTURE comportamento OF registradorFlag IS
BEGIN
  -- In Altera devices, register signals have a set priority.
  -- The HDL design should reflect this priority.
  PROCESS (RST, CLK)
  BEGIN
    IF (RST = '1') THEN
      DOUT <= '0'; -- Código reconfigurável.
    ELSE
      IF (rising_edge(CLK)) THEN
        IF (ENABLE = '1') THEN
          DOUT <= DIN;
        END IF;
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE;