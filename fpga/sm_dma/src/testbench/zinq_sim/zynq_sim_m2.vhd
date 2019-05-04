---------------------------------------------------------------------------------------------------
--
-- Title       : zynq_sim_m2.vhd
-- Author      : Dmitry Smekhov
-- Company     : Instrumental System
-- E-mail      : dsmv@insys.ru
--	
-- Version	   : 1.0 
--
---------------------------------------------------------------------------------------------------
--
-- Description : Модель процессора PowerPC PPC405	 
--
--			Модификация 5 - ширина шины 64 разряда
--						  - есть возможность выбора сигналов  adm_cmd, adm_ret 
--							через параметр instance
--
--
--			Поддерживаются команды:			
--
--				data_read, data_write, array_read, array_write
--
--
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.axi_pkg.all;

package zynq_sim_m2_pkg is
	
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


end package	zynq_sim_m2_pkg;




library ieee;
use ieee.std_logic_1164.all;		
use ieee.std_logic_arith.all;		  
use ieee.std_logic_unsigned.all;

library work;
use work.cmd_sim_pkg.all;	  
use work.adm_simulation_pkg.all;		   

use work.axi_pkg.all;
--use work.zynq_sim_m2_pkg.all;

entity zynq_sim_m2 is		 
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
end zynq_sim_m2;


architecture zynq_sim_m2_1 of zynq_sim_m2 is

constant  DL: time:=1 ns; 			-- время установки сигнала на шине


--signal tmem: mem32( 1024 downto 0 ):=(others=>(others=>'0')); -- память процессора
--signal tmem_cmd_wr: std_logic; 	-- 1 - запись в память по команде
--signal tmem_dsp_wr: std_logic; -- 1 - запись в память от ADSP
--signal tmem_dsp_adr: integer; 	-- адрес для записи в память от ADSP
--signal tmem_dsp_data: std_logic_vector( 63 downto 0 ); -- данные для записи в память от ADSP

type mem_1M		is array ( 1048575 downto 0 ) of integer;

shared variable	bank_0x10	: mem_1M;
shared variable	bank_0x20	: mem_1M;
shared variable	bank_0x30	: mem_1M;

signal cmd_rst: std_logic;					-- 0 - программный сброс процессора
signal master_reset: std_logic;				-- 0 - сброс
signal master_cmd_start: std_logic:='0'; 		-- 1 - начало выполнения команды
signal master_cmd_rdy: std_logic:='0';   		-- 1 - завершение выполнения команды

shared variable  vp0	: std_logic_vector( 31 downto 0 );		 
shared variable  clk_mode : integer:=0;

signal data_int: type_mem64; -- принимаемый блок данных с шины

signal master	: std_logic;  	-- 1 - процессор управляет шиной
						   		-- 0 - процессор ожидает сигналов управления

signal	awe_o		: std_logic;	-- строб записи
signal	are_o		: std_logic;	-- строб чтения
signal	aoe_o		: std_logic;	-- сигнал разрешения выхода

signal	data_i		: std_logic_vector( 63 downto 0 );	-- вход шины данных
signal	data_o		: std_logic_vector( 63 downto 0 );	-- выход шины данных
signal	adr_o		: std_logic_vector( 31 downto 0 );	-- выход адреса


signal	data_out_master	: std_logic_vector( 63 downto 0 ):=(others=>'Z');

signal	cmd_i				: bh_cmd;
signal	ret_i				: bh_ret;


begin
  
gen_cmd0: if( instance=0 ) generate

	cmd_i <= adm_cmd;
	adm_ret <= ret_i;
	
end generate;

gen_cmdx: if( instance>0 ) generate
	
	cmd_i <= adm_cmd_arr( instance );
	adm_ret_arr( instance ) <= ret_i;
	
end generate;
	

master_reset <= reset_n;



pr_cmd: process
variable vret: bh_ret:=(0, (others=>(others=>'0')) );

