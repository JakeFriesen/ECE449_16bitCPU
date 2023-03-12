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
           NPC : out STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           PC_in : in STD_LOGIC_VECTOR (15 downto 0);
           halt : in STD_LOGIC;
           ram_addr : out std_logic_vector (15 downto 0);
           ram_data : in std_logic_vector (15 downto 0);
           br_in : in STD_LOGIC);
end Intruction_Fetch_Stage;

architecture Behavioral of Intruction_Fetch_Stage is
    --Signals
    signal branch : std_logic := '0';
    signal instruction_data : std_logic_vector(15 downto 0) := (others=>'0');
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
                IR <= (others=>'0');
                NPC <= (others=>'0');
                program_counter <= (others=>'0');
                branch <= '0';
                PC_new <= (others=>'0');
            else
                program_counter <= next_counter;
                NPC <= program_counter;
                IR <= instruction_data;
                branch <= br_in;
                PC_new <= PC_in;                
            end if;
        end if;
    end process;
        
    --RAM Access
    ram_addr <= program_counter;
    instruction_data <= instruction_data when halt = '1' else
                        ram_data;
    
    
    --Program Counter Update
    next_counter <= PC_new when branch = '1' else
                    program_counter when halt = '1' else
                    program_counter + 1;

end Behavioral;
