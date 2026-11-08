
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity my_register is
    Generic (
        N : integer := 8
    );
    Port ( 
        clk : in std_logic;
        reset : in std_logic;
        
        d : in std_logic_vector(N-1 DOWNTO 0);
        q : out std_logic_vector(N-1 DOWNTO 0)
    );
end my_register;

architecture Behavioral of my_register is
    component ff_d is
        Port(
            reset : in std_logic;
            clk : in std_logic;
        
            d : in std_logic;
            q : out std_logic
        );
    end component;
begin
    FF_GEN : for I in 0 TO N-1 generate
        ff_inst : ff_d
            Port Map(
                reset => reset,
                clk => clk,
                d => d(I),
                q => q(I)
            );
    end generate FF_GEN;

end Behavioral;
