LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RegisterFile IS
    PORT (
        CLK : IN STD_LOGIC;
        REG_A_SEL : IN STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
        REG_B_SEL : IN STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
        REG_WRITE_SEL : IN STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
        INPUT_DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        WRITE_ENABLE : IN STD_LOGIC := '0';
        OUT_A : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        OUT_B : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')
    );
END ENTITY;

ARCHITECTURE arch OF RegisterFile IS

    TYPE register_file IS ARRAY(31 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

    FUNCTION initMemory
        RETURN register_file IS VARIABLE tmp : register_file := (OTHERS => (OTHERS => '0'));
    BEGIN
        tmp(0) := x"00000000"; -- Nao deve ter efeito.
        tmp(8) := x"00000000"; -- $t0 = 0x00
        tmp(9) := x"00000001"; -- $t1 = 0x0A
        tmp(10) := x"00000002"; -- $t2 = 0x0B
        tmp(11) := x"00000003"; -- $t3 = 0x0C
        tmp(12) := x"00000004"; -- $t4 = 0x0D
        tmp(13) := x"00000005"; -- $t5 = 0x16

        RETURN tmp;
    END initMemory;

    SIGNAL registers : register_file := initMemory;

    CONSTANT ZERO : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PROCESS (CLK) IS
    BEGIN
        -- Falling edge enable read and save on the same clock cycle
        IF (rising_edge(CLK)) THEN
            IF (WRITE_ENABLE = '1') THEN
                registers(to_integer(unsigned(REG_WRITE_SEL))) <= INPUT_DATA; -- Write
            END IF;
        END IF;
    END PROCESS;

    OUT_A <= ZERO WHEN REG_A_SEL = "00000" ELSE
        registers(to_integer(unsigned(REG_A_SEL)));
    OUT_B <= ZERO WHEN REG_B_SEL = "00000" ELSE
        registers(to_integer(unsigned(REG_B_SEL)));
END ARCHITECTURE;