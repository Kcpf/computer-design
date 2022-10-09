LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY memoriaROM IS
  GENERIC (
    dataWidth : NATURAL := 4;
    addrWidth : NATURAL := 3
  );
  PORT (
    Endereco : IN STD_LOGIC_VECTOR (addrWidth - 1 DOWNTO 0) := (OTHERS => '0');
    Dado : OUT STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0) := (OTHERS => '0')
  );
END ENTITY;

ARCHITECTURE assincrona OF memoriaROM IS
  CONSTANT NOP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
  CONSTANT LDA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
  CONSTANT SOMA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
  CONSTANT SUB : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
  CONSTANT LDI : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
  CONSTANT STA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
  CONSTANT JMP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
  CONSTANT JEQ : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
  CONSTANT CEQ : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000";
  CONSTANT JSR : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001";
  CONSTANT RET : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010";

  -- 0 	LDI $0 			Carrega o acumulador com o valor 0
  -- 1 	STA @0 			Armazena o valor do acumulador em MEM[0] (constante 0)
  -- 2 	STA @2 			Armazena o valor do acumulador em MEM[2] (contador)
  -- 3 	LDI $1 			Carrega o acumulador com o valor 1
  -- 4 	STA @1 			Armazena o valor do acumulador em MEM[1] (constante 1)
  -- 5 	NOP 			
  -- 6 	LDA @352 			Carrega o acumulador com a leitura do botão KEY0
  -- 7 	STA @288 			Armazena o valor lido em HEX0 (para verificar erros de leitura)
  -- 8 	CEQ @0 			Compara com o valor de MEM[0] (constante 0)
  -- 9 	JEQ @10 			Desvia se igual a 0 (botão não foi pressionado)
  -- 10 	JSR @32 			O botão foi pressionado, chama a sub-rotina de incremento
  -- 11 	NOP 			Retorno da sub-rotina de incremento
  -- 12 	JMP @5 			Fecha o laço principal, faz uma nova leitura de KEY0
  -- … 				
  -- … 				
  -- 32 	STA @511 			Limpa a leitura do botão
  -- 33 	LDA @2 			Carrega o valor de MEM[2] (contador)
  -- 34 	SOMA @1 			Soma com a constante em MEM[1]
  -- 35 	STA @2 			Salva o incremento em MEM[2] (contador)
  -- 36 	STA @258 			Armazena o valor do bit0 do acumulador no LDR9
  -- 37 	RET 			Retorna da sub-rotina

  TYPE blocoMemoria IS ARRAY(0 TO 2 ** addrWidth - 1) OF STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0);

  FUNCTION initMemory
    RETURN blocoMemoria IS VARIABLE tmp : blocoMemoria := (OTHERS => (OTHERS => '0'));
  BEGIN
    tmp(0) := LDI & "0" & x"00";
    tmp(1) := STA & "0" & x"00";
    tmp(2) := STA & "0" & x"02";
    tmp(3) := LDI & "0" & x"01";
    tmp(4) := STA & "0" & x"01";
    tmp(5) := NOP & "0" & x"00";
    tmp(6) := LDA & "1" & x"60";
    tmp(7) := STA & "1" & x"20";
    tmp(8) := CEQ & "0" & x"00";
    tmp(9) := JEQ & "0" & x"0B";
    tmp(10) := JSR & "0" & x"20";
    tmp(11) := NOP & "0" & x"00";
    tmp(12) := JMP & "0" & x"05";

    tmp(32) := STA & "1" & x"FF";
    tmp(33) := LDA & "0" & x"02";
    tmp(34) := SOMA & "0" & x"01";
    tmp(35) := STA & "0" & x"02";
    tmp(36) := STA & "1" & x"02";
    tmp(37) := RET & "0" & x"00";

    RETURN tmp;
  END initMemory;

  SIGNAL memROM : blocoMemoria := initMemory;

BEGIN
  Dado <= memROM (to_integer(unsigned(Endereco)));
END ARCHITECTURE;