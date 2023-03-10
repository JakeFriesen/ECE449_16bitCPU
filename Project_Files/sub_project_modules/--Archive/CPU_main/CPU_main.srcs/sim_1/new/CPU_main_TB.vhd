----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/06/2023 05:18:00 PM
-- Design Name: 
-- Module Name: test_main_V0 - Behavioral
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

entity CPU_main_TB is
end CPU_main_TB;

architecture Behavioral of CPU_main_TB is

component CPU_main is 
    port( 	
        cpu_clk:	in std_logic;
        rst: in STD_LOGIC;
        addr: in std_logic_vector(5 downto 0);
        in_port: in STD_LOGIC_VECTOR (15 downto 0);
        out_port: out STD_LOGIC_VECTOR (15 downto 0);
        reg_write_data: in STD_LOGIC_VECTOR(15 downto 0);
        reg_write_index: in STD_LOGIC_VECTOR(2 downto 0);
        reg_write_enable: in STD_LOGIC
        );
end component CPU_main;

signal addr : std_logic_vector(5 downto 0);
signal reg_write_index: std_logic_vector (2 downto 0);

signal clk, rst, reg_write_enable : std_logic;
signal out_port, in_port, reg_write_data : std_logic_vector(15 downto 0);

begin
UUT: CPU_main port map(clk, rst, addr, in_port,out_port, reg_write_data, reg_write_index, reg_write_enable);


    process begin
        clk <= '0'; wait for 10 ns;
        clk<= '1'; wait for 10 ns; 
    end process;
    process  begin
        rst <= '1';  reg_write_enable <= '1';
        reg_write_data <= X"0000";
        reg_write_index <= "000";
        wait until (clk='0' and clk'event); wait until (clk='1' and clk'event); wait until (clk='1' and clk'event);
        rst <= '0';
        wait until (clk='1' and clk'event); reg_write_index <= "000"; reg_write_data <= X"0000";
        wait until (clk='1' and clk'event); reg_write_index <= "001"; reg_write_data <= X"0001";
        wait until (clk='1' and clk'event); reg_write_index <= "010"; reg_write_data <= X"0002";
        wait until (clk='1' and clk'event); reg_write_index <= "011"; reg_write_data <= X"0003";
        wait until (clk='1' and clk'event); reg_write_index <= "100"; reg_write_data <= X"0004";
        wait for 20 ns;
        
        wait until (clk='1' and clk'event); in_port<= "0000001" & "000" & "000" & "001";
        wait for 20 ns;
        wait until (clk='1' and clk'event); in_port<= "0000001" & "000" & "001" & "010";
         wait for 20 ns;
        wait until (clk='1' and clk'event); in_port<= "0000001" & "000" & "010" & "011";
         wait for 20 ns;
        wait until (clk='1' and clk'event); in_port<= "0000001" & "000" & "011" & "100";
         wait for 20 ns;

        wait;
--      
       
--        wait;
    end process;


end Behavioral;
