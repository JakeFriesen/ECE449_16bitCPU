----------------------------------------------------------------------------------
-- Company: University of Victoria ECE 449
-- Engineer: Jake Friesen
-- 
-- Create Date: 01/30/2023 08:28:20 PM
-- Module Name: ROM - Behavioral
-- Project Name: 16-bit CPU
-- Target Devices: Basys3 FPGA
-- 
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Library xpm;
use xpm.vcomponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ROM is
    Port ( addr : in STD_LOGIC_VECTOR (5 downto 0);
           clk : in std_logic;
           rst : in std_logic;
           en : in std_logic;
           data : out STD_LOGIC_VECTOR (15 downto 0));

end ROM;

architecture Behavioral of ROM is
    signal dbiterra, sbiterra, clka, ena, 
        injectdbiterra, injectsbiterra, 
        regcea, rsta, sleep : std_logic;
    signal douta : std_logic_vector(15 downto 0);
    signal addra : std_logic_vector(5 downto 0);
begin
-- xpm_memory_sprom: Single Port ROM
-- Xilinx Parameterized Macro, version 2018.3
xpm_memory_sprom_inst : xpm_memory_sprom
generic map (
 ADDR_WIDTH_A => 6,             -- DECIMAL
 AUTO_SLEEP_TIME => 0,          -- DECIMAL
 ECC_MODE => "no_ecc",          -- String
 MEMORY_INIT_FILE => "ROM_Test.mem",    -- String
 MEMORY_INIT_PARAM => "",      -- String
 MEMORY_OPTIMIZATION => "true", -- String
 MEMORY_PRIMITIVE => "auto",    -- String
 MEMORY_SIZE => 1024,           -- DECIMAL
 MESSAGE_CONTROL => 0,          -- DECIMAL
 READ_DATA_WIDTH_A => 16,       -- DECIMAL
 READ_LATENCY_A => 1,           -- DECIMAL
 READ_RESET_VALUE_A => "0",     -- String
-- RST_MODE_A => "SYNC",          -- String
 USE_MEM_INIT => 1,             -- DECIMAL
 WAKEUP_TIME => "disable_sleep" -- String
)
port map (
 dbiterra => dbiterra,      -- 1-bit output: Leave open.
 douta => douta,            -- READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
 sbiterra => sbiterra,      -- 1-bit output: Leave open.
 addra => addra,            -- ADDR_WIDTH_A-bit input: Address for port A read operations.
 clka => clka,              -- 1-bit input: Clock signal for port A.
 ena => ena,                -- 1-bit input: Memory enable signal for port A. Must be high on clock
                            -- cycles when read operations are initiated. Pipelined internally.
 injectdbiterra => injectdbiterra,  -- 1-bit input: Do not change from the provided value.
 injectsbiterra => injectsbiterra,  -- 1-bit input: Do not change from the provided value.
 regcea => regcea,                  -- 1-bit input: Do not change from the provided value.
 rsta => rsta,                      -- 1-bit input: Reset signal for the final port A output register
                                    -- stage. Synchronously resets output port douta to the value specified
                                    -- by parameter READ_RESET_VALUE_A.
 sleep => sleep                     -- 1-bit input: sleep signal to enable the dynamic power saving feature.
);
-- End of xpm_memory_sprom_inst instantiation

--Connect ROM ports to block ports
addra <= addr;
data <= douta;
clka <= clk;
rsta <= rst;
ena <= en;


end Behavioral;
