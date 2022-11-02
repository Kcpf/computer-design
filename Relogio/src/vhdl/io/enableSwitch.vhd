LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY EnableSwitch IS
  PORT (
    SWITCH_9 : IN STD_LOGIC := '0';
    SWITCH_8 : IN STD_LOGIC := '0';
    SWITCH_7_0 : IN STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');
    HAB_SWITCH_9 : IN STD_LOGIC := '0';
    HAB_SWITCH_8 : IN STD_LOGIC := '0';
    HAB_SWITCH_7_0 : IN STD_LOGIC := '0';
    OUT_SWITCH_9 : OUT STD_LOGIC := '0';
    OUT_SWITCH_8 : OUT STD_LOGIC := '0';
    OUT_SWITCH_7_0 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0')
  );
END ENTITY;

ARCHITECTURE arch OF EnableSwitch IS
  COMPONENT OneBitBuffer3State
    PORT (
      entrada : IN STD_LOGIC;
      habilita : IN STD_LOGIC;
      saida : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT EightBitBuffer3State
    PORT (
      entrada : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      habilita : IN STD_LOGIC;
      saida : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
  END COMPONENT;

BEGIN
  BUFF_SW_9 : OneBitBuffer3State
  PORT MAP(
    entrada => SWITCH_9,
    habilita => HAB_SWITCH_9,
    saida => OUT_SWITCH_9
  );

  BUFF_SW_8 : OneBitBuffer3State
  PORT MAP(
    entrada => SWITCH_8,
    habilita => HAB_SWITCH_8,
    saida => OUT_SWITCH_8
  );

  BUFF_SW_7_0 : EightBitBuffer3State
  PORT MAP(
    entrada => SWITCH_7_0(7 DOWNTO 0),
    habilita => HAB_SWITCH_7_0,
    saida => OUT_SWITCH_7_0(7 DOWNTO 0)
  );

END ARCHITECTURE;