LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ROM IS
  GENERIC (
    dataWidth : NATURAL := 4;
    addrWidth : NATURAL := 3
  );
  PORT (
    Endereco : IN STD_LOGIC_VECTOR (addrWidth - 1 DOWNTO 0) := (OTHERS => '0');
    Dado : OUT STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0) := (OTHERS => '0')
  );
END ENTITY;

ARCHITECTURE assincrona OF ROM IS

  TYPE blocoMemoria IS ARRAY(0 TO 2 ** addrWidth - 1) OF STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0);

  FUNCTION initMemory
    RETURN blocoMemoria IS VARIABLE tmp : blocoMemoria := (OTHERS => (OTHERS => '0'));
  BEGIN
    -- SETUP:
    tmp(0) := "00100" & "00" & "000000000"; -- LDI %R0, $0
    tmp(1) := "00101" & "00" & "100000000"; -- STA %R0, @256
    tmp(2) := "00101" & "00" & "100000001"; -- STA %R0, @257
    tmp(3) := "00101" & "00" & "100000010"; -- STA %R0, @258
    tmp(4) := "00101" & "00" & "100100000"; -- STA %R0, @288
    tmp(5) := "00101" & "00" & "100100001"; -- STA %R0, @289
    tmp(6) := "00101" & "00" & "100100010"; -- STA %R0, @290
    tmp(7) := "00101" & "00" & "100100011"; -- STA %R0, @291
    tmp(8) := "00101" & "00" & "100100100"; -- STA %R0, @292
    tmp(9) := "00101" & "00" & "100100101"; -- STA %R0, @293
    tmp(10) := "00101" & "00" & "000000000"; -- STA %R0, @0
    tmp(11) := "00101" & "00" & "000000101"; -- STA %R0, @5
    tmp(12) := "00101" & "00" & "000000110"; -- STA %R0, @6
    tmp(13) := "00101" & "00" & "000000111"; -- STA %R0, @7
    tmp(14) := "00100" & "00" & "000000001"; -- LDI %R0, $1
    tmp(15) := "00101" & "00" & "000000001"; -- STA %R0, @1
    tmp(16) := "00100" & "00" & "000001010"; -- LDI %R0, $10
    tmp(17) := "00101" & "00" & "000000010"; -- STA %R0, @2
    tmp(18) := "00100" & "00" & "000111100"; -- LDI %R0, $60
    tmp(19) := "00101" & "00" & "000000011"; -- STA %R0, @3
    tmp(20) := "00100" & "01" & "000011000"; -- LDI %R1, $24
    tmp(21) := "00101" & "01" & "000000100"; -- STA %R1, @4

    -- LOOP:
    tmp(22) := "00001" & "00" & "101100101"; -- LDA %R0, @357
    tmp(23) := "01000" & "00" & "000000000"; -- CEQ %R0, @0
    tmp(24) := "00100" & "00" & "000000001"; -- LDI %R0, $1
    tmp(25) := "00101" & "00" & "111111010"; -- STA %R0, @506
    tmp(26) := "00111" & "00" & "000011100"; -- JEQ @DISPLAY
    tmp(27) := "01001" & "00" & "000101111"; -- JSR @INCREMENTO

    -- DISPLAY:
    tmp(28) := "00001" & "00" & "000000101"; -- LDA %R0, @5
    tmp(29) := "01111" & "00" & "000000010"; -- MOD %R0, @2
    tmp(30) := "00101" & "00" & "100100000"; -- STA %R0, @288
    tmp(31) := "00001" & "01" & "000000101"; -- LDA %R1, @5
    tmp(32) := "10000" & "01" & "000000010"; -- DIV %R1, @2
    tmp(33) := "00101" & "01" & "100100001"; -- STA %R1, @289
    tmp(34) := "00001" & "00" & "000000110"; -- LDA %R0, @6
    tmp(35) := "01111" & "00" & "000000010"; -- MOD %R0, @2
    tmp(36) := "00101" & "00" & "100100010"; -- STA %R0, @290
    tmp(37) := "00001" & "01" & "000000110"; -- LDA %R1, @6
    tmp(38) := "10000" & "01" & "000000010"; -- DIV %R1, @2
    tmp(39) := "00101" & "01" & "100100011"; -- STA %R1, @291
    tmp(40) := "00001" & "00" & "000000111"; -- LDA %R0, @7
    tmp(41) := "01111" & "00" & "000000010"; -- MOD %R0, @2
    tmp(42) := "00101" & "00" & "100100100"; -- STA %R0, @292
    tmp(43) := "00001" & "01" & "000000111"; -- LDA %R1, @7
    tmp(44) := "10000" & "01" & "000000010"; -- DIV %R1, @2
    tmp(45) := "00101" & "01" & "100100101"; -- STA %R1, @293
    tmp(46) := "00110" & "00" & "000010110"; -- JMP @LOOP

    -- INCREMENTO:
    tmp(47) := "00001" & "00" & "000000101"; -- LDA %R0, @5
    tmp(48) := "00010" & "00" & "000000001"; -- SOMA %R0, @1
    tmp(49) := "01000" & "00" & "000000011"; -- CEQ %R0, @3
    tmp(50) := "00111" & "00" & "000110101"; -- JEQ @INCREMENTA_MINUTO
    tmp(51) := "00101" & "00" & "000000101"; -- STA %R0, @5
    tmp(52) := "01010" & "00" & "000000000"; -- RET

    -- INCREMENTA_MINUTO:
    tmp(53) := "00100" & "00" & "000000000"; -- LDI %R0, $0
    tmp(54) := "00101" & "00" & "000000101"; -- STA %R0, @5
    tmp(55) := "00001" & "00" & "000000110"; -- LDA %R0, @6
    tmp(56) := "00010" & "00" & "000000001"; -- SOMA %R0, @1
    tmp(57) := "01000" & "00" & "000000011"; -- CEQ %R0, @3
    tmp(58) := "00111" & "00" & "000111101"; -- JEQ @INCREMENTA_HORA
    tmp(59) := "00101" & "00" & "000000110"; -- STA %R0, @6
    tmp(60) := "01010" & "00" & "000000000"; -- RET

    -- INCREMENTA_HORA:
    tmp(61) := "00100" & "00" & "000000000"; -- LDI %R0, $0
    tmp(62) := "00101" & "00" & "000000110"; -- STA %R0, @6
    tmp(63) := "00001" & "00" & "000000111"; -- LDA %R0, @7
    tmp(64) := "00010" & "00" & "000000001"; -- SOMA %R0, @1
    tmp(65) := "01000" & "00" & "000000100"; -- CEQ %R0, @4
    tmp(66) := "00111" & "00" & "001000101"; -- JEQ @INCREMENTO_OVERFLOW
    tmp(67) := "00101" & "00" & "000000111"; -- STA %R0, @7
    tmp(68) := "01010" & "00" & "000000000"; -- RET

    -- INCREMENTO_OVERFLOW:
    tmp(69) := "00100" & "00" & "000000000"; -- LDI %R0, $0
    tmp(70) := "00101" & "00" & "000000101"; -- STA %R0, @5
    tmp(71) := "00101" & "00" & "000000110"; -- STA %R0, @6
    tmp(72) := "00101" & "00" & "000000111"; -- STA %R0, @7
    tmp(73) := "01010" & "00" & "000000000"; -- RET

    RETURN tmp;
  END initMemory;

  SIGNAL memROM : blocoMemoria := initMemory;

BEGIN
  Dado <= memROM (to_integer(unsigned(Endereco)));
END ARCHITECTURE;