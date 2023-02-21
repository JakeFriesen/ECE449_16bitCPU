----------------------------------------------------------------------------------
-- Company: University of Victoria ECE 449
-- Engineer: Matthew Ebert
-- 
-- Create Date: 2023-FEB-16 
-- Module Name: EX Stage - Behavioral
-- Project Name: 16-bit CPU
-- Target Devices: Basys3 FPGA
-- 
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity EX_stage is
    Port ( 
           clk: in STD_LOGIC;
           rst: in STD_LOGIC;
           ALU_OP : in STD_LOGIC_VECTOR (2 downto 0);
           A : in STD_LOGIC_VECTOR (15 downto 0);
           B : in STD_LOGIC_VECTOR (15 downto 0);
           
                   
           result : out STD_LOGIC_VECTOR (15 downto 0);
           data : out STD_LOGIC_VECTOR (15 downto 0);
           Z : out STD_LOGIC;
           N : out STD_LOGIC;
           V : out STD_LOGIC;
           V_EN: out STD_LOGIC;
           
           Z_OUTPUT : out std_logic;
           N_OUTPUT: out std_logic
           
           );
         
end EX_stage;

architecture Behavioral of EX_stage is


--ALU
component ALU is
    port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           B : in STD_LOGIC_VECTOR (15 downto 0);
           sel : in STD_LOGIC_VECTOR (2 downto 0);
           result : out STD_LOGIC_VECTOR (15 downto 0);
           v_result : out STD_LOGIC_VECTOR (15 downto 0);
           Z : out STD_LOGIC;
           N : out STD_LOGIC;
           V : out STD_LOGIC
           );
end component;
    
-- signal mul_result: STD_LOGIC_VECTOR (31 downto 0);
signal ALU_B,ALU_A , v_result: STD_LOGIC_VECTOR (15 downto 0);


signal in_data_sel: std_logic;
signal in_A, in_B: std_logic_vector( 15 downto 0);
signal in_ALU_OP: std_logic_vector (2 downto 0);

signal out_result, out_data, out_v_result: std_logic_vector(15 downto 0);
signal out_z, out_n, out_v, out_v_en: std_logic;

signal out_z_output, out_n_output: std_logic;
    
begin

   
   
   
   process (clk)
   begin
    if (clk='1' and clk'event) then 
     if(rst ='1') then
          in_ALU_OP <= "000";
      else
          in_ALU_OP <= ALU_OP;
          in_A <= A;
          in_B <= B;
      end if;
      end if;
   end process;
   

    ALU_0: ALU port map( in_A, in_B, in_ALU_OP, out_result, out_v_result, out_Z, out_N, out_V);
    
    
    with in_ALU_OP Select
                        out_data <= out_v_result when "011",
                                    in_A when others;
     
    process(in_ALU_OP, out_result)
    begin
        if(in_ALU_OP = "111") then
        
        out_Z_OUTPUT <= out_z;
        out_N_OUTPUT <= out_n;
        
        end if; 
     
    end process;
    
    
       with in_ALU_OP Select 
         out_V_EN <= out_V when "011", 
         '0' when others;
        
    
    process (clk)
    begin
     if (clk='0' and clk'event) then 
           result <= out_result;
           data <= out_data;
           z <= out_z;
           N <= out_n;
           V <= out_v;
           V_en <= out_v_en;
           
           Z_OUTPUT <= out_z_output;
           N_output <= out_n_output;
     end if;
    end process;
     
     
end Behavioral;
