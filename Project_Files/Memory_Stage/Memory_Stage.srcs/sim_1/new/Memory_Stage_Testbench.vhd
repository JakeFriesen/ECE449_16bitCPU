----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/19/2023 01:36:39 PM
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
    component Memory_Stage is
    Port ( ALU_in : in STD_LOGIC_VECTOR (15 downto 0);
           IR_in : in STD_LOGIC_VECTOR (15 downto 0);
           V : in STD_LOGIC;
           N : in STD_LOGIC;
           Z : in STD_LOGIC;
           clk, rst : in STD_LOGIC;
           branch : out STD_LOGIC;
           branch_addr : out STD_LOGIC_VECTOR (5 downto 0);
           ram_wr : out STD_LOGIC;
           ram_addrb : out STD_LOGIC_VECTOR (5 downto 0);
           ram_datab : in STD_LOGIC_VECTOR (15 downto 0);
           Mem_out : out STD_LOGIC_VECTOR (15 downto 0);
           ALU_out : out STD_LOGIC_VECTOR (15 downto 0);
           IR_out : out STD_LOGIC_VECTOR (15 downto 0);
           Overflow_in, A_in, B_in : in STD_LOGIC_VECTOR (15 downto 0);
           Overflow_out : out STD_LOGIC_VECTOR (15 downto 0));
    end component Memory_Stage;
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
    --Signals
    signal wr_en, ram_ena, ram_enb, branch_choice, clk, rst : std_logic;
    signal douta, doutb, dina, IR, ALU, Overflow_in, Overflow_out, A, B : std_logic_vector(15 downto 0);
    signal addra, addrb : std_logic_vector (5 downto 0); 
    signal V, N, Z : std_logic; 
   -- Test Vectors
    type test_vector is record
        ALU, Overflow, IR : std_logic_vector (15 downto 0);
        branch_addr : std_logic_vector (5 downto 0);
        Z, N, V, branch : std_logic;
    end record;
    type test_vector_array is array (natural range <>) of test_vector;
    constant test_array : test_vector_array := (
        (ALU=>x"aaaa", Overflow=>x"dead",IR=>x"0001",V=>'0',Z=>'0',N=>'0', branch_addr=>"000000", branch=>'0'), 
        (ALU=>x"5555", Overflow=>x"beef",IR=>x"0003",V=>'0',Z=>'0',N=>'0', branch_addr=>"000000", branch=>'0'),
        (ALU=>x"1111", Overflow=>x"4444",IR=>x"0000",V=>'0',Z=>'0',N=>'0', branch_addr=>"000000", branch=>'0'),
        (ALU=>x"dead", Overflow=>x"1111",IR=>x"0000",V=>'0',Z=>'0',N=>'0', branch_addr=>"000000", branch=>'0'),
        (ALU=>x"deef", Overflow=>x"aaaa",IR=>x"0000",V=>'0',Z=>'0',N=>'0', branch_addr=>"000000", branch=>'0'),
        (ALU=>x"4444", Overflow=>x"5555",IR=>x"0000",V=>'0',Z=>'0',N=>'0', branch_addr=>"000000", branch=>'0'),
        (ALU=>x"8888", Overflow=>x"0000",IR=>x"0000",V=>'0',Z=>'0',N=>'0', branch_addr=>"000000", branch=>'0'),
        (ALU=>x"0000", Overflow=>x"1234",IR=>x"0000",V=>'0',Z=>'0',N=>'0', branch_addr=>"000000", branch=>'0')
    );   
    
begin
    RAM_inst : RAM port map (douta=>douta, doutb=>doutb, addra=>addra, addrb=>addrb, dina=>dina, wr_en=>wr_en, ena=>ram_ena, enb=>ram_enb, clk=>clk, rst=>rst);
    MEM_Stage : Memory_Stage port map (clk=>clk, rst=>rst, IR_in=>IR, ALU_in=>ALU, V=>V, N=>N, Z=>Z, Overflow_in=>Overflow_in, Overflow_out=>Overflow_out, ram_addrb=>addrb, ram_datab=>doutb,ram_wr=>wr_en, A_in=>A, B_in=>B );

    process begin
        clk <= '0';
        wait for 1us;
        clk <= '1';
        wait for 1us;
    end process;

    process begin
        rst <= '0';
        ram_ena <= '0';
        ram_enb <= '1';
        for i in test_array'range loop
            wait until clk = '0';
            ALU <= test_array(i).ALU;
            IR <= test_array(i).IR;
            N <= test_array(i).N;
            V <= test_array(i).V;
            Z <= test_array(i).Z;
            Overflow_in <= test_array(i).Overflow;
            wait until clk <= '1';
        
        end loop;
        
    
        wait;
    end process;


end tb;
