----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Antti Lukats
-- 
-- Create Date: 24.05.2016
-- Design Name: 
-- Module Name: TRISTATEIO - Behavioral
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


entity UART_MON is 
        generic (
            C_INCLUDE_DEBUG : boolean := false
      );
        port ( 
   		  --
		  mon_RXD : out STD_LOGIC;
		  mon_TXD : out STD_LOGIC;


	      RXD : in STD_LOGIC;
          TXD : in STD_LOGIC
	);

end UART_MON;

architecture Behavioral of UART_MON is


begin
	mon_RXD <= RXD;
	mon_TXD <= TXD;
end Behavioral;
