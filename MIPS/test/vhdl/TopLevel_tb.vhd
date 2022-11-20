LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY TopLevel_tb IS
END TopLevel_tb;

ARCHITECTURE test OF TopLevel_tb IS
  COMPONENT TopLevel
    PORT (
      CLOCK_50 : IN STD_LOGIC := '0'
    );
  END COMPONENT;

  SIGNAL W_CLK : STD_LOGIC := '0';

  CONSTANT PERIODO : TIME := 10 ps;

BEGIN

  TL : TopLevel
  PORT MAP(
    CLOCK_50 => W_CLK
  );

  W_CLK <= NOT W_CLK AFTER PERIODO / 2;

END test;