begin
	wait until cmd_i'event and cmd_i.cmd/=0;

	vp0:= conv_std_logic_vector( cmd_i.p0, 32 );
	
	if( cmd_i.cmd<10 ) then
			master_cmd_start<='1';		   
			--wait until rising_edge( clk ) and cmd_i_rdy='1';
			--wait until rising_edge( clk ) and cmd_i_rdy='0';
			
			lp1: loop
				wait until rising_edge( clk );
				if( master_cmd_rdy='1' ) then
					master_cmd_start<='0';
					wait until rising_edge( clk ) and master_cmd_rdy='0';
					vret.ret:=1;
					exit lp1;
--				elsif( flag_ma='1' ) then
--					vret.ret_i:=2; 	
--					master_cmd_start<='0';
--					cmd_i_rst<='0', '1' after 100 ns;		
--					exit lp1;
				end if;
			end loop;
			vret.data:=data_int;
	elsif( cmd_i.cmd<40 ) then
		-- доступ к памяти
		case cmd_i.cmd is
			when 20 =>   --	  	20 - запись числа в память
			case( cmd_i.adr(0)(31 downto 20 ) ) is
				when x"001" => 
					bank_0x10( conv_integer( cmd_i.adr(0)( 19 downto 2 ) )):=conv_integer( unsigned(cmd_i.data(0)( 31 downto 0 )) );
				when x"002" => 
					bank_0x20( conv_integer( cmd_i.adr(0)( 19 downto 2 ) )):=conv_integer( unsigned(cmd_i.data(0)( 31 downto 0 )) );
				when x"003" => 
					bank_0x30( conv_integer( cmd_i.adr(0)( 19 downto 2 ) )):=conv_integer( unsigned(cmd_i.data(0)( 31 downto 0 )) );
				when others => null;
			end case;
	
	
			when 21 =>   --		21 - чтение числа из памяти
--				vret.data(0)( 63 downto 0 ):=tmem( conv_integer( unsigned( cmd_i.adr(0) ) ) );
				case( cmd_i.adr(0)(31 downto 20 ) ) is
					when x"001" =>  
						vret.data(0)( 31 downto 0 ):=conv_std_logic_vector( bank_0x10( conv_integer( cmd_i.adr(0)( 19 downto 2 ) )), 32);
					when x"002" =>  
						vret.data(0)( 31 downto 0 ):=conv_std_logic_vector( bank_0x20( conv_integer( cmd_i.adr(0)( 19 downto 2 ) )), 32);
					when x"003" =>  
						vret.data(0)( 31 downto 0 ):=conv_std_logic_vector( bank_0x30( conv_integer( cmd_i.adr(0)( 19 downto 2 ) )), 32);
					when others => null;
				end case;


----		22 - запись возрастающей последовательности чисел
----		30 - запись массива из файла data0.dat
----		63 - чтение массива и запись в файл data1.dat
--
--			when 35 => -- управление сигналом clk
--			   clk_mode := cmd_i.p0;
--			   
			when others => null;
		end case;
		vret.ret:=1;
	else
		vret.ret:=1;
	end if;
	ret_i<=vret;
	wait until cmd_i'event and cmd_i.cmd=0;
	vret.ret:=0;
	ret_i<=vret;
end process;	

--pr_tmem: process( tmem_cmd_i_wr, clk ) begin
--	if( rising_edge( tmem_cmd_i_wr ) ) then
--		tmem( conv_integer( unsigned( cmd_i.adr(0) ) ) )<=cmd_i.data(0)( 63 downto 0 );
--	end if;
----	if( rising_edge( tmem_adsp_wr ) ) then
----		tmem( tmem_adsp_adr )<=tmem_adsp_data;
----	end if;
--
----	if( rising_edge( clk ) ) then
----		if( twrl1='0' ) then
----		  tmem( tadr1 )<=data_in( 63 downto 0 );
----		end if;
----	end if;
--			
--
--end process;
								  

	

	
pr_main: process 

procedure sync_write is 

variable 	nmax	: integer; -- число слов для передачи
variable    vp0		: std_logic_vector( 31 downto 0 );

