library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity extend is
  generic (
    N : positive := 32
  );
  port (
    Instr  : in  std_logic_vector(31 downto 0);
    ImmSrc : in  std_logic_vector(1 downto 0);
    ExtImm : out std_logic_vector(N-1 downto 0)
  );
end entity extend;

architecture Behavioral of extend is
begin
  process(Instr, ImmSrc)
    variable imm_i : std_logic_vector(11 downto 0);
    variable imm_s : std_logic_vector(11 downto 0);
    variable imm_b : std_logic_vector(12 downto 0);
  begin
    case ImmSrc is
      when "00" =>
        imm_i := Instr(31 downto 20);
        ExtImm <= std_logic_vector(resize(signed(imm_i), N));

      when "01" =>
        imm_s := Instr(31 downto 25) & Instr(11 downto 7);
        ExtImm <= std_logic_vector(resize(signed(imm_s), N));

      when "10" =>
        imm_b := Instr(31) & Instr(7) & Instr(30 downto 25) & Instr(11 downto 8) & '0';
        ExtImm <= std_logic_vector(resize(signed(imm_b), N));

      when others =>
        ExtImm <= (others => '0');
    end case;
    
  end process;
  
end Behavioral;
