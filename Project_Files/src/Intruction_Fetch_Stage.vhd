---------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Course: University of Victoria
-- Engineer: Jake Friesen, Matthew Ebert, Samuel Pacheo 
-- 
-- Create Date: 2023-Mar-09

-- Module Name: Intruction_Fetch_Stage - Behavioral
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
           halt : in STD_LOGIC;
           BR_IF_in : in STD_LOGIC);
           
end Intruction_Fetch_Stage;

architecture Behavioral of Intruction_Fetch_Stage is
    --Signals
    signal branch : std_logic := '0';
    signal instr_data : std_logic_vector(15 downto 0) := (others=>'0');
    signal PC_new : std_logic_vector (15 downto 0) := (others=>'0');
    signal program_counter, next_counter : std_logic_vector (15 downto 0) := (others=>'0');
    
begin

    --Latch Process
    process(clk)
    begin
       
        if(rising_edge(clk)) then
            if(rst = '1') then
--                branch <= '0';
--                PC_new <= (others=>'0');
            else
                --Latch Incoming signals
--                branch <= br_in;
--                PC_new <= PC_in;
            end if;
        end if;
        if(falling_edge(clk)) then
            if (rst='1') then
                IR_IF_out <= (others=>'0');
                NPC_IF_out <= (others=>'0');
                program_counter <= (others=>'0');
                branch <= '0';
                PC_new <= (others=>'0');
            else
            --Latch Outgoing signals
                
                if(halt = '1') then
                    instr_data <= instr_data;
                    IR_IF_out <= instr_data;
                else
                    instr_data <= ram_data_B;
                    IR_IF_out <= ram_data_B;
                end if;  
                NPC_IF_out <= program_counter;   
                program_counter <= next_counter;
                branch <= br_IF_in;
                PC_new <= PC_in;                
            end if;
        end if;
    end process;
        
    --RAM Access
    ram_addr_B <= program_counter;  
    
    --Program Counter Update
    next_counter <= PC_new when branch = '1' else
                    program_counter when halt = '1' else
                    program_counter + 1;

end Behavioral;
