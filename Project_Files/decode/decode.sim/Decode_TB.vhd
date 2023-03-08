LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Decode_TB IS
END Decode_TB;
 
ARCHITECTURE Behavioral OF Decode_TB IS 
 
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
			  IR_out : out std_logic_vector(15 downto 0);
			  wr_index : in std_logic_vector(2 downto 0);
			  wr_data : in std_logic_vector(15 downto 0);
			  wr_enable : in std_logic;
			  --Overflow signals
			  ov_data : in std_logic_vector(15 downto 0);
			  ov_enable : in std_logic;
			  --Outport
			  outport : out std_logic_vector(15 downto 0);
			  --RAW
			  halt : out std_logic
        );
    END COMPONENT;
    
   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal IR : std_logic_vector(15 downto 0) := (others => '0');
   --signal npc_in : std_logic_vector(6 downto 0) := (others => '0');
   signal wr_index : std_logic_vector(2 downto 0) := (others => '0');
   signal wr_data : std_logic_vector(15 downto 0):= (others => '0');
   signal wr_enable : std_logic := '0';
   signal ov_data : std_logic_vector(15 downto 0) := (others => '0');
   signal ov_enable : std_logic := '0';

 	--Outputs
   --signal npc_out : std_logic_vector(5 downto 0);
   signal A : std_logic_vector(15 downto 0);
   signal B : std_logic_vector(15 downto 0);
   signal IR_out: std_logic_vector(15 downto 0);
   signal outport : std_logic_vector(15 downto 0);
   signal halt : std_logic;
   
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
 
begin
	-- Instantiate the Unit Under Test (UUT)
   uut: Decode PORT MAP (
          rst => rst,
          clk => clk,
          IR => IR,
          --npc_in => npc_in,
          --npc_out => npc_out,
          A => A,
          B => B,
          IR_out => IR_out,
          wr_index => wr_index,
          wr_data => wr_data,
          wr_enable => wr_enable,
          ov_data => ov_data,
          ov_enable => ov_enable,
          outport => outport,
          halt => halt
        );


   -- Clock process
   process begin
		clk <= '1'; 
		wait for 10 ns;
        clk <= '0'; 
        wait for 10 ns; 
   end process;
 
   -- Stimulus process
   process begin		
      -- insert stimulus here
        rst <= '1';
        wr_index <= "000";
        wr_data <= X"0000";
        wr_enable <= '0';
        ov_data <= X"0000";
        ov_enable <= '0';
		IR <= X"0000"; --NOP
		wait until (clk = '1' and clk'event);
		
		wait until (clk = '0' and clk'event);
		rst <= '0';
		wr_enable <= '1';
		wr_index <= "001";
		wr_data <= X"0001"; --Write in 1 to R1
		IR <= X"0000"; --NOP
		
		wait until (clk = '0' and clk'event);
		wr_enable <= '1';
		wr_index <= "010";
		wr_data <= X"0001"; -- write 1 to R2
		IR <= X"0000"; --NOP
		
		wait until (clk = '0' and clk'event);
		wr_enable <= '1';
		wr_index <= "011";
		wr_data <= X"0002"; -- write 2 to R3
		IR <= X"0000"; --NOP
		
		wait until (clk = '0' and clk'event);
		wr_enable <= '0';
		wr_index <= "000";
		wr_data <= X"0000";
		IR <= add_op & "001" & "010" & "011"; -- Add r1 r2 r3
		
		wait until (clk = '0' and clk'event);
		wr_enable <= '0';
		wr_index <= "000";
		wr_data <= X"0000";
		IR <= mul_op & "001" & "010" & "011"; -- add r3 r1 r2
		
		wait until (clk = '0' and clk'event);
		IR <= out_op & "011" & "000000"; --output contents of R3		
		
      wait;
   end process;

end Behavioral;