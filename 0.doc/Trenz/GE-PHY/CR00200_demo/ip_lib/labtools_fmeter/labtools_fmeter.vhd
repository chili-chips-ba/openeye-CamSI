----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.09.2014 18:06:10
-- Design Name: 
-- Module Name: top - Behavioral
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
    use UNISIM.VComponents.all;

Library UNIMACRO;
    use UNIMACRO.vcomponents.all;

entity labtools_fmeter is
        generic (
            C_REFCLK_HZ : integer := 100000000;
            C_CHANNELS : integer range 1 to 32 := 4;
            C_MODE : integer range 0 to 1 := 0;
            C_NUM_BITS : integer range 16 to 32 := 32
        );  
        port ( 
            refclk    : in STD_LOGIC;
            
            fin      : in STD_LOGIC_VECTOR(C_CHANNELS-1 downto 0);
            
            F0       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F1       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F2       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F3       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);

            F4       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F5       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F6       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F7       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            
            F8       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F9       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F10       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F11       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);

            F12       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F13       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F14       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F15       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            
            F16       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F17       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F18       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F19       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            
            F20       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F21       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F22       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F23       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            
            F24       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F25       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F26       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F27       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);

            F28       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F29       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F30       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            F31       : out STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);
            
            update    : out STD_LOGIC
        );
end labtools_fmeter;

architecture Behavioral of labtools_fmeter is

constant High : std_logic := '1';
constant Low : std_logic := '0';

signal enable_i : STD_LOGIC_VECTOR(C_CHANNELS-1 downto 0);
signal clk_i : STD_LOGIC_VECTOR(C_CHANNELS-1 downto 0);
signal fin_i : STD_LOGIC_VECTOR(C_CHANNELS-1 downto 0);

signal enable_count: STD_LOGIC;
signal reset_count: STD_LOGIC;

signal toggle: STD_LOGIC;

signal tc: STD_LOGIC;
signal refcnt  : STD_LOGIC_VECTOR(C_NUM_BITS-1 downto 0);

signal F_i       :  STD_LOGIC_VECTOR(C_CHANNELS*C_NUM_BITS-1 downto 0);
signal F         :  STD_LOGIC_VECTOR(C_CHANNELS*C_NUM_BITS-1 downto 0);

begin

enable_count <= not toggle; --High;
reset_count  <= toggle;
update <= tc;

process(refclk)
begin
	if (rising_edge(refclk)) then
			if (tc = High) then
			     toggle <= not toggle;
			     if (enable_count=High) then
			         F <= F_i;
			     end if;
			end if;
	end if;
end process;
--
-- Channel 0 exists always
--
    F0 <= F(C_NUM_BITS*1-1 downto C_NUM_BITS*0);

CH1_gen: if C_CHANNELS  > 1 generate begin F1 <= F(C_NUM_BITS*2-1 downto C_NUM_BITS*1); end generate;
CH2_gen: if C_CHANNELS  > 2 generate begin F2 <= F(C_NUM_BITS*3-1 downto C_NUM_BITS*2); end generate;
CH3_gen: if C_CHANNELS  > 3 generate begin F3 <= F(C_NUM_BITS*4-1 downto C_NUM_BITS*3); end generate;
CH4_gen: if C_CHANNELS  > 4 generate begin F4 <= F(C_NUM_BITS*5-1 downto C_NUM_BITS*4); end generate;

CH5_gen: if C_CHANNELS  > 5 generate begin F5 <= F(C_NUM_BITS*6-1 downto C_NUM_BITS*5); end generate;
CH6_gen: if C_CHANNELS  > 6 generate begin F6 <= F(C_NUM_BITS*7-1 downto C_NUM_BITS*6); end generate;
CH7_gen: if C_CHANNELS  > 7 generate begin F7 <= F(C_NUM_BITS*8-1 downto C_NUM_BITS*7); end generate;
CH8_gen: if C_CHANNELS  > 8 generate begin F8 <= F(C_NUM_BITS*9-1 downto C_NUM_BITS*8); end generate;

CH9_gen: if C_CHANNELS  > 9  generate begin F9  <= F(C_NUM_BITS*10-1 downto C_NUM_BITS*9); end generate;
CH10_gen: if C_CHANNELS > 10 generate begin F10 <= F(C_NUM_BITS*11-1 downto C_NUM_BITS*10); end generate;
CH11_gen: if C_CHANNELS > 11 generate begin F11 <= F(C_NUM_BITS*12-1 downto C_NUM_BITS*11); end generate;
CH12_gen: if C_CHANNELS > 12 generate begin F12 <= F(C_NUM_BITS*13-1 downto C_NUM_BITS*12); end generate;

CH13_gen: if C_CHANNELS > 13 generate begin F13 <= F(C_NUM_BITS*14-1 downto C_NUM_BITS*13); end generate;
CH14_gen: if C_CHANNELS > 14 generate begin F14 <= F(C_NUM_BITS*15-1 downto C_NUM_BITS*14); end generate;
CH15_gen: if C_CHANNELS > 15 generate begin F15 <= F(C_NUM_BITS*16-1 downto C_NUM_BITS*15); end generate;
CH16_gen: if C_CHANNELS > 16 generate begin F16 <= F(C_NUM_BITS*17-1 downto C_NUM_BITS*16); end generate;

