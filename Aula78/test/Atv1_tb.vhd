LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Atv1_tb IS
END Atv1_tb;

ARCHITECTURE test OF Atv1_tb IS
  COMPONENT Atv1
    GENERIC (
      larguraDados : NATURAL := 8;
      larguraEnderecos : NATURAL := 9;
      simulacao : BOOLEAN := TRUE
    );
    PORT (
      CLOCK_50 : IN STD_LOGIC;
      KEY : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      FPGA_RESET_N : IN STD_LOGIC;
      SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      DATA_TEST : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL clock : STD_LOGIC := '0';
  SIGNAL key_vector : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
  SIGNAL fpga_reset : STD_LOGIC := '0';
  SIGNAL sw_vector : STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');
  SIGNAL data_test : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL ledr_vector : STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');
  SIGNAL hex0_vector : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
  SIGNAL hex1_vector : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
  SIGNAL hex2_vector : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
  SIGNAL hex3_vector : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
  SIGNAL hex4_vector : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
  SIGNAL hex5_vector : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');

  CONSTANT PERIODO : TIME := 10 ns;

BEGIN

  atv : Atv1
  GENERIC MAP(
    larguraDados => 8,
    larguraEnderecos => 9,
    simulacao => TRUE
  )
  PORT MAP(
    CLOCK_50 => clock,
    KEY => key_vector,
    FPGA_RESET_N => fpga_reset,
    SW => sw_vector,
    DATA_TEST => data_test,
    LEDR => ledr_vector,
    HEX0 => hex0_vector,
    HEX1 => hex1_vector,
    HEX2 => hex2_vector,
    HEX3 => hex3_vector,
    HEX4 => hex4_vector,
    HEX5 => hex5_vector
  );

  clock <= NOT clock AFTER PERIODO / 2;

  main : PROCESS BEGIN

    key_vector <= "0001";

    WAIT FOR 170 ns;

    key_vector <= "0000";

    WAIT FOR 10 ns;

    key_vector <= "0001";

    WAIT FOR 170 ns;

    key_vector <= "0000";

    WAIT FOR 10 ns;

    key_vector <= "0001";

    WAIT;

  END PROCESS;

END test;