-------------------------------------------------------------------------------
--
-- Title       : cl_base_axi_m2
-- Author      : Dmitry Smekhov
-- Company     : Instrumental Systems
--
-- Version     : 1.0
--
-------------------------------------------------------------------------------
--
-- Description : Decode AXI4/AXI3 bus for access to control blocks and
--				 user region
--
-------------------------------------------------------------------------------
--
--	Version : 1.0  
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

use work.axi_pkg.all;


entity cl_base_axi_m2 is
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
		                        	
		bl0_data					: in std_logic_vector( 31 downto 0 ):=(others=>'0');
		bl1_data					: in std_logic_vector( 31 downto 0 ):=(others=>'0');
		bl2_data					: in std_logic_vector( 31 downto 0 ):=(others=>'0');
		bl3_data					: in std_logic_vector( 31 downto 0 ):=(others=>'0');
		
		---- Access to user space ----
		user_reg_adr				: out std_logic_vector( 31 downto 0 );	 --! address        
		user_reg_data_o				: out std_logic_vector( 31 downto 0 );	 --! data for write 
		user_reg_data_i				: in  std_logic_vector( 31 downto 0 );	 --! data for read  
		user_reg_data_wr_req		: out std_logic;	--! 1 - write strobe, set to '1' until reg_data_wr_complete='1'   
		user_reg_data_wr_complete	: in std_logic;		--! 1 - write complete                                            
		user_reg_data_rd_req		: out std_logic;	--! 1 - read strobe, set to '1' until reg_data_rd_complete='1'    
		user_reg_data_rd_complete	: in std_logic		--! 1 - read complete                                             
		

		
	);
end cl_base_axi_m2;


architecture cl_base_axi_m2 of cl_base_axi_m2 is

signal reg_adr						: std_logic_vector( 31 downto 0 );	
signal reg_data_o					: std_logic_vector( 31 downto 0 );	
signal reg_data_i					: std_logic_vector( 31 downto 0 );	
signal reg_data_wr_req				: std_logic;	
signal reg_data_wr_complete			: std_logic;	
signal reg_data_rd_req				: std_logic;	
signal reg_data_rd_complete			: std_logic;	

signal reg_data_wr_req_z2			: std_logic;	
signal reg_data_rd_req_z2			: std_logic;	



signal	adr_block_enable			: std_logic;

begin

	
slave:  entity work.cl_axi_slave 
	port map(

		clk						=> clk,	
		reset					=> reset,
	
		mgp0_axi_lite_m			=> s00_axi_m,
		mgp0_axi_lite_s			=> s00_axi_s,
		
		reg_adr					=> reg_adr,
		reg_data_o				=> reg_data_o,
		reg_data_i				=> reg_data_i,
		reg_data_wr_req			=> reg_data_wr_req,
		reg_data_wr_complete	=> reg_data_wr_complete,
		reg_data_rd_req			=> reg_data_rd_req,
		reg_data_rd_complete	=> reg_data_rd_complete
	
	);
	
xwr_req:	srl16 port map( q=>reg_data_wr_req_z2, clk=>clk, d=>reg_data_wr_req, a3=>'0', a2=>'0', a1=>'1', a0=>'0');	
xrd_req:	srl16 port map( q=>reg_data_rd_req_z2, clk=>clk, d=>reg_data_rd_req, a3=>'0', a2=>'0', a1=>'1', a0=>'0');
	
reg_data_wr_complete <= reg_data_wr_req_z2 after 1 ns when rising_edge( clk );	
reg_data_rd_complete <= reg_data_rd_req_z2 after 1 ns when rising_edge( clk );

user_reg_data_wr_req <= reg_data_wr_req and not adr_block_enable;
user_reg_data_rd_req <= reg_data_rd_req and not adr_block_enable;		
user_reg_data_o  <= reg_data_o;
user_reg_adr <= reg_adr;

reg_data_i <= user_reg_data_i when adr_block_enable='0' else
			  bl0_data when reg_adr( 8 downto 6 )="000" else
			  bl1_data when reg_adr( 8 downto 6 )="001" else
			  bl2_data when reg_adr( 8 downto 6 )="010" else
			  bl3_data when reg_adr( 8 downto 6 )="011" else
			  (others=>'0');
			 
			 
bl_adr <= reg_adr( 8 downto 1 ) after 1 ns when rising_edge( clk );
bl_host_data <= reg_data_o after 1 ns when rising_edge( clk );
			  
pr_bl0_data_we: process( clk ) begin
	if( rising_edge( clk ) ) then
		
		if( reg_adr( 24 downto 9 )=x"0000" ) then
			adr_block_enable <= '1' after 1 ns;
		else
			adr_block_enable <= '0' after 1 ns;
		end if;
		
		bl0_data_we <= '0' after 1 ns;
		bl1_data_we <= '0' after 1 ns;
		bl2_data_we <= '0' after 1 ns;
		bl3_data_we <= '0' after 1 ns;
--		if( reg_adr( 8 downto 6 )="000" ) then
--			bl0_data_we <= reg_data_wr_req and not reg_data_wr_complete after 1 ns;
--		end if;

		if( adr_block_enable='1' ) then
			case( reg_adr( 8 downto 6 ) ) is
				when "000" =>  bl0_data_we <= reg_data_wr_req and not reg_data_wr_complete after 1 ns;
				when "001" =>  bl1_data_we <= reg_data_wr_req and not reg_data_wr_complete after 1 ns;
				when "010" =>  bl2_data_we <= reg_data_wr_req and not reg_data_wr_complete after 1 ns;
				when "011" =>  bl3_data_we <= reg_data_wr_req and not reg_data_wr_complete after 1 ns;
			
				when others => null;
			end case;
		end if;
		
	end if;
end process;	



reset_o <= reset after 1 ns when rising_edge( clk );

	


end cl_base_axi_m2;
