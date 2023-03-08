library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity RAW is
    port(
            rst : in std_logic;
            clk : in std_logic;
            wr_en : in std_logic;
            IR_wb : in std_logic;
            ra_index : in std_logic_vector(2 downto 0);
            wr_addr : in std_logic_vector(2 downto 0);
            rd_data1 : in std_logic_vector(2 downto 0);
            rd_data2 : in std_logic_vector(2 downto 0);
            halt : out std_logic
         );
end RAW;

architecture Behavioral of RAW is 

type wb_queue is array (integer range 0 to 7) of std_logic;

signal wb_tracker : wb_queue;

signal raw_rd1 : std_logic;
signal raw_rd2 : std_logic;

begin 

raw_rd1 <= 
wb_tracker(0) when(rd_data1="000") else
wb_tracker(1) when(rd_data1="001") else
wb_tracker(2) when(rd_data1="010") else
wb_tracker(3) when(rd_data1="011") else
wb_tracker(4) when(rd_data1="100") else
wb_tracker(5) when(rd_data1="101") else
wb_tracker(6) when(rd_data1="110") else wb_tracker(7);

raw_rd2 <= 
wb_tracker(0) when(rd_data2="000") else
wb_tracker(1) when(rd_data2="001") else
wb_tracker(2) when(rd_data2="010") else
wb_tracker(3) when(rd_data2="011") else
wb_tracker(4) when(rd_data2="100") else
wb_tracker(5) when(rd_data2="101") else
wb_tracker(6) when(rd_data2="110") else wb_tracker(7);

halt <= raw_rd1 OR raw_rd2;
    
process(clk)
begin
	if(rising_edge(clk)) then
	
		if(rst = '1') then
			for i in 0 to 7 loop
				wb_tracker(i) <= '0';
			end loop;
			halt <= '0';
			
		else
		    if (wr_en = '1') then
		        wb_tracker(to_integer(unsigned(wr_addr))) <= '0';
            elsif (IR_wb = '1') then
                wb_tracker(to_integer(unsigned(ra_index))) <= '1';
             end if;
		end if;
	end if;
end process;
end Behavioral;