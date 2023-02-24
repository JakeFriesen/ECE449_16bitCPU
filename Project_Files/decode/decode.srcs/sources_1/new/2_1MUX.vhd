----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2023 12:28:29 PM
-- Design Name: 
-- Module Name: 2_1MUX - Behavioral
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

entity 2_1MUX is
    Port ( x : in STD_LOGIC_VECTOR (15 downto 0);
           y : in STD_LOGIC_VECTOR (15 downto 0);
           s : in STD_LOGIC;
           z : out STD_LOGIC_VECTOR (15 downto 0));
end 2_1MUX;

architecture Behavioral of 2_1MUX is

begin


end Behavioral;
