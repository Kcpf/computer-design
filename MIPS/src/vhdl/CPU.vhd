LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY CPU IS
  PORT (
    CLOCK_50 : IN STD_LOGIC := '0';
    PONTO_INVERTE_A : IN STD_LOGIC := '0';
    PONTO_INVERTE_B : IN STD_LOGIC := '0';
    PONTO_OPERACAO : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    PONTO_CARRY_IN : IN STD_LOGIC := '0';
    PONTO_ESCREVE_C : IN STD_LOGIC := '0';
    PONTO_HAB_WRITE : IN STD_LOGIC := '0';
    PONTO_HAB_READ : IN STD_LOGIC := '0';
    PONTO_HAB_RAM : IN STD_LOGIC := '0';
    PONTO_MUX_RT_IMEDIATO : IN STD_LOGIC := '0';
    PONTO_BEQ : IN STD_LOGIC := '0';
    PONTO_MUX_RT_RD : IN STD_LOGIC := '0';
    PONTO_MUX_ALU_RAM : IN STD_LOGIC := '0';
    PONTO_MUX_JMP : IN STD_LOGIC := '0'
  );
END ENTITY;
ARCHITECTURE arch OF CPU IS

  COMPONENT ROM
    PORT (
      Endereco : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      Dado : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT PCRegister
    PORT (
      DIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
      ENABLE : IN STD_LOGIC := '0';
      CLK, RST : IN STD_LOGIC := '0';
      DOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')
    );
  END COMPONENT;

  COMPONENT AddConstant
    GENERIC (
      constante : NATURAL
    );
    PORT (
      entrada : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      saida : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT ALU32Bit
    PORT (
      entradaA : IN STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
      entradaB : IN STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
      InverteA : IN STD_LOGIC := '0';
      InverteB : IN STD_LOGIC := '0';
      Selecao : IN STD_LOGIC_VECTOR (1 DOWNTO 0) := (OTHERS => '0');
      CarryIn : IN STD_LOGIC := '0';
      Resultado : OUT STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
      Zero : OUT STD_LOGIC := '0'
    );
  END COMPONENT;

  COMPONENT RegisterFile
    PORT (
      CLK : IN STD_LOGIC;
      REG_B_SEL : IN STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
      REG_A_SEL : IN STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
      REG_WRITE_SEL : IN STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
      INPUT_DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
      WRITE_ENABLE : IN STD_LOGIC := '0';
      OUT_A : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
      OUT_B : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')
    );
  END COMPONENT;

  COMPONENT RAM
    PORT (
      clk : IN STD_LOGIC := '0';
      Endereco : IN STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
      Dado_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
      Dado_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
      we, re, habilita : IN STD_LOGIC := '0'
    );
  END COMPONENT;

  COMPONENT ExtendSignal
    PORT (
      -- Input ports
      estendeSinal_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      -- Output ports
      estendeSinal_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
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

  COMPONENT Adder
    PORT (
      entradaA, entradaB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      saida : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
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
  SIGNAL SAIDA_MUX_BEQ : STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL ENTRADA_B_ULA : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL FLAG_ZERO_ALU : STD_LOGIC;
  SIGNAL SAIDA_BITSHIFT_IMEDIATO : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL SAIDA_ADDER_BEQ : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL SAIDA_SOMA_CONSTANTE_PC : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL REG_WRITE_ADDR : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL INPUT_DATA_REG_FILE : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
  ROM_MEM : ROM
  PORT MAP(
    Endereco => ENDERECO_ROM,
    Dado => SAIDA_ROM
  );

  PC_REGISTER : PCRegister
  PORT MAP(
    DIN => PROX_PC,
    DOUT => ENDERECO_ROM,
    ENABLE => '1',
    CLK => CLOCK_50,
    RST => '0'
  );

  INCREASE_PC : AddConstant
  GENERIC MAP(constante => 4)
  PORT MAP(entrada => ENDERECO_ROM, saida => SAIDA_SOMA_CONSTANTE_PC);

  ESTENDE : ExtendSignal
  PORT MAP(estendeSinal_IN => SAIDA_ROM(15 DOWNTO 0), estendeSinal_OUT => SAIDA_ESTENDE_SINAL);

  RAM_MEM : RAM
  PORT MAP(
    clk => CLOCK_50,
    Endereco => SAIDA_ULA,
    Dado_in => SAIDA_B,
    Dado_out => SAIDA_RAM,
    we => PONTO_HAB_WRITE,
    re => PONTO_HAB_READ,
    habilita => PONTO_HAB_RAM
  );

  MUX_RT_RD : GenericMux2x1
  GENERIC MAP(larguraDados => 5)
  PORT MAP(
    entradaA_MUX => SAIDA_ROM(20 DOWNTO 16),
    entradaB_MUX => SAIDA_ROM(15 DOWNTO 11),
    seletor_MUX => PONTO_MUX_RT_RD,
    saida_MUX => REG_WRITE_ADDR
  );

  MUX_ALU_RAM : GenericMux2x1
  GENERIC MAP(larguraDados => 32)
  PORT MAP(
    entradaA_MUX => SAIDA_ULA,
    entradaB_MUX => SAIDA_RAM,
    seletor_MUX => PONTO_MUX_ALU_RAM,
    saida_MUX => INPUT_DATA_REG_FILE
  );

  RegFile : RegisterFile
  PORT MAP(
    CLK => CLOCK_50,
    REG_A_SEL => SAIDA_ROM(25 DOWNTO 21),
    REG_B_SEL => SAIDA_ROM(20 DOWNTO 16),
    REG_WRITE_SEL => REG_WRITE_ADDR,
    INPUT_DATA => INPUT_DATA_REG_FILE,
    WRITE_ENABLE => PONTO_ESCREVE_C,
    OUT_A => SAIDA_A,
    OUT_B => SAIDA_B
  );

  ADDER_BEQ : Adder
  PORT MAP(
    entradaA => SAIDA_SOMA_CONSTANTE_PC,
    entradaB => SAIDA_ESTENDE_SINAL(29 DOWNTO 0) & "00",
    saida => SAIDA_ADDER_BEQ
  );

  MUX_JMP : GenericMux2x1
  GENERIC MAP(larguraDados => 32)
  PORT MAP(
    entradaA_MUX => SAIDA_MUX_BEQ,
    entradaB_MUX => SAIDA_SOMA_CONSTANTE_PC(31 DOWNTO 28) & SAIDA_ROM(25 DOWNTO 0) & "00",
    seletor_MUX => PONTO_MUX_JMP,
    saida_MUX => PROX_PC
  );

  MUX_BEQ : GenericMux2x1
  GENERIC MAP(larguraDados => 32)
  PORT MAP(
    entradaA_MUX => SAIDA_SOMA_CONSTANTE_PC,
    entradaB_MUX => SAIDA_ADDER_BEQ,
    seletor_MUX => FLAG_ZERO_ALU AND PONTO_BEQ,
    saida_MUX => SAIDA_MUX_BEQ
  );

  MUX_ENTRADA_B_ULA : GenericMux2x1
  GENERIC MAP(larguraDados => 32)
  PORT MAP(
    entradaA_MUX => SAIDA_B,
    entradaB_MUX => SAIDA_ESTENDE_SINAL,
    seletor_MUX => PONTO_MUX_RT_IMEDIATO,
    saida_MUX => ENTRADA_B_ULA
  );

  ULA_PROCESSOR : ALU32Bit
  PORT MAP(
    entradaA => SAIDA_A,
    entradaB => ENTRADA_B_ULA,
    InverteA => PONTO_INVERTE_A,
    InverteB => PONTO_INVERTE_B,
    Selecao => PONTO_OPERACAO,
    CarryIn => PONTO_CARRY_IN,
    Resultado => SAIDA_ULA,
    Zero => FLAG_ZERO_ALU
  );

END ARCHITECTURE;