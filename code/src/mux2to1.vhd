library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
  generic (
    N : positive := 32
  );
  port (
    D0  : in  std_logic_vector(N-1 downto 0);
    D1  : in  std_logic_vector(N-1 downto 0);
    SEL : in  std_logic;
    Y   : out std_logic_vector(N-1 downto 0)
  );
end entity mux2to1;

architecture Behavioral of mux2to1 is
begin
  Y <= D0 when SEL = '0' else D1;
end Behavioral;
