LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Atv1_tb IS
END Atv1_tb;

ARCHITECTURE test OF Atv1_tb IS
  COMPONENT Atv1
    GENERIC (
      larguraDados : NATURAL;
      larguraEnderecos : NATURAL;
      simulacao : BOOLEAN
    );
    PORT (
      CLOCK_50 : IN STD_LOGIC;
      SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      PC_OUT : OUT STD_LOGIC_VECTOR(larguraEnderecos - 1 DOWNTO 0);
      LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL clock : STD_LOGIC := '0';
  SIGNAL sw : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL pc_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL ledr : STD_LOGIC_VECTOR(9 DOWNTO 0);

  CONSTANT PERIODO : TIME := 10 ns;

BEGIN

  at : Atv1 
  GENERIC MAP(larguraDados => 4, larguraEnderecos => 3, simulacao => TRUE)
  PORT MAP(
    CLOCK_50 => clock,
    SW => sw,
    PC_OUT => pc_out,
    LEDR => ledr
  );

  clock <= NOT clock AFTER PERIODO / 2;

  main : PROCESS BEGIN

    sw <= "0000000000";
    WAIT FOR PERIODO;

    sw <= "0011000000";
    WAIT FOR PERIODO;

    sw <= "0011000000";
    WAIT FOR PERIODO;

    sw <= "0011000000";
    WAIT FOR PERIODO;

    sw <= "0100000000";
    WAIT FOR PERIODO;

    WAIT;

  END PROCESS;

END test;