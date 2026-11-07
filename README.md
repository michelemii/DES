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
### Generate statement
if
```
NULL_GEN : if NULL_VALUE = true generate
  c <= (Others => '0');
end generate;

NO_NULL_GEN : if NULL_VALUE = false generate
  c <= a;
end generate;
```
for
```
LOOP_GEN_1 : for I in 0 TO 3 generate
  c(I) <= a(0);
end generate;

LOOP_GEN_2 : for I in 4 TO 7 generate
  c(I) <= a(1);
end generate;
```

### Custom types
Declared in the architecture before `begin`.
```
subtype byte_type is std_logic_vector(7 DOWNTO 0);	-- subtype: still compatible with the base type
subtype short is integer range 0 TO 255;
 
type state_type is (IDLE, WAITING, WORKING, DONE);	-- enum: synthesizer picks the encoding (FSM)
 
type op_type is record
    opcode : std_logic_vector(3 DOWNTO 0);
    op1    : unsigned(7 DOWNTO 0);
end record;
 
signal b  : byte_type;
signal v  : std_logic_vector(7 DOWNTO 0);
signal st : state_type := IDLE;
signal op : op_type;
 
v <= b;				-- legal, same base type
op.opcode <= "0001";		-- record field access
```

### Arrays
```
-- nested 1D: array of vectors (small memory). NOT a 2D array
type mem_type is array (0 TO 15) of std_logic_vector(7 DOWNTO 0);
signal mem : mem_type := (Others => (Others => '0'));
 
mem(0)(0) <= '1';		-- single bit
mem(1)    <= "01010101";	-- whole word
 
-- 2D: two indexes, accessed with (i, j)
type img_type is array (0 TO 15, 0 TO 15) of unsigned(7 DOWNTO 0);
signal img : img_type := (Others => (Others => (Others => '0')));
 
img(0, 0) <= to_unsigned(100, 8);
 
-- unconstrained: size given when the signal is declared
type vec_array is array (natural range <>) of std_logic_vector(7 DOWNTO 0);
signal regs : vec_array(0 TO 3);
```

### Unconstrained ports
Width is inherited from the signal connected at instantiation. Inside, use attributes, never fixed widths.<br>
The top level entity must have constrained ports for synthesis.
```
entity rev is
    Port (
        data_in  : in  std_logic_vector;
        data_out : out std_logic_vector
    );
end rev;
 
architecture Behavioral of rev is
begin
    process(all)
    begin
        for I in data_in'RANGE loop
            data_out(data_out'LOW + (data_in'HIGH - I)) <= data_in(I);	-- bit reverse, any width
        end loop;
    end process;
end Behavioral;
 
rev_inst : entity work.rev
    Port Map (
        data_in  => x8,		-- std_logic_vector(7 DOWNTO 0)
        data_out => y8
    );
```
 
### Custom types in ports
A type declared in the architecture is not visible in the entity: put it in a package.
```
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
package my_types_pkg is
    type mem_type is array (0 TO 15) of std_logic_vector(7 DOWNTO 0);
end package;
 
-- in the entity file
use work.my_types_pkg.all;
```

### Process
* The process is a concurrent statement, its content is sequential. In hardware nothing runs line by line: the synthesizer infers a circuit.
* No sensitivity list and no `wait`: infinite loop, the simulator hangs.
* Sensitivity list OR `wait`, never both in the same process.
* Synthesis: sensitivity list. Testbench: `wait`.
* Sensitivity list = every signal read (right side of assignments and `if`/`case` conditions). A missing signal changes the simulation only: synthesis ignores the list. VHDL 2008: `process(all)`.
* Clocked process: only `clk` (plus `reset` if asynchronous).
* `wait for` is not synthesizable.
* Inside a process you can declare variables, never signals.
### Wait
```
wait for 10 ns;			-- time delay
wait until clk = '1';		-- boolean condition
wait on sig1, sig2;		-- any event on sig1 or sig2
wait;				-- stop forever (without it the process restarts)
```
 
### Signal vs Variable
Signal: updated only when the process suspends (`wait` or end of process). Last assignment wins.<br>
Variable: updated immediately, assigned with `:=`, visible only inside its process.
```
signal a : integer := 0;
 
process
    variable v : integer := 0;
begin
    a <= 2;
    wait for 10 ns;		-- a = 2
    a <= 5;
    a <= a * 5;			-- uses the old a (2), overrides a <= 5
    wait for 10 ns;		-- a = 10
    v := 5;
    v := v * 5;			-- v = 25 immediately
    a <= v;
    wait for 10 ns;		-- a = 25
    wait;
end process;
```
 
### Standard templates
Async reset
```
process (clk, reset)
begin
    if reset = '1' then
        q <= '0';
    elsif rising_edge(clk) then
        q <= d;
    end if;
end process;
```
Sync reset
```
process (clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            q <= '0';
        else
            q <= d;
        end if;
    end if;
end process;
```
Combinational: default value first, otherwise a latch is inferred
```
process (all)
begin
    y <= '0';
    if sel = '1' then
        y <= d;
    end if;
end process;
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
    
    c <= ('0' & a) + ('0' & b);		-- padding
    -- c <= (a(7) & a) + (b(7) & b);		-- padding (sign extension)
    
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
                   "0001" when "11",
                   "0000" when Others;

with a select b <= "1000" when "00",
                   "0100" when "01",
                   "0000" when Others;
```
