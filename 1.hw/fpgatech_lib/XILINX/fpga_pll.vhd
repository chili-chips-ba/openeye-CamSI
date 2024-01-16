----------------------------------------------------------------------------------
-- CHILI CHIPS LLC
----------------------------------------------------------------------------------
-- Technology-specific Xilinx PLL. From external 24MHz source, it creates:
--
-- 1) for rendering on a 1280x720P@60Hz screen
--      371.25MHz 5x serial pixel clock
--       74.25MHz pixel clock
--
-- Also see: https://github.com/hdl-util/hdmi
----------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.ALL;

library unisim;
    use unisim.vcomponents.all;


entity fpga_pll is
  port ( 
     clk_ext      : in  std_logic; --24MHz
     srst_n       : out std_logic;
     clk_pix      : out std_logic; -- 5x pixel clock: 371.25MHz
     clk_pix5     : out std_logic  -- pixel clock: 74.25MHz
);
end fpga_pll;


architecture behavioral of fpga_pll is
    signal pll_lock    : std_logic;
    signal clkfb       : std_logic;
    signal srst_n_pipe : std_logic;
    signal uclk_pix    : std_logic;
    signal uclk_pix5   : std_logic;

begin

u_MMCME2_BASE : MMCME2_BASE
   generic map (
      BANDWIDTH => "OPTIMIZED",  -- Jitter programming (OPTIMIZED, HIGH, LOW)
      
--      --  1080P
--      -- CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
--      CLKOUT0_DIVIDE_F => 1.0,      -- Divide amount for CLKOUT0 (1.000-128.000).
--      CLKOUT1_DIVIDE   => 1,
--      CLKOUT2_DIVIDE   => 5,

      --720P
      DIVCLK_DIVIDE      => 1,     -- Master division value (1-106)
      CLKFBOUT_MULT_F    => 31.06, -- Multiply value for all CLKOUT (2.000-64.000).
      CLKFBOUT_PHASE     => 0.0,   -- Phase offset in degrees of CLKFB (-360.000-360.000).
      CLKIN1_PERIOD      => 41.6666667,  -- Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).

      -- CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
      CLKOUT0_DIVIDE_F   => 2.0,   -- Divide amount for CLKOUT0 (1.000-128.000).
      CLKOUT1_DIVIDE     => 1,
      CLKOUT2_DIVIDE     => 10,
      CLKOUT3_DIVIDE     => 1,
      CLKOUT4_DIVIDE     => 1,
      CLKOUT5_DIVIDE     => 1,
      CLKOUT6_DIVIDE     => 1,

      -- CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
      CLKOUT0_DUTY_CYCLE => 0.5,
      CLKOUT1_DUTY_CYCLE => 0.5,
      CLKOUT2_DUTY_CYCLE => 0.5,
      CLKOUT3_DUTY_CYCLE => 0.5,
      CLKOUT4_DUTY_CYCLE => 0.5,
      CLKOUT5_DUTY_CYCLE => 0.5,
      CLKOUT6_DUTY_CYCLE => 0.5,

      -- CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
      CLKOUT0_PHASE      => 0.0,
      CLKOUT1_PHASE      => 0.0,
      CLKOUT2_PHASE      => 0.0,
      CLKOUT3_PHASE      => 0.0,
      CLKOUT4_PHASE      => 0.0,
      CLKOUT5_PHASE      => 0.0,
      CLKOUT6_PHASE      => 0.0,

      CLKOUT4_CASCADE    => FALSE, -- Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
      REF_JITTER1        => 0.0,   -- Reference input jitter in UI (0.000-0.999).
      STARTUP_WAIT       => FALSE  -- Delays DONE until MMCM is locked (FALSE, TRUE)
   )
   port map (

      -- Clock Outputs: 1-bit (each) output: User configurable clock outputs
      CLKOUT0   => uclk_pix5,   -- 1-bit output: CLKOUT0
      CLKOUT0B  => open,        -- 1-bit output: Inverted CLKOUT0

      CLKOUT1   => open,        -- 1-bit output: CLKOUT1
      CLKOUT1B  => open,        -- 1-bit output: Inverted CLKOUT1

      CLKOUT2   => uclk_pix,    -- 1-bit output: CLKOUT2
      CLKOUT2B  => open,        -- 1-bit output: Inverted CLKOUT2

      CLKOUT3   => open,        -- 1-bit output: CLKOUT3
      CLKOUT3B  => open,        -- 1-bit output: Inverted CLKOUT3

      CLKOUT4   => open,        -- 1-bit output: CLKOUT4
      CLKOUT5   => open,        -- 1-bit output: CLKOUT5

      CLKOUT6   => open,        -- 1-bit output: CLKOUT6

      -- Feedback Clocks: 1-bit (each) output: Clock feedback ports
      CLKFBOUT  => clkfb,       -- 1-bit output: Feedback clock
      CLKFBOUTB => open,        -- 1-bit output: Inverted CLKFBOUT

      -- Status Ports: 1-bit (each) output: MMCM status ports
      LOCKED    => pll_lock,    -- 1-bit output: LOCK

      -- Clock Inputs: 1-bit (each) input: Clock input
      CLKIN1    => clk_ext,     -- 1-bit input: Clock

      -- Control Ports: 1-bit (each) input: MMCM control ports
      PWRDWN    => '0',         -- 1-bit input: Power-down
      RST       => '0',         -- 1-bit input: Reset

      -- Feedback Clocks: 1-bit (each) input: Clock feedback ports
      CLKFBIN   => clkfb        -- 1-bit input: Feedback clock
   );

------------------------------------------------
 --Clock buffers
------------------------------------------------
        u_BUFG_clk_pix : BUFG port map ( 
           I => uclk_pix,  
           O => clk_pix
        );

        u_BUFG_clk_pix5 : BUFG port map 
        ( 
          I => uclk_pix5,  
          O => clk_pix5
        );

------------------------------------------------
 --Reset synchronizer
------------------------------------------------
  process (pll_lock, clk_pix) begin  
     if pll_lock = '0' then
        srst_n_pipe  <= '0';
        srst_n       <= '0';

     elsif rising_edge(clk_pix) then   
        srst_n_pipe  <= '1';
        srst_n       <= srst_n_pipe;
     end if;
  end process;
  
end behavioral;
