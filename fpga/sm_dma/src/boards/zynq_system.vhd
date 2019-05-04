-------------------------------------------------------------------------------
--
-- Title       : zynq_system
--
-- Version     : 1.0
--
-------------------------------------------------------------------------------
--
-- Description : 	Подключение компонента zynq созданного в Block Design 
--
--					Модификация 4 - напрямую выводяться шины HP0, HP1, M_GP0
--					Тип шин - AXI3
--
-------------------------------------------------------------------------------
--
--  Version 1.0  26.01.2019
--
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;


library work;
use work.axi_pkg.all;

package	zynq_system_pkg is





component zynq_system is
generic(

	is_simulation			: in integer:=0	 -- 0 - подключение Zynq, 1 - подключение модели
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
        FIXED_IO_ps_srstb   : inout STD_LOGIC;	
	
		aclk_out		    : out std_logic;    -- тактовая частота шины
		reset_n			    : out std_logic;    -- 0 - сброс 
		
		IRQ_F2P				: in std_logic_vector( 0 downto 0 );

		--- Доступ от процессора к периферийным устройствам ---
        M_AXI_GP0_IN         : in S_AXI_TYPE;
        M_AXI_GP0_OUT        : out M_AXI_TYPE;

        --- Доступ к DDR памяти процессора ---
        HP0_AXI_IN          : in M_AXI_TYPE;
        HP0_AXI_OUT         : out S_AXI_TYPE;
        
--        HP1_AXI_IN          : in M_AXI_TYPE;
--        HP1_AXI_OUT         : out S_AXI_TYPE;
        
        HP2_AXI_IN          : in M_AXI_TYPE;
        HP2_AXI_OUT         : out S_AXI_TYPE
        
--        HP3_AXI_IN          : in M_AXI_TYPE;
--        HP3_AXI_OUT         : out S_AXI_TYPE;
		
		

--		---- Доступ ко всем устройствам ----
--        ACP_AXI_IN          : in M_AXI_TYPE;
--        ACP_AXI_OUT         : out S_AXI_TYPE

    
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

	is_simulation			: in integer:=0	 -- 0 - подключение Zynq, 1 - подключение модели
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
        FIXED_IO_ps_srstb   : inout STD_LOGIC;	
	
		aclk_out		    : out std_logic;    -- тактовая частота шины
		reset_n		    	: out std_logic;    -- 0 - сброс 
		
		IRQ_F2P				: in std_logic_vector( 0 downto 0 );

		--- Доступ от процессора к периферийным устройствам ---
        M_AXI_GP0_IN         : in S_AXI_TYPE;
        M_AXI_GP0_OUT        : out M_AXI_TYPE;

        --- Доступ к DDR памяти процессора ---
        HP0_AXI_IN          : in M_AXI_TYPE;
        HP0_AXI_OUT         : out S_AXI_TYPE;
        
--        HP1_AXI_IN          : in M_AXI_TYPE;
--        HP1_AXI_OUT         : out S_AXI_TYPE;
        
        HP2_AXI_IN          : in M_AXI_TYPE;
        HP2_AXI_OUT         : out S_AXI_TYPE
        
--        HP3_AXI_IN          : in M_AXI_TYPE;
--        HP3_AXI_OUT         : out S_AXI_TYPE;
		
		

--		---- Доступ ко всем устройствам ----
--        ACP_AXI_IN          : in M_AXI_TYPE;
--        ACP_AXI_OUT         : out S_AXI_TYPE

);
end zynq_system;


architecture zynq_system of zynq_system is

--signal  clk100                  : std_logic:='0';
--signal  reset_n                 : std_logic;

--signal FIXED_IO_ps_clk_i          : std_logic:='Z';
--signal FIXED_IO_ps_porb_i         : std_logic:='Z';
--signal FIXED_IO_ps_srstb_i        : std_logic:='Z';




