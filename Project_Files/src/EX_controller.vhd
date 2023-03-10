
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use ieee.std_logic_unsigned.all;

--entity EX_control is
--    Port ( 
--           opcode : in STD_LOGIC_VECTOR (6 downto 0);
--           ALU_sel : out STD_LOGIC_VECTOR (2 downto 0);
--           data_sel : out STD_LOGIC_VECTOR (0 downto 0)
--           );
         
--end  EX_control ;

--architecture Behavioral of EX_control  is


    
--signal ALU_B,ALU_A , v_result: STD_LOGIC_VECTOR (15 downto 0);


--ALU_sel <= "000"; 
--B_sel <= "1"; 
--data_sel <= "1"; --Nothing    
--begin
--    process(opcode)
--    begin
    
--        case opcode is
        
--            when "0000000" =>               --Nothing
--                            ALU_sel <= "000"; 
--                           -- B_sel <= "1"; 
--                            data_sel <= "1"; 
--            when "0000001" =>               --ADD
--                            ALU_sel <= "001"; 
--                           -- B_sel <= "1"; 
--                            data_sel <= "1"; 
--            when "0000010" =>               --SUB
--                            ALU_sel <= "010"; 
--                           -- B_sel <= "1"; 
--                            data_sel <= "1";
--            when "0000011" =>               --
--                            ALU_sel <= "011"; 
--                           -- B_sel <= "1"; 
--                            data_sel <= "1"; 
--            when "0000100" =>
--                            ALU_sel <= "100"; 
--                            B_sel <= "1"; 
--                            data_sel <= "1"; 
--            when "0000101" =>
--                            ALU_sel <= "101"; 
--                           -- B_sel <= "1"; 
--                            data_sel <= "1"; 
--            when "0000110" =>
--                            ALU_sel <= "110"; 
--                           -- B_sel <= "1"; 
--                            data_sel <= "1"; 
--            when "0000111" =>
--                            ALU_sel <= "111"; 
--                           -- B_sel <= "1"; 
--                            data_sel <= "1";
--            when "0010000" =>
--                            ALU_sel <= "000"; 
--                          --  B_sel <= "1"; 
--                            data_sel <= "1"; 
--            when "0010001" =>
--                            ALU_sel <= "000"; 
--                          --  B_sel <= "1"; 
--                            data_sel <= "1"; 
--            when  others   =>
--                            ALU_sel <= "000"; 
--                          --  B_sel <= "1"; 
--                            data_sel <= "1"; 
     
--        end case;
        
--    end process;
--end Behavioral;

-- 
----------------------------------------------------------------------------------