begin
	
   vp0:=conv_std_logic_vector(	 cmd_i.p0, 32 );
   nmax:=conv_integer( unsigned( vp0( 31 downto 16 ) ) );

   adr_o <= cmd_i.adr(0)( 31 downto 0 ) after  DL;	
   data_out_master <= cmd_i.data(0)( 63 downto 0 ) after DL;


   
   wait until rising_edge( clk );
   m_axi_gp0_m.awaddr <= adr_o after 1 ns;
   m_axi_gp0_m.awvalid <= '1' after 1 ns;
   wait until rising_edge( clk ) and m_axi_gp0_s.awready='1';
   m_axi_gp0_m.awvalid <= '0' after 1 ns;
   m_axi_gp0_m.wdata <= data_out_master after 1 ns;
   m_axi_gp0_m.wstrb <= x"0F" after 1 ns;
   m_axi_gp0_m.wvalid <= '1' after 1 ns;	 	
   m_axi_gp0_m.wlast <= '1' after 1 ns;
   wait until rising_edge( clk ) and m_axi_gp0_s.wready='1';
   m_axi_gp0_m.wstrb <= x"00" after 1 ns;
   m_axi_gp0_m.wvalid <= '0' after 1 ns;	 
   m_axi_gp0_m.wlast <= '0' after 1 ns;
   wait until rising_edge( clk );
   m_axi_gp0_m.bready <= '1' after 1 ns;
   wait until rising_edge( clk ) and m_axi_gp0_s.bvalid='1';
   m_axi_gp0_m.bready <= '0' after 1 ns;
   
   

end sync_write;

procedure sync_read is 

variable 	na, nd	: integer; -- текущее передаваемое слово
variable 	nmax	: integer; -- число слов для передачи
variable    vp0		: std_logic_vector( 31 downto 0 );

begin
	
   vp0:=conv_std_logic_vector(	 cmd_i.p0, 32 );
   nmax:=conv_integer( unsigned( vp0( 31 downto 16 ) ) );
   adr_o<=cmd_i.adr(0) after DL; 

   wait until rising_edge( clk );
   m_axi_gp0_m.araddr <= adr_o after 1 ns;
   m_axi_gp0_m.arvalid <= '1' after 1 ns;
   wait until rising_edge( clk ) and m_axi_gp0_s.arready='1';
   m_axi_gp0_m.arvalid <= '0' after 1 ns;
   m_axi_gp0_m.rready  <= '1' after 1 ns;

   wait until rising_edge( clk ) and m_axi_gp0_s.rvalid='1';
   data_int(0) <= m_axi_gp0_s.rdata;
   
   m_axi_gp0_m.rready  <= '0' after 1 ns;
   
end sync_read;




begin
	
	m_axi_gp0_m.awaddr <= (others=>'0') after 1 ns;
	m_axi_gp0_m.awvalid <= '0' after 1 ns;
    m_axi_gp0_m.wstrb <= x"00" after 1 ns;
    m_axi_gp0_m.wvalid <= '0' after 1 ns;	 
    m_axi_gp0_m.bready <= '0' after 1 ns;
    m_axi_gp0_m.awlen		<= x"01";
    m_axi_gp0_m.awsize		<= "100";
	m_axi_gp0_m.wlast		<= '0';
	

	m_axi_gp0_m.araddr <= (others=>'0') after 1 ns;
	m_axi_gp0_m.arvalid <= '0' after 1 ns;
    m_axi_gp0_m.arlen		<= x"01";
    m_axi_gp0_m.arsize		<= "100";
	m_axi_gp0_m.rready		<= '0';
	
	master <= '1';
	master_cmd_rdy <= '0';
	wait until rising_edge( master_cmd_start );

	case( cmd_i.cmd ) is
		when 1 =>   -- Чтение
				sync_read;
		when  2 =>   -- Запись
				sync_write;
		when others => null;
	end case;
	
	master_cmd_rdy <= '1';
	wait until falling_edge( master_cmd_start );
	master_cmd_rdy <= '0';
	
