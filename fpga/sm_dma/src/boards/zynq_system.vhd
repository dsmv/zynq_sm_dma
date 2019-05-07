-------------------------------------------------------------------------------
--
-- Title       : zynq_system
--
-- Version     : 1.0
--
-------------------------------------------------------------------------------
--
-- Description : 	Connect to  zynq in Block Design 
--
--
-------------------------------------------------------------------------------
--
--  Version 1.0  07.05.2019
--
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;


library work;
use work.axi_pkg.all;

package	zynq_system_pkg is


component zynq_system is
	generic(

		is_simulation		: in integer:=0	 -- 1 - simulation mode
	);	
	port(		
	    --- External ---
        ddr_addr            : inout std_logic_vector ( 14 downto 0 );
        ddr_ba              : inout std_logic_vector ( 2 downto 0 );
        ddr_cas_n           : inout std_logic;
        ddr_ck_n            : inout std_logic;
        ddr_ck_p            : inout std_logic;
        ddr_cke             : inout std_logic;
        ddr_cs_n            : inout std_logic;
        ddr_dm              : inout std_logic_vector ( 3 downto 0 );
        ddr_dq              : inout std_logic_vector ( 31 downto 0 );
        ddr_dqs_n           : inout std_logic_vector ( 3 downto 0 );
        ddr_dqs_p           : inout std_logic_vector ( 3 downto 0 );
        ddr_odt             : inout std_logic;
        ddr_ras_n           : inout std_logic;
        ddr_reset_n         : inout std_logic;
        ddr_we_n            : inout std_logic;
        fixed_io_ddr_vrn    : inout std_logic;
        fixed_io_ddr_vrp    : inout std_logic;
        fixed_io_mio        : inout std_logic_vector ( 53 downto 0 );
        fixed_io_ps_clk     : inout std_logic;
        fixed_io_ps_porb    : inout std_logic;
        fixed_io_ps_srstb   : inout std_logic;	

		--- Internal ---
		reset_n			    : out std_logic;    -- 0 - reset
		
		aclk_out		    : out std_logic;    -- clock for axi bus
		
		clk1_out			: out std_logic;
		clk2_out			: out std_logic;
		clk3_out			: out std_logic;
		
		irq_f2p				: in std_logic_vector( 0 downto 0 );

        gp0_axi_s        	: in s_axi_type;
        gp0_axi_m       	: out m_axi_type;

        hp0_axi_m          	: in m_axi_type;
        hp0_axi_s         	: out s_axi_type
        
);
end component;

end package;



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.axi_pkg.all;
use work.zynq_system_pkg.all;

entity zynq_system is		  
	generic(
		is_simulation		: in integer:=0	 -- 1 - simulation mode
	);	
	port(		
	    --- External ---
        ddr_addr            : inout std_logic_vector ( 14 downto 0 );
        ddr_ba              : inout std_logic_vector ( 2 downto 0 );
        ddr_cas_n           : inout std_logic;
        ddr_ck_n            : inout std_logic;
        ddr_ck_p            : inout std_logic;
        ddr_cke             : inout std_logic;
        ddr_cs_n            : inout std_logic;
        ddr_dm              : inout std_logic_vector ( 3 downto 0 );
        ddr_dq              : inout std_logic_vector ( 31 downto 0 );
        ddr_dqs_n           : inout std_logic_vector ( 3 downto 0 );
        ddr_dqs_p           : inout std_logic_vector ( 3 downto 0 );
        ddr_odt             : inout std_logic;
        ddr_ras_n           : inout std_logic;
        ddr_reset_n         : inout std_logic;
        ddr_we_n            : inout std_logic;
        fixed_io_ddr_vrn    : inout std_logic;
        fixed_io_ddr_vrp    : inout std_logic;
        fixed_io_mio        : inout std_logic_vector ( 53 downto 0 );
        fixed_io_ps_clk     : inout std_logic;
        fixed_io_ps_porb    : inout std_logic;
        fixed_io_ps_srstb   : inout std_logic;	

		--- Internal ---
		reset_n			    : out std_logic;    -- 0 - reset
		
		aclk_out		    : out std_logic;    -- clock for axi bus
		
		clk1_out			: out std_logic;
		clk2_out			: out std_logic;
		clk3_out			: out std_logic;
		
		irq_f2p				: in std_logic_vector( 0 downto 0 );

        gp0_axi_s        	: in s_axi_type;
        gp0_axi_m       	: out m_axi_type;

        hp0_axi_m          	: in m_axi_type;
        hp0_axi_s         	: out s_axi_type
        
);
end zynq_system;


