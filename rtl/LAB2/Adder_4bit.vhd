
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;

entity Adder_4bit is
    Port ( 
    -- All ports are encoded as unsigned
    a : in std_logic_vector(3 DOWNTO 0);
    b : in std_logic_vector(3 DOWNTO 0);
    
    sum : out std_logic_vector(3 DOWNTO 0);
    overflow : out std_logic
    );
end Adder_4bit;

architecture Behavioral of Adder_4bit is
    component FullAdder is
        Port(
            a : in std_logic;
            b : in std_logic;
            cin : in std_logic;
    
            s : out std_logic;
            cout : out std_logic
        );
    end component;
    
    component HalfAdder is
        Port ( 
            a : in std_logic;
            b : in std_logic;
    
            s : out std_logic;
            cout : out std_logic
        );
     end component;
     
     signal cout1, cout2, cout3 : std_logic;
begin
    HalfAdder_inst1 : HalfAdder
        Port Map(
             a =>  a(0),
             b => b(0),
             s => sum(0),
             cout => cout1
        );

    FullAdder_inst1 : FullAdder
        Port Map(
             a =>  a(1),
             b => b(1),
             cin => cout1,
             s => sum(1),
             cout => cout2
        );
        
    FullAdder_inst2 : FullAdder
        Port Map(
             a =>  a(2),
             b => b(2),
             cin => cout2,
             s => sum(2),
             cout => cout3
        );
     
    FullAdder_inst3 : FullAdder
        Port Map(
             a =>  a(3),
             b => b(3),
             cin => cout3,
             s => sum(3),
             cout => overflow
        );
end Behavioral;
