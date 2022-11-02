LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY DisplayHex IS
  PORT (
    ENTRADA_HABILITA : IN STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";
    ESCRITA_DADOS : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    CLK : IN STD_LOGIC := '0';
    HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000"
  );
END ENTITY;

ARCHITECTURE comportamento OF DisplayHex IS

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

  COMPONENT Hex7SegConverter
    PORT (
      -- Input ports
      dadoHex : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      apaga : IN STD_LOGIC := '0';
      negativo : IN STD_LOGIC := '0';
      overFlow : IN STD_LOGIC := '0';
      -- Output ports
      saida7seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) -- := (others => '1')
    );
  END COMPONENT;

  -- REGISTRADOR -> DECODER 
  SIGNAL REG_DECODER_0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL REG_DECODER_1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL REG_DECODER_2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL REG_DECODER_3 : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL REG_DECODER_4 : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL REG_DECODER_5 : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
  REG0 : GenericRegister
  GENERIC MAP(larguraDados => 4)
  PORT MAP(
    DIN => ESCRITA_DADOS(3 DOWNTO 0),
    DOUT => REG_DECODER_0(3 DOWNTO 0),
    ENABLE => ENTRADA_HABILITA(0),
    CLK => CLK,
    RST => '0'
  );

  DEC0 : Hex7SegConverter
  PORT MAP(
    dadoHex => REG_DECODER_0,
    apaga => '0',
    negativo => '0',
    overflow => '0',
    saida7seg => HEX0
  );

  REG1 : GenericRegister
  GENERIC MAP(larguraDados => 4)
  PORT MAP(
    DIN => ESCRITA_DADOS(3 DOWNTO 0),
    DOUT => REG_DECODER_1(3 DOWNTO 0),
    ENABLE => ENTRADA_HABILITA(1),
    CLK => CLK,
    RST => '0'
  );

  DEC1 : Hex7SegConverter
  PORT MAP(
    dadoHex => REG_DECODER_1,
    apaga => '0',
    negativo => '0',
    overflow => '0',
    saida7seg => HEX1
  );

  REG2 : GenericRegister
  GENERIC MAP(larguraDados => 4)
  PORT MAP(
    DIN => ESCRITA_DADOS(3 DOWNTO 0),
    DOUT => REG_DECODER_2(3 DOWNTO 0),
    ENABLE => ENTRADA_HABILITA(2),
    CLK => CLK,
    RST => '0'
  );

  DEC2 : Hex7SegConverter
  PORT MAP(
    dadoHex => REG_DECODER_2,
    apaga => '0',
    negativo => '0',
    overflow => '0',
    saida7seg => HEX2
  );

  REG3 : GenericRegister
  GENERIC MAP(larguraDados => 4)
  PORT MAP(
    DIN => ESCRITA_DADOS(3 DOWNTO 0),
    DOUT => REG_DECODER_3(3 DOWNTO 0),
    ENABLE => ENTRADA_HABILITA(3),
    CLK => CLK,
    RST => '0'
  );

  DEC3 : Hex7SegConverter
  PORT MAP(
    dadoHex => REG_DECODER_3,
    apaga => '0',
    negativo => '0',
    overflow => '0',
    saida7seg => HEX3
  );

  REG4 : GenericRegister
  GENERIC MAP(larguraDados => 4)
  PORT MAP(
    DIN => ESCRITA_DADOS(3 DOWNTO 0),
    DOUT => REG_DECODER_4(3 DOWNTO 0),
    ENABLE => ENTRADA_HABILITA(4),
    CLK => CLK,
    RST => '0'
  );

  DEC4 : Hex7SegConverter
  PORT MAP(
    dadoHex => REG_DECODER_4,
    apaga => '0',
    negativo => '0',
    overflow => '0',
    saida7seg => HEX4
  );

  REG5 : GenericRegister
  GENERIC MAP(larguraDados => 4)
  PORT MAP(
    DIN => ESCRITA_DADOS(3 DOWNTO 0),
    DOUT => REG_DECODER_5(3 DOWNTO 0),
    ENABLE => ENTRADA_HABILITA(5),
    CLK => CLK,
    RST => '0'
  );

  DEC5 : Hex7SegConverter
  PORT MAP(
    dadoHex => REG_DECODER_5,
    apaga => '0',
    negativo => '0',
    overflow => '0',
    saida7seg => HEX5
  );
END ARCHITECTURE;