component zynq_m1_wrapper is
  port (
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
    FCLK_CLK0 : out STD_LOGIC;
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
    HP0_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    HP0_AXI_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    HP0_AXI_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    HP0_AXI_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    HP0_AXI_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    HP0_AXI_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    HP0_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    HP0_AXI_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    HP0_AXI_arready : out STD_LOGIC;
    HP0_AXI_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    HP0_AXI_arvalid : in STD_LOGIC;
    HP0_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    HP0_AXI_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    HP0_AXI_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    HP0_AXI_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    HP0_AXI_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    HP0_AXI_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    HP0_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    HP0_AXI_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    HP0_AXI_awready : out STD_LOGIC;
    HP0_AXI_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    HP0_AXI_awvalid : in STD_LOGIC;
    HP0_AXI_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    HP0_AXI_bready : in STD_LOGIC;
    HP0_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    HP0_AXI_bvalid : out STD_LOGIC;
    HP0_AXI_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    HP0_AXI_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    HP0_AXI_rlast : out STD_LOGIC;
    HP0_AXI_rready : in STD_LOGIC;
    HP0_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    HP0_AXI_rvalid : out STD_LOGIC;
    HP0_AXI_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    HP0_AXI_wid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    HP0_AXI_wlast : in STD_LOGIC;
    HP0_AXI_wready : out STD_LOGIC;
    HP0_AXI_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    HP0_AXI_wvalid : in STD_LOGIC;
    HP2_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    HP2_AXI_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    HP2_AXI_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    HP2_AXI_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    HP2_AXI_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    HP2_AXI_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    HP2_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    HP2_AXI_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    HP2_AXI_arready : out STD_LOGIC;
    HP2_AXI_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    HP2_AXI_arvalid : in STD_LOGIC;
    HP2_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    HP2_AXI_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    HP2_AXI_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    HP2_AXI_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    HP2_AXI_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    HP2_AXI_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    HP2_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    HP2_AXI_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    HP2_AXI_awready : out STD_LOGIC;
    HP2_AXI_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    HP2_AXI_awvalid : in STD_LOGIC;
    HP2_AXI_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    HP2_AXI_bready : in STD_LOGIC;
    HP2_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    HP2_AXI_bvalid : out STD_LOGIC;
    HP2_AXI_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    HP2_AXI_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    HP2_AXI_rlast : out STD_LOGIC;
    HP2_AXI_rready : in STD_LOGIC;
    HP2_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    HP2_AXI_rvalid : out STD_LOGIC;
    HP2_AXI_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    HP2_AXI_wid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    HP2_AXI_wlast : in STD_LOGIC;
    HP2_AXI_wready : out STD_LOGIC;
    HP2_AXI_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    HP2_AXI_wvalid : in STD_LOGIC;
    resetn_o : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
end component;	 


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
        hp0_axi_s          		: out  s_axi_type;
        
        hp2_axi_m          		: in m_axi_type;
        hp2_axi_s         		: out  s_axi_type	
		
		
	);
end  component;


signal	areset_n		: std_logic_vector (0 downto 0);	   
signal	clk				: std_logic:='0';	-- for simulation only
  
-- Передача команд
signal 	cmd_rw			: std_logic_vector (1 downto 0):="00"; 		-- Признак чтения-записи: 0 - чтение, 1 - запись
signal 	cmd_req			: std_logic:='0';		-- 1 - Запрос операции
signal 	cmd_ack			: std_logic:='0';		-- 1 - подтверждение опреации
signal 	cmd_adr			: std_logic_vector( 31 downto 0 ); -- адрес для команды чтения-записи
signal 	cmd_data_i		: std_logic_vector( 31 downto 0 );	-- данные для записи
signal 	cmd_data_o		: std_logic_vector( 31 downto 0 );	-- прочитанные данные
signal	cmd_init_done_i		: std_logic;

