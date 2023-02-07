----------------------------------------------------------------------------------
-- Company: University of Victoria ECE 449
-- Engineer: Jake Friesen
-- 
-- Create Date: 01/30/2023 08:28:20 PM
-- Module Name: ALU - Behavioral
-- Project Name: 16-bit CPU
-- Target Devices: Basys3 FPGA
-- Description: Purely Combinational ALU design for use in the 16-bit CPU design.
-- 
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity ALU is
    Port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           B : in STD_LOGIC_VECTOR (15 downto 0);
           sel : in STD_LOGIC_VECTOR (2 downto 0);
           result : out STD_LOGIC_VECTOR (15 downto 0);
           Z : out STD_LOGIC;
           N : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
    signal result_int : std_logic_vector (15 downto 0);
    signal mult : std_logic_vector (31 downto 0);
begin
    --Main ALU Process - Pure Combinational Circuitry, No Clocking
    process(A, B, sel) 
    begin
        --Case For ALU sel
        case sel is
            when "000" => result_int <= (others=>'0');                                                      --NOP (TODO: Shouldn't update flags?)
            when "001" => result_int <= A + B;                                                              --ADD
            when "010" => result_int <= A - B;                                                              --SUB
            when "011" => result_int <= A(7 downto 0) * B(7 downto 0);                                      --MUL (TODO: Overflow, save 32-bit, specific register?)      
            when "100" => result_int <= A NAND B;                                                           --NAND
            when "101" => result_int <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B)))); --SHL
            when "110" => result_int <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B))));--SHR
            when "111" => result_int <= A;                                                                  --TEST
            when others => result_int <= (others => 'X');                                                   --Should never see this
        end case;
    end process;
    
    --TOOD: Might need to selectively control when these flags are updated.
    --Zero Flag
    Z <= '1' when result_int = x"00000" else '0';
    --Negative Flag
    N <= '1' when result_int(15) = '1' else '0';
    --Result Register
    result <= result_int;
    
end Behavioral;
