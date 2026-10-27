library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  generic (
    N : positive := 32
  );
  port (
    SrcA       : in  std_logic_vector(N-1 downto 0);
    SrcB       : in  std_logic_vector(N-1 downto 0);
    ALUControl : in  std_logic_vector(2 downto 0);
    SLTUorSLT  : in  std_logic;
    ALUResult  : out std_logic_vector(N-1 downto 0);
    Nf         : out std_logic;
    Zf         : out std_logic;
    Cf         : out std_logic;
    Vf         : out std_logic
  );
end entity alu;

architecture Behavioral of alu is
  signal add_ext : unsigned(N downto 0);
  signal sub_ext : unsigned(N downto 0);
  signal is_sub  : std_logic;
begin

  is_sub <= '1' when (ALUControl = "001" or ALUControl = "010") else '0';

  add_ext <= ('0' & unsigned(SrcA)) + ('0' & unsigned(SrcB));
  sub_ext <= ('0' & unsigned(SrcA)) - ('0' & unsigned(SrcB));

  process(SrcA, SrcB, ALUControl, SLTUorSLT, add_ext, sub_ext, is_sub)
    variable res_arith  : unsigned(N downto 0);
    variable result_v   : std_logic_vector(N-1 downto 0);
    variable carry_v    : std_logic;
    variable ovf_v      : std_logic;
    variable slt_bit    : std_logic;
  begin
    if is_sub = '1' then
      res_arith := sub_ext;
    else
      res_arith := add_ext;
    end if;

    carry_v := '0';
    ovf_v   := '0';

    case ALUControl is
      when "000" =>  -- add
        result_v := std_logic_vector(res_arith(N-1 downto 0));
        carry_v  := res_arith(N);
        ovf_v    := (SrcA(N-1) xnor SrcB(N-1)) and (SrcA(N-1) xor res_arith(N-1));

      when "001" =>  -- sub
        result_v := std_logic_vector(res_arith(N-1 downto 0));
        carry_v  := not res_arith(N);   -- carry ~ NOT borrow
        ovf_v    := (SrcA(N-1) xor SrcB(N-1)) and (SrcA(N-1) xor res_arith(N-1));

      when "010" =>  -- slt or sltu
        if SLTUorSLT = '0' then -- slt
          if signed(SrcA) < signed(SrcB) then
            slt_bit := '1';
          else
            slt_bit := '0';
          end if;
        else -- sltu
          if unsigned(SrcA) < unsigned(SrcB) then
            slt_bit := '1';
          else
            slt_bit := '0';
          end if;
        end if;
        result_v := std_logic_vector(to_unsigned(0, N-1)) & slt_bit;
        carry_v  := not res_arith(N);
        ovf_v    := (SrcA(N-1) xor SrcB(N-1)) and (SrcA(N-1) xor res_arith(N-1));
 
      when "100" =>  -- and
        result_v := SrcA and SrcB;
 
      when "101" =>  -- or
        result_v := SrcA or SrcB;
 
      when "110" =>  -- xor
        result_v := SrcA xor SrcB;
 
      when others =>
        result_v := (others => '0');
    end case;

    ALUResult <= result_v;
    Nf <= result_v(N-1);
    if result_v = std_logic_vector(to_unsigned(0, N)) then
      Zf <= '1';
    else
      Zf <= '0';
    end if;

    if ALUControl = "100" or ALUControl = "101" or ALUControl = "110" then
      Cf <= '0';
      Vf <= '0';
    else
      Cf <= carry_v;
      Vf <= ovf_v;
    end if;

  end process;

end Behavioral;