signal	gp0_axi_i	: S_AXI_TYPE;
signal	gp0_axi_o	: M_AXI_TYPE;

signal	gp1_axi_lite_i	: S_AXI_LITE_TYPE;
signal	gp1_axi_lite_o	: M_AXI_LITE_TYPE;

signal	hp0_axi_i	: M_AXI_TYPE;	
signal	hp0_axi_o	: S_AXI_TYPE;	

signal	hp1_axi_i	: M_AXI_TYPE;	
signal	hp1_axi_o	: S_AXI_TYPE;	

signal	hp2_axi_i	: M_AXI_TYPE;	
signal	hp2_axi_o	: S_AXI_TYPE;	

signal	hp3_axi_i	: M_AXI_TYPE;	
signal	hp3_axi_o	: S_AXI_TYPE;	

signal	acp_axi_i	: M_AXI_TYPE;	
signal	acp_axi_o	: S_AXI_TYPE;	


signal    FIXED_IO_ps_srstb_i   : STD_LOGIC:='Z';
signal    FIXED_IO_ps_clk_i     : STD_LOGIC:='Z';
signal    FIXED_IO_ps_porb_i    : STD_LOGIC:='Z';



begin

gen_synt: if( is_simulation=0 ) generate
	
i_ZYNQ : zynq_m1_wrapper
   port map(
	FCLK_CLK0			=> ACLK_OUT,
	resetn_o			=> areset_n,
	
	
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

--    FIXED_IO_ps_clk     => FIXED_IO_ps_clk_i,
--    FIXED_IO_ps_porb    => FIXED_IO_ps_porb_i,
--    FIXED_IO_ps_srstb   => FIXED_IO_ps_srstb_i,


--	ACP_AXI_araddr		=> acp_axi_i.araddr,
--	ACP_AXI_arburst		=> acp_axi_i.arburst,
--	ACP_AXI_arcache		=> acp_axi_i.arcache,
--	ACP_AXI_arlen		=> acp_axi_i.arlen( 3 downto 0 ),
--	ACP_AXI_arlock  	=> acp_axi_i.arlock( 1 downto 0 ),
--	ACP_AXI_arprot  	=> acp_axi_i.arprot,
--	ACP_AXI_arqos  		=> acp_axi_i.arqos,
--	ACP_AXI_arready  	=> acp_axi_o.arready,
--	--ACP_AXI_arregion	=> acp_axi_i.arregion,
--	ACP_AXI_arsize  	=> acp_axi_i.arsize,
--	ACP_AXI_aruser(4 downto 0) => acp_axi_i.aruser(4 downto 0),  
--	ACP_AXI_arvalid  	=> acp_axi_i.arvalid,
--	ACP_AXI_awaddr  	=> acp_axi_i.awaddr,
--	ACP_AXI_awburst  	=> acp_axi_i.awburst,
--	ACP_AXI_awcache  	=> acp_axi_i.awcache,
--	ACP_AXI_awlen  		=> acp_axi_i.awlen( 3 downto 0 ),
--	ACP_AXI_awlock  	=> acp_axi_i.awlock( 1 downto 0 ),
--	ACP_AXI_awprot  	=> acp_axi_i.awprot,
--	ACP_AXI_awqos  		=> acp_axi_i.awqos,
--	ACP_AXI_awready   	=> acp_axi_o.awready,
--	--ACP_AXI_awregion	=> acp_axi_i.awregion,
--	ACP_AXI_awsize  	=> acp_axi_i.awsize,
--	ACP_AXI_awuser(4 downto 0) => acp_axi_i.awuser(4 downto 0),  
--	ACP_AXI_awvalid   	=> acp_axi_i.awvalid,
--	ACP_AXI_bready  	=> acp_axi_i.bready,
--	ACP_AXI_bresp  		=> acp_axi_o.bresp,
--	ACP_AXI_bvalid  	=> acp_axi_o.bvalid,
--	ACP_AXI_rdata  		=> acp_axi_o.rdata,
--	ACP_AXI_rlast  		=> acp_axi_o.rlast,
--	ACP_AXI_rready  	=> acp_axi_i.rready,
--	ACP_AXI_rresp  		=> acp_axi_o.rresp,
--	ACP_AXI_rvalid  	=> acp_axi_o.rvalid,
--	ACP_AXI_wdata  		=> acp_axi_i.wdata,
--	ACP_AXI_wlast  		=> acp_axi_i.wlast,
--	ACP_AXI_wready  	=> acp_axi_o.wready,
--	ACP_AXI_wstrb  		=> acp_axi_i.wstrb,
--	ACP_AXI_wvalid  	=> acp_axi_i.wvalid,
	
--    ACP_AXI_wid         => acp_axi_i.wid( 2 downto 0 ),
--    ACP_AXI_arid        => acp_axi_i.arid( 2 downto 0 ),
--    ACP_AXI_awid        => acp_axi_i.awid( 2 downto 0 ),
--    ACP_AXI_bid         => hp1_axi_o.bid( 2 downto 0 ),
--    ACP_AXI_rid         => hp1_axi_o.rid( 2 downto 0 ),

	
	HP0_AXI_araddr		=> hp0_axi_i.araddr,
	HP0_AXI_arburst		=> hp0_axi_i.arburst,
	HP0_AXI_arcache		=> hp0_axi_i.arcache,
	HP0_AXI_arlen		=> hp0_axi_i.arlen( 3 downto 0 ),
	HP0_AXI_arlock  	=> hp0_axi_i.arlock(1 downto 0 ),
	HP0_AXI_arprot  	=> hp0_axi_i.arprot,
	HP0_AXI_arqos  		=> hp0_axi_i.arqos,
	HP0_AXI_arready	    => hp0_axi_o.arready,
	--HP0_AXI_arregion	=> hp0_axi_i.arregion,
	HP0_AXI_arsize  	=> hp0_axi_i.arsize,
	HP0_AXI_arvalid  	=> hp0_axi_i.arvalid,
	HP0_AXI_awaddr  	=> hp0_axi_i.awaddr,
	HP0_AXI_awburst  	=> hp0_axi_i.awburst,
	HP0_AXI_awcache  	=> hp0_axi_i.awcache,
	HP0_AXI_awlen  		=> hp0_axi_i.awlen( 3 downto 0 ),
	HP0_AXI_awlock  	=> hp0_axi_i.awlock( 1 downto 0 ),
	HP0_AXI_awprot  	=> hp0_axi_i.awprot,
	HP0_AXI_awqos  		=> hp0_axi_i.awqos,
	HP0_AXI_awready  	=> hp0_axi_o.awready,
	--HP0_AXI_awregion	=> hp0_axi_i.awregion,
	HP0_AXI_awsize  	=> hp0_axi_i.awsize,
	HP0_AXI_awvalid  	=> hp0_axi_i.awvalid,
	HP0_AXI_bready  	=> hp0_axi_i.bready,
	HP0_AXI_bresp  		=> hp0_axi_o.bresp,
	HP0_AXI_bvalid  	=> hp0_axi_o.bvalid,
	HP0_AXI_rdata  		=> hp0_axi_o.rdata,
	HP0_AXI_rlast  		=> hp0_axi_o.rlast,
	HP0_AXI_rready  	=> hp0_axi_i.rready,
	HP0_AXI_rresp  		=> hp0_axi_o.rresp,
	HP0_AXI_rvalid  	=> hp0_axi_o.rvalid,
	HP0_AXI_wdata  		=> hp0_axi_i.wdata,
	HP0_AXI_wid 		=> hp0_axi_i.wid( 5 downto 0 ),
	HP0_AXI_wlast  		=> hp0_axi_i.wlast,
	HP0_AXI_wready  	=> hp0_axi_o.wready,
	HP0_AXI_wstrb  		=> hp0_axi_i.wstrb,
	HP0_AXI_wvalid  	=> hp0_axi_i.wvalid,
	
    HP0_AXI_arid        => hp0_axi_i.arid( 5 downto 0 ),
    HP0_AXI_awid        => hp0_axi_i.awid( 5 downto 0 ),
    HP0_AXI_bid         => hp1_axi_o.bid( 5 downto 0 ),
    HP0_AXI_rid         => hp1_axi_o.rid( 5 downto 0 ),
	
	
--    HP0_FIFO_CTRL_racount 		=> hp0_fifo_ctrl_out.racount,
--    HP0_FIFO_CTRL_rcount 		=> hp0_fifo_ctrl_out.rcount,
--    HP0_FIFO_CTRL_rdissuecapen 	=> hp0_fifo_ctrl_in.rdissuecapen,
--    HP0_FIFO_CTRL_wacount 		=> hp0_fifo_ctrl_out.wacount,
--    HP0_FIFO_CTRL_wcount 		=> hp0_fifo_ctrl_out.wcount,
--    HP0_FIFO_CTRL_wrissuecapen  => hp0_fifo_ctrl_in.wrissuecapen,
--

	
--	HP1_AXI_araddr		=> hp1_axi_i.araddr,
--    HP1_AXI_arburst     => hp1_axi_i.arburst,
--    HP1_AXI_arcache     => hp1_axi_i.arcache,
--    HP1_AXI_arlen       => hp1_axi_i.arlen( 7 downto 0 ),
--    HP1_AXI_arlock      => hp1_axi_i.arlock( 0 downto 0 ),
--    HP1_AXI_arprot      => hp1_axi_i.arprot,
--    HP1_AXI_arqos       => hp1_axi_i.arqos,
--    HP1_AXI_arready     => hp1_axi_o.arready,
--    HP1_AXI_arregion    => hp1_axi_i.arregion,
--    HP1_AXI_arsize      => hp1_axi_i.arsize,
--    HP1_AXI_arvalid     => hp1_axi_i.arvalid,
--    HP1_AXI_awaddr      => hp1_axi_i.awaddr,
--    HP1_AXI_awburst     => hp1_axi_i.awburst,
--    HP1_AXI_awcache     => hp1_axi_i.awcache,
--    HP1_AXI_awlen       => hp1_axi_i.awlen( 7 downto 0 ),
--    HP1_AXI_awlock      => hp1_axi_i.awlock( 0 downto 0 ),
--    HP1_AXI_awprot      => hp1_axi_i.awprot,
--    HP1_AXI_awqos       => hp1_axi_i.awqos,
--    HP1_AXI_awready     => hp1_axi_o.awready,
--    HP1_AXI_awregion    => hp1_axi_i.awregion,
--    HP1_AXI_awsize      => hp1_axi_i.awsize,
--    HP1_AXI_awvalid     => hp1_axi_i.awvalid,
--    HP1_AXI_bready      => hp1_axi_i.bready,
--    HP1_AXI_bresp       => hp1_axi_o.bresp,
--    HP1_AXI_bvalid      => hp1_axi_o.bvalid,
--    HP1_AXI_rdata       => hp1_axi_o.rdata,
--    HP1_AXI_rlast       => hp1_axi_o.rlast,
--    HP1_AXI_rready      => hp1_axi_i.rready,
--    HP1_AXI_rresp       => hp1_axi_o.rresp,
--    HP1_AXI_rvalid      => hp1_axi_o.rvalid,
--    HP1_AXI_wdata       => hp1_axi_i.wdata,
--    HP1_AXI_wlast       => hp1_axi_i.wlast,
--    HP1_AXI_wready      => hp1_axi_o.wready,
--    HP1_AXI_wstrb       => hp1_axi_i.wstrb,
--    HP1_AXI_wvalid      => hp1_axi_i.wvalid,
	
--    HP1_AXI_arid        => hp1_axi_i.arid( 0 downto 0 ),
--    HP1_AXI_awid        => hp1_axi_i.awid( 0 downto 0 ),
--    HP1_AXI_bid         => hp1_axi_o.bid( 0 downto 0 ),
--    HP1_AXI_rid         => hp1_axi_o.rid( 0 downto 0 ),
	
--    HP1_FIFO_CTRL_racount 		=> hp1_fifo_ctrl_out.racount,
--    HP1_FIFO_CTRL_rcount 		=> hp1_fifo_ctrl_out.rcount,
--    HP1_FIFO_CTRL_rdissuecapen 	=> hp1_fifo_ctrl_in.rdissuecapen,
--    HP1_FIFO_CTRL_wacount 		=> hp1_fifo_ctrl_out.wacount,
--    HP1_FIFO_CTRL_wcount 		=> hp1_fifo_ctrl_out.wcount,
--    HP1_FIFO_CTRL_wrissuecapen  => hp1_fifo_ctrl_in.wrissuecapen,
	
	
    HP2_AXI_araddr		=> hp2_axi_i.araddr,
    HP2_AXI_arburst     => hp2_axi_i.arburst,
    HP2_AXI_arcache     => hp2_axi_i.arcache,
    HP2_AXI_arlen       => hp2_axi_i.arlen( 3 downto 0 ),
    HP2_AXI_arlock      => hp2_axi_i.arlock( 1 downto 0 ),
    HP2_AXI_arprot      => hp2_axi_i.arprot,
    HP2_AXI_arqos       => hp2_axi_i.arqos,
    HP2_AXI_arready     => hp2_axi_o.arready,
    --HP2_AXI_arregion    => hp2_axi_i.arregion,
    HP2_AXI_arsize      => hp2_axi_i.arsize,
    HP2_AXI_arvalid     => hp2_axi_i.arvalid,
    HP2_AXI_awaddr      => hp2_axi_i.awaddr,
    HP2_AXI_awburst     => hp2_axi_i.awburst,
    HP2_AXI_awcache     => hp2_axi_i.awcache,
    HP2_AXI_awlen       => hp2_axi_i.awlen( 3 downto 0 ),
    HP2_AXI_awlock      => hp2_axi_i.awlock( 1 downto 0 ),
    HP2_AXI_awprot      => hp2_axi_i.awprot,
    HP2_AXI_awqos       => hp2_axi_i.awqos,
    HP2_AXI_awready     => hp2_axi_o.awready,
    --HP2_AXI_awregion    => hp2_axi_i.awregion,
    HP2_AXI_awsize      => hp2_axi_i.awsize,
    HP2_AXI_awvalid     => hp2_axi_i.awvalid,
    HP2_AXI_bready      => hp2_axi_i.bready,
    HP2_AXI_bresp       => hp2_axi_o.bresp,
    HP2_AXI_bvalid      => hp2_axi_o.bvalid,
    HP2_AXI_rdata       => hp2_axi_o.rdata,
    HP2_AXI_rlast       => hp2_axi_o.rlast,
    HP2_AXI_rready      => hp2_axi_i.rready,
    HP2_AXI_rresp       => hp2_axi_o.rresp,
    HP2_AXI_rvalid      => hp2_axi_o.rvalid,
    HP2_AXI_wdata       => hp2_axi_i.wdata,
	HP2_AXI_wid 		=> hp2_axi_i.wid( 5 downto 0 ),
    HP2_AXI_wlast       => hp2_axi_i.wlast,
    HP2_AXI_wready      => hp2_axi_o.wready,
    HP2_AXI_wstrb       => hp2_axi_i.wstrb,
    HP2_AXI_wvalid      => hp2_axi_i.wvalid,
	
    HP2_AXI_arid        => hp2_axi_i.arid( 5 downto 0 ),
    HP2_AXI_awid        => hp2_axi_i.awid( 5 downto 0 ),
    HP2_AXI_bid         => hp2_axi_o.bid( 5 downto 0 ),
    HP2_AXI_rid         => hp2_axi_o.rid( 5 downto 0 ),
	
    --HP2_AXI_wid        	=> hp2_axi_i.wid( 5 downto 0 ),
	
--    HP2_FIFO_CTRL_racount 		=> hp2_fifo_ctrl_out.racount,
--    HP2_FIFO_CTRL_rcount 		=> hp2_fifo_ctrl_out.rcount,
--    HP2_FIFO_CTRL_rdissuecapen 	=> hp2_fifo_ctrl_in.rdissuecapen,
--    HP2_FIFO_CTRL_wacount 		=> hp2_fifo_ctrl_out.wacount,
--    HP2_FIFO_CTRL_wcount 		=> hp2_fifo_ctrl_out.wcount,
--    HP2_FIFO_CTRL_wrissuecapen  => hp2_fifo_ctrl_in.wrissuecapen,
	
	IRQ_F2P				=> IRQ_F2P,
	
--	HP3_AXI_araddr		=> hp3_axi_i.araddr,
--    HP3_AXI_arburst     => hp3_axi_i.arburst,
--    HP3_AXI_arcache     => hp3_axi_i.arcache,
--    HP3_AXI_arlen       => hp3_axi_i.arlen( 7 downto 0 ),
--    HP3_AXI_arlock      => hp3_axi_i.arlock( 0 downto 0 ),
--    HP3_AXI_arprot      => hp3_axi_i.arprot,
--    HP3_AXI_arqos       => hp3_axi_i.arqos,
--    HP3_AXI_arready     => hp3_axi_o.arready,
--    HP3_AXI_arregion    => hp3_axi_i.arregion,
--    HP3_AXI_arsize      => hp3_axi_i.arsize,
--    HP3_AXI_arvalid     => hp3_axi_i.arvalid,
--    HP3_AXI_awaddr      => hp3_axi_i.awaddr,
--    HP3_AXI_awburst     => hp3_axi_i.awburst,
--    HP3_AXI_awcache     => hp3_axi_i.awcache,
--    HP3_AXI_awlen       => hp3_axi_i.awlen( 7 downto 0 ),
--    HP3_AXI_awlock      => hp3_axi_i.awlock( 0 downto 0 ),
--    HP3_AXI_awprot      => hp3_axi_i.awprot,
--    HP3_AXI_awqos       => hp3_axi_i.awqos,
--    HP3_AXI_awready     => hp3_axi_o.awready,
--    HP3_AXI_awregion    => hp3_axi_i.awregion,
--    HP3_AXI_awsize      => hp3_axi_i.awsize,
--    HP3_AXI_awvalid     => hp3_axi_i.awvalid,
--    HP3_AXI_bready      => hp3_axi_i.bready,
--    HP3_AXI_bresp       => hp3_axi_o.bresp,
--    HP3_AXI_bvalid      => hp3_axi_o.bvalid,
--    HP3_AXI_rdata       => hp3_axi_o.rdata,
--    HP3_AXI_rlast       => hp3_axi_o.rlast,
--    HP3_AXI_rready      => hp3_axi_i.rready,
--    HP3_AXI_rresp       => hp3_axi_o.rresp,
--    HP3_AXI_rvalid      => hp3_axi_o.rvalid,
--    HP3_AXI_wdata       => hp3_axi_i.wdata,
--    HP3_AXI_wlast       => hp3_axi_i.wlast,
--    HP3_AXI_wready      => hp3_axi_o.wready,
--    HP3_AXI_wstrb       => hp3_axi_i.wstrb,
--    HP3_AXI_wvalid      => hp3_axi_i.wvalid,
	
--    HP3_AXI_arid        => hp3_axi_i.arid( 0 downto 0 ),
--    HP3_AXI_awid        => hp3_axi_i.awid( 0 downto 0 ),
--    HP3_AXI_bid         => hp3_axi_o.bid( 0 downto 0 ),
--    HP3_AXI_rid         => hp3_axi_o.rid( 0 downto 0 ),	
	
--    --HP3_AXI_wid        	=> hp3_axi_i.wid( 5 downto 0 ),
	
	
--    HP3_FIFO_CTRL_racount 		=> hp3_fifo_ctrl_out.racount,
--    HP3_FIFO_CTRL_rcount 		=> hp3_fifo_ctrl_out.rcount,
--    HP3_FIFO_CTRL_rdissuecapen 	=> hp3_fifo_ctrl_in.rdissuecapen,
--    HP3_FIFO_CTRL_wacount 		=> hp3_fifo_ctrl_out.wacount,
--    HP3_FIFO_CTRL_wcount 		=> hp3_fifo_ctrl_out.wcount,
--    HP3_FIFO_CTRL_wrissuecapen  => hp3_fifo_ctrl_in.wrissuecapen,
	
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

hp0_axi_i <= HP0_AXI_IN;
HP0_AXI_OUT <= hp0_axi_o;

--hp1_axi_i <= HP1_AXI_IN;
--HP1_AXI_OUT <= hp1_axi_o;

hp2_axi_i <= HP2_AXI_IN;
HP2_AXI_OUT <= hp2_axi_o;

--hp3_axi_i <= HP3_AXI_IN;
--HP3_AXI_OUT <= hp3_axi_o;

--        M_AXI_GP0_IN         : in S_AXI_TYPE;
--        M_AXI_GP0_OUT        : out M_AXI_TYPE;


gp0_axi_i <= M_AXI_GP0_IN;
M_AXI_GP0_OUT <= gp0_axi_o;	
	
--gp1_axi_lite_i <= GP1_AXI_LITE_IN;
--GP1_AXI_LITE_OUT <= gp1_axi_lite_o;

--FIXED_IO_ps_clk  <= 'Z';   
--FIXED_IO_ps_porb <= 'Z';  
--FIXED_IO_ps_srstb  <= 'Z'; 


--reset_n <= '1', '0' after 10 ns, '1' after 100 ns;
--clk100 <= not clk100 after 5 ns;
 

--FIXED_IO_ps_clk_i         <= clk100;
--FIXED_IO_ps_porb_i        <= reset_n;
--FIXED_IO_ps_srstb_i       <= reset_n;

 FIXED_IO_ps_srstb_i <=  FIXED_IO_ps_srstb;
 FIXED_IO_ps_clk_i   <=  FIXED_IO_ps_clk;  
 FIXED_IO_ps_porb_i  <=  FIXED_IO_ps_porb;
 
   
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

        m_axi_gp0_s         => m_axi_gp0_in,
        m_axi_gp0_m        	=> m_axi_gp0_out,

        hp0_axi_m          	=> hp0_axi_in,
        hp0_axi_s         	=> hp0_axi_out,
        hp2_axi_m          	=> hp2_axi_in,
        hp2_axi_s         	=> hp2_axi_out 

 
);		
	
end generate;
      
--        M_AXI_GP0_IN         : in S_AXI_TYPE;
--        M_AXI_GP0_OUT        : out M_AXI_TYPE;
--
--        --- Доступ к DDR памяти процессора ---
--        HP0_AXI_IN          : in M_AXI_TYPE;
--        HP0_AXI_OUT         : out S_AXI_TYPE;
--        
----        HP1_AXI_IN          : in M_AXI_TYPE;
----        HP1_AXI_OUT         : out S_AXI_TYPE;
--        
--        HP2_AXI_IN          : in M_AXI_TYPE;
--        HP2_AXI_OUT         : out S_AXI_TYPE
         
 
end zynq_system;
