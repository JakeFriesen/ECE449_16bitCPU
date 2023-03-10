----------------------------------------------------------------------------------
-- Company: University of Victoria ECE 449
-- Engineer: Jake Friesen
-- 
-- Create Date: 01/30/2023 08:28:20 PM
-- Module Name: ALU - Behavioral
-- Project Name: 16-bit CPU
-- Target Devices: Basys3 FPGA
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
           v_result: out STD_LOGIC_VECTOR (15 downto 0);
           Z : out STD_LOGIC;
           N : out STD_LOGIC;
           V: out STD_LOGIC
           );
end ALU;

architecture Behavioral of ALU is
    signal mul_result_int: std_logic_vector(31 downto 0);
    signal result_int, V_result_int: std_logic_vector (15 downto 0);
    signal V_int: std_logic;
    signal v_check: std_logic_vector(31 downto 0);
    signal V_temp: std_logic;
begin
    --Main ALU Process
    process(A, B, sel) 
    begin
       -- v_check <= "000";
        case sel is
            when "000" => result_int <= (others=>'0');                                                      --NOP (TODO: Shouldn't update flags?)
            when "001" => result_int <= A + B;                                           --ADD             
                V_temp <= (A(15) XNOR B(15)) AND result_int(15);
            when "010" => result_int <= A - B;
                V_temp <= (A(15) NOR B(15)) AND result_int(15);                                                --SUB
            when "011" => mul_result_int <= A * B;  
            when "100" => result_int(15 downto 0) <= A(15 downto 0) NAND B(15 downto 0);                                                           --NAND
            when "101" => result_int <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B)))); --SHL
            when "110" => result_int <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B))));--SHR
            when "111" => result_int <= A;                                                                  --TEST
            when others => result_int <= (others => 'X');                                                   --Should never see this
        end case;
    end process;
             
    --Overflow Flag   
    v_check <= mul_result_int(31 downto 0) AND X"FFFF0000";

    with v_check Select
                        V_int <= '0' when X"00000000",
                        '1' when others;
    with sel Select
                    V <= V_int when "011",
                    (A(15) XNOR B(15)) AND result_int(15) when "001",
                    (A(15) XOR B(15)) AND (A(15) XOR result_int(15)) when "010",
                    '0' when others;
    --Zero Flag
    Z <= '1' when result_int(15 downto 0) = x"0000" else '0';
    --Negative Flag
    N <= '1' when result_int(15) = '1' else '0';
    --Result Register 
    with sel Select
        result <= mul_result_int(15 downto 0) when "011",
                  result_int(15 downto 0) when others;            
              
    --overflow data register 
    with sel Select
        v_result <= mul_result_int(31 downto 16) when "011",
                    X"0000" when others;  
                    
   
end Behavioral;
