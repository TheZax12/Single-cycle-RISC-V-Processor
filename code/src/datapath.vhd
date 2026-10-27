library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity datapath is
  generic (
    N          : positive := 32;
    IMEM_ADDRW : positive := 6;
    DMEM_ADDRW : positive := 5;
    REG_ADDRW  : positive := 5
  );
  port (
    CLK        : in std_logic;
    RESET      : in std_logic;
 
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
end entity datapath;
 
architecture Structural of datapath is
 
  component pc_reg is
    generic ( N : positive := 32 );
    port (
      CLK   : in  std_logic;
      RESET : in  std_logic;
      D     : in  std_logic_vector(N-1 downto 0);
      Q     : out std_logic_vector(N-1 downto 0)
    );
  end component;
 
  component instr_mem is
    generic ( N : positive := 6; M : positive := 32 );
    port (
      A  : in  std_logic_vector(N-1 downto 0);
      RD : out std_logic_vector(M-1 downto 0)
    );
  end component;
 
  component adder is
    generic ( N : positive := 32 );
    port (
      A : in  std_logic_vector(N-1 downto 0);
      B : in  std_logic_vector(N-1 downto 0);
      Y : out std_logic_vector(N-1 downto 0)
    );
  end component;
 
  component regfile is
    generic ( N : positive := 5; M : positive := 32 );
    port (
      CLK : in  std_logic;
      WE3 : in  std_logic;
      A1  : in  std_logic_vector(N-1 downto 0);
      A2  : in  std_logic_vector(N-1 downto 0);
      A3  : in  std_logic_vector(N-1 downto 0);
      WD3 : in  std_logic_vector(M-1 downto 0);
      RD1 : out std_logic_vector(M-1 downto 0);
      RD2 : out std_logic_vector(M-1 downto 0)
    );
  end component;
 
  component extend is
    generic ( N : positive := 32 );
    port (
      Instr  : in  std_logic_vector(31 downto 0);
      ImmSrc : in  std_logic_vector(1 downto 0);
      ExtImm : out std_logic_vector(N-1 downto 0)
    );
  end component;
 
  component mux2to1 is
    generic ( N : positive := 32 );
    port (
      D0  : in  std_logic_vector(N-1 downto 0);
      D1  : in  std_logic_vector(N-1 downto 0);
      SEL : in  std_logic;
      Y   : out std_logic_vector(N-1 downto 0)
    );
  end component;
 
  component alu is
    generic ( N : positive := 32 );
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
  end component;
 
  component data_mem is
    generic ( N : positive := 8; M : positive := 32 );
    port (
      CLK : in  std_logic;
      WE  : in  std_logic;
      A   : in  std_logic_vector(N-1 downto 0);
      WD  : in  std_logic_vector(M-1 downto 0);
      RD  : out std_logic_vector(M-1 downto 0)
    );
  end component;
 
 
  constant FOUR : std_logic_vector(N-1 downto 0) := std_logic_vector(to_unsigned(4, N));
 
  signal PC_cur, PC_next   : std_logic_vector(N-1 downto 0);
  signal PCPlus4, PCTarget : std_logic_vector(N-1 downto 0);
  signal Instr_int         : std_logic_vector(N-1 downto 0);
  signal RD1, RD2          : std_logic_vector(N-1 downto 0);
  signal ExtImm            : std_logic_vector(N-1 downto 0);
  signal SrcB              : std_logic_vector(N-1 downto 0);
  signal ALUResult_int     : std_logic_vector(N-1 downto 0);
  signal ReadData          : std_logic_vector(N-1 downto 0);
  signal Result_int        : std_logic_vector(N-1 downto 0);
 
begin
 
  U_PC : pc_reg
    generic map ( N => N )
    port map ( CLK => CLK, RESET => RESET, D => PC_next, Q => PC_cur );
 
  U_IMEM : instr_mem
    generic map ( N => IMEM_ADDRW, M => N )
    port map ( A => PC_cur(IMEM_ADDRW+1 downto 2), RD => Instr_int );
 
  U_INC4 : adder
    generic map ( N => N )
    port map ( A => PC_cur, B => FOUR, Y => PCPlus4 );
 
  U_RF : regfile
    generic map ( N => REG_ADDRW, M => N )
    port map (
      CLK => CLK,
      WE3 => RegWrite,
      A1  => Instr_int(19 downto 15),   -- rs1
      A2  => Instr_int(24 downto 20),   -- rs2
      A3  => Instr_int(11 downto 7),    -- rd
      WD3 => Result_int,
      RD1 => RD1,
      RD2 => RD2
    );
 
  U_EXT : extend
    generic map ( N => N )
    port map ( Instr => Instr_int, ImmSrc => ImmSrc, ExtImm => ExtImm );
 
  U_MUX_SRCB : mux2to1
    generic map ( N => N )
    port map ( D0 => RD2, D1 => ExtImm, SEL => ALUSrc, Y => SrcB );
 
  U_ALU : alu
    generic map ( N => N )
    port map (
      SrcA       => RD1,
      SrcB       => SrcB,
      ALUControl => ALUControl,
      SLTUorSLT  => SLTUorSLT,
      ALUResult  => ALUResult_int,
      Nf => Nf, Zf => Zf, Cf => Cf, Vf => Vf
    );
 
  U_DMEM : data_mem
    generic map ( N => DMEM_ADDRW, M => N )
    port map (
      CLK => CLK,
      WE  => MemWrite,
      A   => ALUResult_int(DMEM_ADDRW+1 downto 2),
      WD  => RD2,
      RD  => ReadData
    );
 
  U_MUX_RESULT : mux2to1
    generic map ( N => N )
    port map ( D0 => ALUResult_int, D1 => ReadData, SEL => ResultSrc, Y => Result_int );
 
  U_PC_TARGET : adder
    generic map ( N => N )
    port map ( A => PC_cur, B => ExtImm, Y => PCTarget );
 
  U_MUX_PC : mux2to1
    generic map ( N => N )
    port map ( D0 => PCPlus4, D1 => PCTarget, SEL => PCSrc, Y => PC_next );
 
  -- Observation Outputs
  PC        <= PC_cur;
  Instr     <= Instr_int;
  ALUResult <= ALUResult_int;
  WriteData <= RD2;
  Result    <= Result_int;
 
end Structural;