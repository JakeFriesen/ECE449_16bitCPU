
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity IF_ID_buf is
     port(
      rst : in std_logic; 
      clk: in std_logic;
      opcode_in: in std_logic_vector(6 downto 0);
      Ra_in: in std_logic_vector(2 downto 0);
      Rb_in: in std_logic_vector(2 downto 0);
      Rc_in: in std_logic_vector(2 downto 0);
      opcode_out: out std_logic_vector(6 downto 0);
      Ra_out: out std_logic_vector(2 downto 0);
      Rb_out: out std_logic_vector(2 downto 0);
      Rc_out: out std_logic_vector(2 downto 0)
      );
        
end IF_ID_buf ;

architecture behavioural of IF_ID_buf  is

--write operation 
begin
process(clk)
begin

   if (clk='0' and clk'event) then 
   if(rst ='1') then
        opcode_out <= "0000000";
        Ra_out <= "000";
        Rb_out <= "000";
        Rc_out <= "000";

    else

        Ra_out <= Ra_in;
        Rb_out <= Rb_in;
        Rc_out <= Rc_in;
        opcode_out <= opcode_in;
    end if;
    end if;
   
end process;

end behavioural;