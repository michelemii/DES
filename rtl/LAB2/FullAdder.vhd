
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FullAdder is
    Port ( 
    a : in std_logic;
    b : in std_logic;
    cin : in std_logic;
    
    s : out std_logic;
    cout : out std_logic
    );
end FullAdder;

architecture Behavioral of FullAdder is

    component HalfAdder is
        Port ( 
            a : in std_logic;
            b : in std_logic;
    
            s : out std_logic;
            cout : out std_logic
        );
     end component;
     
     signal cout1, cout2, s1 : std_logic;
begin

    HalfAdder_inst1 : HalfAdder
        Port Map(
            a => a,
            b => b,
            s => s1,
            cout => cout1
        );
    
    HalfAdder_inst2 : HalfAdder
        Port Map(
            a => s1,
            b => cin,
            s => s,
            cout => cout2
        );
        
    cout <= cout1 or cout2;
    
end Behavioral;
