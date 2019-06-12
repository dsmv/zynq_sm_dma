---------------------------------------------------------------------------------------------------
--
-- Title       : sm_dma_main
-- Author      : Dmitry Smekhov
-- Company     : Instrumental Systems
-- E-mail      : dsmv@insys.ru
--
-- Version     : 1.0  
--
---------------------------------------------------------------------------------------------------
--
-- Description : 
--					
--		
--
---------------------------------------------------------------------------------------------------
--
--  	Version 1.0   12.06.2019
--						Created from block_pe_main v1.1
--
---------------------------------------------------------------------------------------------------





library ieee;
use ieee.std_logic_1164.all;   

library	work;
use	work.host_pkg.all;
use work.ctrl_ram16_v1_pkg.all;

library unisim;
use unisim.vcomponents.all;



entity sm_dma_main is				
	generic (
		Device_ID		: in std_logic_vector( 15 downto 0 ):=x"0000"; --! ID of HW
		Revision		: in std_logic_vector( 15 downto 0 ):=x"0000"; --! revision of HW
		PLD_ID			: in std_logic_vector( 15 downto 0 ):=x"0000"; --! ID of FPGA
		PLD_VER			: in std_logic_vector( 15 downto 0 ):=x"0000"; --! version of FPGA
		PLD_BUILD		: in std_logic_vector( 15 downto 0 ):=x"0000"; --! build of FPGA
		BLOCK_CNT		: in std_logic_vector( 15 downto 0 ):=x"0008"  --! count of block in address space
	);	
	port(
	
		---- Global ----
		reset_i			: in std_logic;		--! 0 - reset
		clk				: in std_logic;		--! clock
		reset_o			: out std_logic;	--! 0 - reset for others blocks
		
		---- HOST ----
		bl_adr			: in  std_logic_vector( 4 downto 0 );	--! address
		bl_data_in		: in  std_logic_vector( 31 downto 0 );	--! data for write
		bl_data_out		: out std_logic_vector( 31 downto 0 );	--! data for read
		bl_data_we		: in  std_logic;	-- 1 - write strobe
		
		---- Управление ----
		brd_mode0		: out std_logic_vector( 15 downto 0 );  --! BRD_MODE0 register
		brd_mode1		: out std_logic_vector( 15 downto 0 );  --! BRD_MODE1 register
		brd_status		: in  std_logic_vector( 15 downto 0 ):=(others=>'0')
		
	);	
end sm_dma_main;


architecture sm_dma_main of sm_dma_main is					   



---- Constant ----
constant BLOCK_ID		: std_logic_vector( 15 downto 0 ):=x"1D00"; 
constant BLOCK_VER		: std_logic_vector( 15 downto 0 ):=x"0100"; 

constant	bl_rom		: bh_rom:=( 0=> BLOCK_ID,
								1=> BLOCK_VER,
								2=> Device_ID,
								3=> Revision,
								4=> PLD_VER,  
								5=> BLOCK_CNT,
								6=> PLD_ID,
								7=> x"0000" );



								
	---- PLX ----
signal	bl_ram_out		: std_logic_vector( 15 downto 0 );	-- выход констант и командных
														-- регистров
signal	bl_reg_out		: std_logic_vector( 31 downto 0 );	-- выход непосредственных регистров


				
signal	c_brd_mode		: std_logic_vector( 15 downto 0 );	-- регистр BRD_MODE

	---- Reset ----
signal	dsp_reg_reset	: std_logic_vector( 11 downto 0 );
signal	reset_flag		: std_logic_vector( 7 downto 0 );
signal	reset_val		: std_logic_vector( 7 downto 0 );
signal	reset_val_0		: std_logic_vector( 7 downto 0 );
signal	reset_val_1		: std_logic_vector( 7 downto 0 );
signal	reset_host		: std_logic_vector( 7 downto 0 );




signal	brd_status_i	: std_logic_vector( 15 downto 0 );


begin

	
bl_ram: ctrl_ram16_v1 
	generic map(
		rom			=> bl_rom		-- значения констант
	)
	port map(
		clk			=> clk,		-- Тактовая частота
		
		adr			=> bl_adr,			-- адрес 
		data_in		=> bl_data_in( 15 downto 0 ),	-- вход данных
		data_out	=> bl_ram_out,		-- выход данных
		
		data_we		=> bl_data_we		-- 1 - запись данных
	);
	

	
	
pr_data_out: process( clk )
begin
	
	if( rising_edge( clk ) ) then
		if( bl_adr(4)='0' ) then
			bl_data_out( 15 downto 0 ) <= bl_ram_out after 1 ns;
			bl_data_out( 31 downto 16 ) <= (others=>'0') after 1 ns;
		else
			case bl_adr( 3 downto 0 ) is
				when "0000" 	=> 	-- BRD_STATUS
						bl_data_out( 15 downto 0 ) <=brd_status after 1 ns;
						bl_data_out( 31 downto 16 ) <= (others=>'0') after 1 ns;
						
				when others => bl_data_out<=(others=>'-');
			end case;
		end if;
	end if;
end process;   

	


pr_reg: process( reset_i, clk ) 
	
begin
	if( reset_i='0' ) then
		c_brd_mode<=(others=>'0');
	elsif( rising_edge( clk ) ) then
		if( bl_data_we='1' ) then
			case bl_adr( 4 downto 0 ) is
				when "01000"	=> -- BRD_MODE0
						c_brd_mode <= bl_data_in( 15 downto 0 ) after 1 ns;
				when "01001"	=> -- BRD_MODE1
						c_brd_mode <= bl_data_in( 15 downto 0 ) after 1 ns;
				when others => null;
			end case;
		end if;
		
	end if;
end process;
				

brd_mode0 <=c_brd_mode;


reset_o <= reset_i and not c_brd_mode(0) after 1 ns when rising_edge( clk );

end sm_dma_main;
 