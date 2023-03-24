----------------------------------------------------------------------------------
-- Course: University of Victoria
-- Engineer: Jake Friesen, Matthew Ebert, Samuel Pacheo 
-- 
-- Create Date: 2023-Mar-09

-- Module Name: Write_Back_Stage - Behavioral
-- Project Name: 16bitCPU
-- Target Devices: Artix7
-- Description: 
-- 
-- Dependencies: 
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.Constant_Package.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Write_Back_Stage is
    Port ( clk, rst : in std_logic;
           Result_WB_in : in STD_LOGIC_VECTOR (15 downto 0);
           Overflow_in : in STD_LOGIC_VECTOR (15 downto 0);
           memdata_WB_in : in STD_LOGIC_VECTOR (15 downto 0);
           IR_WB_in : in STD_LOGIC_VECTOR (15 downto 0);
           IN_PORT : in STD_LOGIC_VECTOR (15 downto 0);
           OUT_PORT : out STD_LOGIC_VECTOR (15 downto 0);
           wr_data_WB_out : out STD_LOGIC_VECTOR (15 downto 0);
           wr_addr_WB_out : out STD_LOGIC_VECTOR (2 downto 0);
           wr_enable_WB_out : out std_logic;
           ov_en_WB_out : out std_logic;
           loadIMM_WB_out: out std_logic;
           load_align_WB_out: out std_logic;
           ov_data_WB_out : out STD_LOGIC_VECTOR (15 downto 0));   
end Write_Back_Stage;

architecture Behavioral of Write_Back_Stage is
    signal Result, Overflow, IR, input_port, Mem, out_port_internal, out_port_previous : std_logic_vector (15 downto 0):= (others=>'0');
    signal OPCODE : std_logic_vector (6 downto 0):= (others=>'0');

    
begin
    --Latch Process
    process(clk)
    begin
        if(clk'event and clk = '1') then
            if(rst = '1') then
            --Reset
                Result <= (others=>'0');
                IR <= (others=>'0');
                Overflow <= (others=>'0');
              --  input_port <= (others=>'0');
                Mem <= (others=>'0');
            else
            --Latch Incoming signals
                Result <= Result_WB_in;
                IR <= IR_WB_in;
                Overflow <= Overflow_in;
               -- input_port <= IN_PORT;
                Mem <= memdata_WB_in;
            end if;
        end if;
        if(clk'event and clk = '0') then
            if(rst = '1') then
                OUT_PORT <= (others=>'0');
                out_port_previous <= (others=>'0');
            else
                OUT_PORT <= out_port_internal;
                out_port_previous <= out_port_internal;
            end if;
        end if;
    end process;


    OPCODE <= IR(15 downto 9);
    --Output Signals - Combinational, Latched at Register File
    with OPCODE select
        wr_addr_WB_out <=
            "111" when loadIMM_op | br_sub_op,  --Load Imm (18) Load into R7
            "000" when nop_op,                  --NOP, set all 0
            IR(8 downto 6) when others;         --LOAD, ALU ops 
                
    with OPCODE select
        wr_enable_WB_out <=
            '1' when pop_op | add_op | sub_op | mul_op | nand_op | 
                     shl_op | shr_op | in_op | load_op | loadIMM_op | 
                     mov_op | br_sub_op,            
            '0' when others;
            
    with OPCODE select
        wr_data_WB_out <=
            (others=>'0') when nop_op,                      --NOP, set all 0
            "00000000" & IR(7 downto 0) when loadIMM_op,                    --Load lower (18)
            Mem when load_op | mov_op | pop_op,                             --Mem accessed
            Result when others;                                      --ALU otherwise
    
    ov_en_WB_out <= 
        '1' when OPCODE = mul_op else   --MUL (3)
        '0';
    
    loadIMM_WB_out <=    '1' when OPCODE = loadIMM_op else '0';
    load_align_WB_out <= IR(8);
    ov_data_WB_out <= Overflow;
    out_port_internal <= Mem when OPCODE = out_op else
                        out_port_previous;

end Behavioral;
