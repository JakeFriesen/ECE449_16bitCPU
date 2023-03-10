----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/01/2023 02:23:53 PM
-- Design Name: 
-- Module Name: ROM_Testbench - tb
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
use ieee.std_logic_textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ROM_Testbench is
end ROM_Testbench;

architecture tb of ROM_Testbench is
    component ROM is 
        port(
        addr : in std_logic_vector (5 downto 0);
        clk, rst, en : in std_logic;
        data : out std_logic_vector (15 downto 0)        
        );
    end component ROM;
-- Test Vectors
type test_vector is record
    addr : std_logic_vector (5 downto 0);
    data : std_logic_vector (15 downto 0); 
end record;
type test_vector_array is array (natural range <>) of test_vector;
constant test_array : test_vector_array := (
    (addr=>"000000", data=>x"0001"), 
    (addr=>"000001", data=>x"0203"),
    (addr=>"000010", data=>x"0405"),
    (addr=>"000011", data=>x"0607"),
    (addr=>"000100", data=>x"0809"),
    (addr=>"000101", data=>x"0A0B")
);
--Test Signals
signal addr : std_logic_vector(5 downto 0);
signal clk, rst, en : std_logic;
signal data : std_logic_vector(15 downto 0);

begin
UUT: ROM port map(addr=>addr, clk=>clk, rst=>rst, en=>en, data=>data);

    process begin
        --clk set to 0
        clk <= '0';
        --Enable ROM
        en <= '1';
        --RST kept low
        rst <= '0';
        --Set first data
        addr <= test_array(0).addr;
        clk <= '1';
        wait for 1us;
        clk <= '0';
        wait for 1us;
        
        for i in 0 to (test_array'length - 2) loop
            addr <= test_array(i+1).addr;
            clk <= '1';
            wait for 1us;
            clk <= '0';
            wait for 1us;
            
            assert(data = test_array(i).data)
                   
            report "test_array " & integer'image(i) & " failed!" --TOOD: How to cast vectors to strings?
                severity error;
            
        end loop;        
        wait;
    end process;
    
end tb;
