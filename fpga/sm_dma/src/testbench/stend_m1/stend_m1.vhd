-------------------------------------------------------------------------------
--
-- Title       : stend_m2
--
-- Version     : 1.0
--
-------------------------------------------------------------------------------
--
-- Description : 	Проверка ikva_control
--														  
--
-------------------------------------------------------------------------------
--
--  Version 1.0  26.01.2019 Dmitry Smekhov
--
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_textio.all;

use std.textio.all;
use std.textio;
    
use work.cmd_sim_pkg.all;
use work.test_dma_pkg.all;		

use work.adm_simulation_pkg.all;		   



entity stend_m2 is
	generic(
	 	test_id             : in integer:=-1;       	-- идентификатор теста
        stend_name          : in string:="stend_m2";     -- имя стенда
        test_log            : in string:="../../../../src/testbench/log/"    -- путь к файлу отчёта
    );
end stend_m2;

architecture Behavioral of stend_m2 is
	
constant	fname_test_id	        : string:= test_log & "test_id.txt";
constant    path                    : string:= test_log;

function  get_id_from_file( id : integer; fname	: in string ) return integer is

	FILE   		file_id		: text;
	variable	L			: line;		 
	variable	L1			: line;		 
	variable	ret			: integer;

begin
	
	if( id=-1 ) then
		file_open( file_id, fname, READ_MODE );
		readline( file_id, L );
		read( L, ret );
		file_close( file_id );
	else
		ret:=id;
	end if;
	
	return ret;
end function;

signal	cmd				: bh_cmd; 	
signal  ret				: bh_ret; 	
signal	cmd_init_done	: std_logic:='0';

signal  clk             : std_logic:='0';
signal  reset_n         : std_logic:='0';



begin
	
clk <= not clk after 5 ns;
reset_n <= '0', '1' after 200 ns;
	
	
uut: entity work.top
	generic map(
		is_simulation => 1
	);
  
 
        
pr_main: process 

variable    test_id_z       : integer;

variable	data	: std_logic_vector( 31 downto 0 );
variable 	str 	: LINE;		-- pointer to string
begin
	
    test_id_z:= get_id_from_file( test_id, fname_test_id ); 
	
	test_dma_init( path, stend_name, test_id_z );
	
	wait for 150 ns;

	
	case( test_id_z ) is
	
	    when 20 => test_dma_register( adm_cmd, adm_ret );
		
		
		when others => null;
	end case;
    	

	
	test_dma_close;
	wait;
	
end process;

end Behavioral;
            