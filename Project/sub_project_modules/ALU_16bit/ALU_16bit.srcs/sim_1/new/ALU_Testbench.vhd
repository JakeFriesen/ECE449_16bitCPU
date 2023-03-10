----------------------------------------------------------------------------------
-- Company: University of Victoria ECE 449
-- Engineer: Jake Friesen
-- 
-- Create Date: 01/30/2023 08:28:20 PM
-- Module Name: ALU - Testbench
-- Project Name: 16-bit CPU
-- Target Devices: Basys3 FPGA
-- Description: Testbench for ALU with simple vector tests
-- 
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
         Port ( A : in STD_LOGIC_VECTOR (15 downto 0);
            B : in STD_LOGIC_VECTOR (15 downto 0);
            sel : in STD_LOGIC_VECTOR (2 downto 0);
            result : out STD_LOGIC_VECTOR (15 downto 0);
            v_result: out STD_LOGIC_VECTOR (15 downto 0);
            Z : out STD_LOGIC;
            N : out STD_LOGIC;
            V: out STD_LOGIC);
    end component ALU;
    
    -- Test Vectors
    type test_vector is record
        a, b, result : std_logic_vector (15 downto 0);
        sel : std_logic_vector (2 downto 0);
        Z, N : std_logic;
    end record;
    type test_vector_array is array (natural range <>) of test_vector;
    constant test_array : test_vector_array := (
        (A=>x"F000", B=>x"0234",sel=>"001",result=>x"0000",Z=>'1',N=>'0'),   --NOP
        (A=>x"7FFF", B=>x"7FFF",sel=>"001",result=>x"0002",Z=>'0',N=>'0'),   --ADD 1 + 1 = 2
        (A=>x"7FFF", B=>x"0002",sel=>"011",result=>x"0004",Z=>'0',N=>'0'),   --SUB 5 - 1 = 4
        (A=>x"0002", B=>x"0500",sel=>"011",result=>x"0010",Z=>'0',N=>'0'),   --MUL 2 * 8 = 16
        (A=>x"F000", B=>x"00AA",sel=>"010",result=>x"FFFF",Z=>'0',N=>'1'),   --NAND 55 NAND AA = FFFF, negative
        (A=>x"0001", B=>x"0002",sel=>"010",result=>x"0004",Z=>'0',N=>'0'),   --SHL 2 << 1 = 4
        (A=>x"0FFF", B=>x"F000",sel=>"010",result=>x"0002",Z=>'0',N=>'0')   --SHR 16 >> 3 = 2   --TEST N=1, Z=0
    );
    --Test Signals
    signal A, B, result : std_logic_vector(15 downto 0);
    signal v_result: std_logic_vector(15 downto 0);
    signal sel : std_logic_vector(2 downto 0);
    signal Z, N, V : std_logic;
    signal clk : std_logic;
    
begin
    UUT : ALU port map(A=>A, B=>B, sel=>sel, result=>result, v_result=>v_result, Z=>Z, N=>N, V=>V);
    
    process begin
        for i in test_array'range loop
            A <= test_array(i).A;
            B <= test_array(i).B;
            sel <= test_array(i).sel;
            
            clk <= '0';
           wait for 30ns;
           clk <= '1';
           wait for 30ns;
            
           assert(result = test_array(i).result and 
                   Z = test_array(i).Z and
                   N = test_array(i).N)
                   
           report "test_array " & integer'image(i) & " failed!" --TOOD: How to cast vectors to strings?
                  severity error;
            
        end loop;
        wait;
    end process;

end tb;
