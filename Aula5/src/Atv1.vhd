LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Atv1 IS
  GENERIC (
    larguraDados : NATURAL := 8;
    larguraEnderecos : NATURAL := 9
  );
  PORT (
    CLOCK_50 : IN STD_LOGIC;
    PC_OUT : OUT STD_LOGIC_VECTOR(larguraEnderecos - 1 DOWNTO 0);
    LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
END ENTITY;
ARCHITECTURE arquitetura OF Atv1 IS
  COMPONENT ULA
    GENERIC (larguraDados : NATURAL);
    PORT (
      entradaA, entradaB : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      seletor : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      saida : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      flagIgual : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT registradorGenerico
    GENERIC (larguraDados : NATURAL);
    PORT (
      DIN : IN STD_LOGIC_VECTOR(larguraDados - 1 DOWNTO 0);
      DOUT : OUT STD_LOGIC_VECTOR(larguraDados - 1 DOWNTO 0);
      ENABLE : IN STD_LOGIC;
      CLK, RST : IN STD_LOGIC
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

  COMPONENT muxGenerico2x1
    GENERIC (larguraDados : NATURAL);
    PORT (
      entradaA_MUX, entradaB_MUX : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      seletor_MUX : IN STD_LOGIC;
      saida_MUX : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT muxGenerico3x1
    GENERIC (larguraDados : NATURAL);
    PORT (
      entradaA_MUX, entradaB_MUX, entradaC_MUX : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      seletor_MUX : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
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

  COMPONENT decoderGeneric
    PORT (
      entrada : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      saida : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT memoriaRAM
    GENERIC (
      dataWidth : NATURAL;
      addrWidth : NATURAL
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

  -- ULA
  SIGNAL Entrada_A_ULA, Entrada_B_ULA : STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
  SIGNAL Saida_ULA : STD_LOGIC_VECTOR (larguraDados - 1 DOWNTO 0);
  SIGNAL FlagIgual : STD_LOGIC;

  -- MEMORIA
  SIGNAL Saida_Memoria : STD_LOGIC_VECTOR (larguraDados - 1 DOWNTO 0);
  SIGNAL habEscritaMEM : STD_LOGIC;
  SIGNAL habLeituraMEM : STD_LOGIC;

  -- Intrucao
  SIGNAL Instrucao : STD_LOGIC_VECTOR (12 DOWNTO 0);

  -- Decodificador
  SIGNAL Sinais_Controle : STD_LOGIC_VECTOR (11 DOWNTO 0);
  SIGNAL SelMUX : STD_LOGIC;
  SIGNAL Habilita_A : STD_LOGIC;
  SIGNAL Operacao_ULA : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL JUMP : STD_LOGIC;
  SIGNAL JUMPEQ : STD_LOGIC;
  SIGNAL RET : STD_LOGIC;
  SIGNAL JSR : STD_LOGIC;

  -- Registrador PC
  SIGNAL Endereco : STD_LOGIC_VECTOR (larguraEnderecos - 1 DOWNTO 0);
  SIGNAL proxPC : STD_LOGIC_VECTOR (larguraEnderecos - 1 DOWNTO 0);
  SIGNAL Saida_MUX_PC : STD_LOGIC_VECTOR (larguraEnderecos - 1 DOWNTO 0);

  -- Registrador Flag Equal
  SIGNAL habFlagEqual : STD_LOGIC;
  SIGNAL Saida_FlagEqual : STD_LOGIC;

  -- Registrador de Retorno
  SIGNAL habRetorno : STD_LOGIC;
  SIGNAL Saida_Retorno : STD_LOGIC_VECTOR (larguraEnderecos - 1 DOWNTO 0);

  SIGNAL CLK : STD_LOGIC;

BEGIN

  CLK <= CLOCK_50;

  -- O port map completo do MUX.
  MUX1 : muxGenerico2x1
  GENERIC MAP(larguraDados => larguraDados)
  PORT MAP(
    entradaA_MUX => Saida_Memoria,
    entradaB_MUX => Instrucao(7 DOWNTO 0),
    seletor_MUX => SelMUX,
    saida_MUX => Entrada_B_ULA
  );

  -- O port map completo do Acumulador.
  REGA : registradorGenerico
  GENERIC MAP(larguraDados => larguraDados)
  PORT MAP(DIN => Saida_ULA, DOUT => Entrada_A_ULA, ENABLE => Habilita_A, CLK => CLK, RST => '0');

  -- O port map completo do Program Counter.
  PC : registradorGenerico
  GENERIC MAP(larguraDados => larguraEnderecos)
  PORT MAP(DIN => Saida_MUX_PC, DOUT => Endereco, ENABLE => '1', CLK => CLK, RST => '0');

  incrementaPC : somaConstante
  GENERIC MAP(larguraDados => larguraEnderecos, constante => 1)
  PORT MAP(entrada => Endereco, saida => proxPC);

  REGRETORNO : registradorGenerico
  GENERIC MAP(larguraDados => larguraEnderecos)
  PORT MAP(DIN => proxPC, DOUT => Saida_Retorno, ENABLE => habRetorno, CLK => CLK, RST => '0');

  -- O port map completo do MUX PC
  MUX2 : muxGenerico3x1
  GENERIC MAP(larguraDados => larguraEnderecos)
  PORT MAP(
    entradaA_MUX => proxPC,
    entradaB_MUX => Instrucao(8 DOWNTO 0),
    entradaC_MUX => Saida_Retorno,
    seletor_MUX => RET & (JUMP OR JSR OR (JUMPEQ AND Saida_FlagEqual)),
    saida_MUX => Saida_MUX_PC
  );

  -- O port map completo da ULA:
  ULA1 : ULA
  GENERIC MAP(larguraDados => larguraDados)
  PORT MAP(entradaA => Entrada_A_ULA, entradaB => Entrada_B_ULA, saida => Saida_ULA, seletor => Operacao_ULA, flagIgual => FlagIgual);

  REGFLAGEQUAL : registradorFlag
  PORT MAP(DIN => FlagIgual, DOUT => Saida_FlagEqual, ENABLE => habFlagEqual, CLK => CLK, RST => '0');

  -- Falta acertar o conteudo da ROM
  ROM1 : memoriaROM
  GENERIC MAP(dataWidth => 13, addrWidth => larguraEnderecos)
  PORT MAP(Endereco => Endereco, Dado => Instrucao);

  -- Decoder
  DEC : decoderGeneric
  PORT MAP(entrada => Instrucao(12 DOWNTO 9), saida => Sinais_Controle);

  -- Memoria
  MEM : memoriaRAM
  GENERIC MAP(dataWidth => larguraDados, addrWidth => larguraEnderecos)
  PORT MAP(addr => Instrucao(8 DOWNTO 0), we => habEscritaMEM, re => habLeituraMEM, habilita => Instrucao(8), clk => CLK, dado_in => Entrada_A_ULA, dado_out => Saida_Memoria);

  habRetorno <= Sinais_Controle(11);
  JUMP <= Sinais_Controle(10);
  RET <= Sinais_Controle(9);
  JSR <= Sinais_Controle(8);
  JUMPEQ <= Sinais_Controle(7);
  selMUX <= Sinais_Controle(6);
  Habilita_A <= Sinais_Controle(5);
  Operacao_ULA <= Sinais_Controle(4 DOWNTO 3);
  habFlagEqual <= Sinais_Controle(2);
  habLeituraMEM <= Sinais_Controle(1);
  habEscritaMEM <= Sinais_Controle(0);

  -- A ligacao dos LEDs:
  LEDR (9) <= SelMUX;
  LEDR (8) <= Habilita_A;
  LEDR (7 DOWNTO 0) <= Entrada_A_ULA;

  PC_OUT <= Endereco;

END ARCHITECTURE;