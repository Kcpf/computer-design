LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY barramentoKey IS
  PORT (
    KEY_IN : IN STD_LOGIC;
    HAB_KEY : IN STD_LOGIC;
    KEY_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE comportamento OF barramentoKey IS

  COMPONENT buffer_3_state_1porta
    PORT (
      entrada : IN STD_LOGIC;
      habilita : IN STD_LOGIC;
      saida : OUT STD_LOGIC
    );
  END COMPONENT;

BEGIN
  BUFF_0 : buffer_3_state_1porta
  PORT MAP(
    entrada => KEY_IN,
    habilita => HAB_KEY,
    saida => KEY_OUT(0)
  );

  BUFF_1 : buffer_3_state_1porta
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY,
    saida => KEY_OUT(1)
  );

  BUFF_2 : buffer_3_state_1porta
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY,
    saida => KEY_OUT(2)
  );

  BUFF_3 : buffer_3_state_1porta
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY,
    saida => KEY_OUT(3)
  );

  BUFF_4 : buffer_3_state_1porta
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY,
    saida => KEY_OUT(4)
  );

  BUFF_5 : buffer_3_state_1porta
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY,
    saida => KEY_OUT(5)
  );

  BUFF_6 : buffer_3_state_1porta
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY,
    saida => KEY_OUT(6)
  );

  BUFF_7 : buffer_3_state_1porta
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY,
    saida => KEY_OUT(7)
  );
END ARCHITECTURE;