
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;

entity and4_logic is
    Port ( 
        a0 : in std_logic;
        a1 : in std_logic;
        a2 : in std_logic;
        a3 : in std_logic;
        b : out std_logic
    );
end and4_logic;

architecture Behavioral of and4_logic is

    component and2_logic is
        Port ( 
            a : in std_logic;
            b : in std_logic;
            c : out std_logic
        );
    end component;
    
    signal n1, n2 : std_logic;
    
begin

    and2_logic_inst1 : and2_logic
        Port Map( 
            a => a0,
            b => a1,
            c => n1
        );

    and2_logic_inst2 : and2_logic
        Port Map( 
            a => a2,
            b => a3,
            c => n2
        );
        
    and2_logic_inst3 : and2_logic
        Port Map( 
            a => n1,
            b => n2,
            c => b
        );
        
end Behavioral;
