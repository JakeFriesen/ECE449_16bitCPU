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
            rd_index1 : in std_logic_vector(2 downto 0);
            rd_index2 : in std_logic_vector(2 downto 0);
            rd_enable : in std_logic;
            halt : out std_logic
         );
end RAW;

architecture Behavioral of RAW is 

type wb_queue is array (integer range 0 to 7) of std_logic_vector(3 downto 0);

signal wb_tracker : wb_queue := (others=>(others=>'0'));

signal raw1 : std_logic := '0';
signal raw2 : std_logic := '0';
signal halt_intern : std_logic := '0';

signal in_use : std_logic_vector (7 downto 0);

begin 
    
process(clk)
begin
    if(falling_edge(clk)) then
		if(rst = '1') then
		  in_use <= (others=>'0');		 
			for i in 0 to 7 loop
				wb_tracker(i) <= (others=>'0');
		    end loop;		
		else
            if (IR_wb='1' and halt_intern = '0') then
                wb_tracker(to_integer(unsigned(ra_index))) <= wb_tracker(to_integer(unsigned(ra_index))) + 1;
--                in_use(to_integer(unsigned(ra_index))) <= '1';
            end if;
            if (wr_en='1') then
                if(wb_tracker(to_integer(unsigned(wr_addr))) = 0) then
                    wb_tracker(to_integer(unsigned(wr_addr))) <= x"0";
                else
                    wb_tracker(to_integer(unsigned(wr_addr))) <= wb_tracker(to_integer(unsigned(wr_addr))) - 1;
--                    in_use(to_integer(unsigned(wr_addr))) <= '0';
                end if;
            end if;
        end if;
    end if;
end process;

raw1 <= '1' when wb_tracker(to_integer(unsigned(rd_index1))) > 0 else
        '0';
--    in_use(0) when rd_index1 = "000" else
--    in_use(1) when rd_index1 = "001" else
--    in_use(2) when rd_index1 = "010" else
--    in_use(3) when rd_index1 = "011" else
--    in_use(4) when rd_index1 = "100" else
--    in_use(5) when rd_index1 = "101" else
--    in_use(6) when rd_index1 = "110" else
--    in_use(7) when rd_index1 = "111" else
--    '0';
raw2 <= '1' when wb_tracker(to_integer(unsigned(rd_index2))) > 0 else
        '0';
--    in_use(0) when rd_index2 = "000" else
--    in_use(1) when rd_index2 = "001" else
--    in_use(2) when rd_index2 = "010" else
--    in_use(3) when rd_index2 = "011" else
--    in_use(4) when rd_index2 = "100" else
--    in_use(5) when rd_index2 = "101" else
--    in_use(6) when rd_index2 = "110" else
--    in_use(7) when rd_index2 = "111" else
--    '0';

halt_intern <= (raw1 or raw2) and rd_enable;    

halt <= halt_intern;
    
end Behavioral;