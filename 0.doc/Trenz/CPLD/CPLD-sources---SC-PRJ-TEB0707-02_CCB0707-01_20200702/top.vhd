--------------------------------------------------------------------------------
-- Company: Trenz Electronic GmbH
-- Engineer: Martin Rohrmüller
--
-- TEB0707 CPLD MAX10 (U6)
--
--
-- Revision     : 01
-- Release Date : ---
-- Supported PCB Revision: 01, 02
-- Changes: REV01 initial Version
--  ---
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all; 
use ieee.STD_LOGIC_arith.all;
use ieee.STD_LOGIC_unsigned.all;
use ieee.STD_LOGIC_misc.all;
use IEEE.NUMERIC_STD.ALL;

LIBRARY work;
--------------------------------------------------------------------------------
ENTITY top IS 
	PORT
	(
	-- Bank1A
		X7	: IN  STD_ULOGIC;
		X1	: IN  STD_ULOGIC;
		X3	: IN  STD_ULOGIC;
		X4	: OUT  STD_ULOGIC;
		X6	: OUT  STD_ULOGIC;
		X0	: OUT  STD_ULOGIC;
		X2	: OUT  STD_ULOGIC;
		X5	: IN  STD_ULOGIC;

	-- Bank1B
		TCK	: IN  STD_ULOGIC;   	--JTAG from FTDI
		TMS	: IN  STD_ULOGIC;		--JTAG from FTDI
		TDO	: OUT  STD_ULOGIC;	--JTAG from FTDI
		TDI	: IN  STD_ULOGIC;		--JTAG from FTDI
		
		DIP1				: IN   STD_ULOGIC;  
		EN_C5VIN			: OUT  STD_ULOGIC;
--		CB_SMB_SCL		: IN  STD_ULOGIC;
--		CB_SMB_ALERT	: IN   STD_ULOGIC;
	
	-- Bank2
		LED5			: OUT STD_ULOGIC;  
--		CB_SMB_SDA 	: IN  STD_ULOGIC;
--		CB_DI 		: OUT STD_LOGIC;	
--		CB_REFCLK	: OUT STD_ULOGIC;
		--	OSCI_CPLD	: IN  STD_ULOGIC;		--12MHz shared with FTDI, currently not used
--		CB_MODE		: OUT STD_ULOGIC;
--		CB_DO			: IN  STD_ULOGIC;
--		CA_DO			: IN  STD_ULOGIC;
--		CA_SCK	: OUT  STD_ULOGIC; 		
--		CA_MODE	: OUT  STD_ULOGIC;	
--		CA_SEL	: OUT  STD_ULOGIC;	
--		CB_SEL	: OUT  STD_ULOGIC;		
		DIP2		: IN   STD_ULOGIC;
--		CB_SCK	: OUT  STD_ULOGIC;
		DIP3		: IN   STD_ULOGIC;
		
	-- Bank3
		LED8		: OUT  STD_ULOGIC;
		BUTTON1	: IN  STD_ULOGIC;		-- User Button (configured to SoM)
--		CA_SMB_SCL	: IN  STD_ULOGIC;
--		CA_SMB_SDA	: INOUT  STD_ULOGIC;		
		LED7		: OUT  STD_ULOGIC;		-- ERROR LED (red)
--		CA_SMB_ALERT	: IN  STD_ULOGIC;		
--		CA_DI	: OUT  STD_ULOGIC;
--		CA_REFCLK	: OUT  STD_ULOGIC;		
		VS1	: OUT  STD_ULOGIC;	  -- select IOV voltage of DCDC (U3)
		ETH_LED1	: OUT  STD_ULOGIC;		
		LED4	: OUT  STD_ULOGIC;
		EN_C3_3V	: OUT  STD_ULOGIC;		
		VS2	: OUT STD_ULOGIC;   -- select IOV voltage of DCDC (U3)
		PGOOD	: IN STD_ULOGIC;
		F_UART_TX : IN STD_ULOGIC;
		SD_CD	: IN STD_ULOGIC;		--SD Card detect, weak pullup enabled
		VS0	: OUT STD_ULOGIC;	  -- select IOV voltage of DCDC (U3)
		EN_IOV	: OUT STD_ULOGIC;
		ETH_LED2	: OUT STD_ULOGIC;
		USB_OC	: IN STD_ULOGIC;
		EN1	: OUT STD_ULOGIC;
		MODE	: OUT STD_ULOGIC;  
		RESIN	: OUT STD_ULOGIC;
		F_UART_RX: OUT STD_ULOGIC;
		M3_3VOUT:  IN STD_ULOGIC;  -- SoM 3.3V output  used for enable CRUVI Powers

	-- Bank5
		M_TDO	: IN   STD_ULOGIC; --JTAG TO SoM
		M_TMS	: OUT  STD_ULOGIC; --JTAG TO SoM
		M_TCK	: OUT  STD_ULOGIC; --JTAG TO SoM
		M_TDI	: OUT  STD_ULOGIC; --JTAG TO SoM

	-- Bank 6
		M_G1_20 : OUT   STD_ULOGIC;   -- Button1 Signal to SoM
		M_G1_02 : IN   STD_ULOGIC;
		M_G1_05 : OUT   STD_ULOGIC;
		M_G1_07 : OUT   STD_ULOGIC;
		M_G1_06 : OUT  STD_ULOGIC;
		M_G1_08 : OUT   STD_ULOGIC;
		M_G1_01 : IN   STD_ULOGIC;
		M_G1_04 : IN   STD_ULOGIC;
--		M_G1_15 : IN   STD_ULOGIC;
--		M_G1_13 : IN   STD_ULOGIC;
		M_G1_18 : IN   STD_ULOGIC;
--		M_G1_11 : IN   STD_ULOGIC;
		M_G1_17 : IN   STD_ULOGIC;
--		M_G1_12 : IN   STD_ULOGIC;
--		M_G1_14 : IN   STD_ULOGIC;
		M_G1_19 : IN   STD_ULOGIC;
		M_G1_16 : OUT   STD_ULOGIC;
--		M_G1_09 : IN   STD_ULOGIC;
		M_G1_03 : IN   STD_ULOGIC;
--		M_G1_10 : IN   STD_ULOGIC;
		
	-- Bank8
		LED3 		: OUT STD_ULOGIC;		
		NOSEQ 	: OUT STD_ULOGIC;		
		M_G6_07 	: IN  STD_ULOGIC;   		--MIO on Zynq devices
		PROGMODE	: OUT  STD_ULOGIC; 			
--		M_G6_06 	: IN  STD_ULOGIC;   		--MIO on Zynq devices
--		M_G6_05 	: INOUT  STD_ULOGIC;   		--MIO on Zynq devices
		M_G6_04 	: IN  STD_ULOGIC;   		--MIO on Zynq devices
--		M_G6_03 	: OUT  STD_ULOGIC;   		--MIO on Zynq devices
		LED2 	: OUT STD_ULOGIC;
		LED1 	: OUT STD_ULOGIC;
		M_G6_08 	: IN  STD_ULOGIC;     		--MIO on Zynq devices 	
--		CC_SMB_ALERT :IN STD_ULOGIC;
		M_G6_02 	: IN  STD_ULOGIC;   	 --RX UART from SoM, MIO on Zynq devices	
--		CC_REFCLK :IN STD_ULOGIC;
--		CC_SMB_SDA :IN STD_ULOGIC;
--		CC_SMB_SEL :IN STD_ULOGIC;
		M_G6_01 	: OUT  STD_ULOGIC;   	 --TX UART to SoM, MIO on Zynq devices
--		CC_SCK : IN STD_ULOGIC;
--		CC_DI	: IN STD_ULOGIC;
--		CC_DO	: IN STD_ULOGIC;
--		CC_MODE : IN STD_ULOGIC;
--		CC_SMB_SCL : IN STD_ULOGIC;
		LED6 	: OUT STD_ULOGIC;
		BUTTON0 : IN STD_ULOGIC
		
		);
