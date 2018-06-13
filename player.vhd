LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.GenericDefinitions.all;
USE ieee.math_real.all;

entity player is
		generic(
			 animation_time : INTEGER := 10000000
			 );
		port (
			control : in std_logic_vector(1 downto 0)
		);
end entity;