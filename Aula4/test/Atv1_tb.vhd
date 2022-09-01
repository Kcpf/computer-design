LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Atv1_tb IS
END Atv1_tb;

ARCHITECTURE test OF Atv1_tb IS
  COMPONENT Atv1
    GENERIC (
      larguraDados : NATURAL := 8;
      larguraEnderecos : NATURAL := 9
    );
    PORT (
      CLOCK_50 : IN STD_LOGIC;
      PC_OUT : OUT STD_LOGIC_VECTOR(larguraEnderecos - 1 DOWNTO 0);
      LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL clock : STD_LOGIC := '0';
  SIGNAL ledr : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL pc_out : STD_LOGIC_VECTOR(8 DOWNTO 0);

  CONSTANT PERIODO : TIME := 10 ns;

BEGIN

  atv : Atv1
  GENERIC MAP(
    larguraDados => 8,
    larguraEnderecos => 9
  )
  PORT MAP(
    CLOCK_50 => clock,
    PC_OUT => pc_out,
    LEDR => ledr
  );
  
  clock <= NOT clock AFTER PERIODO / 2;

END test;