END ENTITY top;
--------------------------------------------------------------------------------
ARCHITECTURE main OF top IS 
--------------------------------------------------------------------------------
constant net_vcc			: STD_LOGIC	:= '1'; 
constant net_gnd			: STD_LOGIC	:= '0'; 
--------------------------------------------------------------------------------

component altera_int_osc is
generic (
	DEVICE_FAMILY   : string := "MAX 10";
	DEVICE_ID       : string := "08";
	CLOCK_FREQUENCY : string := "82"
);
port (
	oscena 			: in  STD_LOGIC := 'X';
	clkout 			: out STD_LOGIC
);
end component altera_int_osc;

component led_ind is
generic(
	C_CNT_WIDTH		: INTEGER	:= 25
);
port(
	clk	 			: in  STD_LOGIC	:= '0';
	control_in		: in  STD_LOGIC_VECTOR(3 downto 0);
	led_out			: out STD_LOGIC
);
end component;
--------------------------------------------------------------------------------
	CONSTANT CNT_MAX : INTEGER := (82000000/50);		-- 20ms=1/50Hz

	SIGNAL   power_status		: STD_LOGIC_VECTOR(3 downto 0) :=x"F";  
	SIGNAL   system_status		: STD_LOGIC_VECTOR(3 downto 0) :=x"0"; 
	
	SIGNAL   osc_clk			: STD_LOGIC;

	SIGNAL   Button1_db : STD_LOGIC:= '0';
	SIGNAL   Input_FF : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL	Count : INTEGER range 0 to CNT_MAX:= 0;