end process;	

pr_mem_read: process

variable	adr		: std_logic_vector( 31 downto 0);
variable	index	: integer;			
variable	data	: std_logic_vector( 63 downto 0 );

begin		  
	
	hp0_axi_s.arready <= '0';
	hp0_axi_s.rvalid <= '0';
	
	wait for 100 ns;		
	
	loop
		wait until rising_edge( clk );
		hp0_axi_s.arready <= '1' after 1 ns;

		wait until rising_edge( clk ) and hp0_axi_m.arvalid='1';
		adr:=hp0_axi_m.araddr;	 
		hp0_axi_s.arready <= '0';
		index:=conv_integer( adr( 19 downto 2 ));
		for ii in 0 to 15 loop
			hp0_axi_s.rvalid <= '1';
			case( adr( 31 downto 20 ) ) is
				when x"001" => 
					data := conv_std_logic_vector( bank_0x10(index+1), 32 ) & conv_std_logic_vector( bank_0x10(index), 32 );
				when x"002" => 
					data := conv_std_logic_vector( bank_0x20(index+1), 32 ) & conv_std_logic_vector( bank_0x20(index), 32 );
				when x"003" => 
					data := conv_std_logic_vector( bank_0x30(index+1), 32 ) & conv_std_logic_vector( bank_0x30(index), 32 );
				when others => data := (others=>'1');
			end case;
			index:=index+2;
				
			hp0_axi_s.rdata <= data after 1 ns;
			if( ii=15 ) then
			 	hp0_axi_s.rlast <= '1' after 1 ns;
			else
				hp0_axi_s.rlast <= '0' after 1 ns;
			end if;
			wait until rising_edge( clk ) and  hp0_axi_m.rready='1';
			
		end loop;
		hp0_axi_s.rvalid <= '0';
		wait until rising_edge( clk );
	end loop;
	
	
	
end process;	

pr_mem_write: process 

variable	adr		: std_logic_vector( 31 downto 0);
variable	index	: integer;			
variable	data	: std_logic_vector( 63 downto 0 );

begin
	
	hp2_axi_s.awready <= '0';
	hp2_axi_s.bresp <= "00";
	hp2_axi_s.bvalid <= '0'; 
	hp2_axi_s.wready <= '0';
	
		wait for 100 ns;		
	
	loop
		wait until rising_edge( clk );
		hp2_axi_s.awready <= '1' after 1 ns;

		wait until rising_edge( clk ) and hp2_axi_m.awvalid='1';
		adr:=hp2_axi_m.awaddr;	 
		hp2_axi_s.awready <= '0' after 1 ns;
		index:=conv_integer( adr( 19 downto 2 ));
		hp2_axi_s.wready <= '1' after 1 ns;
		
		for ii in 0 to 15 loop
			wait until rising_edge( clk ) and hp2_axi_m.wvalid='1';
			data:= hp2_axi_m.wdata;
			case( adr( 31 downto 20 ) ) is
				when x"001" => 
					bank_0x10(index+1) := conv_integer( data( 63 downto 32 ) );
					bank_0x10(index+0) := conv_integer( data( 31 downto 0 ) );

				when x"002" => 
					bank_0x20(index+1) := conv_integer( data( 63 downto 32 ) );
					bank_0x20(index+0) := conv_integer( data( 31 downto 0 ) );

				when x"003" => 
					bank_0x30(index+1) := conv_integer( data( 63 downto 32 ) );
					bank_0x30(index+0) := conv_integer( data( 31 downto 0 ) );
					
				when others => null;
				
			end case;  
			index:=index+2;
			
		end loop;
		hp2_axi_s.wready <= '0' after 1 ns;
		wait until rising_edge( clk );
		
		hp2_axi_s.bvalid <= '1' after 1 ns;
		wait until rising_edge( clk ) and hp2_axi_m.bready='1';
		hp2_axi_s.bvalid <= '0' after 1 ns;
		
	end loop;
		
end process;

end zynq_sim_m2_1;
