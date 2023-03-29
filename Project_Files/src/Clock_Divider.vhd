---------------------------------------------------------------
-- ECE 441 Lab orientation example (2022)
-- written by Dr. D. Capson
-- example VHDL code for dividing the 100Mhz clock on NEXSYS A7
---------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity my_D_FF is
    Port ( clock_100MHz : in  STD_LOGIC;  -- the 100MHz clock on NEXSYS A7 board
           reset        : in  STD_LOGIC;  -- reset input to the flip flop
           Q            : out STD_LOGIC   -- Q output from the flip flop
           );
end my_D_FF;

architecture behavioural of my_D_FF is

signal clock_tick_counter: STD_LOGIC_VECTOR (27 downto 0);  -- a counter for counting the number of clock ticks (27 bits required for 100,000,000 ticks !
signal max_number_of_clock_ticks_reached: std_logic;        -- a signal to indicate when we reach the maximum number of clock ticks 
signal Q_int: std_logic;   -- an intermediate signal to hold the value of Q to be output to PMOD JC
constant clock_count : std_logic_vector (27 downto 0) := x"0000001";

begin

-- the on-board clock is 100MHz (100,000,000 equals x"5F5E100")
-- Therefore:
-- x"5F5E100" ticks take exactly 1 second (i.e. counting from 0 to x"5F5E0FF")
-- x"2FAF080" (which is x"5F5E100"/2) ticks take exactly 1/2 second (i.e. counting from 0 to x"2FAF07F")
-- x"17D7840" (which is x"5F5E100"/4) ticks take exactly 1/4 second (i.e. counting from 0 to x"17D783F")
-- x"0BEBC20" (which is x"5F5E100"/8) ticks take exactly 1/8 second (i.e. counting from 0 to x"0BEBC1F")
-- and so on ...

-- Similarly (the number of ticks is for a HALF cycle):
-- 2 ticks gives 100MHz/4 = 25MHz(i.e. counting from 0 to x"0000001")
-- 4 ticks gives 100MHz/8 = 12.5MHz(i.e. counting from 0 to x"0000003")
-- 8 ticks gives 100MHz/16 = 6.25MHz(i.e. counting from 0 to x"0000007")
-- 16 ticks gives 100MHz/32 = 3.125MHz(i.e. counting from 0 to x"000000F")
-- 32 ticks gives 100MHz/64 = 1.5625MHz(i.e. counting from 0 to x"000001F")
-- 64 ticks gives 100MHz/128 = 0.78125MHz(i.e. counting from 0 to x"000003F")
-- 128 ticks gives 100MHz/256= 0.390625MHz(i.e. counting from 0 to x"000007F")
-- 256 ticks gives 100MHz/512 = 0.1953125MHz(i.e. counting from 0 to x"00000FF")
-- and so on ...

process(clock_100MHz, reset)
begin
        if(reset='1') then
            clock_tick_counter <= x"0000000";
        elsif(rising_edge(clock_100MHz)) then
            if(clock_tick_counter >= clock_count) then
                clock_tick_counter <= x"0000000";
            else
                clock_tick_counter <= clock_tick_counter + x"0000001";
            end if;
        end if;
end process;

max_number_of_clock_ticks_reached <= '1' when clock_tick_counter = clock_count else '0';

process(clock_100Mhz, reset)  
begin
        if(reset='1') then
            Q_int <= '0';
        elsif(rising_edge(clock_100MHz)) then
             if(max_number_of_clock_ticks_reached = '1') then
                Q_int <= not(Q_int);   -- toggle when the maximum number of clock ticks has been reached
             end if;
        end if;
end process;


Q <= Q_int; 

end behavioural;