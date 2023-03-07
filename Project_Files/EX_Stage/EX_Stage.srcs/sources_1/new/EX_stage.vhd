----------------------------------------------------------------------------------
-- Company: University of Victoria ECE 449
-- Engineer: Matthew Ebert
-- 
-- Create Date: 2023-FEB-16 
-- Module Name: EX Stage - Behavioral
-- Project Name: 16-bit CPU
-- Target Devices: Basys3 FPGA
-- 
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity EX_stage is
    Port ( 
           clk: in STD_LOGIC;
           rst: in STD_LOGIC;
           I_IR: in std_logic_vector(15 downto 0);
           I_A : in STD_LOGIC_VECTOR (15 downto 0);
           I_B : in STD_LOGIC_VECTOR (15 downto 0);
--           INPUT: in STD_LOGIC_VECTOR(15 downto 0);
                   
           O_result : out STD_LOGIC_VECTOR (15 downto 0);
           O_Vdata : out STD_LOGIC_VECTOR (15 downto 0);
           O_A : out STD_LOGIC_VECTOR (15 downto 0);
           O_B : out STD_LOGIC_VECTOR (15 downto 0);
         --  O_Z : out STD_LOGIC;
          -- O_N : out STD_LOGIC;
         --  O_V : out STD_LOGIC;
        --   O_V_EN: out STD_LOGIC; 
           O_Z_OUTPUT : out std_logic;
           O_N_OUTPUT: out std_logic;
--           O_OUTPUT: out std_logic_vector(15 downto 0);
           O_IR: out std_logic_vector(15 downto 0));
         
end EX_stage;

architecture Behavioral of EX_stage is

--ALU
component ALU is
    port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           B : in STD_LOGIC_VECTOR (15 downto 0);
           sel : in STD_LOGIC_VECTOR (2 downto 0);
           result : out STD_LOGIC_VECTOR (15 downto 0);
           v_result : out STD_LOGIC_VECTOR (15 downto 0);
           Z : out STD_LOGIC;
           N : out STD_LOGIC;
           V : out STD_LOGIC
           );
end component;
    
-- signal mul_result: STD_LOGIC_VECTOR (31 downto 0);

--signal in_data_sel: std_logic;
signal ALU_A, ALU_B, IR: std_logic_vector( 15 downto 0);
signal ALU_OP: std_logic_vector (2 downto 0);
signal ALU_result, Vdata, ALU_v_result, result: std_logic_vector(15 downto 0);
signal z, n, v, v_en: std_logic;
signal z_output, n_output: std_logic := '0';
signal data_sel: std_logic;    
signal B_data, imm_data: std_logic_vector(15 downto 0);
signal OPCODE: std_logic_vector(6 downto 0);
signal result_sel,  output_sel: std_logic;

begin

   
      ALU_0: ALU port map( ALU_A, ALU_B, ALU_OP, ALU_result, ALU_v_result, Z, N, V);
       
       
       process (clk)
       begin
            
            if (clk='1' and clk'event) then 
                if(rst ='1') then
                    ALU_OP <= "000";
                else
                    IR <= I_IR;
                    ALU_OP <= I_IR(11 downto 9);
                    ALU_A <= I_A;          
                    B_data <= I_B;
                   OPCODE<= I_IR(15 downto 9);
                  --Sign extend immediate
                  if(I_IR(5) = '1') then
                    imm_data <= "1111111111" & I_IR(5 downto 0);
                  else
                      imm_data <= "0000000000" & I_IR(5 downto 0);
                  end if; 
                end if;
            end if;
            
            if (clk='0' and clk'event) then
             
                O_result <= result;
                O_Vdata <= ALU_V_RESULT;
                O_A <= I_A;
                O_B <= I_B;
               -- O_Vdata <= Vdata;
               -- O_z <= z;
              --  O_N <= n;
              --  O_V <= v;
             --   O_V_en <= v_en;
                O_Z_OUTPUT <= z_output;
                O_N_output <= n_output;
--                O_OUTPUT <= OUTPUT;
                O_IR <= IR;
            end if;
       end process;
       
        
                 
      process(ALU_OP, ALU_result)
      begin
        if(ALU_OP = "111") then       
          Z_OUTPUT <= z;
          N_OUTPUT <= n;
        else
          Z_OUTPUT <= Z_OUTPUT;
          N_OUTPUT <= N_OUTPUT;
        end if;
      end process;
      
      

        
        --OUTPUT AND INPUT PORT SELECT
        
        
        result <= ALU_result;
        
--        with OPCODE Select
--                 OUTPUT <= ALU_A when "0010000",
--                            X"0000" when others;
        
        
        
        --ALU input B select
        with ALU_OP Select
        ALU_B <= imm_data when "110",
                imm_data when "101",
                B_data when others;
        
        --overflow output select
--        with ALU_OP Select
--        data_sel<= '1' when "011",
--                '0' when others;
        
       -- V_EN <= data_sel AND V;
        
--        with V_EN Select
--        Vdata <= ALU_v_result when '1',
--                I_A when others;


     
     
end Behavioral;
