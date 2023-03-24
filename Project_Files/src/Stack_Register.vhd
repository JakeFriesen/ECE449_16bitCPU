----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/16/2023 03:45:07 PM
-- Design Name: 
-- Module Name: Stack_Register - Behavioral
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

library work;
use work.Constant_Package.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Stack_Register is
    Port ( SP_in : in STD_LOGIC_VECTOR (15 downto 0);
           SP_out : out STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           halt : in STD_LOGIC;
           IR_in : in STD_LOGIC_VECTOR (15 downto 0));
end Stack_Register;

architecture Behavioral of Stack_Register is
    signal stack_pointer_internal, next_stack_pointer, stack_result, stack_out : std_logic_vector (15 downto 0) := stack_address;
--    signal next_stack_pointer : std_logic_vector (15 downto 0) := x"0100";
    
begin
    --Latching Process
    process(clk)
    begin
        if falling_edge(clk) then
            if(rst = '1') then
                stack_pointer_internal <= (others=>'0');
            else    
                stack_pointer_internal <= next_stack_pointer;
            end if;                
        end if;
    end process;


-- Stack Pointer must be set to
-- SP + 1 when pop or when rti
-- SP - 1 when push
-- SP_in when load_sp
-- SP otherwise (no change)
SP_out <= stack_pointer_internal when halt = '1' else
          stack_pointer_internal when IR_in(15 downto 9) = push_op else
          stack_pointer_internal + 1 when IR_in(15 downto 9) = pop_op else
          stack_pointer_internal;

next_stack_pointer <= stack_pointer_internal when halt = '1' else
                      stack_pointer_internal - 1 when IR_in(15 downto 9) = push_op else
                      stack_pointer_internal + 1 when IR_in(15 downto 9) = pop_op else
                      stack_pointer_internal;

end Behavioral;
