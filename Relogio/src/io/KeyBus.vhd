LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY KeyBus IS
  PORT (
    KEY_IN : IN STD_LOGIC;
    HAB_KEY : IN STD_LOGIC;
    KEY_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE arch OF KeyBus IS

  COMPONENT OneBitBuffer3State
    PORT (
      entrada : IN STD_LOGIC;
      habilita : IN STD_LOGIC;
      saida : OUT STD_LOGIC
    );
  END COMPONENT;

BEGIN
  BUFF_0 : OneBitBuffer3State
  PORT MAP(
    entrada => KEY_IN,
    habilita => HAB_KEY,
    saida => KEY_OUT(0)
  );

  BUFF_1 : OneBitBuffer3State
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY,
    saida => KEY_OUT(1)
  );

  BUFF_2 : OneBitBuffer3State
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY,
    saida => KEY_OUT(2)
  );

  BUFF_3 : OneBitBuffer3State
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY,
    saida => KEY_OUT(3)
  );

  BUFF_4 : OneBitBuffer3State
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY,
    saida => KEY_OUT(4)
  );

  BUFF_5 : OneBitBuffer3State
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY,
    saida => KEY_OUT(5)
  );

  BUFF_6 : OneBitBuffer3State
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY,
    saida => KEY_OUT(6)
  );

  BUFF_7 : OneBitBuffer3State
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY,
    saida => KEY_OUT(7)
  );
END ARCHITECTURE;