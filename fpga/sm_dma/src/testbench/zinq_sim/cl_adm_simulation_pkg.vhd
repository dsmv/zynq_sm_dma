-------------------------------------------------------------------------------
--
-- Title       : cl_adm_simulation
-- Author      : Dmitry Smekhov
-- Company     : Instrumental Systems
-- E-mail      : dsmv@insys.ru
--
-- Version     : 1.0
--
-------------------------------------------------------------------------------
--
-- Description :  Узел для моделирования интерфейса ADM
--
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

library work;
use work.adm2_pkg.all;	
use work.cmd_sim_pkg.all;



package	adm_simulation_pkg is
	
	
---- Сигналы для взаимодействия с моделью процессора ----	
signal		adm_cmd		: bh_cmd; 	-- команда
signal		adm_ret		: bh_ret; 	-- ответ
	
type std_logic_array_16xbh_cmd is array (15 downto 0) of bh_cmd;
type std_logic_array_16xbh_ret is array (15 downto 0) of bh_ret;

signal	adm_cmd_arr				: std_logic_array_16xbh_cmd;
signal	adm_ret_arr				: std_logic_array_16xbh_ret;


end package;



