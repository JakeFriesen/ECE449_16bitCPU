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
           halt : in STD_LOGIC;
           PC_in : in STD_LOGIC_VECTOR (5 downto 0);
           ram_addr : out std_logic_vector (5 downto 0);
           ram_data : in std_logic_vector (15 downto 0);
           br_in : in STD_LOGIC);
end Intruction_Fetch_Stage;

architecture Behavioral of Intruction_Fetch_Stage is
    --Signals
    signal branch : std_logic := '0';
    signal PC_new, next_counter : std_logic_vector (5 downto 0) := (others=>'0');
    signal program_counter : std_logic_vector (5 downto 0) := (others=>'0');
    
begin

    --Latch Process
    process(clk)
    begin
       
        if(rising_edge(clk)) then
            if(rst = '1') then
                --Reset
                NPC <= (others=>'0');
                branch <= '0';
                PC_new <= (others=>'0');
            else
                --Latch Incoming signals
                program_counter <= next_counter;
                branch <= br_in;
                PC_new <= PC_in;
            end if;
        end if;
    end process;
   
    -- Ram Access
    ram_addr <= program_counter when rst='0' else "000000";
    IR <= ram_data when rst='0' else x"0000";  
    
    --Program Counter Update
    NPC <= next_counter;
    next_counter <= PC_new when branch = '1' else
                    "000000" when rst='1' else
                    program_counter when halt='1' else
                    program_counter + 1;

end Behavioral;
