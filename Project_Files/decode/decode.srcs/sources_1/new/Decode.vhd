library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.Constant_Package.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decode is
    Port ( 
    rst : in STD_LOGIC;
    clk : in STD_LOGIC;
    I_br_clear : in STD_LOGIC;
    IR : in  STD_LOGIC_VECTOR (15 downto 0);
    npc_in : in  STD_LOGIC_VECTOR (15 downto 0);
    npc_out : out STD_LOGIC_VECTOR (15 downto 0);
    A : out std_logic_vector(15 downto 0); 
    B : out std_logic_vector(15 downto 0);
    IR_out : out std_logic_vector(15 downto 0);
    wr_index : in std_logic_vector(2 downto 0);
    wr_data : in std_logic_vector(15 downto 0);
    wr_enable : in std_logic;
    --Overflow signals
    ov_data : in std_logic_vector(15 downto 0);
    ov_enable : in std_logic;
    loadIMM: in std_logic;
    load_align: in std_logic
    );			  
end Decode;

architecture Behavioral of Decode is

component register_file is
    port(rst : in std_logic; clk: in std_logic;
    --read signals
    rd_index1: in std_logic_vector(2 downto 0); 
    rd_index2: in std_logic_vector(2 downto 0); 
    rd_data1: out std_logic_vector(15 downto 0); 
    rd_data2: out std_logic_vector(15 downto 0);
    --write signals
    wr_index: in std_logic_vector(2 downto 0); 
    wr_data: in std_logic_vector(15 downto 0); 
    wr_enable: in std_logic;
    --overflow signals
    ov_data: in std_logic_vector(15 downto 0);
    loadIMM: in std_logic;
    load_align: in std_logic;
    ov_enable: in std_logic
    );
end component register_file;

component MUX2_1 is
    Port ( x : in STD_LOGIC_VECTOR (15 downto 0);
           y : in STD_LOGIC_VECTOR (15 downto 0);
           s : in STD_LOGIC;
           z : out STD_LOGIC_VECTOR (15 downto 0));
end component MUX2_1;

--Signals
signal rd_index1_intern : STD_LOGIC_VECTOR(2 downto 0);
signal rd_index2_intern : STD_LOGIC_VECTOR(2 downto 0);
signal rd_data1_out : STD_LOGIC_VECTOR(15 downto 0);
signal load_en : STD_LOGIC;
signal output_en : STD_LOGIC;
signal IR_intrn : STD_LOGIC_VECTOR(15 downto 0);
signal npc : std_logic_vector (15 downto 0);
signal A_internal, B_internal, outport_internal, outport_previous : std_logic_vector(15 downto 0) := (others=>'0');

-- Constant X"0000"
constant zero : std_logic_vector(15 downto 0) := X"0000";


begin

--loadIMM <= (IR_intrn(7 downto 0) & "00000000") when IR(8) = '1' else ("00000000" & IR_intrn(7 downto 0));

--select read index 1 & 2 for regfile	
with IR_intrn(15 downto 9) select
	rd_index1_intern <= IR_intrn(5 downto 3) when add_op | sub_op | mul_op | mov_op | load_op,
						IR_intrn(8 downto 6) when nand_op | shl_op | shr_op | test_op | out_op | br_op | br_n_op | br_z_op | br_sub_op | store_op,
						"111" when return_op,
						"000" when others;	
						
with IR_intrn(15 downto 9) select	
	rd_index2_intern <= IR_intrn(2 downto 0) when add_op | sub_op | mul_op,
	                    IR_intrn(5 downto 3) when nand_op | store_op,
	                    "000" when others;
	
-- Configure output_en
--load_en <= '1' when IR_intrn(15 downto 9) = loadIMM_op  else '0';
--Why is this hardcoded?
load_en <= '0';


--reg file
reg_file : register_file port map(rst => rst, clk => clk, rd_index1 => rd_index1_intern, 
	       rd_index2 => rd_index2_intern, rd_data1 => rd_data1_out, rd_data2 => B_internal, wr_index => wr_index,
	       wr_data => wr_data, wr_enable => wr_enable, ov_data => ov_data,loadIMM=>loadIMM,load_align => load_align, ov_enable => ov_enable);

--MUX assignments--
m1 : MUX2_1 port map(x => rd_data1_out, y => zero , s => load_en, z => A_internal);
        
	--latching		
	process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1' or I_br_clear = '1') then
				IR_intrn <= zero;
				npc <= (others=>'0');
			else
			    IR_intrn <= IR;
				npc <= npc_in;
			end if;
		end if;
		--Latch Output Signals
		if falling_edge(clk) then
		  if(rst = '1') then
		      A <= (others=>'0');
		      B <= (others=>'0');
		      npc_out <= (others=>'0');
		      IR_out <= (others=>'0');
		  else
		      A <= A_internal;
		      B <= B_internal;
		      IR_out <= IR_intrn;
		      npc_out <= npc;
		  end if;	
		end if;
	end process;

end Behavioral;
