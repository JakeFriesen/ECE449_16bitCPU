----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2023 01:11:56 PM
-- Design Name: 
-- Module Name: Constant_Package - Behavioral
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

package Constant_Package is
    --Generic constants - Instruction Opcodes
    constant nop_op : std_logic_vector(6 downto 0) := "0000000";        --NOP (0)
    constant add_op : std_logic_vector(6 downto 0) := "0000001";        --ADD (1)
    constant sub_op : std_logic_vector(6 downto 0) := "0000010";        --SUB (2)
    constant mul_op : std_logic_vector(6 downto 0) := "0000011";        --MUL (3)
    constant nand_op : std_logic_vector(6 downto 0) := "0000100";       --NAND (4)
    constant shl_op : std_logic_vector(6 downto 0) := "0000101";        --SHL (5)
    constant shr_op : std_logic_vector(6 downto 0) := "0000110";        --SHR (6)
    constant test_op : std_logic_vector(6 downto 0) := "0000111";       --TEST (7)
   
    constant brr_op : std_logic_vector(6 downto 0) := "1000000";        --BRR (64)
    constant brr_n_op : std_logic_vector(6 downto 0) := "1000001";      --BRR.N (65)
    constant brr_z_op : std_logic_vector(6 downto 0) := "1000010";      --BRR.Z (66)
    constant br_op : std_logic_vector(6 downto 0) := "1000011";         --BR (67)
    constant br_n_op : std_logic_vector(6 downto 0) := "1000100";       --BR.N (68)
    constant br_z_op : std_logic_vector(6 downto 0) := "1000101";       --BR.Z (69)
    constant br_sub_op : std_logic_vector(6 downto 0) := "1000110";
    constant return_op : std_logic_vector(6 downto 0) := "1000111";
    constant out_op : std_logic_vector(6 downto 0)  := "0100000";
    constant in_op : std_logic_vector(6 downto 0)   := "0100001";
    
    constant load_op : std_logic_vector(6 downto 0) := "0010000";       --LOAD (16)
    constant store_op : std_logic_vector(6 downto 0) := "0010001";      --STORE (17)
    constant loadIMM_op : std_logic_vector(6 downto 0) := "0010010";    --LD IMM (18)
    constant mov_op : std_logic_vector(6 downto 0) := "0010011";        --MOV (19)
    
end package Constant_Package;

package body Constant_Package is
    --Add some generic functions here
end package body Constant_Package;
