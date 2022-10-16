LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY enableKey IS
  PORT (
    CLK : IN STD_LOGIC := '0';
    KEY_3_0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    KEY_RESET : IN STD_LOGIC := '0';
    HAB_KEY_3_0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    HAB_KEY_RESET : IN STD_LOGIC := '0';
    HAB_LIMPA_0 : IN STD_LOGIC := '0';
    HAB_LIMPA_1 : IN STD_LOGIC := '0';
    HAB_LIMPA_2 : IN STD_LOGIC := '0';
    HAB_LIMPA_3 : IN STD_LOGIC := '0';
    HAB_LIMPA_RESET : IN STD_LOGIC := '0';
    OUT_KEY_3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    OUT_KEY_2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    OUT_KEY_1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    OUT_KEY_0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    OUT_KEY_RESET : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0')
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

  COMPONENT barramentoKey
    PORT (
      KEY_IN : IN STD_LOGIC;
      HAB_KEY : IN STD_LOGIC;
      KEY_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
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

  SIGNAL KEY_1_REG : STD_LOGIC;
  SIGNAL KEY_1_EDGE : STD_LOGIC;

  SIGNAL KEY_2_REG : STD_LOGIC;
  SIGNAL KEY_2_EDGE : STD_LOGIC;

  SIGNAL KEY_3_REG : STD_LOGIC;
  SIGNAL KEY_3_EDGE : STD_LOGIC;

  SIGNAL KEY_RESET_REG : STD_LOGIC;
  SIGNAL KEY_RESET_EDGE : STD_LOGIC;

BEGIN

  BARRAMENTO_KEY0 : barramentoKey
  PORT MAP(
    KEY_IN => KEY_0_REG,
    HAB_KEY => HAB_KEY_3_0(0),
    KEY_OUT => OUT_KEY_0
  );

  BARRAMENTO_KEY1 : barramentoKey
  PORT MAP(
    KEY_IN => KEY_1_REG,
    HAB_KEY => HAB_KEY_3_0(1),
    KEY_OUT => OUT_KEY_1
  );

  BARRAMENTO_KEY2 : barramentoKey
  PORT MAP(
    KEY_IN => KEY_2_REG,
    HAB_KEY => HAB_KEY_3_0(2),
    KEY_OUT => OUT_KEY_2
  );

  BARRAMENTO_KEY3 : barramentoKey
  PORT MAP(
    KEY_IN => KEY_3_REG,
    HAB_KEY => HAB_KEY_3_0(3),
    KEY_OUT => OUT_KEY_3
  );

  BARRAMENTO_KEY_RESET : barramentoKey
  PORT MAP(
    KEY_IN => KEY_RESET_REG,
    HAB_KEY => HAB_KEY_RESET,
    KEY_OUT => OUT_KEY_RESET
  );

  EDGE_0 : edgeDetector
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
    RST => HAB_LIMPA_0
  );

  EDGE_1 : edgeDetector
  PORT MAP(
    clk => CLK,
    entrada => NOT(KEY_3_0(1)),
    saida => KEY_1_EDGE
  );

  FF_KEY_1 : registradorFlag
  PORT MAP(
    DIN => '1',
    DOUT => KEY_1_REG,
    ENABLE => '1',
    CLK => KEY_1_EDGE,
    RST => HAB_LIMPA_1
  );

  EDGE_2 : edgeDetector
  PORT MAP(
    clk => CLK,
    entrada => NOT(KEY_3_0(2)),
    saida => KEY_2_EDGE
  );

  FF_KEY_2 : registradorFlag
  PORT MAP(
    DIN => '1',
    DOUT => KEY_2_REG,
    ENABLE => '1',
    CLK => KEY_2_EDGE,
    RST => HAB_LIMPA_2
  );

  EDGE_3 : edgeDetector
  PORT MAP(
    clk => CLK,
    entrada => NOT(KEY_3_0(3)),
    saida => KEY_3_EDGE
  );

  FF_KEY_3 : registradorFlag
  PORT MAP(
    DIN => '1',
    DOUT => KEY_3_REG,
    ENABLE => '1',
    CLK => KEY_3_EDGE,
    RST => HAB_LIMPA_3
  );

  EDGE_RESET : edgeDetector
  PORT MAP(
    clk => CLK,
    entrada => NOT(KEY_RESET),
    saida => KEY_RESET_EDGE
  );

  FF_KEY_RESET : registradorFlag
  PORT MAP(
    DIN => '1',
    DOUT => KEY_RESET_REG,
    ENABLE => '1',
    CLK => KEY_RESET_EDGE,
    RST => HAB_LIMPA_RESET
  );

END ARCHITECTURE;