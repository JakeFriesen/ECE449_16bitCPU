----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/21/2023 10:18:17 AM
-- Design Name: 
-- Module Name: Write_Back_Stage - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Write_Back_Stage is
    Port ( clk, rst : in std_logic;
           ALU_in : in STD_LOGIC_VECTOR (15 downto 0);
           Overflow_in : in STD_LOGIC_VECTOR (15 downto 0);
           Mem_in : in STD_LOGIC_VECTOR (15 downto 0);
           IR_in : in STD_LOGIC_VECTOR (15 downto 0);
           IN_PORT : in STD_LOGIC_VECTOR (15 downto 0);
           wr_data : out STD_LOGIC_VECTOR (15 downto 0);
           wr_addr : out STD_LOGIC_VECTOR (2 downto 0);
           V_data : out STD_LOGIC_VECTOR (15 downto 0));
end Write_Back_Stage;

architecture Behavioral of Write_Back_Stage is
    signal ALU, Overflow, IR, input_port, Mem, write_internal : std_logic_vector (15 downto 0);
    signal addr_internal : std_logic_vector (2 downto 0);
begin
    --Latch Process
    process(clk)
    begin
        if(rst = '1') then
        --Reset
            wr_data <= (others=>'0');
            wr_addr <= (others=>'0');
            V_data <= (others=>'0');
        end if;    
        if(clk'event and clk = '1') then
        --Latch Incoming signals
            ALU <= ALU_in;
            IR <= IR_in;
            Overflow <= Overflow_in;
            input_port <= IN_PORT;
            Mem <= Mem_in;
        end if;
        if(clk'event and clk = '0') then
        --Latch Outgoing signals
            V_data <= Overflow;
            wr_data <= write_internal;
            wr_addr <= addr_internal;
        end if;
    end process;

    write_internal <= 
        "00000000"&IR(7 downto 0) when (IR(15 downto 8) = "00100100") else  --Load lower (18) (TODO: Need to fix the zeros)
        IR(7 downto 0)&"00000000" when (IR(15 downto 8) = "00100101") else  --Load Upper (18) (TODO: Need to fix the zeros)
        input_port when IR(15 downto 9) = "0100001" else                    --IN (33)
        Mem when IR(15 downto 9) = "0010000" else                           --LOAD (16)
        ALU;-- when IR(15 downto 9) = "" else                               --ALU for the rest (TODO: May need to specify)
        --(others=>'0'); 
    addr_internal <=
        "111" when IR(15 downto 9) = "0010010" else                         --Load Imm (18) Load into R7
        IR(8 downto 6) when IR(15 downto 9) = "0010010";                    --LOAD, ALU ops (TODO: May need to specify)



end Behavioral;
