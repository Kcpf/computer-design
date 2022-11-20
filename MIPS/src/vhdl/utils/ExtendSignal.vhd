LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ExtendSignal IS
    PORT (
        -- Input ports
        estendeSinal_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        -- Output ports
        estendeSinal_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch OF ExtendSignal IS
BEGIN

    estendeSinal_OUT <= (31 DOWNTO 16 => estendeSinal_IN(15)) & estendeSinal_IN;

END ARCHITECTURE;