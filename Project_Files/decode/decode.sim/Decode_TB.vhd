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
    PORT(     rst : in STD_LOGIC;
			  clk : in STD_LOGIC;
			  IR : in  STD_LOGIC_VECTOR (15 downto 0);
			  npc_in : in  STD_LOGIC_VECTOR (15 downto 0);
			  npc_out : out STD_LOGIC_VECTOR (15 downto 0);
			  rd_data1 : out std_logic_vector(15 downto 0); 
			  rd_data2 : out std_logic_vector(15 downto 0);
			  wr_index : in std_logic_vector(2 downto 0);
			  wr_data : in std_logic_vector(15 downto 0);
			  wr_enable : in std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal IR : std_logic_vector(15 downto 0) := (others => '0');
   signal npc_in : std_logic_vector(6 downto 0) := (others => '0');
   signal wr_index : std_logic_vector(2 downto 0) := (others => '0');
   signal wr_data : std_logic_vector(15 downto 0) := (others => '0');
   signal wr_enable : std_logic := '0';

 	--Outputs
   signal npc_out : std_logic_vector(5 downto 0);
   signal rd_data1 : std_logic_vector(15 downto 0);
   signal rd_data2 : std_logic_vector(15 downto 0);
   
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
          IR => IR,
          npc_in => npc_in,
          npc_out => npc_out,
          rd_data1 => rd_data1,
          rd_data2 => rd_data2,
          wr_index => wr_index,
          wr_data => wr_data,
          wr_enable => wr_enable
        );


   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1'; wait for 10 ns;
        clk <= '0'; wait for 10 ns; 
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- insert stimulus here
        rst <= '0';
        wr_index <= "000";
        wr_data <= X"0000";
        wr_enable <= '0';
        npc_in <= "000000";
		IR <= X"0000"; --NOP
		wait until (clk = '1' and clk'event);
		
		wait until (clk = '0' and clk'event);
		
		
      wait;
   end process;

END;