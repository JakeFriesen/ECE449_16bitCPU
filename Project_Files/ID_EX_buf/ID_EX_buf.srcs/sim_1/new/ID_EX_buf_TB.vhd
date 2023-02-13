 
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
use work.all;

entity IF_ID_buf_TB is 
end IF_ID_buf_TB;

architecture behavioural of ID_EX_buf_TB is
  
  component ID_EX_buf 
     port(
         rst : in std_logic; 
         clk: in std_logic;
         opcode_in: in std_logic_vector(6 downto 0);
         A_in: in std_logic_vector(15 downto 0);
         B_in: in std_logic_vector(15 downto 0);
         opcode_out: out std_logic_vector(6 downto 0);
         A: out std_logic_vector(15 downto 0);
         B: out std_logic_vector(15 downto 0)
     );      
  end component; 

  signal rst, clk: std_logic; 
  signal A_in, B_in, A_out, B_out: std_logic_vector(15 downto 0); 

  signal opcode_in, opcode_out : std_logic_vector(6 downto 0); 
  
  begin 
  UUT: ID_EX_buf port map (rst, clk, opcode_in, A_in, B_in, opcode_out, A_out, B_out); 
  process begin  
      clk <= '0'; wait for 10 ns;
      clk<= '1'; wait for 10 ns; 
  end process;
  
  process begin
        rst <= '0';
        wait until (clk='1' and clk'event); 
        wait until (clk='1' and clk'event); 
        wait until (clk='1' and clk'event); 
        wait;
  end process;
end behavioural;