
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ID_EX_buf is
     port(
      rst : in std_logic; 
      clk: in std_logic;
      sel_in: in std_logic_vector(2 downto 0);
      A_in: in std_logic_vector(15 downto 0);
      B_in: in std_logic_vector(15 downto 0);
      sel_out: out std_logic_vector(2 downto 0);
      A_out: out std_logic_vector(15 downto 0);
      B_out: out std_logic_vector(15 downto 0)
      );
        
end ID_EX_buf;

architecture behavioural of ID_EX_buf  is

--write operation 
begin
process(clk)
begin
   if (clk='0' and clk'event) then 
   if(rst ='1') then
        sel_out <= "000";
        A_out <= X"0000";
        B_out <= X"0000";
    else
        A_out <= A_in;
        B_out <= B_in;
        sel_out <= sel_in;
    end if;
    end if;
   
end process;

end behavioural;