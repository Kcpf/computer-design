LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY TopLevel IS
  GENERIC (
    larguraDados : NATURAL := 8;
    larguraEnderecos : NATURAL := 9;
    simulacao : BOOLEAN := TRUE
  );
  PORT (
    CLOCK_50 : IN STD_LOGIC := '0';
    KEY : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    FPGA_RESET_N : IN STD_LOGIC := '0';
    SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');
    DATA_TEST : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');
    HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
    HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
    HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
    HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
    HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
    HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0')
  );
END ENTITY;
ARCHITECTURE arch OF TopLevel IS

  COMPONENT RAM
    GENERIC (
      dataWidth : NATURAL := 8;
      addrWidth : NATURAL := 8
    );
    PORT (
      addr : IN STD_LOGIC_VECTOR(addrWidth - 1 DOWNTO 0);
      we, re : IN STD_LOGIC;
      habilita : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      dado_in : IN STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0);
      dado_out : OUT STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT ROM
    GENERIC (
      dataWidth : NATURAL := 4;
      addrWidth : NATURAL := 3
    );
    PORT (
      Endereco : IN STD_LOGIC_VECTOR (addrWidth - 1 DOWNTO 0);
      Dado : OUT STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT CPU
    PORT (
      CLOCK : IN STD_LOGIC;
      INSTRUCTION_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      DATA_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      RD, WR : OUT STD_LOGIC;
      ROM_ADDRESS : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      DATA_ADDRESS : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      DATA_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT IOAddressDecoder
    PORT (
      ENTRADA : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      RD : IN STD_LOGIC;
      WR : IN STD_LOGIC;
      SAIDA_RAM : OUT STD_LOGIC;
      SAIDA_LED_1 : OUT STD_LOGIC;
      SAIDA_LED_2 : OUT STD_LOGIC;
      SAIDA_LED_FITA : OUT STD_LOGIC;
      SAIDA_HEX : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      SAIDA_SW_9 : OUT STD_LOGIC;
      SAIDA_SW_8 : OUT STD_LOGIC;
      SAIDA_SW_7_0 : OUT STD_LOGIC;
      SAIDA_KEY_3_0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      SAIDA_KEY_RESET : OUT STD_LOGIC;
      SAIDA_CLOCK : OUT STD_LOGIC;
      SAIDA_LIMPA_0 : OUT STD_LOGIC;
      SAIDA_LIMPA_1 : OUT STD_LOGIC;
      SAIDA_LIMPA_2 : OUT STD_LOGIC;
      SAIDA_LIMPA_3 : OUT STD_LOGIC;
      SAIDA_LIMPA_RESET : OUT STD_LOGIC;
      SAIDA_LIMPA_CLOCK : OUT STD_LOGIC
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

  COMPONENT GenericRegister
    GENERIC (
      larguraDados : NATURAL := 8
    );
    PORT (
      DIN : IN STD_LOGIC_VECTOR(larguraDados - 1 DOWNTO 0);
      DOUT : OUT STD_LOGIC_VECTOR(larguraDados - 1 DOWNTO 0);
      ENABLE : IN STD_LOGIC;
      CLK, RST : IN STD_LOGIC
    );
  END COMPONENT;

  COMPONENT DisplayHex
    PORT (
      ENTRADA_HABILITA : IN STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";
      ESCRITA_DADOS : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
      CLK : IN STD_LOGIC := '0';
      HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT EnableKey
    PORT (
      CLK : IN STD_LOGIC := '0';
      KEY_3_0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      KEY_RESET : IN STD_LOGIC := '0';
      HAB_KEY_3_0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      HAB_KEY_RESET : IN STD_LOGIC := '0';
      HAB_LIMPA_0 : IN STD_LOGIC := '0';
      HAB_LIMPA_1 : IN STD_LOGIC := '0';
      HAB_LIMPA_2 : IN STD_LOGIC := '0';
      HAB_LIMPA_3 : IN STD_LOGIC := '0';
      HAB_LIMPA_RESET : IN STD_LOGIC := '0';
      OUT_KEY_3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      OUT_KEY_2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      OUT_KEY_1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      OUT_KEY_0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      OUT_KEY_RESET : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT EnableSwitch
    PORT (
      SWITCH_9 : IN STD_LOGIC;
      SWITCH_8 : IN STD_LOGIC;
      SWITCH_7_0 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      HAB_SWITCH_9 : IN STD_LOGIC;
      HAB_SWITCH_8 : IN STD_LOGIC;
      HAB_SWITCH_7_0 : IN STD_LOGIC;
      OUT_SWITCH_9 : OUT STD_LOGIC;
      OUT_SWITCH_8 : OUT STD_LOGIC;
      OUT_SWITCH_7_0 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT ClockInterface
    PORT (
      clk : IN STD_LOGIC;
      habilitaLeitura : IN STD_LOGIC;
      limpaLeitura : IN STD_LOGIC;
      leituraUmSegundo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
  END COMPONENT;

  -- RAM
  SIGNAL HABILITA_RAM : STD_LOGIC;
  SIGNAL ENDERECO_RAM : STD_LOGIC_VECTOR(5 DOWNTO 0);

  -- ROM
  SIGNAL SAIDA_ROM : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL ENDERECO_ROM : STD_LOGIC_VECTOR(8 DOWNTO 0);

  -- PROCESSADOR
  SIGNAL RD : STD_LOGIC;
  SIGNAL WR : STD_LOGIC;
  SIGNAL DATA_ADDRESS : STD_LOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL PROC_OUT : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL DATA_IN : STD_LOGIC_VECTOR(7 DOWNTO 0);

  -- LED
  SIGNAL HABILITA_LED_1 : STD_LOGIC;
  SIGNAL HABILITA_LED_2 : STD_LOGIC;
  SIGNAL HABILITA_LED_FITA : STD_LOGIC;

  -- HEX
  SIGNAL HABILITA_HEX : STD_LOGIC_VECTOR(5 DOWNTO 0);

  -- KEY
  SIGNAL HAB_KEY_3_0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL HAB_KEY_RESET : STD_LOGIC;
  SIGNAL HAB_LIMPA_0 : STD_LOGIC;
  SIGNAL HAB_LIMPA_1 : STD_LOGIC;
  SIGNAL HAB_LIMPA_2 : STD_LOGIC;
  SIGNAL HAB_LIMPA_3 : STD_LOGIC;
  SIGNAL HAB_LIMPA_RESET : STD_LOGIC;

  -- SW
  SIGNAL HAB_SWITCH_9 : STD_LOGIC;
  SIGNAL HAB_SWITCH_8 : STD_LOGIC;
  SIGNAL HAB_SWITCH_7_0 : STD_LOGIC;

  -- Relogio
  SIGNAL HAB_RELOGIO, HAB_LIMPA_RELOGIO : STD_LOGIC;

BEGIN

  -- Memoria
  RAM_MEM : RAM
  GENERIC MAP(dataWidth => 8, addrWidth => 6)
  PORT MAP(addr => ENDERECO_RAM, we => WR, re => RD, habilita => HABILITA_RAM, clk => CLOCK_50, dado_in => PROC_OUT, dado_out => DATA_IN);

  -- Falta acertar o conteudo da ROM
  ROM_MEM : ROM
  GENERIC MAP(dataWidth => 16, addrWidth => 9)
  PORT MAP(Endereco => ENDERECO_ROM, Dado => SAIDA_ROM);

  PROC : CPU
  PORT MAP(
    CLOCK => CLOCK_50,
    INSTRUCTION_IN => SAIDA_ROM,
    DATA_IN => DATA_IN,
    RD => RD,
    WR => WR,
    ROM_ADDRESS => ENDERECO_ROM,
    DATA_ADDRESS => DATA_ADDRESS,
    DATA_OUT => PROC_OUT
  );

  IO_ADDRESS_DECODER : IOAddressDecoder
  PORT MAP(
    ENTRADA => DATA_ADDRESS,
    RD => RD,
    WR => WR,
    SAIDA_RAM => HABILITA_RAM,
    SAIDA_LED_1 => HABILITA_LED_1,
    SAIDA_LED_2 => HABILITA_LED_2,
    SAIDA_LED_FITA => HABILITA_LED_FITA,
    SAIDA_HEX => HABILITA_HEX,
    SAIDA_SW_9 => HAB_SWITCH_9,
    SAIDA_SW_8 => HAB_SWITCH_8,
    SAIDA_SW_7_0 => HAB_SWITCH_7_0,
    SAIDA_KEY_3_0 => HAB_KEY_3_0,
    SAIDA_KEY_RESET => HAB_KEY_RESET,
    SAIDA_CLOCK => HAB_RELOGIO,
    SAIDA_LIMPA_0 => HAB_LIMPA_0,
    SAIDA_LIMPA_1 => HAB_LIMPA_1,
    SAIDA_LIMPA_2 => HAB_LIMPA_2,
    SAIDA_LIMPA_3 => HAB_LIMPA_3,
    SAIDA_LIMPA_RESET => HAB_LIMPA_RESET,
    SAIDA_LIMPA_CLOCK => HAB_LIMPA_RELOGIO
  );

  FF_LED_1 : OneBitRegister
  PORT MAP(
    DIN => PROC_OUT(0),
    DOUT => LEDR (9),
    ENABLE => HABILITA_LED_1,
    CLK => CLOCK_50,
    RST => '0'
  );

  FF_LED_2 : OneBitRegister
  PORT MAP(
    DIN => PROC_OUT(0),
    DOUT => LEDR (8),
    ENABLE => HABILITA_LED_2,
    CLK => CLOCK_50,
    RST => '0'
  );

  REG_LED_FITA : GenericRegister
  GENERIC MAP(larguraDados => 8)
  PORT MAP(
    DIN => PROC_OUT(7 DOWNTO 0),
    DOUT => LEDR (7 DOWNTO 0),
    ENABLE => HABILITA_LED_FITA,
    CLK => CLOCK_50,
    RST => '0'
  );

  HEX_DISPLAY : DisplayHex
  PORT MAP(
    ENTRADA_HABILITA => HABILITA_HEX,
    ESCRITA_DADOS => PROC_OUT (3 DOWNTO 0),
    HEX0 => HEX0,
    HEX1 => HEX1,
    HEX2 => HEX2,
    HEX3 => HEX3,
    HEX4 => HEX4,
    HEX5 => HEX5,
    CLK => CLOCK_50
  );

  SWITCH : EnableSwitch
  PORT MAP(
    SWITCH_9 => SW(9),
    SWITCH_8 => SW(8),
    SWITCH_7_0 => SW(7 DOWNTO 0),
    HAB_SWITCH_9 => HAB_SWITCH_9,
    HAB_SWITCH_8 => HAB_SWITCH_8,
    HAB_SWITCH_7_0 => HAB_SWITCH_7_0,
    OUT_SWITCH_9 => DATA_IN(0),
    OUT_SWITCH_8 => DATA_IN(0),
    OUT_SWITCH_7_0 => DATA_IN
  );

  KEYENABLE : EnableKey
  PORT MAP(
    CLK => CLOCK_50,
    KEY_3_0 => KEY,
    KEY_RESET => FPGA_RESET_N,
    HAB_KEY_3_0 => HAB_KEY_3_0,
    HAB_KEY_RESET => HAB_KEY_RESET,
    HAB_LIMPA_0 => HAB_LIMPA_0,
    HAB_LIMPA_1 => HAB_LIMPA_1,
    HAB_LIMPA_2 => HAB_LIMPA_2,
    HAB_LIMPA_3 => HAB_LIMPA_3,
    HAB_LIMPA_RESET => HAB_LIMPA_RESET,
    OUT_KEY_3 => DATA_IN,
    OUT_KEY_2 => DATA_IN,
    OUT_KEY_1 => DATA_IN,
    OUT_KEY_0 => DATA_IN,
    OUT_KEY_RESET => DATA_IN
  );

  RELOGIOINTERFACE : ClockInterface
  PORT MAP(
    clk => CLOCK_50,
    habilitaLeitura => HAB_RELOGIO,
    limpaLeitura => HAB_LIMPA_RELOGIO,
    leituraUmSegundo => DATA_IN
  );

  ENDERECO_RAM <= DATA_ADDRESS(5 DOWNTO 0);
  DATA_TEST <= PROC_OUT;

END ARCHITECTURE;