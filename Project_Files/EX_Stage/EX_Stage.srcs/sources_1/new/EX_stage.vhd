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
           data_sel: in STD_LOGIC;
           ALU_OP : in STD_LOGIC_VECTOR (2 downto 0);
           A : in STD_LOGIC_VECTOR (15 downto 0);
           B : in STD_LOGIC_VECTOR (15 downto 0);
           
                   
           result : out STD_LOGIC_VECTOR (15 downto 0);
           data : out STD_LOGIC_VECTOR (15 downto 0);
           Z : out STD_LOGIC;
           N : out STD_LOGIC;
           V : out STD_LOGIC;
           V_EN: out STD_LOGIC
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
           V : out STD_LOGIC;
           V_EN: out std_logic
           );
end component;
    
-- signal mul_result: STD_LOGIC_VECTOR (31 downto 0);
signal ALU_B,ALU_A , v_result: STD_LOGIC_VECTOR (15 downto 0);
    
begin

   

    ALU_0: ALU port map( A, B, ALU_OP, result,v_result, Z, N, V, V_EN);
    
    
    process(data_sel, A, v_result)
    begin
       case data_sel is
                when '0' => data <= v_result;
                when '1' => data <= A;
                when others => data <= A;
       end case;
    end process;
     
end Behavioral;
