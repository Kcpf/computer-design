LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Atv1_tb IS
END Atv1_tb;

ARCHITECTURE test OF Atv1_tb IS
  COMPONENT memoria
    GENERIC (
      dataWidth : NATURAL;
      addrWidth : NATURAL
    );
    PORT (
      -- O fato da interface ser do tipo std_logic auxilía na simulação.
      Endereco : IN STD_LOGIC_VECTOR (addrWidth - 1 DOWNTO 0);
      Dado : OUT STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL ender : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL data : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

  mem : memoria GENERIC MAP(
    dataWidth => 8,
    addrWidth => 10)
  PORT MAP(
    Endereco => ender,
    Dado => data);

  main : PROCESS BEGIN
    ender <= "0000000000";
    WAIT FOR 10 ns;

    ender <= "0000000001";
    WAIT FOR 10 ns;

    ender <= "0000000010";
    WAIT FOR 10 ns;

    WAIT;

  END PROCESS;

END test;