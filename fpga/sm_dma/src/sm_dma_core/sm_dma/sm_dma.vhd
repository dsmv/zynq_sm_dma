-------------------------------------------------------------------------------
--
-- Title       : sm_dma
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

use work.axi_pkg.all;

entity sm_dma is 
--	generic(
--		Device_ID		: in std_logic_vector( 15 downto 0 ):=x"0000"; -- ID of HW
--		Revision		: in std_logic_vector( 15 downto 0 ):=x"0000"; -- revision of HW
--		PLD_ID			: in std_logic_vector( 15 downto 0 ):=x"0000"; -- ID of FPGA
--		PLD_VER			: in std_logic_vector( 15 downto 0 ):=x"0000"; -- version of FPGA
--		PLD_BUILD		: in std_logic_vector( 15 downto 0 ):=x"0000"  -- build of FPGA
--	);
	port(
	
		clk							: in std_logic;	
		reset						: in std_logic; 
	                            	
		s00_axi_m					: in M_AXI_TYPE;
		s00_axi_s					: out S_AXI_TYPE;	
		                        	
		reset_o						: out std_logic;	  
		
		--- Access to control block address space ---
		bl_adr						: out std_logic_vector( 7 downto 0 );
		bl_host_data				: out std_logic_vector( 31 downto 0 );
		                        	
		bl0_data_we					: out std_logic;
		bl1_data_we					: out std_logic;
		bl2_data_we					: out std_logic;
		bl3_data_we					: out std_logic;
		bl4_data_we					: out std_logic;
		bl5_data_we					: out std_logic;
		bl6_data_we					: out std_logic;
		bl7_data_we					: out std_logic;
		                        	
		bl0_data					: in std_logic_vector( 31 downto 0 ):=(others=>'0');
		bl1_data					: in std_logic_vector( 31 downto 0 ):=(others=>'0');
		bl2_data					: in std_logic_vector( 31 downto 0 ):=(others=>'0');
		bl3_data					: in std_logic_vector( 31 downto 0 ):=(others=>'0');
		bl4_data					: in std_logic_vector( 31 downto 0 ):=(others=>'0');
		bl5_data					: in std_logic_vector( 31 downto 0 ):=(others=>'0');
		bl6_data					: in std_logic_vector( 31 downto 0 ):=(others=>'0');
		bl7_data					: in std_logic_vector( 31 downto 0 ):=(others=>'0');		

		
		---- Access to user space ----
		user_reg_adr				: out std_logic_vector( 31 downto 0 );	 --! address        
		user_reg_data_o				: out std_logic_vector( 31 downto 0 );	 --! data for write 
		user_reg_data_i				: in  std_logic_vector( 31 downto 0 );	 --! data for read  
		user_reg_data_wr_req		: out std_logic;	--! 1 - write strobe, set to '1' until reg_data_wr_complete='1'   
		user_reg_data_wr_complete	: in std_logic;		--! 1 - write complete                                            
		user_reg_data_rd_req		: out std_logic;	--! 1 - read strobe, set to '1' until reg_data_rd_complete='1'    
		user_reg_data_rd_complete	: in std_logic		--! 1 - read complete                                             
		

		
	);	
end sm_dma;


architecture sm_dma of sm_dma is



--signal	bl_adr						: std_logic_vector( 7 downto 0 );
--signal	bl_host_data				: std_logic_vector( 31 downto 0 );
--
--signal	bl0_data_we					: std_logic;
--
--signal	bl0_data					: std_logic_vector( 31 downto 0 ):=(others=>'0');

signal	reset_n						: std_logic;

begin
	
reset_o <= reset_n after 1 ns when rising_edge( clk );
	
axi:  entity work.cl_base_axi_m2 
	port map(
	
		clk							=> clk,
		reset						=> reset,
	                            	                           
		s00_axi_m					=> s00_axi_m,
		s00_axi_s					=> s00_axi_s,
		
		reset_o						=> reset_n,
		
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
		
		user_reg_adr				=> user_reg_adr,
		user_reg_data_o				=> user_reg_data_o,
		user_reg_data_i				=> user_reg_data_i,
		user_reg_data_wr_req		=> user_reg_data_wr_req,
		user_reg_data_wr_complete	=> user_reg_data_wr_complete,
		user_reg_data_rd_req		=> user_reg_data_rd_req,
		user_reg_data_rd_complete	=> user_reg_data_rd_complete
	);

end sm_dma;
