-------------------------------------------------------------------------------
--
-- Title       : axis_pkg
--
-- Version     : 1.0
--
-------------------------------------------------------------------------------
--
-- Description : 	Определение типов для шины AXIS
--
--
-------------------------------------------------------------------------------
--
--  Version 1.0    21.10.2018  Dmitry Smekhov
--                Создан из axi_pkg
--
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;


package	axis_pkg is

--- Шина AXIS 16 ---
type M_AXIS_16_TYPE is record
	tdata			: std_logic_vector( 15 downto 0 );
	tvalid			: std_logic;
	tlast			: std_logic;
end record;

--- Шина AXIS 24 ---
type M_AXIS_24_TYPE is record
	tdata			: std_logic_vector( 23 downto 0 );
	tvalid			: std_logic;
	tlast			: std_logic;
end record;


--- Шина AXIS 32 ---
type M_AXIS_32_TYPE is record
	tdata			: std_logic_vector( 31 downto 0 );
	tvalid			: std_logic;
	tlast			: std_logic;
end record;



--- Шина AXIS 48 ---
type M_AXIS_48_TYPE is record
	tdata			: std_logic_vector( 47 downto 0 );
	tvalid			: std_logic;
	tlast			: std_logic;
end record;

--- Шина AXIS 64 ---
type M_AXIS_64_TYPE is record
	tdata			: std_logic_vector( 63 downto 0 );
	tvalid			: std_logic;
	tlast			: std_logic;
end record;



--- Шина AXIS 128 ---
type M_AXIS_128_TYPE is record
	tdata			: std_logic_vector( 127 downto 0 );
	tvalid			: std_logic;
	tlast			: std_logic;
end record;

--- Шина AXIS 256 ---
type M_AXIS_256_TYPE is record
	tdata			: std_logic_vector( 255 downto 0 );
	tvalid			: std_logic;
	tlast			: std_logic;
end record;







end package;

