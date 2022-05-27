LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity decode_stage is
    port(
        CLK,rst:in std_logic;
        Instruction: in std_logic_vector(31 downto 0);

        --control signals
	    reg_write : in std_logic;
	    flush_id : in std_logic;
        WBen: in std_logic;
        MEMen:in std_logic;
        EXen:in std_logic;
        hazard_results: in std_logic;

        --other inputs
        writeData: in std_logic_vector(31 downto 0);
        writeReg: in std_logic_vector(2 downto 0);
        PC_in: in std_logic_vector(31 downto 0);
        --IMM_in: in std_logic_vector(31 downto 0);

        --outputs
        Pc_out: out std_logic_vector(31 downto 0);
        readData1,readData2: out std_logic_vector(31 downto 0);
        Rd, Rs,Rt: out std_logic_vector(2 downto 0);
        index: out std_logic_vector(1 downto 0);
        WBenSignal:out  std_logic;
        MEMenSignal: out std_logic;
        ExenSignal: out std_logic
        
      





--to do:
---muxx bt3 el mem wb ex signals lesa msh m3mol
--hazard detection unit
    );
end entity;

architecture rtl of Decode_stage is
    
component registersFile is
   port(
        reg_write: in std_logic;
        clk, rst: in std_logic;
        Rsrc1,Rsrc2: in std_logic_vector(2 downto 0);
        write_reg: in std_logic_vector(2 downto 0);
        write_data: in std_logic_vector(31 downto 0);
        read_data1,read_data2: out std_logic_vector(31 downto 0)
    );
end component;

-- component control_unit IS
-- port (
-- clk : in std_logic;
-- 	opcode : in std_logic_vector(4 downto 0);
-- 	CCR_OUT: in std_logic_vector(2 downto 0);
-- 	ccr_wr_en : out std_logic_vector(2 downto 0);
-- 	reg_write : out std_logic;
-- 	alu_src : out std_logic;
-- 	alu_op : out std_logic_vector(4 downto 0);
-- 	alu_imm : out std_logic;
-- 	mem_write : out std_logic;
-- 	mem_read : out std_logic;
-- 	stack_en : out std_logic;
-- 	mem_to_reg : out std_logic;
-- 	return_en : out std_logic;
-- 	restore_flags : out std_logic;
-- 	int_en : out std_logic;
-- 	pc_src : out std_logic_vector(1 downto 0)
-- );
-- end component;

component adder is
generic (n: integer := 16);
port(
	cin: in std_logic;
	a,b: in std_logic_vector(n-1 downto 0);
	sum: out std_logic_vector(n-1 downto 0);
	cout: out std_logic
);
end component;

component mux2x1_1bit is
port (
    in1, in2 : in std_logic;
    sel : in  std_logic;
    out1: out std_logic
);
end component;

signal bit5INTindex: std_logic_vector(1 downto 0);
--signal cURegWrite: std_logic;
signal LoadUseAndFlush: std_logic;
-- 



begin
    --controlUn: control_unit port map(CLK, Instruction(4 downto 0), CCR_out,ccr_wr_en, cURegWrite, alu_src, alu_op, alu_imm, mem_write, mem_read, stack_en, mem_to_reg, return_en,restore_flags, int_en, pc_src,flush_if,flush_id,flush_ex,flush_wb);
   --reg_write<=cURegWrite;
    bit5INTindex<='0' & Instruction(5);
    RegistersComp: registersFile port map (reg_write, CLK, rst, Instruction(10 downto 8), Instruction(13 downto 11), writeReg, writeData, readData1, readData2);
    Rs<=Instruction(7 downto 5);
    Rt<=Instruction(10 downto 8);
    Rd<=Instruction(13 downto 11);
    addingPc: adder generic map (2) port map ('0',"10",bit5INTindex,index, open);
    LoadUseAndFlush<=flush_id or hazard_Results;
    WBZeroingMux: mux2x1_1bit port map (WBen,'0',LoadUseAndFlush,WBenSignal);
    MEMZeroingMux: mux2x1_1bit  port map (MEMen,'0',LoadUseAndFlush,MEMenSignal);
    EXZeroingMux: mux2x1_1bit  port map (EXen,'0',LoadUseAndFlush,EXenSignal);






end architecture rtl;