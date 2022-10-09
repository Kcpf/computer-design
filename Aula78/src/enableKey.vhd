LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY enableKey IS
  PORT (
    CLK : IN STD_LOGIC := '0';
    KEY_3_0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    KEY_RESET : IN STD_LOGIC := '0';
    HAB_KEY_3_0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    HAB_KEY_RESET : IN STD_LOGIC := '0';
    HAB_LIMPA : IN STD_LOGIC := '0';
    OUT_KEY_3 : OUT STD_LOGIC := '0';
    OUT_KEY_2 : OUT STD_LOGIC := '0';
    OUT_KEY_1 : OUT STD_LOGIC := '0';
    OUT_KEY_0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    OUT_KEY_RESET : OUT STD_LOGIC := '0'
  );
END ENTITY;

ARCHITECTURE comportamento OF enableKey IS

  COMPONENT buffer_3_state_1porta
    PORT (
      entrada : IN STD_LOGIC;
      habilita : IN STD_LOGIC;
      saida : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT edgeDetector
    PORT (
      clk : IN STD_LOGIC;
      entrada : IN STD_LOGIC;
      saida : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT registradorFlag
    PORT (
      DIN : IN STD_LOGIC;
      DOUT : OUT STD_LOGIC;
      ENABLE : IN STD_LOGIC;
      CLK, RST : IN STD_LOGIC
    );
  END COMPONENT;

  SIGNAL KEY_0_REG : STD_LOGIC;
  SIGNAL KEY_0_EDGE : STD_LOGIC;

BEGIN
  BUFF0_1 : buffer_3_state_1porta
  PORT MAP(
    entrada => KEY_0_REG,
    habilita => HAB_KEY_3_0(0),
    saida => OUT_KEY_0(0)
  );

  BUFF0_2 : buffer_3_state_1porta
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY_3_0(0),
    saida => OUT_KEY_0(1)
  );

  BUFF0_3 : buffer_3_state_1porta
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY_3_0(0),
    saida => OUT_KEY_0(2)
  );

  BUFF0_4 : buffer_3_state_1porta
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY_3_0(0),
    saida => OUT_KEY_0(3)
  );

  BUFF0_5 : buffer_3_state_1porta
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY_3_0(0),
    saida => OUT_KEY_0(4)
  );

  BUFF0_6 : buffer_3_state_1porta
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY_3_0(0),
    saida => OUT_KEY_0(5)
  );

  BUFF0_7 : buffer_3_state_1porta
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY_3_0(0),
    saida => OUT_KEY_0(6)
  );

  BUFF0_8 : buffer_3_state_1porta
  PORT MAP(
    entrada => '0',
    habilita => HAB_KEY_3_0(0),
    saida => OUT_KEY_0(7)
  );
  BUFF1 : buffer_3_state_1porta
  PORT MAP(
    entrada => KEY_3_0(1),
    habilita => HAB_KEY_3_0(1),
    saida => OUT_KEY_1
  );

  BUFF2 : buffer_3_state_1porta
  PORT MAP(
    entrada => KEY_3_0(2),
    habilita => HAB_KEY_3_0(2),
    saida => OUT_KEY_2
  );

  BUFF3 : buffer_3_state_1porta
  PORT MAP(
    entrada => KEY_3_0(3),
    habilita => HAB_KEY_3_0(3),
    saida => OUT_KEY_3
  );
  BUFF4 : buffer_3_state_1porta
  PORT MAP(
    entrada => KEY_RESET,
    habilita => HAB_KEY_RESET,
    saida => OUT_KEY_RESET
  );

  EDGE : edgeDetector
  PORT MAP(
    clk => CLK,
    entrada => NOT(KEY_3_0(0)),
    saida => KEY_0_EDGE
  );

  FF_KEY_0 : registradorFlag
  PORT MAP(
    DIN => '1',
    DOUT => KEY_0_REG,
    ENABLE => '1',
    CLK => KEY_0_EDGE,
    RST => HAB_LIMPA
  );

END ARCHITECTURE;