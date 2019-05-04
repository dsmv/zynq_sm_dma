-------------------------------------------------------------------------------
--
-- Title       : cl_axi_slave
-- Author      : Dmitry Smekhov
-- Company     : Instrumental Systems
-- E-mail      : dsmv@insys.ru
--
-- Version     : 1.0
--
-------------------------------------------------------------------------------
--
-- Description : Decode AXI4/AXI3 bus for access to register
--															
--				Support only single 32-bit read and write operation.
--
-------------------------------------------------------------------------------
--
-- Version 1.0  
--
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;

use work.axi_pkg.all;


entity cl_axi_slave is
	port(

		clk						: in std_logic;		--! AXI bus clock
		reset					: in std_logic; 	--! 0 - reset
	
		mgp0_axi_lite_m			: in M_AXI_TYPE;   	--! AXI3 bus, master
		mgp0_axi_lite_s			: out S_AXI_TYPE;	--! AXI3 bus, slave
		
		reg_adr					: out std_logic_vector( 31 downto 0 );	--! address
		reg_data_o				: out std_logic_vector( 31 downto 0 );	--! data for write
		reg_data_i				: in  std_logic_vector( 31 downto 0 );	--! data for read
		reg_data_wr_req			: out std_logic;	--! 1 - write strobe, set to '1' until reg_data_wr_complete='1' 
		reg_data_wr_complete	: in std_logic;		--! 1 - write complete
		reg_data_rd_req			: out std_logic;	--! 1 - read strobe, set to '1' until reg_data_rd_complete='1' 
		reg_data_rd_complete	: in std_logic		--! 1 - read complete
		
	
	);
end cl_axi_slave;


architecture cl_axi_slave of cl_axi_slave is										

signal	rstp_z			: std_logic;
signal	rstp_z1			: std_logic;

signal	awready			: std_logic;
signal	wready			: std_logic;  	
signal	arready			: std_logic;
signal	bvalid			: std_logic;
signal	req_wr_0		: std_logic;
signal	rvalid			: std_logic;					 

signal	rdata			: std_logic_vector( 31 downto 0 );
signal	rdata_i			: std_logic_vector( 31 downto 0 );

signal	awadr			: std_logic_vector( 19 downto 0 );
signal	aradr			: std_logic_vector( 19 downto 0 );
signal	rresp			: std_logic_vector( 1 downto 0 );
--signal	bresp			: std_logic_vector( 1 downto 0 );

type 	stw_type		is ( s0, s1, s2, s3, s4, s5 );
signal	stw				: stw_type;

type 	stp_type		is ( s0, s1, s2 );
signal	stp				: stp_type;

signal  sel_awadr       : std_logic;
signal  disp_data       : std_logic_vector( 31 downto 0 );

signal	wr_req			: std_logic;
signal	rd_req			: std_logic;

begin									   
	
rstp_z <= not reset after 1 ns when rising_edge( clk );	
rstp_z1 <= rstp_z after 1 ns when rising_edge( clk );	

mgp0_axi_lite_s.awready <= awready;
mgp0_axi_lite_s.wready  <= wready;
mgp0_axi_lite_s.bvalid  <= bvalid;
mgp0_axi_lite_s.bresp <=rresp;
mgp0_axi_lite_s.rresp <=rresp;
mgp0_axi_lite_s.rdata( 31 downto 0 ) <= rdata;
mgp0_axi_lite_s.rdata( 63 downto 32 ) <= (others=>'0');
--mgp0_axi_lite_s.rdata <=(others=>'0');

mgp0_axi_lite_s.arready <= arready;
mgp0_axi_lite_s.rvalid <= rvalid;	

mgp0_axi_lite_s.bid <= mgp0_axi_lite_m.awid after 1 ns when rising_edge( clk );
mgp0_axi_lite_s.rid <= mgp0_axi_lite_m.arid after 1 ns when rising_edge( clk );
mgp0_axi_lite_s.rlast <= '1';


reg_data_wr_req <= wr_req;
reg_data_rd_req <= rd_req;

