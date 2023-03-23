----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2023 04:52:51 PM
-- Design Name: 
-- Module Name: Top_Level_CPU_TB - tb
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_Level_CPU_TB is
end Top_Level_CPU_TB;

architecture tb of Top_Level_CPU_TB is
component Top_Level_CPU is
    Port ( IN_PORT : in STD_LOGIC_VECTOR (15 downto 0);
           OUT_PORT : out STD_LOGIC_VECTOR (15 downto 0);
           clk_100MHz : in STD_LOGIC;
           reset_load : in STD_LOGIC;
           reset_execute : in STD_LOGIC
           );
end component Top_Level_CPU;
signal in_port, out_port : std_logic_vector(15 downto 0);
signal clk, rst : std_logic;

begin
CPU : Top_Level_CPU port map(clk_100MHz=>clk, reset_load=>rst, reset_execute=>rst, IN_PORT=>in_port, OUT_PORT=>out_port);

--Clocking Process
process begin
    clk <= '0';
    wait for 1us;
    clk <= '1';
    wait for 1us;
end process;

process begin
    rst <= '1';
    wait until clk = '1';
    wait until clk = '0';
    rst <= '0';
 
    wait until clk = '1';
    wait until clk = '0';

    in_port <= x"0002"; --INPUT R0 <= 2
    wait until clk = '1';
    wait until clk = '0';
    in_port <= x"0003"; --INPUT R1 <= 3
    wait until clk = '1';
    wait until clk = '0';
    
    in_port <= x"0001"; --INPUT R0 <= 3
    wait until clk = '1';
    wait until clk = '0';
    in_port <= x"0005"; --INPUT R1 <= 4
    wait until clk = '1';
    wait until clk = '0';
    
    in_port <= x"1000"; --INPUT R0 <= 5
    wait until clk = '1';
    wait until clk = '0';
    in_port <= x"1000"; --INPUT R1 <= 6
    wait until clk = '1';
    wait until clk = '0';
    

    wait;
end process;






end tb;
