library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile is
  generic (
    N : positive := 5;
    M : positive := 32
  );
  port (
    CLK      : in  std_logic;
    WE3      : in  std_logic;
    A1       : in  std_logic_vector(N-1 downto 0);
    A2       : in  std_logic_vector(N-1 downto 0);
    A3       : in  std_logic_vector(N-1 downto 0);
    WD3      : in  std_logic_vector(M-1 downto 0);
    RD1      : out std_logic_vector(M-1 downto 0);
    RD2      : out std_logic_vector(M-1 downto 0)
  );
end entity regfile;

architecture Behavioral of regfile is
  type reg_array_t is array (0 to 2**N - 1) of std_logic_vector(M-1 downto 0);
  signal regs : reg_array_t := (others => (others => '0'));
begin

  process(CLK)
  begin
    if rising_edge(CLK) then
      if WE3 = '1' and unsigned(A3) /= 0 then
        regs(to_integer(unsigned(A3))) <= WD3;
      end if;
    end if;
  end process;

  RD1 <= (others => '0') when unsigned(A1) = 0 else regs(to_integer(unsigned(A1)));
  RD2 <= (others => '0') when unsigned(A2) = 0 else regs(to_integer(unsigned(A2)));

end Behavioral;
