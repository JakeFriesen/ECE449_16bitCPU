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
           OUT_BOOT : out STD_LOGIC;
           sseg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           clk_100MHz : in STD_LOGIC;
           reset_load : in STD_LOGIC;
           reset_execute : in STD_LOGIC;
           mode_sel : in STD_LOGIC;
           seg_sel : in STD_LOGIC_VECTOR (4 downto 0);
           sys_rst : in STD_LOGIC
       );
end component Top_Level_CPU;
signal in_port, out_port : std_logic_vector(15 downto 0);
signal clk, rst, reset_load, reset_execute, sys_rst : std_logic := '0';
signal sseg : std_logic_vector(6 downto 0);
signal an : std_logic_vector(3 downto 0);
signal mode_sel : std_logic := '0';
signal seg_sel : std_logic_vector (4 downto 0) := "00000";
signal boot_input : std_logic_vector (9 downto 0) := (others=>'0');

begin
CPU : Top_Level_CPU port map(
    clk_100MHz=>clk, 
    reset_load=>reset_load, 
    sseg => sseg,
    an => an,
    sys_rst => sys_rst,
    reset_execute=>reset_execute, 
    mode_sel => mode_sel,
    seg_sel => seg_sel,
    IN_PORT=>in_port, 
    OUT_PORT=>out_port
);

--Clocking Process
process begin
    clk <= '0';
    wait for 1us;
    clk <= '1';
    wait for 1us;
end process;

process begin
    sys_rst <= '1';
    wait for 2us;
    sys_rst <= '0';
    reset_execute <= '0';
    reset_load <= '0';
    -- For factorial Test  
--    in_port <= x"AA80";
    in_port <= x"0055";
--    mode_sel <= '1'; --Bootloader
    mode_sel <= '0'; --Program
    -- For factorial Test
    
    wait until clk = '1';
    wait until clk = '0';
    wait until clk = '1';
    wait until clk = '0';
    
--    reset_load <= '1';
----    reset_execute <= '1';
--    for i in 0 to 4 loop
--        wait until clk = '1';
--        wait until clk = '0';
--    end loop;
----    reset_execute <= '0';
--      reset_load <= '0';
    
--    while out_port(0) = '0' loop
--        wait until clk = '1';
--        wait until clk = '0';
--    end loop;
    
--    in_port <= x"0000";
--    while out_port(0) = '1' loop
--         wait until clk = '1';
--         wait until clk = '0';
--    end loop;
     
--    in_port <= x"5580";
--    while out_port(0) = '0' loop
--        wait until clk = '1';
--        wait until clk = '0';
--    end loop;
    
--    in_port <= x"0000";
--    while out_port(0) = '1' loop
--        wait until clk = '1';
--        wait until clk = '0';
--    end loop;
    
--    in_port <= x"1080";
--    while out_port(0) = '0' loop
--        wait until clk = '1';
--        wait until clk = '0';
--    end loop;
    
--    in_port <= x"0000";
--    while out_port(0) = '1' loop
--        wait until clk = '1';
--        wait until clk = '0';
--    end loop;
    
--    in_port <= x"04C0";
--    while out_port(0) = '0' loop
--        wait until clk = '1';
--        wait until clk = '0';
--    end loop;
--    in_port <= x"0000";
--    while out_port(0) = '1' loop
--        wait until clk = '1';
--        wait until clk = '0';
--    end loop;
--    in_port <= x"10C0";
--    while out_port(0) = '0' loop
--        wait until clk = '1';
--        wait until clk = '0';
--    end loop;
--    in_port <= x"0000";
--    while out_port(0) = '1' loop
--       wait until clk = '1';
--       wait until clk = '0';
--    end loop;
--    in_port <= x"2500";
--    while out_port(0) = '0' loop
--        wait until clk = '1';
--        wait until clk = '0';
--    end loop;
--    in_port <= x"0000";
--    while out_port(0) = '1' loop
--       wait until clk = '1';
--       wait until clk = '0';
--    end loop;
--    in_port <= x"2401";
--    while out_port(0) = '0' loop
--        wait until clk = '1';
--        wait until clk = '0';
--    end loop;
--    in_port <= x"0000";
--    while out_port(0) = '1' loop
--       wait until clk = '1';
--       wait until clk = '0';
--    end loop;
    
    
    
    
    wait;
end process;






end tb;
