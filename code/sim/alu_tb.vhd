library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is
end entity alu_tb;

architecture Behavioral of alu_tb is
  constant N : positive := 32;

  component alu is
    port (
      SrcA       : in  std_logic_vector(31 downto 0);
      SrcB       : in  std_logic_vector(31 downto 0);
      ALUControl : in  std_logic_vector(2 downto 0);
      SLTUorSLT  : in  std_logic;
      ALUResult  : out std_logic_vector(31 downto 0);
      Nf         : out std_logic;
      Zf         : out std_logic;
      Cf         : out std_logic;
      Vf         : out std_logic
    );
  end component;

  signal SrcA, SrcB, ALUResult : std_logic_vector(N-1 downto 0);
  signal ALUControl : std_logic_vector(2 downto 0);
  signal SLTUorSLT  : std_logic;
  signal Nf, Zf, Cf, Vf : std_logic;

begin

  uut : alu
    port map (
      SrcA       => SrcA,
      SrcB       => SrcB,
      ALUControl => ALUControl,
      SLTUorSLT  => SLTUorSLT,
      ALUResult  => ALUResult,
      Nf => Nf, Zf => Zf, Cf => Cf, Vf => Vf
    );

  stimulus : process
     
  begin
 
    -- ADD: 10 + 3 = 13
    SrcA <= std_logic_vector(to_signed(10, N));
    SrcB <= std_logic_vector(to_signed(3, N));
    ALUControl <= "000";
    SLTUorSLT  <= '0';
    wait for 10 ns;
 
    -- SUB: 10 - 3 = 7
    SrcA <= std_logic_vector(to_signed(10, N));
    SrcB <= std_logic_vector(to_signed(3, N));
    ALUControl <= "001";
    SLTUorSLT  <= '0';
    wait for 10 ns;
 
    -- AND: 12 and 10 = 8
    SrcA <= std_logic_vector(to_signed(12, N));
    SrcB <= std_logic_vector(to_signed(10, N));
    ALUControl <= "100";
    SLTUorSLT  <= '0';
    wait for 10 ns;
 
    -- OR: 12 or 10 = 14
    SrcA <= std_logic_vector(to_signed(12, N));
    SrcB <= std_logic_vector(to_signed(10, N));
    ALUControl <= "101";
    SLTUorSLT  <= '0';
    wait for 10 ns;
 
    -- XOR: 12 xor 10 = 6
    SrcA <= std_logic_vector(to_signed(12, N));
    SrcB <= std_logic_vector(to_signed(10, N));
    ALUControl <= "110";
    SLTUorSLT  <= '0';
    wait for 10 ns;
 
    -- SLT: 3 < 10 (signed) -> 1
    SrcA <= std_logic_vector(to_signed(3, N));
    SrcB <= std_logic_vector(to_signed(10, N));
    ALUControl <= "010";
    SLTUorSLT  <= '0';
    wait for 10 ns;
 
    -- SLT: 10 < 3 (signed) -> 0
    SrcA <= std_logic_vector(to_signed(10, N));
    SrcB <= std_logic_vector(to_signed(3, N));
    ALUControl <= "010";
    SLTUorSLT  <= '0';
    wait for 10 ns;
 
    -- SLTU: 3 < 10 (unsigned) -> 1
    SrcA <= std_logic_vector(to_signed(3, N));
    SrcB <= std_logic_vector(to_signed(10, N));
    ALUControl <= "010";
    SLTUorSLT  <= '1';
    wait for 10 ns;
 
    -- SLTU: 10 < 3 (unsigned) -> 0
    SrcA <= std_logic_vector(to_signed(10, N));
    SrcB <= std_logic_vector(to_signed(3, N));
    ALUControl <= "010";
    SLTUorSLT  <= '1';
    wait for 10 ns;
 
    -- SUB, negative result, NO overflow: 3 - 10 = -7
    SrcA <= std_logic_vector(to_signed(3, N));
    SrcB <= std_logic_vector(to_signed(10, N));
    ALUControl <= "001";
    SLTUorSLT  <= '0';
    wait for 10 ns;
 
    -- ADD, signed overflow: MAX_INT + 1 wraps to MIN_INT
    SrcA <= std_logic_vector(to_signed(2147483647, N));
    SrcB <= std_logic_vector(to_signed(1, N));
    ALUControl <= "000";
    SLTUorSLT  <= '0';
    wait for 10 ns;
 
    -- SUB, signed overflow: MIN_INT - 1 wraps to MAX_INT
    SrcA <= std_logic_vector(to_signed(-2147483647 - 1, N));
    SrcB <= std_logic_vector(to_signed(1, N));
    ALUControl <= "001";
    SLTUorSLT  <= '0';
    wait for 10 ns;
 
    wait;
  end process stimulus;
 
end Behavioral;