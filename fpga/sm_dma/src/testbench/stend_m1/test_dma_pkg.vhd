---------------------------------------------------------------------------------------------------
--
-- Title       : test_dma_pkg.vhd
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
---------------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;		
use ieee.std_logic_arith.all;  
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;



library work;
use work.cmd_sim_pkg.all;	  	
use work.block_pkg.all;	
--use work.trd_pkg.all;
--use work.pck_fio.all;	



package test_dma_pkg is
	
--! test init
procedure test_dma_init(
		path          : in string;  
        stend_name    : in string;  
        test_id       : in integer  
	);
	
--! test close
procedure test_dma_close;						
	
--! crate message with test result
procedure test_dma_finish( error   : in integer );
	
	
--! Test register access
procedure test_dma_register (
		signal  cmd			: out bh_cmd; 		--! command
		signal  ret			: in  bh_ret  		--! replay
		
	);
	
				
end package	test_dma_pkg;

use work.pck_fio.all;	

package body test_dma_pkg is
	
	FILE   log: text;
	
	shared variable cnt_ok, cnt_error: integer;
	
--! test init
procedure test_dma_init(
    path          : in string;  -- path to log files
    stend_name    : in string;  -- stand name
    test_id       : in integer  -- test id, it is a part of file name
) is
	constant fname : string:=path & stend_name & "_file_id_" & integer'image(test_id) & ".log";
    
begin
    
    file_open( log, fname, WRITE_MODE );
    cnt_ok:=0;
    cnt_error:=0;
    
end test_dma_init;	


procedure test_dma_close is		
begin					  	
	
		
	
	file_close( log ); 
	
end test_dma_close;	
	
	
			

procedure test_dma_finish( error   : in integer )
is

variable    str            : line;         
variable    L              : line;         

begin

	fprint( output, L, "\nTest time:  %r \n", fo(now) );
	fprint(    log, L, "\nTest time:  %r \n", fo(now) );

    -- write to file --
    writeline( log, str );        
    if( error=0 ) then
    write( str, string'("TEST finished successfully" ));
    cnt_ok := cnt_ok + 1;
    else
    write( str, string'("TEST finished with ERR" ));
    cnt_error := cnt_error + 1;
    end if;
    writeline( log, str );    
    writeline( log, str );        
    
    -- write to console --
    writeline( output, str );        
    if( error=0 ) then
    write( str, string'("TEST finished successfully" ));
    else
    write( str, string'("TEST finished with ERR" ));
    end if;
    writeline( output, str );    
    writeline( output, str );

end test_dma_finish;	
	
--! Test register access
procedure test_dma_register (
		signal  cmd			: out bh_cmd; 		--! команда
		signal  ret			: in  bh_ret  		--! ответ
		
	) 
is


variable 	L 		: line;

variable	data_out		: std_logic_vector( 31 downto 0 );
variable	data_in			: std_logic_vector( 31 downto 0 );
variable	data_expect		: std_logic_vector( 31 downto 0 );

variable	error			: integer:=0;



begin

	fprint( output, L, "TEST_REGISTER    time: %r\n", fo(now) );
	fprint(    log, L, "TEST_REGISTER    time: %r\n", fo(now) );
	
	
	data_out:=x"00000D00";
	block_read( cmd, ret, 0, 0, data_in );
	
	if( data_in = data_out ) then
		fprint( output, L, "expect: %r  read: %r  - Ok\n", fo( data_out ), fo( data_in ) );
		fprint(    log, L, "expect: %r  read: %r  - Ok\n", fo( data_out ), fo( data_in ) );
	else
		error:=error+1;
		fprint( output, L, "expect: %r  read: %r  - ERROR\n", fo( data_out ), fo( data_in ) );
		fprint(    log, L, "expect: %r  read: %r  - ERROR\n", fo( data_out ), fo( data_in ) );
	end if;

	
	data_out:=x"00005678";
	
	block_write( cmd, ret, 0, 8, data_out );
	block_read( cmd, ret, 0, 8, data_in );
	
	if( data_in = data_out ) then
		fprint( output, L, "write: %r  read: %r  - Ok\n", fo( data_out ), fo( data_in ) );
		fprint(    log, L, "write: %r  read: %r  - Ok\n", fo( data_out ), fo( data_in ) );
	else
		error:=error+1;
		fprint( output, L, "write: %r  read: %r  - ERROR\n", fo( data_out ), fo( data_in ) );
		fprint(    log, L, "write: %r  read: %r  - ERROR\n", fo( data_out ), fo( data_in ) );
	end if;
	
	
	test_dma_finish( error );	

		
end test_dma_register;


end package	body test_dma_pkg;
