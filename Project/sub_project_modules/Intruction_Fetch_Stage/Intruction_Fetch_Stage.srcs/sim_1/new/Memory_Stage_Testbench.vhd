----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2023 01:12:58 PM
-- Design Name: 
-- Module Name: Memory_Stage_Testbench - tb
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

entity Memory_Stage_Testbench is
end Memory_Stage_Testbench;

architecture tb of Memory_Stage_Testbench is
    --RAM
    component RAM is
    Port ( douta : out STD_LOGIC_VECTOR (15 downto 0);
           doutb : out STD_LOGIC_VECTOR (15 downto 0);
           addra : in std_logic_vector (5 downto 0);
           addrb : in std_logic_vector (5 downto 0);
           dina : in std_logic_vector (15 downto 0);
           wr_en : in std_logic;
           ena : in std_logic;
           enb : in std_logic;
           clk : in std_logic;
           rst : in std_logic);
    end component RAM;
    component Intruction_Fetch_Stage is
        Port ( IR : out STD_LOGIC_VECTOR (15 downto 0);
               NPC : out STD_LOGIC_VECTOR (5 downto 0);
               clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               PC_in : in STD_LOGIC_VECTOR (5 downto 0);
               ram_addr : out std_logic_vector (5 downto 0);
               ram_data : in std_logic_vector (15 downto 0);
               br_in : in STD_LOGIC);
    end component Intruction_Fetch_Stage;
    --Signals
    signal wr_en, ram_ena, ram_enb, branch_choice, clk, rst : std_logic;
    signal douta, doutb, dina, IR : std_logic_vector(15 downto 0);
    signal addra, addrb, PC_branch, NPC : std_logic_vector (5 downto 0);  
    -- Test Vectors
--    type test_vector is record
--        a, b, result : std_logic_vector (15 downto 0);
--        sel : std_logic_vector (2 downto 0);
--        Z, N : std_logic;
--    end record;
--    type test_vector_array is array (natural range <>) of test_vector;
--    constant test_array : test_vector_array := (
--        (A=>x"aaaa", B=>x"1234",sel=>"000",result=>x"0000",Z=>'1',N=>'0'),   --NOP
--        (A=>x"0001", B=>x"0001",sel=>"001",result=>x"0002",Z=>'0',N=>'0'),   --ADD 1 + 1 = 2
--        (A=>x"0005", B=>x"0001",sel=>"010",result=>x"0004",Z=>'0',N=>'0'),   --SUB 5 - 1 = 4
--        (A=>x"0002", B=>x"0008",sel=>"011",result=>x"0010",Z=>'0',N=>'0'),   --MUL 2 * 8 = 16
--        (A=>x"0055", B=>x"00AA",sel=>"100",result=>x"FFFF",Z=>'0',N=>'1'),   --NAND 55 NAND AA = FFFF, negative
--        (A=>x"0002", B=>x"0001",sel=>"101",result=>x"0004",Z=>'0',N=>'0'),   --SHL 2 << 1 = 4
--        (A=>x"0010", B=>x"0003",sel=>"110",result=>x"0002",Z=>'0',N=>'0'),   --SHR 16 >> 3 = 2
--        (A=>x"fffe", B=>x"0000",sel=>"111",result=>x"fffe",Z=>'0',N=>'1')    --TEST N=1, Z=0
--    );  
begin
    IF_ID : Intruction_Fetch_Stage port map(IR=>IR, NPC=>NPC, clk=>clk, rst=>rst, PC_in=>PC_branch, ram_addr=>addra, ram_data=>douta, br_in=>branch_choice);
    RAM_inst : RAM port map (douta=>douta, doutb=>doutb, addra=>addra, addrb=>addrb, dina=>dina, wr_en=>wr_en, ena=>ram_ena, enb=>ram_enb, clk=>clk, rst=>rst);
    
    process begin
        clk <= '1';
        wait for 1us;
        clk <= '0';
        wait for 1us;
    end process;
    
    
    process begin
        rst <= '0';
        branch_choice <= '0';
        PC_branch <= (others=>'0');
        ram_ena <= '1';
        ram_enb <= '0';
        wr_en <= '0';
        dina <= (others=>'0');
        for i in 0 to 5 loop
            wait until clk = '1';
        end loop;
        --Change PC
        wait until clk = '0';
        PC_branch <= "010100"; --20
        branch_choice <= '1';
        wait until clk = '0';
        branch_choice <= '0';
        PC_branch <= "000000";
        
        wait;
    end process;    
    


end tb;
