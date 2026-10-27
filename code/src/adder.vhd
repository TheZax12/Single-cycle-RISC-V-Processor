library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
  generic (
    N : positive := 32
  );
  port (
    A : in  std_logic_vector(N-1 downto 0);
    B : in  std_logic_vector(N-1 downto 0);
    Y : out std_logic_vector(N-1 downto 0)
  );
end entity adder;

architecture Behavioral of adder is
begin
  Y <= std_logic_vector(unsigned(A) + unsigned(B));
end Behavioral;
