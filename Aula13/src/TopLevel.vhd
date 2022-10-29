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
    PONTO_SELETOR : IN STD_LOGIC := '0';
    PONTO_ESCREVE_C : IN STD_LOGIC := '0'
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
      saida : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
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

  SIGNAL SAIDA_ROM : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL ENDERECO_ROM : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL PROX_PC : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL SAIDA_A : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL SAIDA_B : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL SAIDA_ULA : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
  ROM_MEM : ROM
  GENERIC MAP(dataWidth => 32, addrWidth => 32)
  PORT MAP(Endereco => ENDERECO_ROM, Dado => SAIDA_ROM);

  PC_REGISTER : GenericRegister
  GENERIC MAP(larguraDados => 32)
  PORT MAP(DIN => PROX_PC, DOUT => ENDERECO_ROM, ENABLE => '1', CLK => CLOCK_50, RST => '0');

  INCREASE_PC : AddConstant
  GENERIC MAP(larguraDados => 32, constante => 4)
  PORT MAP(entrada => ENDERECO_ROM, saida => PROX_PC);

  BancoReg : ProcessorRegisters
  GENERIC MAP(larguraDados => 32, larguraEndBancoRegs => 5)
  PORT MAP(
    clk => CLOCK_50,
    enderecoA => SAIDA_ROM(4 DOWNTO 0),
    enderecoB => SAIDA_ROM(9 DOWNTO 5),
    enderecoC => SAIDA_ROM(14 DOWNTO 10),
    dadoEscritaC => SAIDA_ULA,
    escreveC => PONTO_ESCREVE_C,
    saidaA => SAIDA_A,
    saidaB => SAIDA_B
  );

  ULA_PROCESSOR : ULA
  GENERIC MAP(larguraDados => 32)
  PORT MAP(
    entradaA => SAIDA_A,
    entradaB => SAIDA_B,
    seletor => PONTO_SELETOR,
    saida => SAIDA_ULA
  );

END ARCHITECTURE;