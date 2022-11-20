LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; -- Biblioteca IEEE para funções aritméticas

ENTITY ALU32Bit IS
  PORT (
    entradaA : IN STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
    entradaB : IN STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
    InverteA : IN STD_LOGIC := '0';
    InverteB : IN STD_LOGIC := '0';
    Selecao : IN STD_LOGIC_VECTOR (1 DOWNTO 0) := (OTHERS => '0');
    CarryIn : IN STD_LOGIC := '0';
    Resultado : OUT STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
    Zero : OUT STD_LOGIC := '0'
  );
END ENTITY;

ARCHITECTURE arch OF ALU32Bit IS

  COMPONENT ULA1Bit
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
  END COMPONENT;

  SIGNAL SLT_SIGNAL : STD_LOGIC;
  SIGNAL CARRY_VEC : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL RESULTADO_VEC : STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN

  ULA_0 : ULA1Bit PORT MAP(
    entradaA => entradaA(0),
    entradaB => entradaB(0),
    SLT => SLT_SIGNAL,
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CarryIn,
    Selecao => Selecao,
    CarryOut => CARRY_VEC(0),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(0)
  );

  ULA_1 : ULA1Bit PORT MAP(
    entradaA => entradaA(1),
    entradaB => entradaB(1),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(0),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(1),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(1)
  );

  ULA_2 : ULA1Bit PORT MAP(
    entradaA => entradaA(2),
    entradaB => entradaB(2),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(1),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(2),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(2)
  );

  ULA_3 : ULA1Bit PORT MAP(
    entradaA => entradaA(3),
    entradaB => entradaB(3),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(2),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(3),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(3)
  );

  ULA_4 : ULA1Bit PORT MAP(
    entradaA => entradaA(4),
    entradaB => entradaB(4),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(3),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(4),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(4)
  );

  ULA_5 : ULA1Bit PORT MAP(
    entradaA => entradaA(5),
    entradaB => entradaB(5),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(4),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(5),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(5)
  );

  ULA_6 : ULA1Bit PORT MAP(
    entradaA => entradaA(6),
    entradaB => entradaB(6),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(5),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(6),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(6)
  );

  ULA_7 : ULA1Bit PORT MAP(
    entradaA => entradaA(7),
    entradaB => entradaB(7),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(6),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(7),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(7)
  );

  ULA_8 : ULA1Bit PORT MAP(
    entradaA => entradaA(8),
    entradaB => entradaB(8),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(7),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(8),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(8)
  );

  ULA_9 : ULA1Bit PORT MAP(
    entradaA => entradaA(9),
    entradaB => entradaB(9),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(8),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(9),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(9)
  );

  ULA_10 : ULA1Bit PORT MAP(
    entradaA => entradaA(10),
    entradaB => entradaB(10),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(9),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(10),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(10)
  );

  ULA_11 : ULA1Bit PORT MAP(
    entradaA => entradaA(11),
    entradaB => entradaB(11),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(10),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(11),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(11)
  );

  ULA_12 : ULA1Bit PORT MAP(
    entradaA => entradaA(12),
    entradaB => entradaB(12),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(11),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(12),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(12)
  );

  ULA_13 : ULA1Bit PORT MAP(
    entradaA => entradaA(13),
    entradaB => entradaB(13),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(12),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(13),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(13)
  );

  ULA_14 : ULA1Bit PORT MAP(
    entradaA => entradaA(14),
    entradaB => entradaB(14),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(13),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(14),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(14)
  );

  ULA_15 : ULA1Bit PORT MAP(
    entradaA => entradaA(15),
    entradaB => entradaB(15),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(14),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(15),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(15)
  );

  ULA_16 : ULA1Bit PORT MAP(
    entradaA => entradaA(16),
    entradaB => entradaB(16),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(15),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(16),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(16)
  );

  ULA_17 : ULA1Bit PORT MAP(
    entradaA => entradaA(17),
    entradaB => entradaB(17),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(16),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(17),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(17)
  );

  ULA_18 : ULA1Bit PORT MAP(
    entradaA => entradaA(18),
    entradaB => entradaB(18),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(17),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(18),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(18)
  );

  ULA_19 : ULA1Bit PORT MAP(
    entradaA => entradaA(19),
    entradaB => entradaB(19),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(18),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(19),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(19)
  );

  ULA_20 : ULA1Bit PORT MAP(
    entradaA => entradaA(20),
    entradaB => entradaB(20),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(19),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(20),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(20)
  );

  ULA_21 : ULA1Bit PORT MAP(
    entradaA => entradaA(21),
    entradaB => entradaB(21),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(20),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(21),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(21)
  );

  ULA_22 : ULA1Bit PORT MAP(
    entradaA => entradaA(22),
    entradaB => entradaB(22),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(21),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(22),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(22)
  );

  ULA_23 : ULA1Bit PORT MAP(
    entradaA => entradaA(23),
    entradaB => entradaB(23),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(22),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(23),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(23)
  );

  ULA_24 : ULA1Bit PORT MAP(
    entradaA => entradaA(24),
    entradaB => entradaB(24),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(23),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(24),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(24)
  );

  ULA_25 : ULA1Bit PORT MAP(
    entradaA => entradaA(25),
    entradaB => entradaB(25),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(24),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(25),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(25)
  );

  ULA_26 : ULA1Bit PORT MAP(
    entradaA => entradaA(26),
    entradaB => entradaB(26),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(25),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(26),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(26)
  );

  ULA_27 : ULA1Bit PORT MAP(
    entradaA => entradaA(27),
    entradaB => entradaB(27),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(26),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(27),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(27)
  );

  ULA_28 : ULA1Bit PORT MAP(
    entradaA => entradaA(28),
    entradaB => entradaB(28),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(27),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(28),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(28)
  );

  ULA_29 : ULA1Bit PORT MAP(
    entradaA => entradaA(29),
    entradaB => entradaB(29),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(28),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(29),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(29)
  );

  ULA_30 : ULA1Bit PORT MAP(
    entradaA => entradaA(30),
    entradaB => entradaB(30),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(29),
    Selecao => Selecao,
    CarryOut => CARRY_VEC(30),
    Overflow => OPEN,
    Resultado => RESULTADO_VEC(30)
  );

  ULA_31 : ULA1Bit PORT MAP(
    entradaA => entradaA(31),
    entradaB => entradaB(31),
    SLT => '0',
    InverteA => InverteA,
    InverteB => InverteB,
    CarryIn => CARRY_VEC(30),
    Selecao => Selecao,
    CarryOut => OPEN,
    Overflow => SLT_SIGNAL,
    Resultado => RESULTADO_VEC(31)
  );

  Zero <= NOT(RESULTADO_VEC(31) OR RESULTADO_VEC(30) OR RESULTADO_VEC(29) OR RESULTADO_VEC(28)
    OR RESULTADO_VEC(27) OR RESULTADO_VEC(26) OR RESULTADO_VEC(25) OR RESULTADO_VEC(24)
    OR RESULTADO_VEC(23) OR RESULTADO_VEC(22) OR RESULTADO_VEC(21) OR RESULTADO_VEC(20)
    OR RESULTADO_VEC(19) OR RESULTADO_VEC(18) OR RESULTADO_VEC(17) OR RESULTADO_VEC(16)
    OR RESULTADO_VEC(15) OR RESULTADO_VEC(14) OR RESULTADO_VEC(13) OR RESULTADO_VEC(12)
    OR RESULTADO_VEC(11) OR RESULTADO_VEC(10) OR RESULTADO_VEC(9) OR RESULTADO_VEC(8)
    OR RESULTADO_VEC(7) OR RESULTADO_VEC(6) OR RESULTADO_VEC(5) OR RESULTADO_VEC(4)
    OR RESULTADO_VEC(3) OR RESULTADO_VEC(2) OR RESULTADO_VEC(1) OR RESULTADO_VEC(0));

  RESULTADO <= RESULTADO_VEC(31 DOWNTO 0);

END ARCHITECTURE;