LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RAM IS
    PORT (
        clk : IN STD_LOGIC := '0';
        Endereco : IN STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
        Dado_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        Dado_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        we, re, habilita : IN STD_LOGIC := '0'
    );
END ENTITY;

ARCHITECTURE assincrona OF RAM IS
    TYPE blocoMemoria IS ARRAY(0 TO 63) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

    FUNCTION initMemory
        RETURN blocoMemoria IS VARIABLE tmp : blocoMemoria := (OTHERS => (OTHERS => '0'));
    BEGIN

        tmp(0) := x"00000008";

        RETURN tmp;
    END initMemory;

    SIGNAL memRAM : blocoMemoria := initMemory;
    SIGNAL EnderecoLocal : STD_LOGIC_VECTOR(5 DOWNTO 0);

BEGIN

    -- Ajusta o enderecamento para o acesso de 32 bits.
    EnderecoLocal <= Endereco(7 DOWNTO 2);

    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            IF (we = '1' AND habilita = '1') THEN
                memRAM(to_integer(unsigned(EnderecoLocal))) <= Dado_in;
            END IF;
        END IF;
    END PROCESS;

    -- A leitura deve ser sempre assincrona:
    Dado_out <= memRAM(to_integer(unsigned(EnderecoLocal))) WHEN (re = '1' AND habilita = '1') ELSE
        (OTHERS => 'Z');

END ARCHITECTURE;