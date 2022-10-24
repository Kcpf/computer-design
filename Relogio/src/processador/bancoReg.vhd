LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY bancoReg IS
  PORT (
    CLOCK : IN STD_LOGIC := '0';
    REG_ADDR : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    DATA_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    HAB_ESCRITA : IN STD_LOGIC := '0';
    SAIDA : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0')
  );
END ENTITY;

ARCHITECTURE arquitetura OF bancoReg IS
  COMPONENT muxGenerico4x1
    GENERIC (larguraDados : NATURAL := 8);
    PORT (
      entradaA_MUX, entradaB_MUX, entradaC_MUX, entradaD_MUX : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      seletor_MUX : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      saida_MUX : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT dMuxGenerico
    GENERIC (larguraDados : NATURAL := 8);
    PORT (
      entrada_DMUX : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);
      seletor_DMUX : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      saidaA_DMUX, saidaB_DMUX, saidaC_DMUX, saidaD_DMUX : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT dMux1bit
    PORT (
      entrada_DMUX : IN STD_LOGIC;
      seletor_DMUX : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
      saidaA_DMUX, saidaB_DMUX, saidaC_DMUX, saidaD_DMUX : OUT STD_LOGIC
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

  SIGNAL DIN_0, DIN_1, DIN_2, DIN_3 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL HAB_0, HAB_1, HAB_2, HAB_3 : STD_LOGIC;
  SIGNAL DOUT_0, DOUT_1, DOUT_2, DOUT_3 : STD_LOGIC_VECTOR (7 DOWNTO 0);

BEGIN
  DMUX1 : dMuxGenerico
  GENERIC MAP(larguraDados => 8)
  PORT MAP(
    entrada_DMUX => DATA_IN,
    seletor_DMUX => REG_ADDR,
    saidaA_DMUX => DIN_0,
    saidaB_DMUX => DIN_1,
    saidaC_DMUX => DIN_2,
    saidaD_DMUX => DIN_3
  );

  DMUX2 : dMux1bit
  PORT MAP(
    entrada_DMUX => HAB_ESCRITA,
    seletor_DMUX => REG_ADDR,
    saidaA_DMUX => HAB_0,
    saidaB_DMUX => HAB_1,
    saidaC_DMUX => HAB_2,
    saidaD_DMUX => HAB_3
  );

  MUX : muxGenerico4x1
  GENERIC MAP(larguraDados => 8)
  PORT MAP(
    entradaA_MUX => DOUT_0,
    entradaB_MUX => DOUT_1,
    entradaC_MUX => DOUT_2,
    entradaD_MUX => DOUT_3,
    seletor_MUX => REG_ADDR,
    saida_MUX => SAIDA
  );

  REG0 : registradorGenerico
  GENERIC MAP(larguraDados => 8)
  PORT MAP(DIN => DIN_0, DOUT => DOUT_0, ENABLE => HAB_0, CLK => CLOCK, RST => '0');

  REG1 : registradorGenerico
  GENERIC MAP(larguraDados => 8)
  PORT MAP(DIN => DIN_1, DOUT => DOUT_1, ENABLE => HAB_1, CLK => CLOCK, RST => '0');

  REG2 : registradorGenerico
  GENERIC MAP(larguraDados => 8)
  PORT MAP(DIN => DIN_2, DOUT => DOUT_2, ENABLE => HAB_2, CLK => CLOCK, RST => '0');

  REG3 : registradorGenerico
  GENERIC MAP(larguraDados => 8)
  PORT MAP(DIN => DIN_3, DOUT => DOUT_3, ENABLE => HAB_3, CLK => CLOCK, RST => '0');

END ARCHITECTURE;