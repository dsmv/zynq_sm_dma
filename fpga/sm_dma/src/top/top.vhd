-------------------------------------------------------------------------------
--
-- Title       : top
-- Author      : Dmitry Smekhov
-- Company     : Instrumental Systems
-- E-mail      : dsmv@insys.ru
--
-- Version     : 1.0
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
--
-- Version 1.0  
--
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;

library work;
use work.axi_pkg.all;
use work.zynq_system_pkg.all;

entity top is				 			
	
generic(

		is_simulation		: in integer:=0;	 -- 1 - simulation mode
		
		Device_ID			: in std_logic_vector( 15 downto 0 ):=x"0000"; -- ID of HW
		Revision			: in std_logic_vector( 15 downto 0 ):=x"0000"; -- revision of HW
		PLD_ID				: in std_logic_vector( 15 downto 0 ):=x"B000"; -- ID of FPGA
		PLD_VER				: in std_logic_vector( 15 downto 0 ):=x"0000"; -- version of FPGA
		PLD_BUILD			: in std_logic_vector( 15 downto 0 ):=x"0000"  -- build of FPGA

);	
port(
	    --- Внещние сигналы ---
        DDR_addr            : inout STD_LOGIC_VECTOR ( 14 downto 0 );
        DDR_ba              : inout STD_LOGIC_VECTOR ( 2 downto 0 );
        DDR_cas_n           : inout STD_LOGIC;
        DDR_ck_n            : inout STD_LOGIC;
        DDR_ck_p            : inout STD_LOGIC;
        DDR_cke             : inout STD_LOGIC;
        DDR_cs_n            : inout STD_LOGIC;
        DDR_dm              : inout STD_LOGIC_VECTOR ( 3 downto 0 );
        DDR_dq              : inout STD_LOGIC_VECTOR ( 31 downto 0 );
        DDR_dqs_n           : inout STD_LOGIC_VECTOR ( 3 downto 0 );
        DDR_dqs_p           : inout STD_LOGIC_VECTOR ( 3 downto 0 );
        DDR_odt             : inout STD_LOGIC;
        DDR_ras_n           : inout STD_LOGIC;
        DDR_reset_n         : inout STD_LOGIC;
        DDR_we_n            : inout STD_LOGIC;
        FIXED_IO_ddr_vrn    : inout STD_LOGIC;
        FIXED_IO_ddr_vrp    : inout STD_LOGIC;
        FIXED_IO_mio        : inout STD_LOGIC_VECTOR ( 53 downto 0 );
        FIXED_IO_ps_clk     : inout STD_LOGIC;
        FIXED_IO_ps_porb    : inout STD_LOGIC;
        FIXED_IO_ps_srstb   : inout STD_LOGIC	

);
end top;


architecture top of top is		


constant	BLOCK_CNT				: std_logic_vector( 15 downto 0 ):=x"0008";  --! count of block in address space


signal	clk		    					: std_logic;    
signal	reset_n			    			: std_logic;    
signal	irq_f2p							: std_logic_vector( 0 downto 0 );
signal  gp0_axi_s         			: s_axi_type;
signal  gp0_axi_m         			: m_axi_type;
signal  hp0_axi_m	        			: m_axi_type;
signal  hp0_axi_s   	    			: s_axi_type;
signal  hp2_axi_m           			: m_axi_type;
signal  hp2_axi_s           			: s_axi_type;



signal	user_reg_adr					: std_logic_vector( 31 downto 0 );	
signal	user_reg_data_o					: std_logic_vector( 31 downto 0 );	
signal	user_reg_data_i					: std_logic_vector( 31 downto 0 );	
signal	user_reg_data_wr_req			: std_logic;	
signal	user_reg_data_wr_complete		: std_logic;	
signal	user_reg_data_rd_req			: std_logic;	
signal	user_reg_data_rd_complete		: std_logic;


signal	reset_main_n					: std_logic;

signal	user_reset_n					: std_logic;

signal	bl_adr							: std_logic_vector( 7 downto 0 );
signal	bl_host_data					: std_logic_vector( 31 downto 0 );
signal	bl0_data_we						: std_logic;
signal	bl1_data_we						: std_logic;
signal	bl2_data_we						: std_logic;
signal	bl3_data_we						: std_logic;
signal	bl4_data_we						: std_logic;
signal	bl5_data_we						: std_logic;
signal	bl6_data_we						: std_logic;
signal	bl7_data_we						: std_logic;
signal	bl0_data						: std_logic_vector( 31 downto 0 ):=(others=>'0');
signal	bl1_data						: std_logic_vector( 31 downto 0 ):=(others=>'0');
signal	bl2_data						: std_logic_vector( 31 downto 0 ):=(others=>'0');
signal	bl3_data						: std_logic_vector( 31 downto 0 ):=(others=>'0');
signal	bl4_data						: std_logic_vector( 31 downto 0 ):=(others=>'0');
signal	bl5_data						: std_logic_vector( 31 downto 0 ):=(others=>'0');
signal	bl6_data						: std_logic_vector( 31 downto 0 ):=(others=>'0');
signal	bl7_data						: std_logic_vector( 31 downto 0 ):=(others=>'0');		



