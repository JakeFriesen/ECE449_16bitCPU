----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/07/2023 04:27:08 PM
-- Design Name: 
-- Module Name: Top_Level - Behavioral
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

entity Top_Level is
    Port ( In_Port : in STD_LOGIC_VECTOR (15 downto 0);
           Out_Port : out STD_LOGIC_VECTOR (15 downto 0));
end Top_Level;

architecture Behavioral of Top_Level is
    component ALU is
        Port ( A : in STD_LOGIC_VECTOR (15 downto 0);
               B : in STD_LOGIC_VECTOR (15 downto 0);
               sel : in STD_LOGIC_VECTOR (2 downto 0);
               result : out STD_LOGIC_VECTOR (15 downto 0);
               clk : in std_logic;
               Z : out STD_LOGIC;
               N : out STD_LOGIC);
    end component ALU;
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
    component ROM is
        Port ( addr : in STD_LOGIC_VECTOR (5 downto 0);
               clk : in std_logic;
               rst : in std_logic;
               en : in std_logic;
               data : out STD_LOGIC_VECTOR (15 downto 0));
    
    end component ROM;
    component register_file is
        port(rst : in std_logic; clk: in std_logic;
            rd_index1: in std_logic_vector(2 downto 0); 
            rd_index2: in std_logic_vector(2 downto 0); 
            rd_data1: out std_logic_vector(15 downto 0); 
            rd_data2: out std_logic_vector(15 downto 0);
            wr_index: in std_logic_vector(2 downto 0); 
            wr_data: in std_logic_vector(15 downto 0); 
            wr_enable: in std_logic);
    end component register_file;
    component PC is
        Port ( clk : in STD_LOGIC;
               load : in STD_LOGIC;
               PC_out : out STD_LOGIC_VECTOR (5 downto 0);
               PC_in : in STD_LOGIC_VECTOR (5 downto 0);
               inc : in STD_LOGIC;
               rst : in STD_LOGIC);
    end component PC;
--Signals
signal clk, rst, Z, N, wr_en, ram_ena, ram_enb, rom_en, wr_enable, inc_PC, load_PC : std_logic;
signal A, B, ALU_res, douta, doutb, dina, rd_data1, rd_data2, wr_data, rom_data : std_logic_vector (15 downto 0);
signal sel, rd_index1, rd_index2, wr_index : std_logic_vector (2 downto 0);
signal rom_addr, addra, addrb, PC_in, PC_out : std_logic_vector (5 downto 0);

begin

ALU_inst : ALU port map (A => A, B=>B, sel=>sel, result=>ALU_res, clk=>clk, Z=>Z, N=>N);
RAM_inst : RAM port map (douta=>douta, doutb=>doutb, addra=>addra, addrb=>addrb, dina=>dina, wr_en=>wr_en, ena=>ram_ena, enb=>ram_enb, clk=>clk, rst=>rst);
ROM_inst : ROM port map (addr=>rom_addr, clk=>clk, rst=>rst, en=>rom_en, data=>rom_data);
REGFILE_inst : register_file port map (rst=>rst, rd_index1=>rd_index1, rd_index2=>rd_index2, rd_data1=>rd_data1, rd_data2=>rd_data2, wr_index=>wr_index, wr_data=>wr_data, wr_enable=>wr_enable, clk=>clk);
PC_inst : PC port map(clk=>clk, rst=>rst, load=>load_PC, inc=>inc_PC, PC_in=>PC_in, PC_out=>PC_out);

--Program Counter Connections



--RAM Connections
addra <= PC_out;
ram_ena <= '1'; --TODO: Control this


--ALU Connections
A <= rd_data1;
B <= rd_data2;
--sel <= --TODO

--REGFILE Connections
--rd_index1 <= 
--rd_index2 <=




end Behavioral;
