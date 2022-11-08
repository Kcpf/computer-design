LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY TwoBitShifter IS
  GENERIC (
    dataLength : NATURAL := 8
  );
  PORT (
    DIN : IN STD_LOGIC_VECTOR(dataLength - 1 DOWNTO 0) := (OTHERS => '0');
    DOUT : OUT STD_LOGIC_VECTOR(dataLength - 1 DOWNTO 0) := (OTHERS => '0')
  );
END ENTITY;

ARCHITECTURE arch OF TwoBitShifter IS
BEGIN

  DOUT <= "00" & DIN(dataLength - 1 DOWNTO 2);

END ARCHITECTURE arch;