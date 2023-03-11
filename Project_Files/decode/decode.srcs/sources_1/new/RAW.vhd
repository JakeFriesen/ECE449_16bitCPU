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

signal wb_tracker : wb_queue := (others=>'0');

signal raw1 : std_logic := '0';
signal raw2 : std_logic := '0';
signal halt_intern : std_logic := '0';

begin 
    
process(clk)
begin
    if(rising_edge(clk)) then
		if(rst = '1') then
			for i in 0 to 7 loop
				wb_tracker(i) <= '0';
		    end loop;
		    halt_intern <= '0';		
		else
            if (IR_wb='1') then
                wb_tracker(to_integer(unsigned(ra_index))) <= '1';
            end if;
        end if;
    elsif(falling_edge(clk)) then
        if (wr_en='1') then
                wb_tracker(to_integer(unsigned(wr_addr))) <= '0';
        end if;
    end if;  
end process;

raw1 <= wb_tracker(to_integer(unsigned(rd_data1))) when ra_index = rd_data1 else '0';
raw2 <= wb_tracker(to_integer(unsigned(rd_data2))) when ra_index = rd_data2 else '0';

halt <= '1' when raw1='1' or raw2='1' else
        '0' when rst='1' else 
        '0';

end Behavioral;