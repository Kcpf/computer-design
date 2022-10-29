LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY TopLevel_tb IS
END TopLevel_tb;

ARCHITECTURE test OF TopLevel_tb IS
  COMPONENT TopLevel
    GENERIC (
      larguraDados : NATURAL := 32;
      larguraEnderecos : NATURAL := 32;
      simulacao : BOOLEAN := TRUE
    );
    PORT (
      CLOCK_50 : IN STD_LOGIC := '0';
      PONTO_SELETOR : IN STD_LOGIC := '0';
      PONTO_ESCREVE_C : IN STD_LOGIC := '0'
    );
  END COMPONENT;

  SIGNAL clock : STD_LOGIC := '0';
  SIGNAL ponto_seletor : STD_LOGIC := '1';
  SIGNAL ponto_escreve_c : STD_LOGIC := '1';

  CONSTANT PERIODO : TIME := 10 ps;

BEGIN

  TL : TopLevel
  GENERIC MAP(
    larguraDados => 32,
    larguraEnderecos => 32,
    simulacao => TRUE
  )
  PORT MAP(
    CLOCK_50 => clock,
    PONTO_SELETOR => ponto_seletor,
    PONTO_ESCREVE_C => ponto_escreve_c
  );

  clock <= NOT clock AFTER PERIODO / 2;
  ponto_seletor <= NOT ponto_seletor AFTER 15 ps;

END test;