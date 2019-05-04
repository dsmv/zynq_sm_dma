-------------------------------------------------------------------------------
--
-- Title       : axi_pkg
--
-- Version     : 1.0
--
-------------------------------------------------------------------------------
--
-- Description : 	Определение типов для шины AXI
--
--
-------------------------------------------------------------------------------
--
--  Version 1.0    12.08.2016  Dmitry Smekhov
--                Создан из Zynq_BFM  
--
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;


package	axi_pkg is

--- Шина AXI Full ---

type M_AXI_TYPE is record
	araddr		: std_logic_vector (31 downto 0);
	arburst		: std_logic_vector (1 downto 0);
	arcache		: std_logic_vector (3 downto 0);
	arid		: std_logic_vector (11 downto 0);
	arlen		: std_logic_vector (7 downto 0);
	arlock  	: std_logic_vector (1 downto 0);
	arprot  	: std_logic_vector (2 downto 0);
	arqos  		: std_logic_vector (3 downto 0);
	arregion	: std_logic_vector (3 downto 0);
	arsize  	: std_logic_vector (2 downto 0);
	aruser		: std_logic_vector( 31 downto 0 );
	arvalid  	: std_logic;
	awaddr  	: std_logic_vector (31 downto 0);
	awburst  	: std_logic_vector (1 downto 0);
	awcache  	: std_logic_vector (3 downto 0);
	awid		: std_logic_vector (11 downto 0);
	awlen		: std_logic_vector (7 downto 0);
	awlock		: std_logic_vector (1 downto 0);
	awprot		: std_logic_vector (2 downto 0);
	awqos		: std_logic_vector (3 downto 0);
	awregion	: std_logic_vector(3 downto 0);
	awsize  	: std_logic_vector (2 downto 0);
	awuser		: std_logic_vector( 31 downto 0 );
	awvalid  	: std_logic;
	bready  	: std_logic;
	rready  	: std_logic;
	wdata  		: std_logic_vector (63 downto 0);
	wid			: std_logic_vector (11 downto 0);
	wlast  		: std_logic;
	wstrb  		: std_logic_vector (7 downto 0);
	wvalid  	: std_logic;
end record;

type S_AXI_TYPE is record
	arready		: std_logic;
	awready  	: std_logic;
	bid			: std_logic_vector (11 downto 0);
	bresp  		: std_logic_vector (1 downto 0);
	bvalid  	: std_logic;
	rdata  		: std_logic_vector (63 downto 0);
	rid			: std_logic_vector (11 downto 0);
	rlast  		: std_logic;
	rresp  		: std_logic_vector (1 downto 0);
	rvalid  	: std_logic;
	wready  	: std_logic;
end record;

type M_AXI_LITE_TYPE is record
   araddr       : STD_LOGIC_VECTOR ( 31 downto 0 );
   arprot       : STD_LOGIC_VECTOR ( 2 downto 0 );
   arvalid      : STD_LOGIC;
   awaddr       : STD_LOGIC_VECTOR ( 19 downto 0 );
   awprot       : STD_LOGIC_VECTOR ( 2 downto 0 );
   awvalid      : STD_LOGIC;
   bready       : STD_LOGIC;
   rready       : STD_LOGIC;
   wdata        : STD_LOGIC_VECTOR ( 31 downto 0 );
   wstrb        : STD_LOGIC_VECTOR ( 3 downto 0 );
   wvalid       : STD_LOGIC;

end record;

type S_AXI_LITE_TYPE is record

    arready     : STD_LOGIC;
    awready     : STD_LOGIC;
    bresp       : STD_LOGIC_VECTOR ( 1 downto 0 );
    bvalid      : STD_LOGIC;
    rdata       : STD_LOGIC_VECTOR ( 31 downto 0 );
    rresp       : STD_LOGIC_VECTOR ( 1 downto 0 );
    rvalid      : STD_LOGIC;
    wready      : STD_LOGIC;
    
end record;    
----------------

type M_HP_FIFO_CTRL_TYPE is record
	racount 	: STD_LOGIC_VECTOR ( 2 downto 0 );
	rcount 		: STD_LOGIC_VECTOR ( 7 downto 0 );
	wacount 	: STD_LOGIC_VECTOR ( 5 downto 0 );
	wcount 		: STD_LOGIC_VECTOR ( 7 downto 0 );
	
end record;

type S_HP_FIFO_CTRL_TYPE is record
	rdissuecapen : STD_LOGIC;
	wrissuecapen : STD_LOGIC;
	
end record;


end package;

