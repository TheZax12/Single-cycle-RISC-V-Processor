library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_mem is
  generic (
    N : positive := 6;
    M : positive := 32
  );
  port (
    A  : in  std_logic_vector(N-1 downto 0);
    RD : out std_logic_vector(M-1 downto 0)
  );
end entity instr_mem;

architecture Behavioral of instr_mem is

  type rom_array_t is array (0 to 2**N - 1) of std_logic_vector(M-1 downto 0);

  constant ROM_CONTENT : rom_array_t := (
    0 => X"00500093",   -- addi x1, x0, 5            -> x1 = 5
    1 => X"00300113",   -- addi x2, x0, 3            -> x2 = 3
    2 => X"002081B3",   -- add  x3, x1, x2           -> x3 = 8
    3 => X"40208233",   -- sub  x4, x1, x2           -> x4 = 2
    4 => X"0020E2B3",   -- or   x5, x1, x2           -> x5 = 7
    5 => X"0020C333",   -- xor  x6, x1, x2           -> x6 = 6
    6 => X"0010F393",   -- andi x7, x1, 1            -> x7 = 1
    7 => X"0020E413",   -- ori  x8, x1, 2            -> x8 = 7
    8 => X"0030C493",   -- xori x9, x1, 3            -> x9 = 6
    9 => X"00112533",   -- slt  x10, x2, x1          -> x10 = 1 (3 < 5)
   10 => X"0020B5B3",   -- sltu x11, x1, x2          -> x11 = 0 (5 < 3? no)
   11 => X"00302023",   -- sw   x3, 0(x0)            -> MEM[0]  = 8
   12 => X"00002603",   -- lw   x12, 0(x0)           -> x12 = 8
   13 => X"00108463",   -- beq  x1, x1, +8 (L1)      -> taken (5=5)
   14 => X"3E700693",   -- addi x13, x0, 999         -> skipped
   15 => X"06F00713",   -- L1: addi x14, x0, 111     -> x14 = 111
   16 => X"00209463",   -- bne  x1, x2, +8 (L2)      -> taken (5!=3)
   17 => X"37800793",   -- addi x15, x0, 888         -> skipped
   18 => X"0DE00813",   -- L2: addi x16, x0, 222     -> x16 = 222
   19 => X"00208463",   -- beq  x1, x2, +8 (L3)      -> NOT taken (5!=3)
   20 => X"14D00893",   -- addi x17, x0, 333         -> x17 = 333
   21 => X"00E02223",   -- L3: sw x14, 4(x0)         -> MEM[4] = 111
   22 => X"00402903",   -- lw   x18, 4(x0)           -> x18 = 111
   23 => X"FFB00993",   -- addi x19, x0, -5          -> x19 = -5
   24 => X"01398A33",   -- add  x20, x19, x19        -> x20 = -10
   25 => X"40100AB3",   -- sub  x21, x0, x1          -> x21 = -5 (0-5)
   26 => X"0019AB33",   -- slt  x22, x19, x1         -> x22 = 1  (-5 < 5 signed)
   27 => X"0019BBB3",   -- sltu x23, x19, x1         -> x23 = 0  (-5 as unsigned > 5)
   28 => X"F80008E3",   -- beq  x0, x0, -112 (START) -> loop back to the start
   others => X"00000000"
  );

begin
  RD <= ROM_CONTENT(to_integer(unsigned(A)));
end Behavioral;