LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Atv2 IS
  -- Total de bits das entradas e saidas
  GENERIC (
    larguraDados : NATURAL := 4;
    larguraEnderecos : NATURAL := 3;
    simulacao : BOOLEAN := TRUE -- para gravar na placa, altere de TRUE para FALSE
  );
  PORT (
    CLOCK_50 : IN STD_LOGIC;
    SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    PC_OUT : OUT STD_LOGIC_VECTOR(larguraEnderecos - 1 DOWNTO 0);
    LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
END ENTITY;
ARCHITECTURE arquitetura OF Atv2 IS
  COMPONENT ULASomaSub
    GENERIC (larguraDados : NATURAL);
    PORT (
      entradaA, entradaB : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      seletor : IN STD_LOGIC;
      saida : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT registradorGenerico
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

  COMPONENT muxGenerico2x1
    GENERIC (larguraDados : NATURAL);
    PORT (
      entradaA_MUX, entradaB_MUX : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      seletor_MUX : IN STD_LOGIC;
      saida_MUX : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT somaConstante
    GENERIC (
      larguraDados : NATURAL;
      constante : NATURAL
    );
    PORT (
      entrada : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      saida : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT memoriaROM
    GENERIC (
      dataWidth : NATURAL;
      addrWidth : NATURAL
    );
    PORT (
      Endereco : IN STD_LOGIC_VECTOR (addrWidth - 1 DOWNTO 0);
      Dado : OUT STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0)
    );
  END COMPONENT;

  -- Faltam alguns sinais:
  SIGNAL chavesX_ULA_B : STD_LOGIC_VECTOR (larguraDados - 1 DOWNTO 0);
  SIGNAL chavesY_MUX_A : STD_LOGIC_VECTOR (larguraDados - 1 DOWNTO 0);
  SIGNAL MUX_REG1 : STD_LOGIC_VECTOR (larguraDados - 1 DOWNTO 0);
  SIGNAL REG1_ULA_A : STD_LOGIC_VECTOR (larguraDados - 1 DOWNTO 0);
  SIGNAL Saida_ULA : STD_LOGIC_VECTOR (larguraDados - 1 DOWNTO 0);
  SIGNAL Sinais_Controle : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL Endereco : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL proxPC : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL Chave_Operacao_ULA : STD_LOGIC;
  SIGNAL CLK : STD_LOGIC;
  SIGNAL SelMUX : STD_LOGIC;
  SIGNAL Habilita_A : STD_LOGIC;
  SIGNAL Reset_A : STD_LOGIC;
  SIGNAL Operacao_ULA : STD_LOGIC;
BEGIN

  CLK <= CLOCK_50;

  -- O port map completo do MUX.
  MUX1 : muxGenerico2x1 GENERIC MAP(larguraDados => larguraDados)
  PORT MAP(
    entradaA_MUX => chavesY_MUX_A,
    entradaB_MUX => Saida_ULA,
    seletor_MUX => SelMUX,
    saida_MUX => MUX_REG1);

  -- O port map completo do Acumulador.
  REGA : registradorGenerico GENERIC MAP(larguraDados => larguraDados)
  PORT MAP(DIN => MUX_REG1, DOUT => REG1_ULA_A, ENABLE => Habilita_A, CLK => CLK, RST => Reset_A);

  -- O port map completo do Program Counter.
  PC : registradorGenerico GENERIC MAP(larguraDados => larguraEnderecos)
  PORT MAP(DIN => proxPC, DOUT => Endereco, ENABLE => '1', CLK => CLK, RST => '0');

  incrementaPC : somaConstante GENERIC MAP(larguraDados => larguraEnderecos, constante => 1)
  PORT MAP(entrada => Endereco, saida => proxPC);

  -- O port map completo da ULA:
  ULA1 : ULASomaSub GENERIC MAP(larguraDados => larguraDados)
  PORT MAP(entradaA => REG1_ULA_A, entradaB => chavesX_ULA_B, saida => Saida_ULA, seletor => Operacao_ULA);

  -- Falta acertar o conteudo da ROM
  ROM1 : memoriaROM GENERIC MAP(dataWidth => larguraDados, addrWidth => larguraEnderecos)
  PORT MAP(Endereco => Endereco, Dado => Sinais_Controle);

  selMUX <= Sinais_Controle(3);
  Habilita_A <= Sinais_Controle(2);
  Reset_A <= Sinais_Controle(1);
  Operacao_ULA <= Sinais_Controle(0);

  -- I/O
  chavesY_MUX_A <= SW(3 DOWNTO 0);
  chavesX_ULA_B <= SW(9 DOWNTO 6);

  -- A ligacao dos LEDs:
  LEDR (9) <= SelMUX;
  LEDR (8) <= Habilita_A;
  LEDR (7) <= Reset_A;
  LEDR (6) <= Operacao_ULA;
  LEDR (5) <= '0'; -- Apagado.
  LEDR (4) <= '0'; -- Apagado.
  LEDR (3 DOWNTO 0) <= REG1_ULA_A;

  PC_OUT <= Endereco;

END ARCHITECTURE;