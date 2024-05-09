-------------------------------------------------------------------------------
-- Company: 		Trenz Electronic
-- Engineer: 		Oleksandr Kiyenko
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
-------------------------------------------------------------------------------
entity led_ind is
generic(
	C_CNT_WIDTH		: INTEGER	:= 25
);
port(
	clk	 			: in  STD_LOGIC	:= '0';
	control_in		: in  STD_LOGIC_VECTOR(3 downto 0);
	led_out			: out STD_LOGIC
);
end led_ind;
-------------------------------------------------------------------------------
architecture Behavioral of led_ind is
-------------------------------------------------------------------------------
signal cycle_cnt	: UNSIGNED(C_CNT_WIDTH-1 downto 0);
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
process(clk)
begin
	if(clk = '1' and clk'event)then
		cycle_cnt	<= cycle_cnt + 1;
		case control_in is
			when x"0" => led_out <= '0';	-- OFF
			when x"1" => led_out <= cycle_cnt(C_CNT_WIDTH-1) and cycle_cnt(C_CNT_WIDTH-2) and cycle_cnt(C_CNT_WIDTH-3) and cycle_cnt(C_CNT_WIDTH-4);
			when x"2" => led_out <= cycle_cnt(C_CNT_WIDTH-1) and cycle_cnt(C_CNT_WIDTH-2) and cycle_cnt(C_CNT_WIDTH-4);
			when x"3" => led_out <= cycle_cnt(C_CNT_WIDTH-1) and (cycle_cnt(C_CNT_WIDTH-2) or cycle_cnt(C_CNT_WIDTH-3)) and cycle_cnt(C_CNT_WIDTH-4);
			when x"4" => led_out <= cycle_cnt(C_CNT_WIDTH-1) and cycle_cnt(C_CNT_WIDTH-4);
			when x"5" => led_out <= (cycle_cnt(C_CNT_WIDTH-1) or (cycle_cnt(C_CNT_WIDTH-2) and cycle_cnt(C_CNT_WIDTH-3))) and cycle_cnt(C_CNT_WIDTH-4);
			when x"6" => led_out <= (cycle_cnt(C_CNT_WIDTH-1) or cycle_cnt(C_CNT_WIDTH-2)) and cycle_cnt(C_CNT_WIDTH-4);
			when x"7" => led_out <= (cycle_cnt(C_CNT_WIDTH-1) or cycle_cnt(C_CNT_WIDTH-2) or cycle_cnt(C_CNT_WIDTH-3)) and cycle_cnt(C_CNT_WIDTH-4);
			when x"8" => led_out <= cycle_cnt(C_CNT_WIDTH-4);
			when x"F" => led_out <= '1';	-- ON
			when others => led_out <= '0';-- OFF
		end case;
	end if;
end process;
--------------------------------------------------------------------------------
end Behavioral;
