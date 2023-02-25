----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2023 10:27:16 AM
-- Design Name: 
-- Module Name: Intruction_Fetch_Stage - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Intruction_Fetch_Stage is
    Port ( IR : out STD_LOGIC_VECTOR (15 downto 0);
           NPC : out STD_LOGIC_VECTOR (5 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           PC_in : in STD_LOGIC_VECTOR (5 downto 0);
           ram_addr : out std_logic_vector (5 downto 0);
           ram_data : in std_logic_vector (15 downto 0);
           br_in : in STD_LOGIC);
end Intruction_Fetch_Stage;

architecture Behavioral of Intruction_Fetch_Stage is
    --Signals
    signal branch : std_logic;
    signal instr_data : std_logic_vector(15 downto 0);
    signal PC_new, next_counter : std_logic_vector (5 downto 0);
    signal program_counter : std_logic_vector (5 downto 0) := (others=>'0');
    
begin

    
    --Latch Process
    process(clk)
    begin
       
        if(clk'event and clk = '1') then
            if(rst = '1') then
            --Reset
                 branch <= '0';
                 PC_new <= (others=>'0');
            else 
            --Latch Incoming signals
                branch <= br_in;
                PC_new <= PC_in;
            end if;
        end if;
        if(clk'event and clk = '0') then
            if(rst = '1') then
                IR <= (others=>'0');
                NPC <= (others=>'0');
                program_counter <= (others=>'0');
            else
            --Latch Outgoing signals
                IR <= instr_data;   
                NPC <= next_counter;   
                program_counter <= next_counter;
            end if;          
        end if;
    end process;
    
    --RAM Access
    ram_addr <= program_counter;
    instr_data <= ram_data;
    
    --Program Counter Update
    next_counter <= PC_new when branch = '1' else
                    program_counter + 1;
        





end Behavioral;
