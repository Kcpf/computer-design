LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; --Soma (esta biblioteca =ieee)

ENTITY AddConstant IS
    GENERIC (
        constante : NATURAL := 4
    );
    PORT (
        entrada : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        saida : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE comportamento OF AddConstant IS
BEGIN
    saida <= STD_LOGIC_VECTOR(unsigned(entrada) + constante);
END ARCHITECTURE;