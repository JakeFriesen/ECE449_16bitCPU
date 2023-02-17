----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/06/2023 05:15:16 PM
-- Design Name: 
-- Module Name: RAM_Testbench - Behavioral
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

entity RAM_Testbench is
end RAM_Testbench;

architecture Behavioral of RAM_Testbench is
component RAM is 
    port (douta : out STD_LOGIC_VECTOR (15 downto 0);
           doutb : out STD_LOGIC_VECTOR (15 downto 0);
           addra : in std_logic_vector (5 downto 0);
           addrb : in std_logic_vector (5 downto 0);
           dina : in std_logic_vector (15 downto 0);
           wr_en : in std_logic;
           ena : in std_logic;
           enb : in std_logic;
           clk : in std_logic;
           rst : in std_logic);
end component RAM;

-- Test Vectors
type test_vector is record
   addra, addrb : std_logic_vector (5 downto 0);
   douta, doutb, dina : std_logic_vector (15 downto 0);
   wr_en, ena, enb : std_logic;
end record;
type test_vector_array is array (natural range <>) of test_vector;
constant test_array : test_vector_array := (
   (addra=>"000000",addrb=>"000000",douta=>x"0000",doutb=>x"0000",dina=>x"9876", wr_en=>'0', ena=>'0', enb=>'0'), 
   (addra=>"000001",addrb=>"000001",douta=>x"0000",doutb=>x"0000",dina=>x"1234", wr_en=>'0', ena=>'0', enb=>'0'),
   (addra=>"000010",addrb=>"000010",douta=>x"0000",doutb=>x"0000",dina=>x"ABCD", wr_en=>'0', ena=>'0', enb=>'0'),
   (addra=>"000011",addrb=>"000011",douta=>x"0000",doutb=>x"0000",dina=>x"DEAD", wr_en=>'0', ena=>'0', enb=>'0'),
   (addra=>"000100",addrb=>"000100",douta=>x"0000",doutb=>x"0000",dina=>x"BEEF", wr_en=>'0', ena=>'0', enb=>'0'),
   (addra=>"000101",addrb=>"000101",douta=>x"0000",doutb=>x"0000",dina=>x"1001", wr_en=>'0', ena=>'0', enb=>'0')
);
--Test Signals
signal addra, addrb : std_logic_vector (5 downto 0);
signal douta, doutb, dina : std_logic_vector (15 downto 0);
signal wr_en, ena, enb, clk, rst : std_logic;
begin
    UUT: RAM port map(douta=>douta, doutb=>doutb, addra=>addra, addrb=>addrb, dina=>dina, wr_en=>wr_en, ena=>ena, enb=>enb, clk=>clk, rst=>rst);

    process begin
        --clk set to 0
        clk <= '0';
        --Enable ROM
        ena <= '0';
        enb <= '0';
        wr_en <= '1';
        --RST kept low
        rst <= '0';
        --Set first data
        addra <= test_array(0).addra;
        addrb <= test_array(0).addrb;
        dina <= test_array(0).dina;
        clk <= '1';
        wait for 50ns;
        clk <= '0';
        wait for 50ns;
        
        
        --write
        for i in 0 to (test_array'length - 2) loop
            addra <= test_array(i+1).addra;
            dina <= test_array(i+1).dina;
            
            clk <= '1';
            wait for 50ns;
            clk <= '0';
            wait for 50ns;

        end loop;   
        
        ena <= '1';
        enb <= '1';
        wr_en <= '0';
        
        --read
        for i in 0 to (test_array'length - 2) loop
            addra <= test_array(i+1).addra;
            addrb <= test_array(i+1).addrb;
            wait for 10ns;
            
            clk <= '1';
            wait for 50ns;
            clk <= '0';
            wait for 40ns;
            
            assert(douta = test_array(i).dina)
                   
            report "test_array " & integer'image(i) & " failed!" --TOOD: How to cast vectors to strings?
                severity error;
            
        end loop;       
        
        
        
        
        
         
        wait;
    end process;

end Behavioral;