architecture zynq_system of zynq_system is

component zynq_m1_wrapper is
 port (
    ACLK_OUT : out STD_LOGIC;
    ARESETn_OUT : out STD_LOGIC_VECTOR ( 0 to 0 );
    CLK1_OUT : out STD_LOGIC;
    CLK2_OUT : out STD_LOGIC;
    CLK3_OUT : out STD_LOGIC;
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    IRQ_F2P : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_GP0_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_GP0_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_arid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_arlen : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_arlock : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_arready : in STD_LOGIC;
    M_AXI_GP0_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_arvalid : out STD_LOGIC;
    M_AXI_GP0_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_GP0_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_awid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_awlen : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_awlock : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_awready : in STD_LOGIC;
    M_AXI_GP0_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_awvalid : out STD_LOGIC;
    M_AXI_GP0_bid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_bready : out STD_LOGIC;
    M_AXI_GP0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_bvalid : in STD_LOGIC;
    M_AXI_GP0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_GP0_rid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_rlast : in STD_LOGIC;
    M_AXI_GP0_rready : out STD_LOGIC;
    M_AXI_GP0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_rvalid : in STD_LOGIC;
    M_AXI_GP0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_GP0_wid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_wlast : out STD_LOGIC;
    M_AXI_GP0_wready : in STD_LOGIC;
    M_AXI_GP0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_wvalid : out STD_LOGIC;
    S_AXI_HP0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_HP0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_arready : out STD_LOGIC;
    S_AXI_HP0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_arvalid : in STD_LOGIC;
    S_AXI_HP0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_HP0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_awready : out STD_LOGIC;
    S_AXI_HP0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_awvalid : in STD_LOGIC;
    S_AXI_HP0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_bready : in STD_LOGIC;
    S_AXI_HP0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_bvalid : out STD_LOGIC;
    S_AXI_HP0_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXI_HP0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_rlast : out STD_LOGIC;
    S_AXI_HP0_rready : in STD_LOGIC;
    S_AXI_HP0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_rvalid : out STD_LOGIC;
    S_AXI_HP0_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXI_HP0_wid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_wlast : in STD_LOGIC;
    S_AXI_HP0_wready : out STD_LOGIC;
    S_AXI_HP0_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP0_wvalid : in STD_LOGIC
  );end component;	 


component zynq_sim_m2 is		 
	generic( 
		instance 		: in integer:=0		-- номер экзкмпляра узла 
	);
	port( 	
	
		clk		    			: in std_logic;    -- тактовая частота шины
		reset_n			    	: in std_logic;    -- 0 - сброс 
		
		irq_f2p					: in std_logic_vector( 0 downto 0 ):="0";

        m_axi_gp0_s         	: in s_axi_type;
        m_axi_gp0_m         	: out  m_axi_type;

        hp0_axi_m          		: in m_axi_type;
        hp0_axi_s          		: out  s_axi_type
        
--        hp2_axi_m          		: in m_axi_type;
--        hp2_axi_s         		: out  s_axi_type	
		
		
	);
end  component;


signal	areset_n		: std_logic_vector (0 downto 0);	   
signal	clk				: std_logic:='0';	-- for simulation only
  

signal	gp0_axi_i	: S_AXI_TYPE;
signal	gp0_axi_o	: M_AXI_TYPE;


signal	hp0_axi_i	: M_AXI_TYPE;	
signal	hp0_axi_o	: S_AXI_TYPE;	

begin

gen_synt: if( is_simulation=0 ) generate
	
