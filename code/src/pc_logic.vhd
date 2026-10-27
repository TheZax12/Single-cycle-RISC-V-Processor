library ieee;
use ieee.std_logic_1164.all;

entity pc_logic is
  port (
    rop    : in  std_logic_vector(2 downto 0);
    funct3 : in  std_logic_vector(2 downto 0);
    Zf     : in  std_logic;
    PCSrc  : out std_logic
  );
end entity pc_logic;

architecture Behavioral of pc_logic is
begin
  process(rop, funct3, Zf)
  begin
    PCSrc <= '0';
    if rop = "100" then -- Branch
      if funct3 = "000" then -- BEQ
        PCSrc <= Zf;
      elsif funct3 = "001" then -- BNE
        PCSrc <= not Zf;
      end if;
    end if;
    
  end process;
  
end Behavioral;
