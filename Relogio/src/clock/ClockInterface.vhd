LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ClockInterface IS
  PORT (
    clk : IN STD_LOGIC;
    habilitaLeitura : IN STD_LOGIC;
    limpaLeitura : IN STD_LOGIC;
    leituraUmSegundo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE interface OF ClockInterface IS

  COMPONENT GenericDivisor
    GENERIC (divisor : NATURAL);
    PORT (
      clk : IN STD_LOGIC;
      saida_clk : OUT STD_LOGIC
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

  COMPONENT KeyBus
    PORT (
      KEY_IN : IN STD_LOGIC;
      HAB_KEY : IN STD_LOGIC;
      KEY_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL sinalUmSegundo : STD_LOGIC;
  SIGNAL saidaclk_reg1seg : STD_LOGIC;

BEGIN

  baseTempo : GenericDivisor
  GENERIC MAP(divisor => 5) -- divide por 10.
  PORT MAP(
    clk => clk,
    saida_clk => saidaclk_reg1seg
  );

  registraUmSegundo : OneBitRegister
  PORT MAP(
    DIN => '1',
    DOUT => sinalUmSegundo,
    ENABLE => '1',
    CLK => saidaclk_reg1seg,
    RST => limpaLeitura
  );

  leituraUmSegundo <= "0000000" & sinalUmSegundo WHEN habilitaLeitura = '1' ELSE
    (OTHERS => 'Z');

  -- ONIBUS : KeyBus
  -- PORT MAP(
  --   KEY_IN => sinalUmSegundo,
  --   HAB_KEY => habilitaLeitura,
  --   KEY_OUT => leituraUmSegundo
  -- );

END ARCHITECTURE interface;