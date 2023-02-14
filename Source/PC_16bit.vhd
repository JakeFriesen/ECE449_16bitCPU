----------------------------------------------------------------------------------
-- Company: University of Victoria ECE 449
-- Engineer: Jake Friesen
-- 
-- Create Date: 01/30/2023 08:28:20 PM
-- Module Name: PC - Behavioral
-- Project Name: 16-bit CPU
-- Target Devices: Basys3 FPGA
-- 
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

entity PC is
    Port ( clk : in STD_LOGIC;
           load : in STD_LOGIC;
           PC_out : out STD_LOGIC_VECTOR (5 downto 0);
           PC_in : in STD_LOGIC_VECTOR (5 downto 0);
           inc : in STD_LOGIC;
           rst : in STD_LOGIC);
end PC;

architecture Behavioral of PC is
    signal count : std_logic_vector (6 downto 0);
begin


    process(clk)
    begin
        if(rst = '1') then--reset
            count <= (others=>'0');
        elsif(load = '1') then--load external
            count <= PC_in;
        elsif(inc = '1') then--Increment counter (16 bit -> 2 bytes per word)
            count <= count + 2;
        else--Do Nothing
            count <= count;
        end if;
    end process;
    
    --PC_out set to count 
    PC_out <= count;
    
end Behavioral;
