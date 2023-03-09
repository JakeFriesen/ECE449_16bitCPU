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
           wr_en : out std_logic;
           v_en : out std_logic;
           loadIMM: out std_logic;
           load_align: out std_logic;
           V_data : out STD_LOGIC_VECTOR (15 downto 0));   
end Write_Back_Stage;

architecture Behavioral of Write_Back_Stage is
    signal ALU, Overflow, IR, input_port, Mem : std_logic_vector (15 downto 0);
    
    
    -- Op Codes
    constant nop_op : std_logic_vector(6 downto 0)  := "0000000";
    constant add_op : std_logic_vector(6 downto 0)  := "0000001";
    constant sub_op : std_logic_vector(6 downto 0)  := "0000010";
    constant mul_op : std_logic_vector(6 downto 0)  := "0000011";
    constant nand_op : std_logic_vector(6 downto 0) := "0000100";
    constant shl_op : std_logic_vector(6 downto 0)  := "0000101";
    constant shr_op : std_logic_vector(6 downto 0)  := "0000110";
    constant test_op : std_logic_vector(6 downto 0) := "0000111";
    constant out_op : std_logic_vector(6 downto 0)  := "0100000";
    constant in_op : std_logic_vector(6 downto 0)   := "0100001";
    constant store_op : std_logic_vector(6 downto 0)   := "0010001";
    constant load_op : std_logic_vector(6 downto 0)   := "0010000";
    constant loadIMM_op : std_logic_vector(6 downto 0)   := "0010010";
    constant mov_op : std_logic_vector(6 downto 0)   := "0010011";
    
begin
    --Latch Process
    process(clk)
    begin
--        if(rst = '1') then
--        --Reset
--            wr_data <= (others=>'0');
--            wr_addr <= (others=>'0');
--            V_data <= (others=>'0');
--        end if;    
        if(clk'event and clk = '1') then
            if(rst = '1') then
            --Reset
                ALU <= (others=>'0');
                IR <= (others=>'0');
                Overflow <= (others=>'0');
                input_port <= (others=>'0');
                Mem <= (others=>'0');
            else
            --Latch Incoming signals
                ALU <= ALU_in;
                IR <= IR_in;
                Overflow <= Overflow_in;
                input_port <= IN_PORT;
                Mem <= Mem_in;
            end if;
        end if;
        if(clk'event and clk = '0') then
            --Nothing to Latch
        end if;
    end process;

    --Output Signals - Combinational, Latched at Register File
    --TODO: Clean this up, add some constants for the opcodes
    wr_data <=
        "00000000" & IR(7 downto 0) when (IR(15 downto 9) = loadIMM_op) else  --Load lower (18) (TODO: Need to fix the zeros)
        input_port when IR(15 downto 9) = in_op else                    --IN (33)
        Mem when IR(15 downto 9) = load_op else 
        Mem when IR(15 downto 9) = mov_op else                           --MOV (16)
        (others=>'0') when IR(15 downto 9) = nop_op else                 --NOP, set all 0
        ALU;-- when IR(15 downto 9) = "" else                               --ALU for the rest (TODO: May need to specify)
        --(others=>'0'); 
    wr_addr <=
        "111" when IR(15 downto 9) = loadIMM_op else                         --Load Imm (18) Load into R7
        "111" when IR(15 downto 9) = "1000110" else                         --Branch Sub (R7 <= PC+1)
        "000" when IR(15 downto 9) = nop_op else                         --NOP, set all 0
        IR(8 downto 6);                                                     --LOAD, ALU ops (TODO: May need to specify)
    v_en <= 
        '1' when IR(15 downto 9) = mul_op else   --MUL (3)
        '0';
    wr_en <=
        '1' when IR(15 downto 9) = add_op else   --ADD(1)
        '1' when IR(15 downto 9) = sub_op else   --SUB(2)
        '1' when IR(15 downto 9) = mul_op else   --MUL(3)
        '1' when IR(15 downto 9) = nand_op else   --NAND(4)
        '1' when IR(15 downto 9) = shl_op else   --SHL(5)
        '1' when IR(15 downto 9) = shr_op else   --SHR(6)
        '1' when IR(15 downto 9) = in_op else   --IN(33)
        '1' when IR(15 downto 9) = load_op else   --LOAD(16)
        '1' when IR(15 downto 9) = loadIMM_op else   --LOADIMM(18)
        '1' when IR(15 downto 9) = MOV_op else   --MOV
        '1' when IR(15 downto 9) = "1000110" else   --BR.SUB(70)
        '0';
        
    loadIMM <=    '1' when IR(15 downto 9) = loadIMM_op else '0';
    load_align <= IR(8);
    V_data <= Overflow;


end Behavioral;
