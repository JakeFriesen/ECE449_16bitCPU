library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX2_1 is
    Port ( x : in STD_LOGIC_VECTOR (15 downto 0);
           y : in STD_LOGIC_VECTOR (15 downto 0);
           s : in STD_LOGIC;
           z : out STD_LOGIC_VECTOR (15 downto 0));
end MUX2_1;

architecture Behavioral of MUX2_1 is

begin
process(x,y,s) is 
    begin 
    if (s = '0') then
        z <= x;
    else
        z <= y;
    end if;
end process;

end Behavioral;