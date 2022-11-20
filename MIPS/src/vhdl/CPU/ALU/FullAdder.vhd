LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; -- Biblioteca IEEE para funções aritméticas

ENTITY FullAdder IS
  PORT (
    entradaA : IN STD_LOGIC := '0';
    entradaB : IN STD_LOGIC := '0';
    CarryIn : IN STD_LOGIC := '0';
    Soma : OUT STD_LOGIC := '0';
    CarryOut : OUT STD_LOGIC := '0'
  );
END ENTITY;

ARCHITECTURE arch OF FullAdder IS
BEGIN
  Soma <= (entradaA XOR entradaB) XOR CarryIn;
  CarryOut <= (entradaA AND entradaB) OR ((entradaA XOR entradaB) AND CarryIn);
END ARCHITECTURE;