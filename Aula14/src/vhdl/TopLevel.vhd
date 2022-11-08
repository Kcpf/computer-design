LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY TopLevel IS
  GENERIC (
    larguraDados : NATURAL := 32;
    larguraEnderecos : NATURAL := 32;
    simulacao : BOOLEAN := TRUE
  );
  PORT (
    CLOCK_50 : IN STD_LOGIC := '0';
    PONTO_OPERACAO : IN STD_LOGIC := '0';
    PONTO_ESCREVE_C : IN STD_LOGIC := '0';
    PONTO_HAB_WRITE : IN STD_LOGIC := '0';
    PONTO_HAB_READ : IN STD_LOGIC := '0';
    PONTO_HAB_RAM : IN STD_LOGIC := '0';
    PONTO_MUX_RT_IMEDIATO : IN STD_LOGIC := '0';
    PONTO_BEQ : IN STD_LOGIC := '0'
  );
END ENTITY;
ARCHITECTURE arch OF TopLevel IS

  COMPONENT ROM
    GENERIC (
      dataWidth : NATURAL;
      addrWidth : NATURAL
    );
    PORT (
      Endereco : IN STD_LOGIC_VECTOR (addrWidth - 1 DOWNTO 0);
      Dado : OUT STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT GenericRegister
    GENERIC (
      larguraDados : NATURAL
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
      larguraDados : NATURAL;
      constante : NATURAL
    );
    PORT (
      entrada : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      saida : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT ULA
    GENERIC (larguraDados : NATURAL);
    PORT (
      entradaA, entradaB : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      seletor : IN STD_LOGIC;
      saida : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      flag_equal : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT ProcessorRegisters
    GENERIC (
      larguraDados : NATURAL;
      larguraEndBancoRegs : NATURAL
    );
    PORT (
      clk : IN STD_LOGIC;
      --
      enderecoA : IN STD_LOGIC_VECTOR((larguraEndBancoRegs - 1) DOWNTO 0);
      enderecoB : IN STD_LOGIC_VECTOR((larguraEndBancoRegs - 1) DOWNTO 0);
      enderecoC : IN STD_LOGIC_VECTOR((larguraEndBancoRegs - 1) DOWNTO 0);
      --
      dadoEscritaC : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      --
      escreveC : IN STD_LOGIC := '0';
      saidaA : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      saidaB : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT RAMMIPS
    GENERIC (
      dataWidth : NATURAL;
      addrWidth : NATURAL;
      memoryAddrWidth : NATURAL
    ); -- 64 posicoes de 32 bits cada
    PORT (
      clk : IN STD_LOGIC;
      Endereco : IN STD_LOGIC_VECTOR (addrWidth - 1 DOWNTO 0);
      Dado_in : IN STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0);
      Dado_out : OUT STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0);
      we, re, habilita : IN STD_LOGIC
    );
  END COMPONENT;

  COMPONENT estendeSinalGenerico
    GENERIC (
      larguraDadoEntrada : NATURAL;
      larguraDadoSaida : NATURAL
    );
    PORT (
      -- Input ports
      estendeSinal_IN : IN STD_LOGIC_VECTOR(larguraDadoEntrada - 1 DOWNTO 0);
      -- Output ports
      estendeSinal_OUT : OUT STD_LOGIC_VECTOR(larguraDadoSaida - 1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT GenericMux2x1
    GENERIC (larguraDados : NATURAL := 8);
    PORT (
      entradaA_MUX, entradaB_MUX : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      seletor_MUX : IN STD_LOGIC;
      saida_MUX : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT TwoBitShifter
    GENERIC (
      dataLength : NATURAL := 8
    );
    PORT (
      DIN : IN STD_LOGIC_VECTOR(dataLength - 1 DOWNTO 0);
      DOUT : OUT STD_LOGIC_VECTOR(dataLength - 1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT Adder
    GENERIC (
      larguraDados : NATURAL := 32
    );
    PORT (
      entradaA, entradaB : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      saida : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL SAIDA_ROM : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL ENDERECO_ROM : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL PROX_PC : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL SAIDA_A : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL SAIDA_B : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL SAIDA_ULA : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL SAIDA_ESTENDE_SINAL : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL SAIDA_RAM : STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL ENTRADA_B_ULA : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL FLAG_EQUAL_ULA : STD_LOGIC;
  SIGNAL SAIDA_BITSHIFT_IMEDIATO : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL SAIDA_ADDER_BEQ : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL SAIDA_SOMA_CONSTANTE_PC : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
  ROM_MEM : ROM
  GENERIC MAP(dataWidth => 32, addrWidth => 32)
  PORT MAP(Endereco => ENDERECO_ROM, Dado => SAIDA_ROM);

  PC_REGISTER : GenericRegister
  GENERIC MAP(larguraDados => 32)
  PORT MAP(DIN => PROX_PC, DOUT => ENDERECO_ROM, ENABLE => '1', CLK => CLOCK_50, RST => '0');

  INCREASE_PC : AddConstant
  GENERIC MAP(larguraDados => 32, constante => 4)
  PORT MAP(entrada => ENDERECO_ROM, saida => SAIDA_SOMA_CONSTANTE_PC);

  ESTENDE : estendeSinalGenerico
  GENERIC MAP(larguraDadoEntrada => 16, larguraDadoSaida => 32)
  PORT MAP(estendeSinal_IN => SAIDA_ROM(15 DOWNTO 0), estendeSinal_OUT => SAIDA_ESTENDE_SINAL);

  RAM_MEM : RAMMIPS
  GENERIC MAP(dataWidth => 32, addrWidth => 32, memoryAddrWidth => 6)
  PORT MAP(
    clk => CLOCK_50,
    Endereco => SAIDA_ULA,
    Dado_in => SAIDA_B,
    Dado_out => SAIDA_RAM,
    we => PONTO_HAB_WRITE,
    re => PONTO_HAB_READ,
    habilita => PONTO_HAB_RAM
  );

  BancoReg : ProcessorRegisters
  GENERIC MAP(larguraDados => 32, larguraEndBancoRegs => 5)
  PORT MAP(
    clk => CLOCK_50,
    enderecoA => SAIDA_ROM(25 DOWNTO 21),
    enderecoB => SAIDA_ROM(20 DOWNTO 16),
    enderecoC => SAIDA_ROM(20 DOWNTO 16),
    dadoEscritaC => SAIDA_RAM,
    escreveC => PONTO_ESCREVE_C,
    saidaA => SAIDA_A,
    saidaB => SAIDA_B
  );

  ADDER_BEQ : Adder
  GENERIC MAP(larguraDados => 32)
  PORT MAP(
    entradaA => SAIDA_SOMA_CONSTANTE_PC,
    entradaB => SAIDA_BITSHIFT_IMEDIATO,
    saida => SAIDA_ADDER_BEQ
  );

  BIT_SHIFT_IMEDIATO : TwoBitShifter
  GENERIC MAP(dataLength => 32)
  PORT MAP(
    DIN => SAIDA_ESTENDE_SINAL,
    DOUT => SAIDA_BITSHIFT_IMEDIATO
  );

  MUX_BEQ : GenericMux2x1
  GENERIC MAP(larguraDados => 32)
  PORT MAP(
    entradaA_MUX => SAIDA_SOMA_CONSTANTE_PC,
    entradaB_MUX => SAIDA_ADDER_BEQ,
    seletor_MUX => FLAG_EQUAL_ULA AND PONTO_BEQ,
    saida_MUX => PROX_PC
  );

  MUX_ENTRADA_B_ULA : GenericMux2x1
  GENERIC MAP(larguraDados => 32)
  PORT MAP(
    entradaA_MUX => SAIDA_B,
    entradaB_MUX => SAIDA_ESTENDE_SINAL,
    seletor_MUX => PONTO_MUX_RT_IMEDIATO,
    saida_MUX => ENTRADA_B_ULA
  );

  ULA_PROCESSOR : ULA
  GENERIC MAP(larguraDados => 32)
  PORT MAP(
    entradaA => SAIDA_A,
    entradaB => ENTRADA_B_ULA,
    seletor => PONTO_OPERACAO,
    saida => SAIDA_ULA,
    flag_equal => FLAG_EQUAL_ULA
  );

END ARCHITECTURE;