--------------------------------------------------------------------------------	
BEGIN 
-- Internal Oscillator
int_osc_0 : component altera_int_osc
generic map (
	DEVICE_FAMILY   => "MAX 10",
	DEVICE_ID       => "08",
	CLOCK_FREQUENCY => "82"
)
port map (
	oscena 			=> net_vcc,
	clkout 			=> osc_clk
);

--debouce
 process(osc_clk)
  begin
    if(rising_edge(osc_clk)) then
      Input_FF <= Input_FF(0) & BUTTON1;  -- sync in the input
      IF(Input_FF(0)/=Input_FF(1)) THEN  -- reset counter because input is changing
        Count <= 0;
      ELSIF(Count < CNT_MAX) THEN  -- stable input time is not yet met
        Count <= Count + 1;
      ELSE                       -- stable input time is met
        Button1_db <= Input_FF(1);
      END IF;    
    END IF;
  END PROCESS;

status_ind1_inst: component led_ind
generic map(
	C_CNT_WIDTH		=> 29
)
port map(
	clk				=> osc_clk,
	control_in		=> power_status,
	led_out			=> LED7
);

status_ind2_inst: component led_ind
generic map(
	C_CNT_WIDTH		=> 29
)
port map(
	clk				=> osc_clk,
	control_in		=> system_status,
	led_out			=> LED8
);


