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
           sys_rst : in STD_LOGIC;
           clk_in : in STD_LOGIC
       );
end component Top_Level_CPU;
type test_vector is record
    in_port_upper, in_port_lower : std_logic_vector (15 downto 0);
end record;
type test_vector_array is array (natural range <>) of test_vector;
constant test_array : test_vector_array := (
    (in_port_upper=>x"2580", in_port_lower=>x"0080"),  
    (in_port_upper=>x"2480", in_port_lower=>x"0180"),  
    (in_port_upper=>x"2780", in_port_lower=>x"7880"),  
    (in_port_upper=>x"2680", in_port_lower=>x"6880"),  
    (in_port_upper=>x"2780", in_port_lower=>x"A880"),
    (in_port_upper=>x"0B80", in_port_lower=>x"8180"),
    (in_port_upper=>x"4280", in_port_lower=>x"0080"),
    (in_port_upper=>x"0680", in_port_lower=>x"4880"),
    (in_port_upper=>x"0480", in_port_lower=>x"0580"),  
    (in_port_upper=>x"0580", in_port_lower=>x"0680"),  
    (in_port_upper=>x"0F80", in_port_lower=>x"0080"),  
    (in_port_upper=>x"8280", in_port_lower=>x"0280"),  
    (in_port_upper=>x"8180", in_port_lower=>x"FB80"),
    (in_port_upper=>x"4080", in_port_lower=>x"4080"),
    (in_port_upper=>x"8180", in_port_lower=>x"F280")    
);
signal in_port, out_port : std_logic_vector(15 downto 0);
signal clk, rst, reset_load, reset_execute, sys_rst, clk_in : std_logic := '0';
signal sseg : std_logic_vector(6 downto 0);
signal an : std_logic_vector(3 downto 0);
signal mode_sel : std_logic := '0';
signal seg_sel : std_logic_vector (4 downto 0) := "00000";
signal boot_input : std_logic_vector (9 downto 0) := (others=>'0');

begin
CPU : Top_Level_CPU port map(
    clk_in => clk,
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
--System Reset
    sys_rst <= '1';
    wait for 2us;
    sys_rst <= '0';
--System Reset

    reset_execute <= '0';
    reset_load <= '0';
    in_port <= x"AA80";
    mode_sel <= '1'; --Bootloader = 1, Program = 0
    
    wait until clk = '1';
    wait until clk = '0';
    wait until clk = '1';
    wait until clk = '0';
    
--Reset Sequence to get into load vector
    reset_load <= '1';
--    reset_execute <= '1';
    for i in 0 to 4 loop
        wait until clk = '1';
        wait until clk = '0';
    end loop;
--    reset_execute <= '0';
      reset_load <= '0';
--Reset Sequence to get into load vector

--Wait until AA is recieved    
    while out_port(0) = '0' loop
      wait until clk = '1';
      wait until clk = '0';
    end loop;
    in_port <= x"0000";
    while out_port(0) = '1' loop
       wait until clk = '1';
       wait until clk = '0';
    end loop;
    
--Wait until 55 is recieved   
    in_port <= x"5580";
    while out_port(0) = '0' loop
      wait until clk = '1';
      wait until clk = '0';
    end loop;    
    in_port <= x"0000";
    while out_port(0) = '1' loop
      wait until clk = '1';
      wait until clk = '0';
    end loop;
    
--Wait until package count is recieved    
    in_port <= x"1080";
    while out_port(0) = '0' loop
      wait until clk = '1';
      wait until clk = '0';
    end loop;    
    in_port <= x"0000";
    while out_port(0) = '1' loop
      wait until clk = '1';
      wait until clk = '0';
    end loop;
    
--Wait until address to store is recieved
    in_port <= x"04C0";--04
    while out_port(0) = '0' loop
      wait until clk = '1';
      wait until clk = '0';
    end loop;    
    in_port <= x"0000";
    while out_port(0) = '1' loop
      wait until clk = '1';
      wait until clk = '0';
    end loop;
    in_port <= x"10C0";--10
    while out_port(0) = '0' loop
      wait until clk = '1';
      wait until clk = '0';
    end loop;    
    in_port <= x"0040";
    while out_port(0) = '1' loop
      wait until clk = '1';
      wait until clk = '0';
    end loop;    
    
--Iterate through all the data to be sent
    for i in test_array'range loop
        in_port <= test_array(i).in_port_upper;
        while out_port(0) = '0' loop
          wait until clk = '1';
          wait until clk = '0';
        end loop;  
        in_port <= x"0000";
        while out_port(0) = '1' loop
          wait until clk = '1';
          wait until clk = '0';
        end loop;  
        in_port <= test_array(i).in_port_lower;
        while out_port(0) = '0' loop
          wait until clk = '1';
          wait until clk = '0';
        end loop;  
        in_port <= x"0000";
        while out_port(0) = '1' loop
          wait until clk = '1';
          wait until clk = '0';
        end loop;  
    end loop;
    
--Program is Loaded! Now to execute the code
    wait for 100us;
    reset_execute <= '1';
    wait for 10us;
    in_port <= x"0005";
    mode_sel <= '0'; --Program
    wait for 10 us;
    reset_execute <= '0';
    
    
    
    wait;
end process;






end tb;
