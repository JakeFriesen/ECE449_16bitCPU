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
            data_sel: std_logic;
            ALU_OP : in STD_LOGIC_VECTOR (2 downto 0);
            A : in STD_LOGIC_VECTOR (15 downto 0);
            B : in STD_LOGIC_VECTOR (15 downto 0);
                    
            result : out STD_LOGIC_VECTOR (15 downto 0);
            data : out STD_LOGIC_VECTOR (15 downto 0);
            Z : out STD_LOGIC;
            N : out STD_LOGIC;
            V : out STD_LOGIC;
            V_EN: out std_logic
            );
    end component;

    --Test Signals
    signal A, B, result, data : std_logic_vector(15 downto 0);
    signal ALU_OP : std_logic_vector(2 downto 0);
    signal Z, N, V, V_EN, data_sel : std_logic;

    
begin
    UUT : EX_stage port map(data_sel, ALU_OP, A, B, result, data, Z, N, V, V_EN);
    
    process begin
        data_sel <= '0';    
        
          
        A<=X"2222";
        B<=X"1111";
        ALU_OP <= "010";
      
        
        wait for 10 ns;
        
         
        A <=X"0000";
        B<=X"1111";
           ALU_OP <= "010";
                
        
        wait for 10 ns;
        
        
         A<=X"2222";
               B<=X"1111";
               ALU_OP <= "010";
             
               
               wait for 10 ns;
        
        
        A <=X"2222";
        B<=X"1111";
           ALU_OP <= "011";
                

        
        wait;
    end process;

end tb;
