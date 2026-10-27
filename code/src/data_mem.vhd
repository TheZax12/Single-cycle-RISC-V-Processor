library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem is
  generic (
    N : positive := 5;
    M : positive := 32
  );
  port (
    CLK : in  std_logic;
    WE  : in  std_logic;
    A   : in  std_logic_vector(N-1 downto 0);
    WD  : in  std_logic_vector(M-1 downto 0);
    RD  : out std_logic_vector(M-1 downto 0)
  );
end entity data_mem;

architecture Behavioral of data_mem is
  type ram_array_t is array (0 to 2**N - 1) of std_logic_vector(M-1 downto 0);
  signal RAM : ram_array_t := (others => (others => '0'));
begin

  process(CLK)
  begin
    if rising_edge(CLK) then
      if WE = '1' then
        RAM(to_integer(unsigned(A))) <= WD;
      end if;
    end if;
  end process;

  RD <= RAM(to_integer(unsigned(A)));

end Behavioral;
