----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2023 12:39:46 PM
-- Design Name: 
-- Module Name: Stage_Overview - Behavioral
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

entity Stage_Overview is
    Port ( In_Port : in STD_LOGIC_VECTOR (15 downto 0);
           Out_Port : out STD_LOGIC_VECTOR (15 downto 0);
           clk, rst : in std_logic
           );
end Stage_Overview;

architecture Behavioral of Stage_Overview is
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
    signal wr_en, ram_ena, ram_enb, branch_choice : std_logic;
    signal douta, doutb, dina, IR : std_logic_vector(15 downto 0);
    signal addra, addrb, PC_branch, NPC : std_logic_vector (5 downto 0);    
begin
    IF_ID : Intruction_Fetch_Stage port map(IR=>IR, NPC=>NPC, clk=>clk, rst=>rst, PC_in=>PC_branch, ram_addr=>addra, ram_data=>douta, br_in=>branch_choice);
    RAM_inst : RAM port map (douta=>douta, doutb=>doutb, addra=>addra, addrb=>addrb, dina=>dina, wr_en=>wr_en, ena=>ram_ena, enb=>ram_enb, clk=>clk, rst=>rst);
    
    
    
    

end Behavioral;
