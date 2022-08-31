LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY memoriaROM IS
  GENERIC (
    dataWidth : NATURAL := 4;
    addrWidth : NATURAL := 3
  );
  PORT (
    Endereco : IN STD_LOGIC_VECTOR (addrWidth - 1 DOWNTO 0);
    Dado : OUT STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE assincrona OF memoriaROM IS

  CONSTANT NOP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
  CONSTANT LDA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
  CONSTANT SOMA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
  CONSTANT SUB : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
  CONSTANT CLRA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111";

  TYPE blocoMemoria IS ARRAY(0 TO 2 ** addrWidth - 1) OF STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0);

  FUNCTION initMemory
    RETURN blocoMemoria IS VARIABLE tmp : blocoMemoria := (OTHERS => (OTHERS => '0'));
  BEGIN
    -- Palavra de Controle = SelMUX, Habilita_A, Reset_A, Operacao_ULA
    -- Inicializa os endereços:
    tmp(0) := CLRA; -- Desta posicao para baixo, é necessário acertar os valores
    tmp(1) := SOMA;
    tmp(2) := SOMA;
    tmp(3) := SOMA;
    tmp(4) := SUB;
    tmp(5) := NOP;
    tmp(6) := NOP;
    tmp(7) := NOP;
    RETURN tmp;
  END initMemory;

  SIGNAL memROM : blocoMemoria := initMemory;

BEGIN
  Dado <= memROM (to_integer(unsigned(Endereco)));
END ARCHITECTURE;