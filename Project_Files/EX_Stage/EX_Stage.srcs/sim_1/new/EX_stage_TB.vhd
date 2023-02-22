----------------------------------------------------------------------------------
-- Company: University of Victoria ECE 449
-- Engineer: Matthew Ebert
-- 
-- Create Date: 2023-FEB-16 
-- Module Name: EX Stage - Test Bench
-- Project Name: 16-bit CPU
-- Target Devices: Basys3 FPGA
-- 
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX_stage_tb is
end EX_stage_tb;

architecture tb of EX_stage_tb is
    --ALU Component
    
    component EX_stage is
    Port ( 
           clk: in STD_LOGIC;
           rst: in STD_LOGIC;
           I_IR: in std_logic_vector(15 downto 0);
           I_A : in STD_LOGIC_VECTOR (15 downto 0);
           I_B : in STD_LOGIC_VECTOR (15 downto 0);
           INPUT: in STD_LOGIC_VECTOR(15 downto 0);
                   
           O_result : out STD_LOGIC_VECTOR (15 downto 0);
           O_Vdata : out STD_LOGIC_VECTOR (15 downto 0);
           O_Z : out STD_LOGIC;
           O_N : out STD_LOGIC;
           O_V : out STD_LOGIC;
           O_V_EN: out STD_LOGIC; 
           O_Z_OUTPUT : out std_logic;
           O_N_OUTPUT: out std_logic;
           O_OUTPUT: out std_logic_vector(15 downto 0);
           O_IR: out std_logic_vector(15 downto 0)
           
           );
    end component;

    --Test Signals
    signal ALU_OP: std_logic_vector(2 downto 0);
    signal A, B, result, Vdata, OUTPUT, INPUT : std_logic_vector(15 downto 0);
    signal IR : std_logic_vector(15 downto 0);
    signal Z, N, V, V_EN, Z_OUTPUT, N_OUTPUT : std_logic;
    signal clk, rst: std_logic;
    signal O_IR: std_logic_vector(15 downto 0);
begin
    UUT : EX_stage port map(clk, rst, IR, A, B,INPUT, result, Vdata, Z, N, V, V_EN, Z_OUTPUT, N_OUTPUT, OUTPUT, O_IR);
    
    process begin
          clk <= '1'; wait for 10 ns;
          clk <= '0'; wait for 10 ns; 
    end process;
    
    process begin
        rst <= '0';
        A<=X"0001";
        B<=X"0001";
        ALU_OP <= "001";
        IR <= "0000001000000000";
        wait until (clk = '1' and clk'event);
        
        
        wait until (clk = '0' and clk'event);
        A<=X"7FFF";
        B<= X"0001";
        ALU_OP <= "001";
        IR <= "0000" & ALU_OP & '0' & X"00";
        
        
        wait until (clk = '0' and clk'event);
        A<=X"0002";
        B<=X"0003";
        ALU_OP <= "010";       
        IR <= "0000" & "010" & '0' & X"00";
        
        wait until (clk = '0' and clk'event);
        A<=X"8000";
        B<=X"0001";
        ALU_OP <= "010";  
        IR <= "0000" & "010" & '0' & X"00";
        
        
        wait until (clk = '0' and clk'event);
        A<=X"0002";
        B<=X"0404";
        ALU_OP <= "011"; 
        IR <= "0000" & "011" & '0' & X"00";
        
        wait until (clk = '0' and clk'event);
        A<=X"000F";
        B<=X"FFFF";
        ALU_OP <= "011";   
        IR <= "0000" & "011"& '0' & X"00";
                
        wait until (clk = '0' and clk'event);
        A<=X"0F0F";
        B<=X"FFFF";
        ALU_OP <= "100";
        IR <= "0000" & "100" & '0' & X"00";
         
         
        wait until (clk = '0' and clk'event);
        A<=X"000F";
        B<=X"FFFF";
        ALU_OP <= "110";
        IR <= "0000" & "110" & '0' & X"02";
        
        wait until (clk = '0' and clk'event);
        A<=X"000F";
        B<=X"FFFF";
        ALU_OP <= "101";
        IR <= "0000" & "101" & '0' & X"02";
         
        wait until (clk = '0' and clk'event);
        A<=X"0000";
        B<=X"0000";
        ALU_OP <= "111";
         IR <= "0000" & "111" & '0' & X"00";
         
         
         
        wait until (clk = '0' and clk'event);
        A<=X"0000";
        B<=X"0000";
        ALU_OP <= "000";
        INPUT <= X"DEEF";
        IR <= "0010" & "001" & '0' & X"00";
         
        wait until (clk = '0' and clk'event);
        A<=X"FEED";
        B<=X"0000";
        ALU_OP <= "001";
        IR <= "0010" & "000" & '0' & X"00";
        
        wait;
    end process;

end tb;