CH17_gen: if C_CHANNELS > 17 generate begin F17 <= F(C_NUM_BITS*18-1 downto C_NUM_BITS*17); end generate;
CH18_gen: if C_CHANNELS > 18 generate begin F18 <= F(C_NUM_BITS*19-1 downto C_NUM_BITS*18); end generate;
CH19_gen: if C_CHANNELS > 19 generate begin F19 <= F(C_NUM_BITS*20-1 downto C_NUM_BITS*19); end generate;
CH20_gen: if C_CHANNELS > 20 generate begin F20 <= F(C_NUM_BITS*21-1 downto C_NUM_BITS*20); end generate;

CH21_gen: if C_CHANNELS > 21 generate begin F21 <= F(C_NUM_BITS*22-1 downto C_NUM_BITS*21); end generate;
CH22_gen: if C_CHANNELS > 22 generate begin F22 <= F(C_NUM_BITS*23-1 downto C_NUM_BITS*22); end generate;
CH23_gen: if C_CHANNELS > 23 generate begin F23 <= F(C_NUM_BITS*24-1 downto C_NUM_BITS*23); end generate;
CH24_gen: if C_CHANNELS > 24 generate begin F24 <= F(C_NUM_BITS*25-1 downto C_NUM_BITS*24); end generate;

CH25_gen: if C_CHANNELS > 25 generate begin F25 <= F(C_NUM_BITS*26-1 downto C_NUM_BITS*25); end generate;
CH26_gen: if C_CHANNELS > 26 generate begin F26 <= F(C_NUM_BITS*27-1 downto C_NUM_BITS*26); end generate;
CH27_gen: if C_CHANNELS > 27 generate begin F27 <= F(C_NUM_BITS*28-1 downto C_NUM_BITS*27); end generate;
CH28_gen: if C_CHANNELS > 28 generate begin F28 <= F(C_NUM_BITS*29-1 downto C_NUM_BITS*28); end generate;

CH29_gen: if C_CHANNELS > 29 generate begin F29 <= F(C_NUM_BITS*30-1 downto C_NUM_BITS*29); end generate;
CH30_gen: if C_CHANNELS > 30 generate begin F30 <= F(C_NUM_BITS*31-1 downto C_NUM_BITS*30); end generate;
CH31_gen: if C_CHANNELS > 31 generate begin F31 <= F(C_NUM_BITS*32-1 downto C_NUM_BITS*31); end generate;




COUNTER_REFCLK_inst: COUNTER_TC_MACRO
   generic map (
      COUNT_BY => X"000000000001", -- Count by value
      DEVICE => "7SERIES",         -- Target Device: "VIRTEX5", "7SERIES" 
      DIRECTION => "UP",            -- Counter direction "UP" or "DOWN" 
      RESET_UPON_TC => "TRUE",      -- Reset counter upon terminal count, TRUE or FALSE
      --TC_VALUE   => X"000005F5E0FF", -- Terminal count value 100M
      
      TC_VALUE   => std_logic_vector(TO_UNSIGNED(C_REFCLK_HZ-1, 32)), -- Terminal count value 100M
      --TC_VALUE => X"000000000100", -- Terminal count value
      WIDTH_DATA => C_NUM_BITS)            -- Counter output bus width, 1-48
   port map (
      Q     => refcnt,          -- Counter ouput, width determined by WIDTH_DATA generic 
      TC    => tc,            --TC,      -- 1-bit terminal count output, high = terminal count is reached
      CLK   => refclk,          --CLK,    -- 1-bit clock input
      CE    => High,             --CE,      -- 1-bit clock enable input
      RST   => '0' --RST        -- 1-bit active high synchronous reset
   );


FMETER_gen: for i in 0 to C_CHANNELS-1 generate
begin

Mode_0_Gen: if C_MODE=0 generate
    enable_i(i) <= enable_count;
    clk_i(i) <= fin(i);
end generate;

Mode_1_Gen: if C_MODE=1 generate
    

FDCE_inst: FDCE
   generic map (
      INIT => '0') -- Initial value of register ('0' or '1')  
   port map (
      Q => fin_i(i),      -- Data output
      C => refclk,      -- Clock input
      CE => High,    -- Clock enable input
      CLR => Low,  -- Asynchronous clear input
      D => fin(i)       -- Data input
   );

    enable_i(i) <= enable_count and fin(i);
    clk_i(i) <= refclk;
end generate;

 
COUNTER_F_inst: COUNTER_TC_MACRO
   generic map (
      COUNT_BY => X"000000000001", -- Count by value
      DEVICE => "7SERIES",         -- Target Device: "VIRTEX5", "7SERIES" 
      DIRECTION => "UP",            -- Counter direction "UP" or "DOWN" 
      RESET_UPON_TC => "FALSE",      -- Reset counter upon terminal count, TRUE or FALSE
      TC_VALUE => X"000000000000", -- Terminal count value
      WIDTH_DATA => C_NUM_BITS)            -- Counter output bus width, 1-48
   port map (
      Q     => F_i(C_NUM_BITS*(i+1)-1 downto C_NUM_BITS*i),              -- Counter ouput, width determined by WIDTH_DATA generic 
      TC    => open,            --TC,      -- 1-bit terminal count output, high = terminal count is reached
      CLK   => clk_i(i),          --CLK,    -- 1-bit clock input
      CE    => enable_i(i),    --CE,      -- 1-bit clock enable input
      RST   => reset_count      --RST        -- 1-bit active high synchronous reset
   );
end generate;


end Behavioral;
