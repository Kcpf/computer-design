LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY PCRegister IS
    PORT (
        DIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        ENABLE : IN STD_LOGIC := '0';
        CLK, RST : IN STD_LOGIC := '0';
        DOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')
    );
END ENTITY;

ARCHITECTURE arch OF PCRegister IS
BEGIN
    PROCESS (RST, CLK)
    BEGIN
        IF (RST = '1') THEN
            DOUT <= (OTHERS => '0');
        ELSE
            IF (rising_edge(CLK)) THEN
                IF (ENABLE = '1') THEN
                    DOUT <= DIN;
                END IF;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;