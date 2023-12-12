--
-- Copyright (c) 2015 Marko Zec, University of Zagreb
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions
-- are met:
-- 1. Redistributions of source code must retain the above copyright
--    notice, this list of conditions and the following disclaimer.
-- 2. Redistributions in binary form must reproduce the above copyright
--    notice, this list of conditions and the following disclaimer in the
--    documentation and/or other materials provided with the distribution.
--
-- THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
-- FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
-- DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
-- OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
-- HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
-- LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
-- OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
-- SUCH DAMAGE.
--
-- $Id$
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library unisim;
use unisim.vcomponents.all;

use work.f32c_pack.all;

entity glue is
    generic (
	   -- ISA
	   --C_arch: integer := ARCH_MI32;

       C_simple_in: integer range 1 to 32 := 32;
       C_simple_out: integer range 1 to 32 := 32;
       C_gpio: integer range 1 to 128 := 32;
        
        
       -- Main clock: N * 10 MHz
	   C_clk_freq: integer := 100;

       -- SoC configuration options
       C_mem_size: integer := 128
    );
    port (
	   clk: in std_logic;      -- 100 MHz

       simple_in: in std_logic_vector(C_simple_in-1 downto 0);
	   simple_out: out std_logic_vector(C_simple_out-1 downto 0);
    
       
       gpio_i: in std_logic_vector(C_gpio-1 downto 0);
       gpio_o: out std_logic_vector(C_gpio-1 downto 0);
       gpio_t: out std_logic_vector(C_gpio-1 downto 0);
        
       RsTx: out std_logic;    -- UART
       RsRx: in std_logic
    );
end glue;


architecture Behavioral of glue is
    signal rs232_break: std_logic;
    signal sout: std_logic_vector(31 downto 0);
    signal sin: std_logic_vector(31 downto 0) := (others => '0');
    
    signal cfgmclk : std_logic; -- internal 66mhz clock
    
    signal gpio_i_i: std_logic_vector(127 downto 0);
    signal gpio_o_i: std_logic_vector(127 downto 0);
    signal gpio_t_i: std_logic_vector(127 downto 0);
    
    
begin

	   gpio_i_i(C_gpio-1 downto 0)    <= gpio_i(C_gpio-1 downto 0);
	   gpio_o(C_gpio-1 downto 0)      <= gpio_o_i(C_gpio-1 downto 0);
	   gpio_t(C_gpio-1 downto 0)      <= gpio_t_i(C_gpio-1 downto 0);


   simple_out <= sout(C_simple_out-1 downto 0);
   sin(C_simple_in-1 downto 0) <= simple_in;
    
    
    -- generic BRAM glue
    glue_bram: entity work.glue_bram
    generic map (
	   C_clk_freq => C_clk_freq,
	   C_arch => ARCH_MI32, --C_arch,
	   C_mem_size => C_mem_size
    )
    port map (
	   clk                     => clk,
	   sio_txd(0)              => rstx, 
	   sio_rxd(0)              => rsrx, 
	   sio_break(0)            => rs232_break,
	   
	   gpio_i(127 downto 0)      => gpio_i_i,
	   gpio_o(127 downto 0)      => gpio_o_i,
	   gpio_t(127 downto 0)      => gpio_t_i,
	   
	   simple_out(31 downto 0) => sout,
	   simple_in(31 downto 0)  => sin, 
	   spi_miso                => (others => '0')
    );
    

    res: startupe2
    generic map (
	   prog_usr => "FALSE"
    )
    port map (
	   cfgmclk     => cfgmclk,
	   clk         => cfgmclk,
	   gsr         => rs232_break,
	   gts         => '0',
	   keyclearb   => '0',
	   pack        => '1',
	   usrcclko    => '1',
	   usrcclkts   => '1',
	   usrdoneo    => '1',
	   usrdonets   => '1'
    );

end Behavioral;
