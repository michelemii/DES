
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    
entity ShiftRegisterSIPO is
    Generic(
        SR_WIDTH : integer := 4
    );
    Port ( 
        reset : in std_logic;
        clk : in std_logic;
        
        data_in : in std_logic;
        data_out : out std_logic_vector(SR_WIDTH-1 DOWNTO 0)
    ); 
end ShiftRegisterSIPO;

architecture Behavioral of ShiftRegisterSIPO is
    signal data_out_internal : std_logic_vector(data_out'RANGE) := (Others => '0');
begin
    process (clk, reset)
    begin
        if reset = '1' then
            data_out_internal <= (Others => '0');
        elsif rising_edge(clk) then
            data_out_internal <= data_in & data_out_internal(data_out_internal'LEFT DOWNTO 1);
        end if;
    end process;
    
    data_out <= data_out_internal;

end Behavioral;
