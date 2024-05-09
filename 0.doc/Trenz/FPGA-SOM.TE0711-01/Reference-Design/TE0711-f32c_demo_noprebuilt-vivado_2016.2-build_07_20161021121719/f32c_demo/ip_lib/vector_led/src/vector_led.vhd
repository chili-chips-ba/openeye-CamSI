----------------------------------------------------------------------------------------------------
--! @file vector_gpio.vhd
--! @brief 
--! @author Antti Lukats
--! @version 1.0
--! @date 2015
--! @license MIT License
--! @copyright Copyright 2015-2016 Trenz Electronic GmbH
--! @pre Vivado 2014.4+
----------------------------------------------------------------------------------------------------
--! Use standard library
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;


entity vector_led is  
    generic (
    --! 
    --! 
    --!         
    C_VECTOR_WIDTH  : integer range 1 to 32    := 32; --!
    C_LED0_BIT      : integer range 0 to 31    := 0 --!
    );
    port (
       --vector_i      : out std_logic_vector(C_VECTOR_WIDTH-1 downto 0);
       --vector_o      : in std_logic_vector(C_VECTOR_WIDTH-1 downto 0) := (others => '0');
       --vector_t      : in std_logic_vector(C_VECTOR_WIDTH-1 downto 0) := (others => '1');
        --
	   -- 
	   --
	   vector_i      : in std_logic_vector(C_VECTOR_WIDTH-1 downto 0);

	   --gpio_i      : in  std_logic_vector(C_GPIO_WIDTH-1 downto 0);
	--gpio_o      : out std_logic_vector(C_GPIO_WIDTH-1 downto 0);
	--gpio_t      : out std_logic_vector(C_GPIO_WIDTH-1 downto 0)
	
	   led0_o      : out std_logic
	);
	
end vector_led;

architecture Behavioral of vector_led is

signal led0_i: std_logic;

begin
    led0_i <= vector_i(C_LED0_BIT);
    led0_o <= led0_i;

end Behavioral;
