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
			  IR : in  STD_LOGIC_VECTOR (15 downto 0);
			  --npc_in : in  STD_LOGIC_VECTOR (15 downto 0);
			  --npc_out : out STD_LOGIC_VECTOR (15 downto 0);
			  A : out std_logic_vector(15 downto 0); 
			  B : out std_logic_vector(15 downto 0);
			  wr_index : in std_logic_vector(2 downto 0);
			  wr_data : in std_logic_vector(15 downto 0);
			  wr_enable : in std_logic;
			  --Overflow signals
			  ov_data : in std_logic_vector(15 downto 0);
			  ov_enable : in std_logic;
			  --Outport
			  outport : out std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    
   --Inputs
   signal rst : std_logic;
   signal clk : std_logic;
   signal IR : std_logic_vector(15 downto 0);
   --signal npc_in : std_logic_vector(6 downto 0) := (others => '0');
   signal wr_index : std_logic_vector(2 downto 0);
   signal wr_data : std_logic_vector(15 downto 0);
   signal wr_enable : std_logic;
   signal ov_data : std_logic_vector(15 downto 0);
   signal ov_enable : std_logic;

 	--Outputs
   --signal npc_out : std_logic_vector(5 downto 0);
   signal A : std_logic_vector(15 downto 0);
   signal B : std_logic_vector(15 downto 0);
   signal outport : std_logic_vector(15 downto 0);
   
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
          --npc_in => npc_in,
          --npc_out => npc_out,
          A => A,
          B => B,
          wr_index => wr_index,
          wr_data => wr_data,
          wr_enable => wr_enable,
          ov_data => ov_data,
          ov_enable => ov_enable,
          outport => outport
        );


   -- Clock process
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
        ov_data <= "000000";
        ov_enable <= '0';
		IR <= X"0000"; --NOP
		wait until (clk = '1' and clk'event);
		
		wait until (clk = '0' and clk'event);
		wr_enable <= '1';
		wr_index <= "001";
		wr_data <= X"0088"; --Write in 0x0088 to R1
		IR <= X"0000"; --NOP
		
		wait until (clk = '0' and clk'event);
		wr_enable <= '1';
		wr_index <= "010";
		wr_data <= X"0044"; -- write 0x0044 to R2
		IR <= X"0000"; --NOP
		
		wait until (clk = '0' and clk'event);
		wr_enable <= '0';
		wr_index <= "000";
		wr_data <= X"0000";
		IR <= out_op & "001" & "000000"; --output contents of R1
		
		wait until (clk = '0' and clk'event);
		IR <= out_op & "010" & "000000"; --output contents of R2		
		
      wait;
   end process;

END;