rdata <= rdata_i after 1 ns when rising_edge( clk );

rdata_i <= reg_data_i after 1 ns when rising_edge( clk ) and  reg_data_rd_complete='1';


reg_adr( 31 downto 18 ) <= (others=>'0');
reg_adr( 17 downto 0  ) <= awadr( 19 downto 2 ) when sel_awadr='1' else
                           aradr( 19 downto 2 );

reg_data_o <= mgp0_axi_lite_m.wdata( 31 downto 0 ) after 1 ns when rising_edge( clk ) and mgp0_axi_lite_m.wvalid='1';



pr_write_state: process( clk ) begin
	if( rising_edge( clk ) ) then
		case( stw ) is
			when s0 =>
				awready <= not reg_data_wr_complete after 1 ns; 
				awadr <= mgp0_axi_lite_m.awaddr( 19 downto 0 ) after 1 ns;
				if( mgp0_axi_lite_m.awvalid='1' and awready='1' ) then
				--if( mgp0_axi_lite_m.awvalid='1' ) then
					stw <= s1 after 1 ns;
					awready <= '0' after 1 ns;
				end if;	  
				
				wr_req <= '0' after 1 ns;
				bvalid <= '0' after 1 ns;
				wready <= '0' after 1 ns;	   
				rresp <= (others=>'0') after 1 ns;
				req_wr_0 <= '0' after 1 ns;
				sel_awadr <= '0' after 1 ns;
				
			when s1 =>
				awready <= '0' after 1 ns;
				sel_awadr <= '1' after 1 ns;
				-- BAR0 --
				req_wr_0 <= '1' after 1 ns;
				stw <= s2 after 1 ns;
				
			when s2 => 
				if( mgp0_axi_lite_m.wvalid='1' ) then
					stw <= s3 after 1 ns;
				end if;
			when s3 =>	 
				wr_req <= '1' after 1 ns;
				awready <= '0' after 1 ns;
				stw <= s4 after 1 ns;		   
				wready <= '1' after 1 ns;
				bvalid <= '0' after 1 ns; 
				
			when s4 =>					  
				bvalid <= '1' after 1 ns; 
				wready <= '0' after 1 ns;
				if( mgp0_axi_lite_m.bready='1' ) then
					stw <= s5 after 1 ns; 
				end if;
				req_wr_0 <= '0' after 1 ns;
				
			when s5 =>
				bvalid <= '0' after 1 ns; 
				if( reg_data_wr_complete='1' ) then
					stw <= s0 after 1 ns;
				end if;
				
				
		end case;
		
		if( rstp_z='1' ) then
			stw <= s0 after 1 ns;
			awready <= '0' after 1 ns;
			rresp <= (others=>'1') after 1 ns;
		end if;
		
		
	end if;
end process;


pr_read_state: process( clk ) begin
	if( rising_edge( clk ) ) then
		case( stp ) is
			when s0 =>
				arready <= not reg_data_rd_complete after 1 ns;
				aradr <= mgp0_axi_lite_m.araddr( 19 downto 0 ) after 1 ns;
				if( mgp0_axi_lite_m.arvalid='1' and arready='1' ) then
					stp <= s1 after 1 ns;
					arready <= '0' after 1 ns;
				end if;	  
				rvalid <= '0' after 1 ns;
				rd_req <= '0' after 1 ns;
				
			when s1 =>
				rd_req <= '1' after 1 ns;
				arready <= '0' after 1 ns;
				-- BAR0 --	
				if( reg_data_rd_complete='1' ) then
					stp <= s2 after 1 ns;			   
				end if;
				
			when s2 =>
				rd_req <= '0' after 1 ns;
				rvalid <= '1' after 1 ns;
				if( mgp0_axi_lite_m.rready='1' ) then
					stp <= s0 after 1 ns;
				end if;
			
		end case;
		
		if( rstp_z1='1' ) then
			stp <= s0 after 1 ns;
			arready <= '0' after 1 ns;
		end if;
	end if;
end process;

end cl_axi_slave;
