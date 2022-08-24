LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY memoria IS
    GENERIC (
        dataWidth : NATURAL := 8;
        addrWidth : NATURAL := 10
    );
    PORT (
        -- O fato da interface ser do tipo std_logic auxilía na simulação.
        Endereco : IN STD_LOGIC_VECTOR (addrWidth - 1 DOWNTO 0);
        Dado : OUT STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE assincrona OF memoria IS

    TYPE blocoMemoria IS ARRAY(0 TO 2 ** addrWidth - 1) OF STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0);

    FUNCTION initMemory
        -- Inicializa todas as posições da memória com zero:
        RETURN blocoMemoria IS VARIABLE tmp : blocoMemoria := (OTHERS => (OTHERS => '0'));
    BEGIN
        -- Inicializa os endereços desejados. Os demais endereços conterão o valor zero:
        tmp(0) := x"46";
        tmp(1) := x"45";
        tmp(2) := x"52";
        tmp(3) := x"4e";
        tmp(4) := x"41";
        tmp(5) := x"4e";
        tmp(6) := x"44";
        tmp(7) := x"4f";
        RETURN tmp;
    END initMemory;

    SIGNAL memROM : blocoMemoria := initMemory;

BEGIN
    -- A conversão de tipos para obter o índice do vetor que será acessado:
    Dado <= memROM (to_integer(unsigned(Endereco)));
END ARCHITECTURE;