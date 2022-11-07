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
      PONTO_OPERACAO : IN STD_LOGIC := '0';
      PONTO_ESCREVE_C : IN STD_LOGIC := '0';
      PONTO_HAB_WRITE : IN STD_LOGIC := '0';
      PONTO_HAB_READ : IN STD_LOGIC := '0';
      PONTO_HAB_RAM : IN STD_LOGIC := '0'
    );
  END COMPONENT;

  SIGNAL clock : STD_LOGIC := '0';
  SIGNAL ponto_operacao_ula : STD_LOGIC := '1';
  SIGNAL ponto_escreve_c : STD_LOGIC := '0';
  SIGNAL ponto_hab_write : STD_LOGIC := '1';
  SIGNAL ponto_hab_read : STD_LOGIC := '0';
  SIGNAL ponto_hab_ram : STD_LOGIC := '1';

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
    PONTO_OPERACAO => ponto_operacao_ula,
    PONTO_ESCREVE_C => ponto_escreve_c,
    PONTO_HAB_WRITE => ponto_hab_write,
    PONTO_HAB_READ => ponto_hab_read,
    PONTO_HAB_RAM => ponto_hab_ram
  );

  clock <= NOT clock AFTER PERIODO / 2;
  ponto_escreve_c <= NOT ponto_escreve_c AFTER 15 ps;
  ponto_hab_write <= NOT ponto_hab_write AFTER 15 ps;
  ponto_hab_read <= NOT ponto_hab_read AFTER 15 ps;

END test;