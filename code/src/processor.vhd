library ieee;
use ieee.std_logic_1164.all;
 
entity processor is
  generic (
    N          : positive := 32;
    IMEM_ADDRW : positive := 6;
    DMEM_ADDRW : positive := 5;
    REG_ADDRW  : positive := 5
  );
  port (
    CLK   : in  std_logic;
    RESET : in  std_logic;
 
    PC        : out std_logic_vector(N-1 downto 0);
    Instr     : out std_logic_vector(N-1 downto 0);
    ALUResult : out std_logic_vector(N-1 downto 0);
    WriteData : out std_logic_vector(N-1 downto 0);
    Result    : out std_logic_vector(N-1 downto 0)
  );
end entity processor;
 
architecture Structural of processor is
 
  component datapath is
    generic (
      N          : positive := 32;
      IMEM_ADDRW : positive := 6;
      DMEM_ADDRW : positive := 5;
      REG_ADDRW  : positive := 5
    );
    port (
      CLK        : in  std_logic;
      RESET      : in  std_logic;
      
      ResultSrc  : in std_logic;
      MemWrite   : in std_logic;
      ALUSrc     : in std_logic;
      ALUControl : in std_logic_vector(2 downto 0);
      SLTUorSLT  : in std_logic;
      ImmSrc     : in std_logic_vector(1 downto 0);
      RegWrite   : in std_logic;
      PCSrc      : in std_logic;
      
      Nf, Zf, Cf, Vf : out std_logic;
      
      PC        : out std_logic_vector(N-1 downto 0);
      Instr     : out std_logic_vector(N-1 downto 0);
      ALUResult : out std_logic_vector(N-1 downto 0);
      WriteData : out std_logic_vector(N-1 downto 0);
      Result    : out std_logic_vector(N-1 downto 0)
    );
  end component;
 
  component control is
    port (
      op         : in std_logic_vector(4 downto 0);
      funct3     : in std_logic_vector(2 downto 0);
      funct7_5   : in std_logic;
      Zf         : in std_logic;
      
      ResultSrc  : out std_logic;
      MemWrite   : out std_logic;
      ALUSrc     : out std_logic;
      ImmSrc     : out std_logic_vector(1 downto 0);
      RegWrite   : out std_logic;
      ALUControl : out std_logic_vector(2 downto 0);
      SLTUorSLT  : out std_logic;
      PCSrc      : out std_logic
    );
  end component;
 
  signal Instr_int  : std_logic_vector(N-1 downto 0);
  
  signal PCSrc          : std_logic;
  signal ResultSrc      : std_logic;
  signal MemWrite       : std_logic;
  signal SLTUorSLT      : std_logic;
  signal ALUControl     : std_logic_vector(2 downto 0);
  signal ALUSrc         : std_logic;
  signal ImmSrc         : std_logic_vector(1 downto 0);
  signal RegWrite       : std_logic;
  signal Nf, Zf, Cf, Vf : std_logic;
 
begin
 
  U_DATAPATH : datapath
    generic map (
      N => N, IMEM_ADDRW => IMEM_ADDRW, DMEM_ADDRW => DMEM_ADDRW, REG_ADDRW => REG_ADDRW
    )
    port map (
      CLK        => CLK,
      RESET      => RESET,     
      ResultSrc  => ResultSrc,
      MemWrite   => MemWrite,
      ALUSrc     => ALUSrc,
      ALUControl => ALUControl,
      SLTUorSLT  => SLTUorSLT,
      ImmSrc     => ImmSrc,
      RegWrite   => RegWrite,      
      PCSrc      => PCSrc,
      Nf => Nf, Zf => Zf, Cf => Cf, Vf => Vf,
      PC         => PC,
      Instr      => Instr_int,
      ALUResult  => ALUResult,
      WriteData  => WriteData,
      Result     => Result
    );
 
  U_CONTROL : control
    port map (
      op         => Instr_int(6 downto 2),
      funct3     => Instr_int(14 downto 12),
      funct7_5   => Instr_int(30),
      Zf         => Zf,
      ResultSrc  => ResultSrc,
      MemWrite   => MemWrite,
      ALUSrc     => ALUSrc,
      ImmSrc     => ImmSrc,
      RegWrite   => RegWrite,
      ALUControl => ALUControl,
      SLTUorSLT  => SLTUorSLT,
      PCSrc      => PCSrc
    );
 
  Instr <= Instr_int;
 
end Structural;