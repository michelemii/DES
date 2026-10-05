library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Adder_4bit_tb is
end Adder_4bit_tb;

architecture Behavioral of Adder_4bit_tb is

    component Adder_4bit is
        Port (
            a        : in  std_logic_vector(3 downto 0);
            b        : in  std_logic_vector(3 downto 0);
            sum      : out std_logic_vector(3 downto 0);
            overflow : out std_logic
        );
    end component;

    signal a        : std_logic_vector(3 downto 0) := (others => '0');
    signal b        : std_logic_vector(3 downto 0) := (others => '0');
    signal sum      : std_logic_vector(3 downto 0);
    signal overflow : std_logic;

begin

    uut : Adder_4bit
        Port Map (
            a        => a,
            b        => b,
            sum      => sum,
            overflow => overflow
        );

    stim : process
        variable expected : unsigned(4 downto 0);
        variable errors   : integer := 0;
    begin
        for i in 0 to 15 loop
            for j in 0 to 15 loop
                a <= std_logic_vector(to_unsigned(i, 4));
                b <= std_logic_vector(to_unsigned(j, 4));
                wait for 10 ns;

                expected := to_unsigned(i + j, 5);

                if (overflow & sum) /= std_logic_vector(expected) then
                    errors := errors + 1;
                    report "Mismatch for " & integer'image(i) & " + " & integer'image(j)
                        severity error;
                end if;
            end loop;
        end loop;

        if errors = 0 then
            report "All 256 combinations passed" severity note;
        else
            report "Test failed with " & integer'image(errors) & " mismatches" severity failure;
        end if;

        wait;
    end process;

end Behavioral;
