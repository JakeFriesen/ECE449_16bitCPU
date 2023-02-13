 
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
use work.all;

entity test_alu is end test_alu;

architecture behavioural of test_alu is
    
    component register_file port(rst : in std_logic; clk: in std_logic; 
        rd_index1, rd_index2: in std_logic_vector(2 downto 0);
        rd_data1, rd_data2: out std_logic_vector(15 downto 0); 
        wr_index: in std_logic_vector(2 downto 0); 
        wr_data: in std_logic_vector(15 downto 0); wr_enable: in std_logic);
    end component; 
    signal rst, clk, wr_enable : std_logic; 
    signal rd_index1, rd_index2, wr_index : std_logic_vector(2 downto 0); 
    signal rd_data1, rd_data2, wr_data : std_logic_vector(15 downto 0); 
    begin
    u0:register_file port map(rst=>rst, clk=>clk, rd_index1=>rd_index1, rd_index2=>rd_index2, 
                            rd_data1=>rd_data1, rd_data2=>rd_data2, wr_index=>wr_index, 
                            wr_data=>wr_data, wr_enable=>wr_enable);
    process begin
        clk <= '0'; wait for 10 us;
        clk<= '1'; wait for 10 us; 
    end process;
    process  begin
        rst <= '1'; rd_index1 <= "000"; rd_index2 <= "000"; wr_enable <= '0'; wr_index <= "000";
        wr_data <= X"0000";
        wait until (clk='0' and clk'event); wait until (clk='1' and clk'event); wait until (clk='1' and clk'event);
        rst <= '0';
        wait until (clk='1' and clk'event); wr_enable <= '1'; wr_data <= X"200a";
        wait until (clk='1' and clk'event); wr_index <= "001"; wr_data <= X"0037";
        wait until (clk='1' and clk'event); wr_index <= "010"; wr_data <= X"8b00";
        wait until (clk='1' and clk'event); wr_index <= "101"; wr_data <= X"f00d";
        wait until (clk='1' and clk'event); wr_index <= "110"; wr_data <= X"00fd";
        wait until (clk='1' and clk'event); wr_index <= "111"; wr_data <= X"fd00";
        wait until (clk='1' and clk'event); wr_enable <= '0';
        wait until (clk='1' and clk'event); rd_index2 <= "001";
        wait until (clk='1' and clk'event); rd_index1 <= "010";
        wait until (clk='1' and clk'event); rd_index2 <= "101";
        wait until (clk='1' and clk'event); rd_index1 <= "110";
        rd_index2 <= "111"; wait;
    end process;
end behavioural;