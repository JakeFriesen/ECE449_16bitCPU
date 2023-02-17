
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity IR_16bit is
    port(
        rst : in std_logic; 
        clk: in std_logic;
        instr_data: in std_logic_vector(15 downto 0);
        opcode: out std_logic_vector(6 downto 0);
        Ra: out std_logic_vector(2 downto 0);
        Rb: out std_logic_vector(2 downto 0);
        Rc: out std_logic_vector(2 downto 0)
        );
        
end IR_16bit;

architecture behavioural of IR_16bit is

--write operation 
begin
process(clk)
begin

   if (clk='0' and clk'event) then 
   if(rst ='1') then
        opcode<="0000000";
        Ra <= "000";
        Rb <= "000";
        Rc <= "000";
    else
        opcode <= instr_data(15 downto 9);
        Ra <= instr_data(8 downto 6);
        Rb <= instr_data(5 downto 3);
        Rc <= instr_data(2 downto 0);
    end if;
    end if;
   
end process;

end behavioural;