----------------------------------------------------------------------------------
-- CHILI CHIPS LLC
----------------------------------------------------------------------------------
-- Technology-specific Xilinx LVDS output buffer. 
----------------------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.ALL;

library unisim;
    use unisim.vcomponents.all;

entity fpga_olvds is
   port ( 
      i : in  std_logic;
      o : out std_logic;
      ob: out std_logic
   );
end fpga_olvds;


architecture behavioral of fpga_olvds is

begin

  u_olvds: OBUFDS
    generic map (
      IOSTANDARD => "TMDS_33",
      SLEW       => "FAST"
    )
    port map (
      O   => o,
      OB  => ob,
      I   => i
    );
    
end behavioral;
