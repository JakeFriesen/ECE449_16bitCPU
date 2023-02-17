----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/06/2023 04:36:14 PM
-- Design Name: 
-- Module Name: main_V0_1 - Behavioral
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



entity CPU_main is
    port( 	
        cpu_clk:	in std_logic;
        rst: in STD_LOGIC;
        addr: in std_logic_vector(5 downto 0);
        in_port: in STD_LOGIC_VECTOR (15 downto 0);
        out_port: out STD_LOGIC_VECTOR (15 downto 0);
        reg_write_data: in STD_LOGIC_VECTOR(15 downto 0);
        reg_write_index: in STD_LOGIC_VECTOR(2 downto 0);
        reg_write_enable: in STD_LOGIC
        );
end CPU_main;



architecture structure of CPU_main is

--ALU
component ALU is
    port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           B : in STD_LOGIC_VECTOR (15 downto 0);
           sel : in STD_LOGIC_VECTOR (2 downto 0);
           result : out STD_LOGIC_VECTOR (15 downto 0);
           Z : out STD_LOGIC;
           N : out STD_LOGIC
           );
end component;


component register_file is

    port(
        rst : in std_logic; 
        clk: in std_logic;
        --read signals
        rd_index1: in std_logic_vector(2 downto 0); 
        rd_index2: in std_logic_vector(2 downto 0); 
        rd_data1: out std_logic_vector(15 downto 0); 
        rd_data2: out std_logic_vector(15 downto 0);
        --write signals
        wr_index: in std_logic_vector(2 downto 0); 
        wr_data: in std_logic_vector(15 downto 0); 
        wr_enable: in std_logic
        );
       
end component;


component IR_16bit is

     port(
        rst : in std_logic; 
        clk: in std_logic;
        instr_data: in std_logic_vector(15 downto 0);
        opcode: out std_logic_vector(6 downto 0);
        Ra: out std_logic_vector(2 downto 0);
        Rb: out std_logic_vector(2 downto 0);
        Rc: out std_logic_vector(2 downto 0)
        );
             
end component;

component IF_ID_buf is

    port(
        rst : in std_logic; 
        clk: in std_logic;
        opcode_in: in std_logic_vector(6 downto 0);
        Ra_in: in std_logic_vector(2 downto 0);
        Rb_in: in std_logic_vector(2 downto 0);
        Rc_in: in std_logic_vector(2 downto 0);
        opcode_out: out std_logic_vector(6 downto 0);
        Ra_out: out std_logic_vector(2 downto 0);
        Rb_out: out std_logic_vector(2 downto 0);
        Rc_out: out std_logic_vector(2 downto 0)
        );
        
end component;


component ID_EX_buf is

    port(
        rst : in std_logic; 
        clk: in std_logic;
        sel_in: in std_logic_vector(2 downto 0);
        A_in: in std_logic_vector(15 downto 0);
        B_in: in std_logic_vector(15 downto 0);
        sel_out: out std_logic_vector(2 downto 0);
        A_out: out std_logic_vector(15 downto 0);
        B_out: out std_logic_vector(15 downto 0)
        );
        
end component;

signal opcode_in, opcode_out: std_logic_vector(6 downto 0);
signal Ra_in, Rb_in, Rc_in, Ra_out, Rb_out, Rc_out, sel: std_logic_vector(2 downto 0);

signal result, rd_data1, rd_data2, wr_data, A, B: std_logic_vector(15 downto 0);
signal ALU_Z, ALU_N: std_logic; 

begin

    IR_0: IR_16bit port map (rst, cpu_clk, in_port, opcode_in, Ra_in, Rb_in, Rc_in);
    IF_ID_buf_0: IF_ID_buf port map (rst, cpu_clk, opcode_in, Ra_in, Rb_in, Rc_in, opcode_out, Ra_out, Rb_out, Rc_out); 
    register_file_0: register_file port map(rst, cpu_clk, Rb_out, Rc_out, rd_data1, rd_data2, reg_write_index, reg_write_data, reg_write_enable);
    ID_EX_buf_0: ID_EX_buf port map (rst, cpu_clk, opcode_out(2 downto 0), rd_data1, rd_data2 ,sel, A, B); 
    ALU_0: ALU port map( A, B, sel, result, ALU_Z, ALU_N);
   --out_port <= opcode_out & Ra_out & Rb_out & Rc_out;
    out_port <= result;
end structure;
