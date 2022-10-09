LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY processador IS
  PORT (
    CLOCK : IN STD_LOGIC := '0';
    INSTRUCTION_IN : IN STD_LOGIC_VECTOR(12 DOWNTO 0) := (OTHERS => '0');
    DATA_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    RD, WR : OUT STD_LOGIC := '0';
    ROM_ADDRESS : OUT STD_LOGIC_VECTOR(8 DOWNTO 0) := (OTHERS => '0');
    DATA_ADDRESS : OUT STD_LOGIC_VECTOR(8 DOWNTO 0) := (OTHERS => '0');
    DATA_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0')
  );
END ENTITY;

ARCHITECTURE arquitetura OF processador IS

  COMPONENT muxGenerico2x1
    GENERIC (larguraDados : NATURAL := 8);
    PORT (
      entradaA_MUX, entradaB_MUX : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      seletor_MUX : IN STD_LOGIC;
      saida_MUX : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT muxGenerico4x1
    GENERIC (larguraDados : NATURAL := 8);
    PORT (
      entradaA_MUX, entradaB_MUX, entradaC_MUX, entradaD_MUX : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      seletor_MUX : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      saida_MUX : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT registradorGenerico
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

  COMPONENT somaConstante
    GENERIC (
      larguraDados : NATURAL := 32;
      constante : NATURAL := 4
    );
    PORT (
      entrada : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      saida : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT ULASomaSub
    GENERIC (larguraDados : NATURAL := 4);
    PORT (
      entradaA, entradaB : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      seletor : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      saida : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      saida_flagzero : OUT STD_LOGIC
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

  COMPONENT decoderGeneric
    PORT (
      entrada : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      entrada_flagzero : IN STD_LOGIC;
      saida : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
    );
  END COMPONENT;

  -- ULA
  SIGNAL ENTRADA_A_ULA, ENTRADA_B_ULA : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL SAIDA_ULA : STD_LOGIC_VECTOR (7 DOWNTO 0);

  -- Decodificador
  SIGNAL SINAIS_DE_CONTROLE : STD_LOGIC_VECTOR (11 DOWNTO 0);
  SIGNAL SEL_MUX : STD_LOGIC;
  SIGNAL HABILITA_A : STD_LOGIC;
  SIGNAL OPERACAO_ULA : STD_LOGIC_VECTOR(1 DOWNTO 0);

  -- Registrador PC
  SIGNAL SAIDA_MUX_PC : STD_LOGIC_VECTOR (8 DOWNTO 0);
  SIGNAL SEL_MUX_PC : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL ENDERECO : STD_LOGIC_VECTOR (8 DOWNTO 0);
  SIGNAL PROX_PC : STD_LOGIC_VECTOR (8 DOWNTO 0);

  -- Registrador Retorno
  SIGNAL SAIDA_REG_RETORNO : STD_LOGIC_VECTOR (8 DOWNTO 0);
  SIGNAL HABILITA_REG_RETORNO : STD_LOGIC;

  -- Registrador FlagZero
  SIGNAL FLAG_ZERO_SAIDA_ULA : STD_LOGIC;
  SIGNAL HABILITA_FLAG_ZERO : STD_LOGIC;
  SIGNAL FLAG_ZERO_SAIDA_REG : STD_LOGIC;

BEGIN

  -- O port map completo do MUX.
  MUX1 : muxGenerico2x1
  GENERIC MAP(larguraDados => 8)
  PORT MAP(
    entradaA_MUX => DATA_IN,
    entradaB_MUX => INSTRUCTION_IN(7 DOWNTO 0),
    seletor_MUX => SEL_MUX,
    saida_MUX => ENTRADA_B_ULA);

  -- MUX do PC.
  MUX2 : muxGenerico4x1
  GENERIC MAP(larguraDados => 9)
  PORT MAP(
    entradaA_MUX => PROX_PC,
    entradaB_MUX => INSTRUCTION_IN(8 DOWNTO 0),
    entradaC_MUX => SAIDA_REG_RETORNO,
    entradaD_MUX => "000000000",
    seletor_MUX => SEL_MUX_PC,
    saida_MUX => SAIDA_MUX_PC);

  -- O port map completo do Acumulador.
  REGA : registradorGenerico
  GENERIC MAP(larguraDados => 8)
  PORT MAP(DIN => SAIDA_ULA, DOUT => ENTRADA_A_ULA, ENABLE => HABILITA_A, CLK => CLOCK, RST => '0');

  -- O port map completo do Program Counter.
  PC : registradorGenerico
  GENERIC MAP(larguraDados => 9)
  PORT MAP(DIN => SAIDA_MUX_PC, DOUT => ENDERECO, ENABLE => '1', CLK => CLOCK, RST => '0');

  INCREMENTAPC : somaConstante
  GENERIC MAP(larguraDados => 9, constante => 1)
  PORT MAP(entrada => ENDERECO, saida => PROX_PC);

  -- O port map do registrador de Retorno
  REGRETORNO : registradorGenerico
  GENERIC MAP(larguraDados => 9)
  PORT MAP(DIN => PROX_PC, DOUT => SAIDA_REG_RETORNO, ENABLE => HABILITA_REG_RETORNO, CLK => CLOCK, RST => '0');

  -- O port map completo da ULA:
  ULA1 : ULASomaSub
  GENERIC MAP(larguraDados => 8)
  PORT MAP(entradaA => ENTRADA_A_ULA, entradaB => ENTRADA_B_ULA, saida => SAIDA_ULA, seletor => OPERACAO_ULA, saida_flagzero => FLAG_ZERO_SAIDA_ULA);

  -- O port map do registrador da flagzero
  REGFLAGZERO : registradorFlag
  PORT MAP(DIN => FLAG_ZERO_SAIDA_ULA, DOUT => FLAG_ZERO_SAIDA_REG, ENABLE => HABILITA_FLAG_ZERO, CLK => CLOCK, RST => '0');

  -- Decoder
  DEC : decoderGeneric
  PORT MAP(entrada => INSTRUCTION_IN(12 DOWNTO 9), entrada_flagzero => FLAG_ZERO_SAIDA_REG, saida => SINAIS_DE_CONTROLE);

  HABILITA_REG_RETORNO <= SINAIS_DE_CONTROLE(11);

  SEL_MUX_PC <= "01" WHEN SINAIS_DE_CONTROLE(10) = '1' ELSE
    "01" WHEN SINAIS_DE_CONTROLE(8) = '1' ELSE
    "01" WHEN SINAIS_DE_CONTROLE(7) = '1' ELSE
    "10" WHEN SINAIS_DE_CONTROLE(9) = '1' ELSE
    "00";

  SEL_MUX <= SINAIS_DE_CONTROLE(6);
  HABILITA_A <= SINAIS_DE_CONTROLE(5);
  OPERACAO_ULA <= SINAIS_DE_CONTROLE(4 DOWNTO 3);

  HABILITA_FLAG_ZERO <= SINAIS_DE_CONTROLE(2);

  RD <= SINAIS_DE_CONTROLE(1);
  WR <= SINAIS_DE_CONTROLE(0);
  ROM_ADDRESS <= ENDERECO;
  DATA_ADDRESS <= INSTRUCTION_IN(8 DOWNTO 0);
  DATA_OUT <= ENTRADA_A_ULA;

END ARCHITECTURE;