i_ZYNQ : zynq_m1_wrapper
   port map(
	ACLK_OUT			=> ACLK_OUT,
	ARESETn_OUT			=> areset_n,
	
	clk1_out			=> clk1_out,
	clk2_out			=> clk2_out,
	clk3_out			=> clk3_out,	
	
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



	
	S_AXI_HP0_araddr		=> hp0_axi_i.araddr,
	S_AXI_HP0_arburst		=> hp0_axi_i.arburst,
	S_AXI_HP0_arcache		=> hp0_axi_i.arcache,
	S_AXI_HP0_arlen			=> hp0_axi_i.arlen( 3 downto 0 ),
	S_AXI_HP0_arlock  		=> hp0_axi_i.arlock(1 downto 0 ),
	S_AXI_HP0_arprot  		=> hp0_axi_i.arprot,
	S_AXI_HP0_arqos  		=> hp0_axi_i.arqos,
	S_AXI_HP0_arready	    => hp0_axi_o.arready,
	--S_AXI_HP0_arregion	=> hp0_axi_i.arregion,
	S_AXI_HP0_arsize  		=> hp0_axi_i.arsize,
	S_AXI_HP0_arvalid  		=> hp0_axi_i.arvalid,
	S_AXI_HP0_awaddr  		=> hp0_axi_i.awaddr,
	S_AXI_HP0_awburst  		=> hp0_axi_i.awburst,
	S_AXI_HP0_awcache  		=> hp0_axi_i.awcache,
	S_AXI_HP0_awlen  		=> hp0_axi_i.awlen( 3 downto 0 ),
	S_AXI_HP0_awlock  		=> hp0_axi_i.awlock( 1 downto 0 ),
	S_AXI_HP0_awprot  		=> hp0_axi_i.awprot,
	S_AXI_HP0_awqos  		=> hp0_axi_i.awqos,
	S_AXI_HP0_awready  		=> hp0_axi_o.awready,
	--S_AXI_HP0_awregion	=> hp0_axi_i.awregion,
	S_AXI_HP0_awsize  		=> hp0_axi_i.awsize,
	S_AXI_HP0_awvalid  		=> hp0_axi_i.awvalid,
	S_AXI_HP0_bready  		=> hp0_axi_i.bready,
	S_AXI_HP0_bresp  		=> hp0_axi_o.bresp,
	S_AXI_HP0_bvalid  		=> hp0_axi_o.bvalid,
	S_AXI_HP0_rdata  		=> hp0_axi_o.rdata,
	S_AXI_HP0_rlast  		=> hp0_axi_o.rlast,
	S_AXI_HP0_rready  		=> hp0_axi_i.rready,
	S_AXI_HP0_rresp  		=> hp0_axi_o.rresp,
	S_AXI_HP0_rvalid  		=> hp0_axi_o.rvalid,
	S_AXI_HP0_wdata  		=> hp0_axi_i.wdata,
	S_AXI_HP0_wid 			=> hp0_axi_i.wid( 5 downto 0 ),
	S_AXI_HP0_wlast  		=> hp0_axi_i.wlast,
	S_AXI_HP0_wready  		=> hp0_axi_o.wready,
	S_AXI_HP0_wstrb  		=> hp0_axi_i.wstrb,
	S_AXI_HP0_wvalid  		=> hp0_axi_i.wvalid,
	
    S_AXI_HP0_arid        	=> hp0_axi_i.arid( 5 downto 0 ),
    S_AXI_HP0_awid        	=> hp0_axi_i.awid( 5 downto 0 ),
    S_AXI_HP0_bid         	=> hp0_axi_o.bid( 5 downto 0 ),
    S_AXI_HP0_rid         	=> hp0_axi_o.rid( 5 downto 0 ),
	
	

	IRQ_F2P				=> IRQ_F2P,

	
	M_AXI_GP0_araddr	=> gp0_axi_o.araddr,
	M_AXI_GP0_arburst	=> gp0_axi_o.arburst,
	M_AXI_GP0_arcache	=> gp0_axi_o.arcache,
	M_AXI_GP0_arid  	=> gp0_axi_o.arid,
	M_AXI_GP0_arlen  	=> gp0_axi_o.arlen( 3 downto 0 ),
	M_AXI_GP0_arlock	=> gp0_axi_o.arlock( 1 downto 0 ),
	M_AXI_GP0_arprot	=> gp0_axi_o.arprot,
	M_AXI_GP0_arqos		=> gp0_axi_o.arqos,
	M_AXI_GP0_arready	=> gp0_axi_i.arready,
	--M_AXI_GP0_arregion	=> gp0_axi_o.arregion,
	M_AXI_GP0_arsize	=> gp0_axi_o.arsize,
	M_AXI_GP0_arvalid	=> gp0_axi_o.arvalid,
	M_AXI_GP0_awaddr	=> gp0_axi_o.awaddr,
	M_AXI_GP0_awburst	=> gp0_axi_o.awburst,
	M_AXI_GP0_awcache	=> gp0_axi_o.awcache,
	M_AXI_GP0_awid		=> gp0_axi_o.awid,
	M_AXI_GP0_awlen		=> gp0_axi_o.awlen( 3 downto 0 ),
	M_AXI_GP0_awlock	=> gp0_axi_o.awlock( 1 downto 0 ),
	M_AXI_GP0_awprot	=> gp0_axi_o.awprot,
	M_AXI_GP0_awqos		=> gp0_axi_o.awqos,
	M_AXI_GP0_awready	=> gp0_axi_i.awready,
	--M_AXI_GP0_awregion	=> gp0_axi_o.awregion,
	M_AXI_GP0_awsize		=> gp0_axi_o.awsize,
	M_AXI_GP0_awvalid	=> gp0_axi_o.awvalid,
	M_AXI_GP0_bid		=> gp0_axi_i.bid,
	M_AXI_GP0_bready	=> gp0_axi_o.bready,
	M_AXI_GP0_bresp		=> gp0_axi_i.bresp,
	M_AXI_GP0_bvalid	=> gp0_axi_i.bvalid,
	M_AXI_GP0_rdata		=> gp0_axi_i.rdata(31 downto 0),
	M_AXI_GP0_rid		=> gp0_axi_i.rid,
	M_AXI_GP0_rlast		=> gp0_axi_i.rlast,
	M_AXI_GP0_rready	=> gp0_axi_o.rready,
	M_AXI_GP0_rresp		=> gp0_axi_i.rresp,
	M_AXI_GP0_rvalid	=> gp0_axi_i.rvalid,
	M_AXI_GP0_wdata		=> gp0_axi_o.wdata(31 downto 0),
	M_AXI_GP0_wlast		=> gp0_axi_o.wlast,
	M_AXI_GP0_wready	=> gp0_axi_i.wready,
	M_AXI_GP0_wstrb		=> gp0_axi_o.wstrb(3 downto 0),
	M_AXI_GP0_wvalid 	=> gp0_axi_o.wvalid
	

 );

reset_n <= areset_n(0);

hp0_axi_i <= hp0_axi_m;
hp0_axi_s <= hp0_axi_o;

gp0_axi_i <= gp0_axi_s;
gp0_axi_m <= gp0_axi_o;	
	
   
end generate;

gen_sim: if( is_simulation/=0 ) generate
	
clk <= not clk after 2.5 ns;

areset_n(0) <= '0', '1' after 101 ns;

reset_n <= areset_n(0);
aclk_out <= clk;
	
zynq: zynq_sim_m2 
	port map(

	
		clk		    		=> clk,    		
		reset_n			    => areset_n(0),    	
		
		IRQ_F2P				=> irq_f2p,

        m_axi_gp0_s         => gp0_axi_s,
        m_axi_gp0_m        	=> gp0_axi_m,

        hp0_axi_m          	=> hp0_axi_m,
        hp0_axi_s         	=> hp0_axi_s
--        hp2_axi_m          	=> hp2_axi_in,
--        hp2_axi_s         	=> hp2_axi_out 

 
);		
	
end generate;
      

 
end zynq_system;
