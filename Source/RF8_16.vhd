
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity register_file is
port(rst : in std_logic; clk: in std_logic;
    --read signals
    rd_index1: in std_logic_vector(2 downto 0); 
    rd_index2: in std_logic_vector(2 downto 0); 
    rd_data1: out std_logic_vector(15 downto 0); 
    rd_data2: out std_logic_vector(15 downto 0);
    --write signals
    wr_index: in std_logic_vector(2 downto 0); 
    wr_data: in std_logic_vector(15 downto 0); wr_enable: in std_logic);
end register_file;

architecture behavioural of register_file is

type reg_array is array (integer range 0 to 7) of std_logic_vector(15 downto 0);
--internals signals
signal reg_file : reg_array; begin
--write operation 
process(clk)
begin
   if(clk='0' and clk'event) then if(rst='1') then
      for i in 0 to 7 loop
         reg_file(i)<= (others => '0'); 
      end loop;
   elsif(wr_enable='1') then
      case wr_index(2 downto 0) is
      when "000" => reg_file(0) <= wr_data;
      when "001" => reg_file(1) <= wr_data;
      when "010" => reg_file(2) <= wr_data;
      when "011" => reg_file(3) <= wr_data;
      when "100" => reg_file(4) <= wr_data;
      when "101" => reg_file(5) <= wr_data;
      when "110" => reg_file(6) <= wr_data;
      when "111" => reg_file(7) <= wr_data;
      when others => NULL; end case;
    end if; 
    end if;
end process;

--read operation
rd_data1 <=	
reg_file(0) when(rd_index1="000") else
reg_file(1) when(rd_index1="001") else
reg_file(2) when(rd_index1="010") else
reg_file(3) when(rd_index1="011") else
reg_file(4) when(rd_index1="100") else
reg_file(5) when(rd_index1="101") else
reg_file(6) when(rd_index1="110") else reg_file(7);

rd_data2 <=
reg_file(0) when(rd_index2="000") else
reg_file(1) when(rd_index2="001") else
reg_file(2) when(rd_index2="010") else
reg_file(3) when(rd_index2="011") else
reg_file(4) when(rd_index2="100") else
reg_file(5) when(rd_index2="101") else
reg_file(6) when(rd_index2="110") else reg_file(7);
--fill this part

end behavioural;