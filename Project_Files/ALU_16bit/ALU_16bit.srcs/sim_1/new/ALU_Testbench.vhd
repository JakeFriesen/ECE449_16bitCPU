----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/31/2023 03:48:36 PM
-- Design Name: 
-- Module Name: ALU_Testbench - Behavioral
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
use ieee.std_logic_textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU_Testbench is
end ALU_Testbench;

architecture tb of ALU_Testbench is
    --ALU Component
    component ALU is 
        port(
        A, B : in std_logic_vector (15 downto 0);
        sel : in std_logic_vector (2 downto 0);
        result : out std_logic_vector (15 downto 0);
        Z, N : out std_logic
    );
    end component ALU;
    -- Test Vectors
    type test_vector is record
        a, b, result : std_logic_vector (15 downto 0);
        sel : std_logic_vector (2 downto 0);
        Z, N : std_logic;
    end record;
    type test_vector_array is array (natural range <>) of test_vector;
    constant test_array : test_vector_array := (
        (A=>x"0001", B=>x"0001",sel=>"001",result=>x"0002",Z=>'0',N=>'0'),   --ADD 1 + 1 = 2
        (A=>x"0005", B=>x"0001",sel=>"010",result=>x"0004",Z=>'0',N=>'0'),   --SUB 5 - 1 = 4
        (A=>x"0002", B=>x"0008",sel=>"011",result=>x"0010",Z=>'0',N=>'0'),   --MUL 2 * 8 = 16 (This one has an issue right now)
        (A=>x"0055", B=>x"00AA",sel=>"100",result=>x"FFFF",Z=>'0',N=>'1')    --NAND 55 NAND AA = FFFF, negative
    );
    --Test Signals
    signal A, B, result : std_logic_vector(15 downto 0);
    signal sel : std_logic_vector(2 downto 0);
    signal Z, N : std_logic;
    
begin
    UUT : ALU port map(A=>A, B=>B, sel=>sel, result=>result, Z=>Z, N=>N);
    
    process begin
        for i in test_array'range loop
            A <= test_array(i).A;
            B <= test_array(i).B;
            sel <= test_array(i).sel;
            
           wait for 30ns;
            
           assert(result = test_array(i).result and 
                   Z = test_array(i).Z and
                   N = test_array(i).N)
                   
           report "test_array" & integer'image(i) & "failed"
                  severity error;
            
        end loop;
        wait;
    end process;

end tb;
