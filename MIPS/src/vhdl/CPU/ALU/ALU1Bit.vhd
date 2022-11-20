LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; -- Biblioteca IEEE para funções aritméticas

ENTITY ULA1Bit IS
  PORT (
    entradaA : IN STD_LOGIC := '0';
    entradaB : IN STD_LOGIC := '0';
    SLT : IN STD_LOGIC := '0';
    InverteA : IN STD_LOGIC := '0';
    InverteB : IN STD_LOGIC := '0';
    CarryIn : IN STD_LOGIC := '0';
    Selecao : IN STD_LOGIC_VECTOR (1 DOWNTO 0) := (OTHERS => '0');
    CarryOut : OUT STD_LOGIC := '0';
    Overflow : OUT STD_LOGIC := '0';
    Resultado : OUT STD_LOGIC := '0'
  );
END ENTITY;

ARCHITECTURE arch OF ULA1Bit IS

  COMPONENT FullAdder
    PORT (
      entradaA : IN STD_LOGIC := '0';
      entradaB : IN STD_LOGIC := '0';
      CarryIn : IN STD_LOGIC := '0';
      Soma : OUT STD_LOGIC := '0';
      CarryOut : OUT STD_LOGIC := '0'
    );
  END COMPONENT;

  SIGNAL MUX_INVERTE_B : STD_LOGIC;
  SIGNAL MUX_INVERTE_A : STD_LOGIC;
  SIGNAL SAIDA_SOMA : STD_LOGIC;
  SIGNAL SAIDA_SOMA_COUT : STD_LOGIC;

BEGIN
  MUX_INVERTE_B <= NOT entradaB WHEN InverteB = '1' ELSE
    entradaB;

  MUX_INVERTE_A <= NOT entradaA WHEN InverteA = '1' ELSE
    entradaA;

  FullAdder1 : FullAdder PORT MAP(
    entradaA => MUX_INVERTE_A,
    entradaB => MUX_INVERTE_B,
    CarryIn => CarryIn,
    Soma => SAIDA_SOMA,
    CarryOut => SAIDA_SOMA_COUT
  );

  Resultado <= MUX_INVERTE_A AND MUX_INVERTE_B WHEN Selecao = "00" ELSE
    MUX_INVERTE_A OR MUX_INVERTE_B WHEN Selecao = "01" ELSE
    SAIDA_SOMA WHEN Selecao = "10" ELSE
    SLT;

  Overflow <= (CarryIn XOR SAIDA_SOMA_COUT) XOR SAIDA_SOMA;
  CarryOut <= SAIDA_SOMA_COUT;

END ARCHITECTURE;