----------------------------------------------------------------------------------
-- CHILI CHIPS LLC
----------------------------------------------------------------------------------
-- Technology-specific Xilinx OSERDES10. It provides 10-1 muxing within output pad
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Adapted from Mike Field <hamster@snap.net.nz> design.
--
-- The tricky part is that reset needs to be asserted, and then CE asserted 
-- after the reset. Otherwise, it will not simulate correctly (outputs show as 'X') 
----------------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.ALL;

library unisim;
use     unisim.vcomponents.all;

entity fpga_oser10 is
  Port (
      arst    : in  std_logic; -- active-high async reset
      clk_par : in  std_logic; -- slower/parallel clock
      clk_ser : in  std_logic; -- faster/serial clock
    d         : in  std_logic_vector(9 downto 0);
    q         : out std_logic
  );
end fpga_oser10;

architecture behavioral of fpga_oser10 is
    signal shift1   : std_logic := '0';
    signal shift2   : std_logic := '0';
    signal ce_delay : std_logic := '0';
begin

u_master : OSERDESE2
   generic map (
      DATA_RATE_OQ   => "DDR",   -- DDR, SDR
      DATA_RATE_TQ   => "DDR",   -- DDR, BUF, SDR
      DATA_WIDTH     => 10,      -- Parallel data width (2-8,10,14)
      INIT_OQ        => '1',     -- Initial value of OQ output (1'b0,1'b1)
      INIT_TQ        => '1',     -- Initial value of TQ output (1'b0,1'b1)
      SERDES_MODE    => "MASTER",-- MASTER, SLAVE
      SRVAL_OQ       => '0',     -- OQ output value when SR is used (1'b0,1'b1)
      SRVAL_TQ       => '0',     -- TQ output value when SR is used (1'b0,1'b1)
      TBYTE_CTL      => "FALSE", -- Enable tristate byte operation (FALSE, TRUE)
      TBYTE_SRC      => "FALSE", -- Tristate byte source (FALSE, TRUE)
      TRISTATE_WIDTH => 1        -- 3-state converter width (1,4)
   )
   port map (
      OFB       => open,         -- 1-bit output: Feedback path for data
      OQ        => q,            -- 1-bit output: Data path output
      -- SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
      SHIFTOUT1 => open,
      SHIFTOUT2 => open,
      TBYTEOUT  => open,         -- 1-bit output: Byte group tristate
      TFB       => open,         -- 1-bit output: 3-state control
      TQ        => open,         -- 1-bit output: 3-state control
      CLK       => clk_ser,      -- 1-bit input: High speed clock
      CLKDIV    => clk_par,      -- 1-bit input: Divided clock

      -- D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
      D1        => d(0),
      D2        => d(1),
      D3        => d(2),
      D4        => d(3),
      D5        => d(4),
      D6        => d(5),
      D7        => d(6),
      D8        => d(7),
      OCE       => ce_delay,     -- 1-bit input: Output data clock enable
      RST       => arst,         -- 1-bit input: Reset

      -- SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
      SHIFTIN1  => shift1,
      SHIFTIN2  => shift2,

      -- T1 - T4: 1-bit (each) input: Parallel 3-state inputs
      T1        => '0',
      T2        => '0',
      T3        => '0',
      T4        => '0',
      TBYTEIN   => '0', -- 1-bit input: Byte group tristate
      TCE       => '0'  -- 1-bit input: 3-state clock enable
   );

u_slave : OSERDESE2
   generic map (
      DATA_RATE_OQ   => "DDR",   -- DDR, SDR
      DATA_RATE_TQ   => "DDR",   -- DDR, BUF, SDR
      DATA_WIDTH     => 10,      -- Parallel data width (2-8,10,14)
      INIT_OQ        => '1',     -- Initial value of OQ output (1'b0,1'b1)
      INIT_TQ        => '1',     -- Initial value of TQ output (1'b0,1'b1)
      SERDES_MODE    => "SLAVE", -- MASTER, SLAVE
      SRVAL_OQ       => '0',     -- OQ output value when SR is used (1'b0,1'b1)
      SRVAL_TQ       => '0',     -- TQ output value when SR is used (1'b0,1'b1)
      TBYTE_CTL      => "FALSE", -- Enable tristate byte operation (FALSE, TRUE)
      TBYTE_SRC      => "FALSE", -- Tristate byte source (FALSE, TRUE)
      TRISTATE_WIDTH => 1        -- 3-state converter width (1,4)
   )
   port map (
      OFB            => open,    -- 1-bit output: Feedback path for data
      OQ             => open,    -- 1-bit output: Data path output

      -- SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
      SHIFTOUT1      => shift1,
      SHIFTOUT2      => shift2,
                      
      TBYTEOUT       => open,    -- 1-bit output: Byte group tristate
      TFB            => open,    -- 1-bit output: 3-state control
      TQ             => open,    -- 1-bit output: 3-state control
      CLK            => clk_ser, -- 1-bit input: High speed clock
      CLKDIV         => clk_par, -- 1-bit input: Divided clock

      -- D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
      D1             => '0',
      D2             => '0',
      D3             => d(8),
      D4             => d(9),
      D5             => '0',
      D6             => '0',
      D7             => '0',
      D8             => '0',
      OCE            => ce_delay, -- 1-bit input: Output data clock enable
      RST            => arst,     -- 1-bit input: Reset

      -- SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
      SHIFTIN1       => '0',
      SHIFTIN2       => '0',

      -- T1 - T4: 1-bit (each) input: Parallel 3-state inputs
      T1             => '0',
      T2             => '0',
      T3             => '0',
      T4             => '0',
      TBYTEIN        => '0',     -- 1-bit input: Byte group tristate
      TCE            => '0'      -- 1-bit input: 3-state clock enable
   );

delay_ce: process(clk_par)
   begin
      if rising_edge(clk_par) then
         ce_delay <= not arst;
      end if;
   end process;
end behavioral;
