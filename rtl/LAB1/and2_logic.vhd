
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;

entity and2_logic is
    Port ( 
        a : in std_logic;
        b : in std_logic;
        c : out std_logic
    );
end and2_logic;

architecture Behavioral of and2_logic is
begin

    c <= a and b;
    
end Behavioral;
