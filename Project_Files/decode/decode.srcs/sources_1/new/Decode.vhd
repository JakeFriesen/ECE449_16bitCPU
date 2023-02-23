library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decode is
    Port ( 
			  rst : in STD_LOGIC;
			  clk : in STD_LOGIC;
			  IR : in  STD_LOGIC_VECTOR (15 downto 0);
			  --npc_in : in  STD_LOGIC_VECTOR (15 downto 0);
			  --npc_out : out STD_LOGIC_VECTOR (15 downto 0);
			  rd_data1 : out std_logic_vector(15 downto 0); 
			  rd_data2 : out std_logic_vector(15 downto 0);
			  wr_index : in std_logic_vector(2 downto 0);
			  wr_data : in std_logic_vector(15 downto 0);
			  wr_enable : in std_logic;
			  --Overflow signals
			  ov_data : in std_logic_vector(15 downto 0);
			  ov_enable : in std_logic;
			  output_en : out std_logic);
			  --input_en : out std_logic;
			  --input_in : in std_logic_vector(15 downto 0);
			  --input_out : out std_logic_vector(15 downto 0)
			  
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
        ov_enable: in std_logic);
end component register_file;

--Signals
signal ra_index_intrn : std_logic_vector(2 downto 0);
signal rd_index1 : STD_LOGIC_VECTOR(2 downto 0);
signal rd_index2 : STD_LOGIC_VECTOR(2 downto 0);
signal IR_intrn : STD_LOGIC_VECTOR(15 downto 0);

-- Op Codes
constant nop_op : std_logic_vector(6 downto 0)  := "0000000";
constant add_op : std_logic_vector(6 downto 0)  := "0000001";
constant sub_op : std_logic_vector(6 downto 0)  := "0000010";
constant mul_op : std_logic_vector(6 downto 0)  := "0000011";
constant nand_op : std_logic_vector(6 downto 0) := "0000100";
constant shl_op : std_logic_vector(6 downto 0)  := "0000101";
constant shr_op : std_logic_vector(6 downto 0)  := "0000110";
constant test_op : std_logic_vector(6 downto 0) := "0000111";
constant out_op : std_logic_vector(6 downto 0)  := "0100000";
constant in_op : std_logic_vector(6 downto 0)   := "0100001";

begin

--signal assignments--
	
--select read index 1 & 2 for regfile	
with IR_intrn(15 downto 9) select
	rd_index1 <= 	IR_intrn(5 downto 3) when add_op | sub_op | mul_op | nand_op,
						IR_intrn(8 downto 6) when shl_op | shr_op | test_op | out_op,
						"000" when others;	
						
with IR_intrn(15 downto 9) select	
	rd_index2 <= IR_intrn(2 downto 0) when others;
	
-- Configure input/output
output_en <= '1' when IR_intrn(15 downto 9) = out_op else '0';
--input_en <= '1' when IR_intrn(15 downto 9) = in_op else '0';
	
--reg file (Inserted 0 for reset for testing)
reg_file : register_file port map(rst, clk, rd_index1, 
	rd_index2, rd_data1, rd_data2, wr_index, wr_data, wr_enable, ov_data, ov_enable);
	
	
	--latching		
	process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				IR_intrn <= x"0000";
				--npc_out <= x"0000";
				--input_out <= x"0000";
			else
				IR_intrn <= IR;
				--npc_out <= npc_in;
				--input_out <= input_in;
			end if;
		end if;
	end process;

end Behavioral;
