# Digital Electronic Systems

Collection of VHDL programs from the Polytechnic of Milan course Digital Electronic Systems.

Software used: Xilinx Vivado 2021.2

# notes

### Attribute  
```
signal vect : std_logic_vector(7 DOWNTO 0);

vect'LEFT		-- 7
vect'RIGHT		-- 0
vect'HIGH		-- 7
vect'LOW		-- 0
vect'LENGHT		-- 8
vect'RANGE		-- (7 DOWNTO 0)
vect'REVERSE_RANGE	-- (0 to 7)
```
### Aggregate
```
signal vect1 : std_logic_vector(7 DOWNTO 0);
signal vect2 : std_logic_vector(7 DOWNTO 0);

vect1 <= (7 => '0', 6 => vect2(3), 3|4|2 => '1', Others => '0')
vect1 <= (vect2(3 DOWNTO 0), vect2(7 DOWNTO 4)
vect1 <= (Others => '0')
vect1 <= (7 DOWNTO 4 => '0', 3 DOWNTO 0 => '1')
```


<br> <br>

## Example
  
### Bit padding
```
entity sum is
    Port ( 
        a : in signed(7 DOWNTO 0);
        b : in signed(7 DOWNTO 0);
    
        c : out signed(8 DOWNTO 0)
    );
end sum;

architecture Behavioral of sum is
begin
    
    c <= (0 & a) + (0 & b);		-- padding
    -- c <= (a(7) & a) + (b(7) & b);		-- better padding
    
end Behavioral;
```

### When / Else
```
signal a : std_logic_vector(1 DOWNTO 0);
signal b : std_logic_vector(3 DOWNTO 0);

b <= "1000" when a = "00" else
     "0100" when a = "01" else
     "0010" when a = "10" else
     "0001" when a = "11";

b <= "1000" when a = "00" else
     "0100" when a = "01" else "0000";
```



### With / Select
```
signal a : std_logic_vector(1 DOWNTO 0);
signal b : std_logic_vector(3 DOWNTO 0);

with a select b <= "1000" when "00",
                   "0100" when "01",
                   "0010" when "10",
                   "0001" when "11";

with a select b <= "1000" when "00",
                   "0100" when "01"
                   "0000" when Others;
```
