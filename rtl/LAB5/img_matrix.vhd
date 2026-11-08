
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity img_matrix is
    Generic (
        IMG_DIM_POW2 : integer := 2
    );
    Port (
        clk : in std_logic;
        reset : in std_logic;
        
        in_red : in std_logic_vector(7 DOWNTO 0);
        in_green : in std_logic_vector(7 DOWNTO 0);
        in_blue : in std_logic_vector(7 DOWNTO 0);
        in_x_addr : in std_logic_vector(IMG_DIM_POW2-1 DOWNTO 0);
        in_y_addr : in std_logic_vector(IMG_DIM_POW2-1 DOWNTO 0);
        
        out_gray : out std_logic_vector(7 DOWNTO 0);
        out_x_addr : in std_logic_vector(IMG_DIM_POW2-1 DOWNTO 0);
        out_y_addr : in std_logic_vector(IMG_DIM_POW2-1 DOWNTO 0)
    );
end img_matrix;

architecture Behavioral of img_matrix is
    component my_register is
        Generic (
            N : integer := 8
        );
        Port(
            reset : in std_logic;
            clk : in std_logic;
            d : in std_logic_vector(N-1 DOWNTO 0);
            q : out std_logic_vector(N-1 DOWNTO 0)
        );
    end component;
    
    constant IMG_DIM : integer := 2**IMG_DIM_POW2;
    type img_array_t is array (0 TO IMG_DIM-1, 0 TO IMG_DIM-1) of std_logic_vector(7 DOWNTO 0);
    
    signal reg_d : img_array_t; -- input D of the 16 register
    signal reg_q : img_array_t; -- output Q of the 16 register
    
    signal gray : std_logic_vector(7 DOWNTO 0);
    signal out_reg_d : std_logic_vector(7 DOWNTO 0);
    
begin
    gray <= std_logic_vector(resize( 
                            ( resize(unsigned(in_red), 10) 
                            + resize(unsigned(in_green), 10) 
                            + resize(unsigned(in_blue), 10) ) / 3, 8));
                            
    X_GEN : for X in 0 TO IMG_DIM-1 generate
        Y_GEN : for Y in 0 TO IMG_DIM-1 generate
            reg_d(X, Y) <= gray when (to_integer(unsigned(in_x_addr)) = X and
                                      to_integer(unsigned(in_y_addr)) = Y) else
                                      reg_q(X, Y);
            reg_inst : my_register
                Generic Map(
                    N => 8
                )
                Port Map(
                    clk => clk,
                    reset => reset,
                    d => reg_d(X, Y),
                    q => reg_q(X, Y)
                );
        end generate Y_GEN;
    end generate X_GEN;
    
    out_reg_d <= reg_q(to_integer(unsigned(out_x_addr)), to_integer(unsigned(out_y_addr)));
    
    out_reg_inst : my_register
        Generic Map(
            N => 8
        )
        Port Map(
            clk => clk,
            reset => reset,
            d => out_reg_d,
            q => out_gray
        );
        
end Behavioral;