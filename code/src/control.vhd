library ieee;
use ieee.std_logic_1164.all;
 
entity control is
  port (
    op         : in  std_logic_vector(4 downto 0);
    funct3     : in  std_logic_vector(2 downto 0);
    funct7_5   : in  std_logic;
    Zf         : in  std_logic;
 
    ResultSrc  : out std_logic;
    MemWrite   : out std_logic;
    ALUSrc     : out std_logic;
    ImmSrc     : out std_logic_vector(1 downto 0);
    RegWrite   : out std_logic;
    ALUControl : out std_logic_vector(2 downto 0);
    SLTUorSLT  : out std_logic;
    PCSrc      : out std_logic
  );
end entity control;
 
architecture Structural of control is
 
  component instr_dec is
    port (
      op        : in  std_logic_vector(4 downto 0);
      ResultSrc : out std_logic;
      MemWrite  : out std_logic;
      ALUSrc    : out std_logic;
      ImmSrc    : out std_logic_vector(1 downto 0);
      RegWrite  : out std_logic;
      rop       : out std_logic_vector(2 downto 0)
    );
  end component;
 
  component alu_dec is
    port (
      rop        : in  std_logic_vector(2 downto 0);
      funct3     : in  std_logic_vector(2 downto 0);
      funct7_5   : in  std_logic;
      ALUControl : out std_logic_vector(2 downto 0);
      SLTUorSLT  : out std_logic
    );
  end component;
 
  component pc_logic is
    port (
      rop    : in  std_logic_vector(2 downto 0);
      funct3 : in  std_logic_vector(2 downto 0);
      Zf     : in  std_logic;
      PCSrc  : out std_logic
    );
  end component;
 
  signal rop_int : std_logic_vector(2 downto 0);
 
begin
 
  U_INSTRDEC : instr_dec
    port map (
      op        => op,
      ResultSrc => ResultSrc,
      MemWrite  => MemWrite,
      ALUSrc    => ALUSrc,
      ImmSrc    => ImmSrc,
      RegWrite  => RegWrite,
      rop       => rop_int
    );
 
  U_ALUDEC : alu_dec
    port map (
      rop        => rop_int,
      funct3     => funct3,
      funct7_5   => funct7_5,
      ALUControl => ALUControl,
      SLTUorSLT  => SLTUorSLT
    );
 
  U_PCLOGIC : pc_logic
    port map (
      rop    => rop_int,
      funct3 => funct3,
      Zf     => Zf,
      PCSrc  => PCSrc
    );
 
end Structural;