LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY EnableKey IS
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

ARCHITECTURE arch OF EnableKey IS

  COMPONENT KeyBus
    PORT (
      KEY_IN : IN STD_LOGIC;
      HAB_KEY : IN STD_LOGIC;
      KEY_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT EdgeDetector
    PORT (
      clk : IN STD_LOGIC;
      entrada : IN STD_LOGIC;
      saida : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT OneBitRegister
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

  KEY0_BUS : KeyBus
  PORT MAP(
    KEY_IN => KEY_0_REG,
    HAB_KEY => HAB_KEY_3_0(0),
    KEY_OUT => OUT_KEY_0
  );

  KEY1_BUS : KeyBus
  PORT MAP(
    KEY_IN => KEY_1_REG,
    HAB_KEY => HAB_KEY_3_0(1),
    KEY_OUT => OUT_KEY_1
  );

  KEY2_BUS : KeyBus
  PORT MAP(
    KEY_IN => KEY_2_REG,
    HAB_KEY => HAB_KEY_3_0(2),
    KEY_OUT => OUT_KEY_2
  );

  KEY3_BUS : KeyBus
  PORT MAP(
    KEY_IN => KEY_3_REG,
    HAB_KEY => HAB_KEY_3_0(3),
    KEY_OUT => OUT_KEY_3
  );

  KEY_RESET_BUS : KeyBus
  PORT MAP(
    KEY_IN => KEY_RESET_REG,
    HAB_KEY => HAB_KEY_RESET,
    KEY_OUT => OUT_KEY_RESET
  );

  EDGE_0 : EdgeDetector
  PORT MAP(
    clk => CLK,
    entrada => NOT(KEY_3_0(0)),
    saida => KEY_0_EDGE
  );

  FF_KEY_0 : OneBitRegister
  PORT MAP(
    DIN => '1',
    DOUT => KEY_0_REG,
    ENABLE => '1',
    CLK => KEY_0_EDGE,
    RST => HAB_LIMPA_0
  );

  EDGE_1 : EdgeDetector
  PORT MAP(
    clk => CLK,
    entrada => NOT(KEY_3_0(1)),
    saida => KEY_1_EDGE
  );

  FF_KEY_1 : OneBitRegister
  PORT MAP(
    DIN => '1',
    DOUT => KEY_1_REG,
    ENABLE => '1',
    CLK => KEY_1_EDGE,
    RST => HAB_LIMPA_1
  );

  EDGE_2 : EdgeDetector
  PORT MAP(
    clk => CLK,
    entrada => NOT(KEY_3_0(2)),
    saida => KEY_2_EDGE
  );

  FF_KEY_2 : OneBitRegister
  PORT MAP(
    DIN => '1',
    DOUT => KEY_2_REG,
    ENABLE => '1',
    CLK => KEY_2_EDGE,
    RST => HAB_LIMPA_2
  );

  EDGE_3 : EdgeDetector
  PORT MAP(
    clk => CLK,
    entrada => NOT(KEY_3_0(3)),
    saida => KEY_3_EDGE
  );

  FF_KEY_3 : OneBitRegister
  PORT MAP(
    DIN => '1',
    DOUT => KEY_3_REG,
    ENABLE => '1',
    CLK => KEY_3_EDGE,
    RST => HAB_LIMPA_3
  );

  EDGE_RESET : EdgeDetector
  PORT MAP(
    clk => CLK,
    entrada => NOT(KEY_RESET),
    saida => KEY_RESET_EDGE
  );

  FF_KEY_RESET : OneBitRegister
  PORT MAP(
    DIN => '1',
    DOUT => KEY_RESET_REG,
    ENABLE => '1',
    CLK => KEY_RESET_EDGE,
    RST => HAB_LIMPA_RESET
  );

END ARCHITECTURE;