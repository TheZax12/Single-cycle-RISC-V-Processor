library ieee;
use ieee.std_logic_1164.all;
 
entity alu_dec is
  port (
    rop        : in  std_logic_vector(2 downto 0);
    funct3     : in  std_logic_vector(2 downto 0);
    funct7_5   : in  std_logic;
    ALUControl : out std_logic_vector(2 downto 0);
    SLTUorSLT  : out std_logic
  );
end entity alu_dec;
 
architecture Behavioral of alu_dec is
begin
  process(rop, funct3, funct7_5)
  begin
    SLTUorSLT <= '0';
 
    case rop is
      when "000" => ALUControl <= "000"; -- LW
      when "001" => ALUControl <= "000"; -- SW
      
      when "010" =>
        case funct3 is
          when "000" => -- ADD or SUB
            if funct7_5 = '1' then
              ALUControl <= "001"; -- SUB
            else
              ALUControl <= "000"; -- ADD
            end if;
          when "110" => ALUControl <= "101"; -- OR
          when "100" => ALUControl <= "110"; -- XOR
          when "010"  => -- SLT
            ALUControl <= "010";
            SLTUorSLT  <= '0';
          when "011"  => -- SLTU
            ALUControl <= "010";
            SLTUorSLT  <= '1';
          when others => ALUControl <= "000";
        end case;
        
      when "011" =>
        case funct3 is
          when "000"  => ALUControl <= "000";  -- ADDI
          when "111"  => ALUControl <= "100";  -- ANDI
          when "110"  => ALUControl <= "101";  -- ORI
          when "100"  => ALUControl <= "110";  -- XORI
          when others => ALUControl <= "000";
        end case;
 
      when "100" =>
        ALUControl <= "001";
 
      when others =>
        ALUControl <= "000";
    end case;
    
  end process;
  
end Behavioral;