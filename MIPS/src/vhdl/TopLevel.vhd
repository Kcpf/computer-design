LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY TopLevel IS
  PORT (
    CLOCK_50 : IN STD_LOGIC := '0'
  );
END ENTITY;
ARCHITECTURE arch OF TopLevel IS

  COMPONENT ROM
    PORT (
      Endereco : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      Dado : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
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

  COMPONENT CPU
    PORT (
      CLOCK : IN STD_LOGIC := '0';
      INSTRUCTION_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
      DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
      RD, WR : OUT STD_LOGIC := '0';
      ROM_ADDRESS : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
      DATA_ADDRESS : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
      DATA_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')
    );
  END COMPONENT;

  SIGNAL ENDERECO_ROM : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL SAIDA_ROM : STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL ENDERECO_RAM : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL ENTRADA_RAM : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL SAIDA_RAM : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL WR, RD : STD_LOGIC;
BEGIN
  ROM_MEM : ROM
  PORT MAP(
    Endereco => ENDERECO_ROM,
    Dado => SAIDA_ROM
  );

  RAM_MEM : RAM
  PORT MAP(
    clk => CLOCK_50,
    Endereco => ENDERECO_RAM,
    Dado_in => ENTRADA_RAM,
    Dado_out => SAIDA_RAM,
    we => WR,
    re => RD,
    habilita => '1'
  );

  CPU_PORT_MAP : CPU
  PORT MAP(
    CLOCK => CLOCK_50,
    INSTRUCTION_IN => SAIDA_ROM,
    DATA_IN => SAIDA_RAM,
    RD => RD,
    WR => WR,
    ROM_ADDRESS => ENDERECO_ROM,
    DATA_ADDRESS => ENDERECO_RAM,
    DATA_OUT => ENTRADA_RAM
  );
END ARCHITECTURE;