
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftRegisterSIPO is 
    Generic(
        SR_WIDTH : integer := 4
    );
    Port(
        reset : in std_logic;
        clk : in std_logic;
        
        data_in : in std_logic;
        data_out : out std_logic_vector(SR_WIDTH-1 DOWNTO 0)
     );
end ShiftRegisterSIPO;

architecture Behavioral of ShiftRegisterSIPO is
    component ff_d is
        Port (
          reset	: in std_logic;
		  clk : in std_logic;
		  d : in std_logic;
		  q : out std_logic
        );
    end component;
    
begin

    ff_d_inst_first : ff_d
        Port Map(
             clk =>  clk,
             reset => reset,
             d => data_in,
             q => data_out(SR_WIDTH-1)
        );
    
    GEN_LOOP : for I in SR_WIDTH-1 DOWNTO 1 generate
       ff_d_inst : ff_d
        Port Map(
             clk =>  clk,
             reset => reset,
             d => data_out(I),
             q => data_out(I-1)
        );
    end generate GEN_LOOP;
	
end Behavioral;
