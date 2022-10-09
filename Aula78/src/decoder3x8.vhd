LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decoder3x8 IS
  PORT (
    entrada : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    saida : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000"
  );
END ENTITY;

ARCHITECTURE comportamento OF decoder3x8 IS

BEGIN
  saida <= "00000001" WHEN entrada = "000" ELSE
    "00000010" WHEN entrada = "001" ELSE
    "00000100" WHEN entrada = "010" ELSE
    "00001000" WHEN entrada = "011" ELSE
    "00010000" WHEN entrada = "100" ELSE
    "00100000" WHEN entrada = "101" ELSE
    "01000000" WHEN entrada = "110" ELSE
    "10000000";
END ARCHITECTURE;