LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY CPU IS
  PORT (
    CLOCK : IN STD_LOGIC := '0';
    INSTRUCTION_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    DATA_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    RD, WR : OUT STD_LOGIC := '0';
    ROM_ADDRESS : OUT STD_LOGIC_VECTOR(8 DOWNTO 0) := (OTHERS => '0');
    DATA_ADDRESS : OUT STD_LOGIC_VECTOR(8 DOWNTO 0) := (OTHERS => '0');
    DATA_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0')
  );
END ENTITY;

ARCHITECTURE arch OF CPU IS

  COMPONENT GenericMux2x1
    GENERIC (larguraDados : NATURAL := 8);
    PORT (
      entradaA_MUX, entradaB_MUX : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      seletor_MUX : IN STD_LOGIC;
      saida_MUX : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT GenericMux4x1
    GENERIC (larguraDados : NATURAL := 8);
    PORT (
      entradaA_MUX, entradaB_MUX, entradaC_MUX, entradaD_MUX : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      seletor_MUX : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      saida_MUX : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT ProcessorRegisters
    PORT (
      CLOCK : IN STD_LOGIC;
      REG_ADDR : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      DATA_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      HAB_ESCRITA : IN STD_LOGIC;
      SAIDA : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
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

  COMPONENT AddConstant
    GENERIC (
      larguraDados : NATURAL := 32;
      constante : NATURAL := 4
    );
    PORT (
      entrada : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      saida : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT ULA
    GENERIC (larguraDados : NATURAL := 4);
    PORT (
      entradaA, entradaB : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      seletor : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      saida : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      saida_flagzero : OUT STD_LOGIC;
      saida_flag_greater : OUT STD_LOGIC;
      saida_flag_lesser : OUT STD_LOGIC
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

  COMPONENT InstructionDecoder
    PORT (
      entrada : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
      entrada_flag_zero : IN STD_LOGIC;
      entrada_flag_greater : IN STD_LOGIC;
      entrada_flag_lesser : IN STD_LOGIC;
      saida : OUT STD_LOGIC_VECTOR(14 DOWNTO 0)
    );
  END COMPONENT;

  -- ULA
  SIGNAL ENTRADA_A_ULA, ENTRADA_B_ULA : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL SAIDA_ULA : STD_LOGIC_VECTOR (7 DOWNTO 0);

  -- Decodificador
  SIGNAL SINAIS_DE_CONTROLE : STD_LOGIC_VECTOR (14 DOWNTO 0);
  SIGNAL SEL_MUX : STD_LOGIC;
  SIGNAL HABILITA_REG : STD_LOGIC;
  SIGNAL OPERACAO_ULA : STD_LOGIC_VECTOR(2 DOWNTO 0);

  -- Registrador PC
  SIGNAL SAIDA_MUX_PC : STD_LOGIC_VECTOR (8 DOWNTO 0);
  SIGNAL SEL_MUX_PC : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL ENDERECO : STD_LOGIC_VECTOR (8 DOWNTO 0);
  SIGNAL PROX_PC : STD_LOGIC_VECTOR (8 DOWNTO 0);

  -- Registrador Retorno
  SIGNAL SAIDA_REG_RETORNO : STD_LOGIC_VECTOR (8 DOWNTO 0);
  SIGNAL HABILITA_REG_RETORNO : STD_LOGIC;

  -- Registrador Flags
  SIGNAL FLAG_ZERO_SAIDA_ULA, FLAG_GREATER_SAIDA_ULA, FLAG_LESSER_SAIDA_ULA : STD_LOGIC;
  SIGNAL HABILITA_FLAG_ZERO, HABILITA_FLAG_GREATER, HABILITA_FLAG_LESSER : STD_LOGIC;
  SIGNAL FLAG_ZERO_SAIDA_REG, FLAG_GREATER_SAIDA_REG, FLAG_LESSER_SAIDA_REG : STD_LOGIC;

BEGIN

  -- O port map completo do MUX.
  MUX_ULA : GenericMux2x1
  GENERIC MAP(larguraDados => 8)
  PORT MAP(
    entradaA_MUX => DATA_IN,
    entradaB_MUX => INSTRUCTION_IN(7 DOWNTO 0),
    seletor_MUX => SEL_MUX,
    saida_MUX => ENTRADA_B_ULA);

  -- MUX do PC.
  MUX_PC : GenericMux4x1
  GENERIC MAP(larguraDados => 9)
  PORT MAP(
    entradaA_MUX => PROX_PC,
    entradaB_MUX => INSTRUCTION_IN(8 DOWNTO 0),
    entradaC_MUX => SAIDA_REG_RETORNO,
    entradaD_MUX => "000000000",
    seletor_MUX => SEL_MUX_PC,
    saida_MUX => SAIDA_MUX_PC);

  REGISTERS : ProcessorRegisters
  PORT MAP(
    CLOCK => CLOCK,
    REG_ADDR => INSTRUCTION_IN(10 DOWNTO 9),
    DATA_IN => SAIDA_ULA,
    HAB_ESCRITA => HABILITA_REG,
    SAIDA => ENTRADA_A_ULA
  );

  -- O port map completo do Program Counter.
  PC_REGISTER : GenericRegister
  GENERIC MAP(larguraDados => 9)
  PORT MAP(DIN => SAIDA_MUX_PC, DOUT => ENDERECO, ENABLE => '1', CLK => CLOCK, RST => '0');

  INCREASE_PC : AddConstant
  GENERIC MAP(larguraDados => 9, constante => 1)
  PORT MAP(entrada => ENDERECO, saida => PROX_PC);

  -- O port map do registrador de Retorno
  RETURN_REGISTER : GenericRegister
  GENERIC MAP(larguraDados => 9)
  PORT MAP(DIN => PROX_PC, DOUT => SAIDA_REG_RETORNO, ENABLE => HABILITA_REG_RETORNO, CLK => CLOCK, RST => '0');

  -- O port map completo da ULA:
  ULA_PROCESSOR : ULA
  GENERIC MAP(larguraDados => 8)
  PORT MAP(
    entradaA => ENTRADA_A_ULA,
    entradaB => ENTRADA_B_ULA,
    saida => SAIDA_ULA,
    seletor => OPERACAO_ULA,
    saida_flagzero => FLAG_ZERO_SAIDA_ULA,
    saida_flag_greater => FLAG_GREATER_SAIDA_ULA,
    saida_flag_lesser => FLAG_LESSER_SAIDA_ULA
  );

  -- O port map do registrador da flagzero
  ZERO_FLAG_REGISTER : OneBitRegister
  PORT MAP(DIN => FLAG_ZERO_SAIDA_ULA, DOUT => FLAG_ZERO_SAIDA_REG, ENABLE => HABILITA_FLAG_ZERO, CLK => CLOCK, RST => '0');

  -- O port map do registrador da flag greater than
  GREATER_FLAG_REGISTER : OneBitRegister
  PORT MAP(DIN => FLAG_GREATER_SAIDA_ULA, DOUT => FLAG_GREATER_SAIDA_REG, ENABLE => HABILITA_FLAG_GREATER, CLK => CLOCK, RST => '0');

  -- O port map do registrador da flag lesser than
  LESSER_FLAG_REGISTER : OneBitRegister
  PORT MAP(DIN => FLAG_LESSER_SAIDA_ULA, DOUT => FLAG_LESSER_SAIDA_REG, ENABLE => HABILITA_FLAG_LESSER, CLK => CLOCK, RST => '0');

  -- Decoder
  INSTRUCTION_DECODER : InstructionDecoder
  PORT MAP(
    entrada => INSTRUCTION_IN(15 DOWNTO 11),
    entrada_flag_zero => FLAG_ZERO_SAIDA_REG,
    entrada_flag_greater => FLAG_GREATER_SAIDA_REG,
    entrada_flag_lesser => FLAG_LESSER_SAIDA_REG,
    saida => SINAIS_DE_CONTROLE
  );

  HABILITA_FLAG_LESSER <= SINAIS_DE_CONTROLE(14);
  HABILITA_FLAG_GREATER <= SINAIS_DE_CONTROLE(13);
  HABILITA_REG_RETORNO <= SINAIS_DE_CONTROLE(12);

  SEL_MUX_PC <= "01" WHEN SINAIS_DE_CONTROLE(11) = '1' ELSE
    "01" WHEN SINAIS_DE_CONTROLE(9) = '1' ELSE
    "01" WHEN SINAIS_DE_CONTROLE(8) = '1' ELSE
    "10" WHEN SINAIS_DE_CONTROLE(10) = '1' ELSE
    "00";

  SEL_MUX <= SINAIS_DE_CONTROLE(7);
  HABILITA_REG <= SINAIS_DE_CONTROLE(6);
  OPERACAO_ULA <= SINAIS_DE_CONTROLE(5 DOWNTO 3);

  HABILITA_FLAG_ZERO <= SINAIS_DE_CONTROLE(2);

  RD <= SINAIS_DE_CONTROLE(1);
  WR <= SINAIS_DE_CONTROLE(0);
  ROM_ADDRESS <= ENDERECO;
  DATA_ADDRESS <= INSTRUCTION_IN(8 DOWNTO 0);
  DATA_OUT <= ENTRADA_A_ULA;

END ARCHITECTURE;