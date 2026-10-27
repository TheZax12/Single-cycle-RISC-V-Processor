library ieee;
use ieee.std_logic_1164.all;

entity processor_tb is
end entity processor_tb;

architecture Behavioral of processor_tb is

  component processor is
    port (
      CLK       : in  std_logic;
      RESET     : in  std_logic;
      PC        : out std_logic_vector(31 downto 0);
      Instr     : out std_logic_vector(31 downto 0);
      ALUResult : out std_logic_vector(31 downto 0);
      WriteData : out std_logic_vector(31 downto 0);
      Result    : out std_logic_vector(31 downto 0)
    );
  end component;

  constant N          : positive := 32;
  constant CLK_PERIOD : time := 11 ns;

  signal CLK, RESET : std_logic := '0';
  signal PC, Instr, ALUResult, WriteData, Result : std_logic_vector(N-1 downto 0);

begin

  uut : processor
    port map (
      CLK => CLK,
      RESET => RESET,
      PC => PC,
      Instr => Instr,
      ALUResult => ALUResult,
      WriteData => WriteData,
      Result => Result
    );

  clock : process
  begin
    CLK <= '0';
    wait for CLK_PERIOD / 2;
    CLK <= '1';
    wait for CLK_PERIOD / 2;
  end process;

  stimulus : process
  begin
    RESET <= '1';
    wait for CLK_PERIOD * 2;
    RESET <= '0';
    wait;
  end process;
  
end Behavioral;