process(osc_clk)
begin
	if(osc_clk = '1' and osc_clk'event)then
		------power status
		if((PGOOD  = '0') or (M3_3VOUT = '0')) then
			power_status	<= x"1";	-- SOM Power Error
		elsif(USB_OC = '0')then
			power_status	<= x"5";	-- USB Power Error 5
		else
			power_status	<= x"0";	-- All OK
		end if;
		------system status
		if(DIP3 ='0')then
			system_status	<= x"5";	-- SoM CPLD JTAG enabled
		else
			system_status 	<= x"F";
		end if;		
	end if;
end process;

-- ETH LEDs currently not implemented (implementation is module dependent) 
  ETH_LED2  <= net_gnd;
  ETH_LED1	<= net_gnd;

-- currently not used HS CRUVI IOs
--	CA_SMB_SCL;
--	CA_SMB_SDA;				
--	CA_SMB_ALERT;		
--	CA_DI	: OUT;
--	CA_REFCLK;	
--	CA_DO		;
--	CA_SCK; 		
--	CA_MODE;	
--	CA_SEL;	
			
--	CB_MODE;
--	CB_DO	;
--	CB_SEL;			
--	CB_SCK;
--	CB_SMB_SCL;
--	CB_SMB_ALERT;
--	CB_SMB_SDA;
--	CB_DI 	;	
--	CB_REFCLK;

--	CC_SMB_ALERT;
--	CC_REFCLK ;
--	CC_SMB_SDA;
--	CC_SMB_SEL;
--	CC_SCK ;
--	CC_DI	;
--	CC_DO	;
--	CC_MODE;
--	CC_SMB_SCL;

--currently not used, PL IO
--		M_G1_09 ;
--		M_G1_10 ;
--		M_G1_11 ;
--		M_G1_12 ;
--		M_G1_13 ;
--		M_G1_14 ;
--		M_G1_15 ;
--currently not used, depending on Module connected to  PL IO or PS MIO 	
--		M_G6_03 ;
--		M_G6_04 ;   	


-- LS Connector configured four as input and four as output
	X0 <= M_G1_01 ;
	X2	<= M_G1_02 ;			
	X4 <= M_G1_03 ;
	X6 <= M_G1_04 ;
	M_G1_05 <= X1;
	M_G1_06 <= X3;
	M_G1_07 <= X5;
	M_G1_08 <= X7;



--currently not used, PL IO
--		M_G1_09 ;
--		M_G1_10 ;
--		M_G1_11 ;
--		M_G1_12 ;
--		M_G1_13 ;
--		M_G1_14 ;
--		M_G1_15 ;
--		M_G1_16 ;
--currently not used, depending on Module connected to  PL IO or PS MIO 	
--		M_G6_03 ;
--		M_G6_04 ;   	
--		M_G6_05 ;   	

		
-- user dips
		M_G1_16 <= not(DIP1); 

-- green LEDs (Connected to PL IO)		
		LED3	<=	M_G1_19;
		LED2	<=	M_G1_18;
		LED1 	<=	M_G1_17;

-- red LEDs (depending on Module connected to  PL IO or PS MIO)
  	   LED4 	<=	M_G6_04; 
		LED5 	<=	M_G6_07; 	
		LED6 	<=	M_G6_08;  	

-- user button on PL
	M_G1_20 <= Button1_db ; -- Debounced BUTTON1 Signal to 4x5 Module



-- Module Config	
	RESIN	<= BUTTON0; -- reset SoM
	NOSEQ <= net_gnd; -- powermanagement by CPLD is NOT disabled	
	PROGMODE <= not(DIP3);  -- select between CPLD (low, closed, on) on SoM or FPGA/SoC (high, open, off )
	EN1 <=	net_vcc; --module power always enabled
	MODE <= SD_CD ; -- select SD boot mode when card installed (low), else QSPI (high)	

--	Enable CRUVI Powers 
	EN_C5VIN <=	 M3_3VOUT;
	EN_C3_3V <=	 M3_3VOUT;	
	EN_IOV <=	 M3_3VOUT;
	
--Select IOV Voltage of DCDC "010" selects 1.8V
	VS0 <= not(DIP2);	
	VS1 <= DIP2;
	VS2 <= net_gnd;	
	
--JTAG: switch with hard wired JTAGEN Dip4 between SoM (Off) and Max10CPLD (on)	
	TDO <=	M_TDO;
	M_TMS	<= TMS;
	M_TCK	<= TCK;
	M_TDI <= TDI;
	
-- UART	
	M_G6_01 <= F_UART_TX;  --TX UART to SoM 	
	F_UART_RX <= M_G6_02; 	 --RX UART from SoM	

	
END main;