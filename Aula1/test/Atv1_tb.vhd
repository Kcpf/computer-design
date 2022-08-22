library ieee;
use ieee.std_logic_1164.all;

entity Atv1_tb is
end Atv1_tb;

architecture test of Atv1_tb is
    component Atv1
    generic ( 
        larguraDados : natural;
        simulacao : boolean -- para gravar na placa, altere de TRUE para FALSE
    );
    port   (
        CLOCK_50 : in std_logic;
        KEY: in std_logic_vector(3 downto 0);
        SW: in std_logic_vector(9 downto 0);
        LEDR  : out std_logic_vector(9 downto 0)
    );
    end component;

    signal clock : std_logic := '0';
    signal key : std_logic_vector(3 downto 0);
    signal sw : std_logic_vector(9 downto 0);
    signal ledr : std_logic_vector(9 downto 0);

    constant PERIODO: time := 10 ns;

begin 

    at: Atv1 generic map (larguraDados => 4, simulacao => TRUE)
    port map (
        CLOCK_50 => clock,
        KEY => key,
        SW => sw,
        LEDR => ledr
    );

    clock <= not clock after PERIODO / 2;

    main : process begin

        key <= "0010"; 
        sw <= "0000000000";
        wait for PERIODO;

		key <= "0100"; 
        sw <= "0100110000";
        wait for PERIODO;

        key <= "0100"; 
        sw <= "0100110000";
        wait for PERIODO;

        key <= "0100"; 
        sw <= "0100110000";
        wait for PERIODO;

        key <= "0100"; 
        sw <= "0100100000";
        wait for PERIODO;

        wait;

    end process;

end test;
