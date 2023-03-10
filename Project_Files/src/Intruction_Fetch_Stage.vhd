---------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Course: University of Victoria
-- Engineer: Jake Friesen, Matthew Ebert, Samuel Pacheo 
-- 
-- Create Date: 2023-Mar-09

-- Module Name: Write_Back_Stage - Behavioral
-- Project Name: 16bitCPU
-- Target Devices: Artix7
-- Description: 
-- 
-- Dependencies: 
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library work;
use work.Constant_Package.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;



entity Intruction_Fetch_Stage is
    Port ( 
           IR_IF_out : out STD_LOGIC_VECTOR (15 downto 0);
           NPC_IF_out : out STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           PC_in : in STD_LOGIC_VECTOR (15 downto 0);
           ram_addr_B : out std_logic_vector (15 downto 0);
           ram_data_B : in std_logic_vector (15 downto 0);
           BR_IF_in : in STD_LOGIC);
end Intruction_Fetch_Stage;

architecture Behavioral of Intruction_Fetch_Stage is
    --Signals
    signal branch : std_logic;
    signal instr_data : std_logic_vector(15 downto 0);
    signal PC_new, next_counter : std_logic_vector (15 downto 0);
    signal program_counter : std_logic_vector (15 downto 0) := (others=>'0');
    
begin

    
    --Latch Process
    process(clk)
    begin
       
        if(clk'event and clk = '1') then
--            if(rst = '1') then
--            --Reset
--                 branch <= '0';
--                 PC_new <= (others=>'0');
--            else 
            --Latch Incoming signals
                branch <= BR_IF_in;
                PC_new <= PC_in;
--            end if;
        end if;
        if(clk'event and clk = '0') then
            if(rst = '1') then
                IR_IF_out <= (others=>'0');
                NPC_IF_out <= (others=>'0');
                program_counter <= (others=>'0');
            else
            --Latch Outgoing signals
                IR_IF_out <= instr_data;   
                NPC_IF_out <= program_counter;   
                program_counter <= next_counter;
            end if;          
        end if;
    end process;
    
    --RAM Access
    ram_addr_B <= program_counter;
    instr_data <= ram_data_B;
    
    
    --Program Counter Update
    next_counter <= PC_new when branch = '1' else
                    program_counter + 1;
        





end Behavioral;
