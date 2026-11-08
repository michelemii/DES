
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UpDownSyncCounter is
    Generic(
        COUNT_WIDTH : integer := 4
    );
    Port ( 
        reset : in std_logic;
        clk : in std_logic;
        inc_count : in std_logic;
        dec_count : in std_logic;
        
        count : out std_logic_vector(COUNT_WIDTH-1 DOWNTO 0) -- Signed
    );
end UpDownSyncCounter;

architecture Behavioral of UpDownSyncCounter is
    component ff_d is
        Port (
          reset	: in std_logic;
		  clk : in std_logic;
		  d : in std_logic;
		  q : out std_logic
        );
    end component;
    
    signal count_reg  : std_logic_vector(COUNT_WIDTH-1 downto 0);
    signal count_next : std_logic_vector(COUNT_WIDTH-1 downto 0);
    
begin

    count_next <= std_logic_vector(signed(count_reg) + 1) when (inc_count = '1' and dec_count = '0') else
                  std_logic_vector(signed(count_reg) - 1) when (inc_count = '0' and dec_count = '1') else
                  count_reg;
    
    GEN_FF : for I in 0 to COUNT_WIDTH-1 generate
        ff_d_inst : ff_d
            Port Map (
                reset => reset,
                clk   => clk,
                d     => count_next(I),
                q     => count_reg(I)
            );
    end generate GEN_FF;
    
    count <= count_reg;

end Behavioral;
