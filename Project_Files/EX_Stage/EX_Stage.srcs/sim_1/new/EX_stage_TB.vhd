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
            clk: std_logic;
            rst: std_logic;
            ALU_OP : in STD_LOGIC_VECTOR (2 downto 0);
            A : in STD_LOGIC_VECTOR (15 downto 0);
            B : in STD_LOGIC_VECTOR (15 downto 0);
                    
            result : out STD_LOGIC_VECTOR (15 downto 0);
            data : out STD_LOGIC_VECTOR (15 downto 0);
            Z : out STD_LOGIC;
            N : out STD_LOGIC;
            V : out STD_LOGIC;
            V_EN: out std_logic;
            
            Z_OUTPUT: out std_logic;
            N_OUTPUT: out std_logic
            );
    end component;

    --Test Signals
    signal A, B, result, data : std_logic_vector(15 downto 0);
    signal ALU_OP : std_logic_vector(2 downto 0);
    signal Z, N, V, V_EN, Z_OUTPUT, N_OUTPUT : std_logic;
    signal clk, rst: std_logic;
    
begin
    UUT : EX_stage port map(clk, rst, ALU_OP, A, B, result, data, Z, N, V, V_EN, Z_OUTPUT, N_OUTPUT);
    
    process begin
          clk <= '1'; wait for 10 ns;
          clk <= '0'; wait for 10 ns; 
    end process;
    
    process begin
        rst <= '0';
        
       -- wait until (clk = '0' and clk'event);
        A<=X"0001";
        B<=X"0001";
        ALU_OP <= "001";
        
        
        wait until (clk = '0' and clk'event);
        A<=X"7FFF";
        B<=X"0001";
        ALU_OP <= "001";
        
        wait until (clk = '0' and clk'event);
        A<=X"0002";
        B<=X"0001";
        ALU_OP <= "010";       
        
        
        wait until (clk = '0' and clk'event);
        A<=X"8000";
        B<=X"0001";
        ALU_OP <= "010";  
        
        wait until (clk = '0' and clk'event);
        A<=X"0002";
        B<=X"0404";
        ALU_OP <= "011"; 
        
        wait until (clk = '0' and clk'event);
        A<=X"000F";
        B<=X"FFFF";
        ALU_OP <= "011";   
        
                
        wait until (clk = '0' and clk'event);
        A<=X"0F0F";
        B<=X"FFFF";
        ALU_OP <= "100";
        
        wait until (clk = '0' and clk'event);
        A<=X"0000";
        B<=X"0000";
        ALU_OP <= "111";
        
        wait until (clk = '0' and clk'event);
        A<=X"8000";
        B<=X"0000";
        ALU_OP <= "111";
        
        
        wait for 30ns;
        rst <= '1';
        
                                                                                  
        
        wait;
    end process;

end tb;
