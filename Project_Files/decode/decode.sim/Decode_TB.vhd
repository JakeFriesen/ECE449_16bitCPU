LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Decode_TB IS
END Decode_TB;
 
ARCHITECTURE behavior OF Decode_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Decode
    PORT(
         rst : in STD_LOGIC;
		 clk : in STD_LOGIC;
		 rst_reg_file : in STD_LOGIC;
		 instruction : in  STD_LOGIC_VECTOR (15 downto 0);
		 ra_index : out std_logic_vector(2 downto 0);
		 npc_in : in  STD_LOGIC_VECTOR (5 downto 0);
		 npc_out : out STD_LOGIC_VECTOR (5 downto 0);
		 ALU_Mode : out  STD_LOGIC_VECTOR (2 downto 0);
		 Writeback_Mode : out  STD_LOGIC_VECTOR (2 downto 0);
		 rd_data1 : out std_logic_vector(15 downto 0); 
		 rd_data2 : out std_logic_vector(15 downto 0);
		 wr_index : in std_logic_vector(2 downto 0);
		 wr_data : in std_logic_vector(15 downto 0);
		 wr_enable : in std_logic;
		 c1 : out std_logic_vector (3 downto 0);
		 output_en : out std_logic;
		 input_en : out std_logic;
		 input_in : in std_logic_vector(15 downto 0);
		 input_out : out std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst_reg_file : std_logic := '0';
   signal instruction : std_logic_vector(15 downto 0) := (others => '0');
   signal npc_in : std_logic_vector(6 downto 0) := (others => '0');
   signal rd_index1 : std_logic_vector(2 downto 0) := (others => '0');
   signal rd_index2 : std_logic_vector(2 downto 0) := (others => '0');
   signal wr_index : std_logic_vector(2 downto 0) := (others => '0');
   signal wr_data : std_logic_vector(15 downto 0) := (others => '0');
   signal wr_enable : std_logic := '0';
   signal input_in : std_vector(15 downto 0);

 	--Outputs
   signal ra_index : std_logic_vector(2 downto 0);
   signal npc_out : std_logic_vector(5 downto 0);
   signal ALU_Mode : std_logic_vector(2 downto 0);
   signal Writeback_Mode : std_logic_vector(1 downto 0);
   signal rd_data1 : std_logic_vector(15 downto 0);
   signal rd_data2 : std_logic_vector(15 downto 0);
   signal c1 : std_logic_vector(3 downto 0);
   signal output_en : std_logic;
   signal input_en : std_logic;
   signal input_out : std_logic_vector(15 downto 0);
   
   -- Clock period definitions
   constant clk_period : time := 10 ns;
   
   	--Op Code Definitions
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
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Decode PORT MAP (
          rst => rst,
          clk => clk,
		  rst_reg_file => rst_reg_file,
          instruction => instruction,
          ra_index => ra_index,
          npc_in => npc_in,
          npc_out => npc_out,
          ALU_Mode => ALU_Mode,
          Writeback_Mode => Writeback_Mode,
          rd_data1 => rd_data1,
          rd_data2 => rd_data2,
          wr_index => wr_index,
          wr_data => wr_data,
          wr_enable => wr_enable,
          c1 => c1,
		  output_en => output_en,
		  input_en => input_en,
		  input_in => input_in,
		  input_out => input_out
        );


   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ns;	

      wait for clk_period*10;

      -- insert stimulus here
		instruction <= in_op & "001" & "111101"; --load value into reg 001
		wait for clk_period*3;
		
      wait;
   end process;

END;