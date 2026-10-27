library ieee;
use ieee.std_logic_1164.all;

entity instr_dec is
  port (
    op        : in  std_logic_vector(4 downto 0);
    ResultSrc : out std_logic;
    MemWrite  : out std_logic;
    ALUSrc    : out std_logic;
    ImmSrc    : out std_logic_vector(1 downto 0);
    RegWrite  : out std_logic;
    rop       : out std_logic_vector(2 downto 0)
  );
end entity instr_dec;

architecture Behavioral of instr_dec is
begin
  process(op)
  begin
    case op is
      when "00000" =>  -- LW
        rop <= "000";
        ResultSrc <= '1';
        MemWrite <= '0';
        ALUSrc <= '1';
        ImmSrc <= "00";
        RegWrite <= '1';

      when "01000" =>  -- SW
        rop <= "001";
        ResultSrc <= '0';
        MemWrite <= '1';
        ALUSrc <= '1';
        ImmSrc <= "01";
        RegWrite <= '0';

      when "01100" =>  -- ALU type-R
        rop <= "010";
        ResultSrc <= '0';
        MemWrite <= '0';
        ALUSrc <= '0';
        ImmSrc <= "00";
        RegWrite <= '1';

      when "00100" =>  -- ALU type-I
        rop <= "011";
        ResultSrc <= '0';
        MemWrite <= '0';
        ALUSrc <= '1';
        ImmSrc <= "00";
        RegWrite <= '1';

      when "11000" =>  -- Branch
        rop <= "100";
        ResultSrc <= '0';
        MemWrite <= '0';
        ALUSrc <= '0';
        ImmSrc <= "10";
        RegWrite <= '0';

      when others =>
        rop <= "111";
        ResultSrc <= '0';
        MemWrite <= '0';
        ALUSrc <= '0';
        ImmSrc <= "00";
        RegWrite <= '0';
    end case;
    
  end process;
  
end Behavioral;
