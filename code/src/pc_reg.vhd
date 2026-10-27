library ieee;
use ieee.std_logic_1164.all;

entity pc_reg is
  generic (
    N : positive := 32
  );
  port (
    CLK   : in  std_logic;
    RESET : in  std_logic;
    D     : in  std_logic_vector(N-1 downto 0);
    Q     : out std_logic_vector(N-1 downto 0)
  );
end entity pc_reg;

architecture Behavioral of pc_reg is
begin
  process(CLK, RESET)
  begin
    if RESET = '1' then
      Q <= (others => '0');
    elsif rising_edge(CLK) then
      Q <= D;
    end if;
    
  end process;
  
end Behavioral;
