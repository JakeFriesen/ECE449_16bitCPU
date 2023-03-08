----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/19/2023 10:59:37 AM
-- Design Name: 
-- Module Name: Memory_Stage - Behavioral
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
library work;
use work.Constant_Package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Memory_Stage is
    Port ( ALU_in : in STD_LOGIC_VECTOR (15 downto 0);
           IR_in : in STD_LOGIC_VECTOR (15 downto 0);
           N : in STD_LOGIC;
           Z : in STD_LOGIC;
           clk, rst : in STD_LOGIC;
           branch : out STD_LOGIC;
           branch_addr : out STD_LOGIC_VECTOR (15 downto 0);
           ram_wr : out STD_LOGIC;
           pipe_flush : out std_logic;
           ram_addrb : out STD_LOGIC_VECTOR (15 downto 0);
           ram_datab : in STD_LOGIC_VECTOR (15 downto 0);
           Mem_out : out STD_LOGIC_VECTOR (15 downto 0);
           ALU_out : out STD_LOGIC_VECTOR (15 downto 0);
           IR_out : out STD_LOGIC_VECTOR (15 downto 0);
           NPC_in : in STD_LOGIC_VECTOR (15 downto 0);
           Overflow_in, A_in, B_in : in STD_LOGIC_VECTOR (15 downto 0);
           Overflow_out : out STD_LOGIC_VECTOR (15 downto 0));
end Memory_Stage;

architecture Behavioral of Memory_Stage is
    signal IR, ALU, Overflow, ram_output, NPC : std_logic_vector (15 downto 0);
    signal flags : std_logic_vector (1 downto 0);
    signal branch_internal : std_logic;

begin
    --Latch Process
    process(clk)
    begin
        if(rst = '1') then
        --Reset
            IR_out <= (others=>'0');
            Overflow_out <= (others=>'0');
            ALU_out <= (others=>'0');
            Mem_out <= (others=>'0');  
        end if;    
        if(clk'event and clk = '1') then
        --Latch Incoming signals
            if(branch_internal = '1') then
            --Internal Branch set, clear the incoming buffer
                flags <= "00";
                IR <= (others=>'0');
                ALU <= (others=>'0');
                Overflow <= (others=>'0');
                NPC <= (others=>'0');
            else
                flags <= N & Z;
                IR <= IR_in;
                ALU <= ALU_in;
                Overflow <= Overflow_in;
                NPC <= NPC_in;
            end if;
        end if;
        if(clk'event and clk = '0') then
        --Latch Outgoing signals
            Overflow_out <= Overflow;
            IR_out <= IR;
            if( IR(15 downto 9) = br_sub_op) then
                ALU_out <= NPC + 1;
            else
                ALU_out <= ALU;
            end if;
            Mem_out <= ram_output;
        end if;
    end process;

    --Branch Choice - Combinational, not latched output
    --This is very redundant, and could always output an address, but this will help to debug branching issues
    branch_internal <=
        '1' when IR(15 downto 9) = brr_op else                          --BRR (64)
        '1' when (IR(15 downto 9) = brr_n_op and flags(1) = '1') else   --BRR.N (65)
        '1' when (IR(15 downto 9) = brr_z_op and flags (0) = '1') else  --BRR.Z (66)
        '1' when (IR(15 downto 9) = br_op) else                         --BR (67)
        '1' when (IR(15 downto 9) = br_n_op and flags (1) = '1') else   --BR.N (68)
        '1' when (IR(15 downto 9) = br_z_op and flags (0) = '1') else   --BR.Z (69)
        '1' when (IR(15 downto 9) = br_sub_op) else                     --BR.SUB (70)
        '1' when (IR(15 downto 9) = return_op) else                     --RETURN (71)
        '0';                                                            --Don't branch any other time
    --Branch Address Choice - Combinational, not banched output.
    --This is very redundant, and could always output an address, but this will help to debug branching issues
    branch_addr <=
        ALU when (IR(15 downto 9) = brr_op) else                     --BRR (64)
        ALU when (IR(15 downto 9) = "1000001" and flags(1) = '1') else  --BRR.N (65)
        ALU when (IR(15 downto 9) = "1000010" and flags (0) = '1') else --BRR.Z (66)
        ALU when (IR(15 downto 9) = "1000011") else                     --BR (67)
        ALU when (IR(15 downto 9) = "1000100" and flags (1) = '1') else --BR.N (68)
        ALU when (IR(15 downto 9) = "1000101" and flags (0) = '1') else --BR.Z (69)
        ALU when (IR(15 downto 9) = "1000110") else                     --BR.SUB (70)
        ALU when (IR(15 downto 9) = "1000111") else                     --RETURN (71)
        (others => '0');                                                --Keep at 0 any other time
    
    pipe_flush <= branch_internal;
    branch <= branch_internal;
    
    --RAM Access
    ram_wr <= '1' when (IR(15 downto 9) = "0010001") else '0';  --STR (17)
    ram_addrb <= A_in(15 downto 0) when (IR(15 downto 9) = "0010001") else --STR Rb (17)
                 B_in(15 downto 0) when (IR(15 downto 9) = "0010000") else --LD Ra (16)
                 (others=>'0');
--    Mem_out <= ram_datab;
    
        


end Behavioral;