begin					

	
zynq: zynq_system 
	generic map(
		is_simulation => is_simulation
	)
	port map(
	
        DDR_addr            => DDR_addr,
        DDR_ba              => DDR_ba,
        DDR_cas_n           => DDR_cas_n,
        DDR_ck_n            => DDR_ck_n,
        DDR_ck_p            => DDR_ck_p,
        DDR_cke             => DDR_cke,
        DDR_cs_n            => DDR_cs_n,
        DDR_dm              => DDR_dm,
        DDR_dq              => DDR_dq,
        DDR_dqs_n           => DDR_dqs_n,
        DDR_dqs_p           => DDR_dqs_p,
        DDR_odt             => DDR_odt,
        DDR_ras_n           => DDR_ras_n,
        DDR_reset_n         => DDR_reset_n,
        DDR_we_n            => DDR_we_n,
        FIXED_IO_ddr_vrn    => FIXED_IO_ddr_vrn,
        FIXED_IO_ddr_vrp    => FIXED_IO_ddr_vrp,
        FIXED_IO_mio        => FIXED_IO_mio,
        FIXED_IO_ps_clk     => FIXED_IO_ps_clk,
        FIXED_IO_ps_porb    => FIXED_IO_ps_porb,
        FIXED_IO_ps_srstb   => FIXED_IO_ps_srstb,
	
		aclk_out		    => clk,    		
		reset_n			    => reset_n,    	
		
		irq_f2p				=> irq_f2p,

        gp0_axi_s         	=> gp0_axi_s,
        gp0_axi_m        	=> gp0_axi_m,

        hp0_axi_m          	=> hp0_axi_m,
        hp0_axi_s         	=> hp0_axi_s

 
);							 

host: entity work.sm_dma 
	port map(
	
		clk							=> clk,		
		reset						=> reset_n,
	                            	
		s00_axi_m					=> gp0_axi_m,
		s00_axi_s					=> gp0_axi_s,	
		                        	
		reset_o						=> user_reset_n,
		
		bl_adr						=> bl_adr,
		bl_host_data				=> bl_host_data,
		
		bl0_data_we					=> bl0_data_we,
		bl1_data_we					=> bl1_data_we,
		bl2_data_we					=> bl2_data_we,
		bl3_data_we					=> bl3_data_we,
		bl4_data_we					=> bl4_data_we,
		bl5_data_we					=> bl5_data_we,
		bl6_data_we					=> bl6_data_we,
		bl7_data_we					=> bl7_data_we,
		
		bl0_data					=> bl0_data,
		bl1_data					=> bl1_data,
		bl2_data					=> bl2_data,
		bl3_data					=> bl3_data,
		bl4_data					=> bl4_data,
		bl5_data					=> bl5_data,
		bl6_data					=> bl6_data,
		bl7_data					=> bl7_data,
		
		---- Access to user space ----
		user_reg_adr				=> user_reg_adr,
		user_reg_data_o				=> user_reg_data_o,
		user_reg_data_i				=> user_reg_data_i,
		user_reg_data_wr_req		=> user_reg_data_wr_req,
		user_reg_data_wr_complete	=> user_reg_data_wr_complete,
		user_reg_data_rd_req		=> user_reg_data_rd_req,
		user_reg_data_rd_complete	=> user_reg_data_rd_complete
	);
	
	
main: entity work.sm_dma_main 
	generic map(
		Device_ID					=> Device_ID, 	
		Revision					=> Revision, 	
		PLD_ID						=> PLD_ID, 		
		PLD_VER						=> PLD_VER, 	
		PLD_BUILD					=> PLD_BUILD, 	
		BLOCK_CNT					=> BLOCK_CNT 	
	)	
	port map(
	
		---- Global ----
		reset_i						=> reset_main_n,	
		clk							=> clk,				
		reset_o						=> user_reset_n,	
		
		---- HOST ----
		bl_adr						=> bl_adr( 4 downto 0 ),
		bl_data_in					=> bl_host_data,		
		bl_data_out					=> bl0_data,			
		bl_data_we					=> bl0_data_we			
		
		---- Управление ----
--		brd_mode0		: out std_logic_vector( 15 downto 0 );  --! BRD_MODE0 register
--		brd_mode1		: out std_logic_vector( 15 downto 0 );  --! BRD_MODE1 register
--		brd_status		: in  std_logic_vector( 15 downto 0 ):=(others=>'0')
		
	);	
	
end top;
