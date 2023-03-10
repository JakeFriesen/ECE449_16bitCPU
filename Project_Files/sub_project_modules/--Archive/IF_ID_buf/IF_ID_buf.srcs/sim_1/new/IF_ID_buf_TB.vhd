 
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
use work.all;

entity IR_16bit_TB is 
end IR_16bit_TB;

architecture behavioural of IR_16bit_TB is
   
   component IR_16bit 
       port(
          rst : in std_logic; 
          clk: in std_logic;
          instr_data: in std_logic_vector(15 downto 0);
          opcode: out std_logic_vector(6 downto 0);
          Ra: out std_logic_vector(2 downto 0);
          Rb: out std_logic_vector(2 downto 0);
          Rc: out std_logic_vector(2 downto 0)
          );        
   end component; 
   signal test: std_logic;
   signal rst, clk: std_logic; 
   signal Ra, Rb, Rc: std_logic_vector(2 downto 0); 
   signal instr_data : std_logic_vector(15 downto 0); 
   signal opcode : std_logic_vector(6 downto 0); 
   
   begin 
   UUT: IR_16bit port map (rst, clk, instr_data, opcode, Ra, Rb, Rc); 
   test<= '1';
   process begin  
       clk <= '0'; wait for 10 ns;
       clk<= '1'; wait for 10 ns; 
   end process;
   
   process begin
   rst <= '0';
   instr_data <= X"0000";
   wait until (clk='1' and clk'event); instr_data <= X"0001";
   wait until (clk='1' and clk'event); instr_data <= X"1111";
   wait until (clk='1' and clk'event); instr_data <= X"FFFF";
   wait;
   end process;
end behavioural;