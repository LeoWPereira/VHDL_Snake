LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.GenericDefinitions.all;
use ieee.numeric_std.all;
USE ieee.math_real.all;

entity controle is
		        
		port (
			bt_up,bt_down,bt_left,bt_right,bt_boost,bt_special,clk :IN std_logic;
			boost_flag: out std_logic;
			special_flag: out std_logic;
			direction : out PlayerDirection
		);
end entity;


architecture a_controle of controle is
	signal up_pulse,down_pulse,left_pulse,right_pulse: std_logic;
begin
	debounce_down: entity work.debouncePulse
	port map (
		input => bt_down,
		clock => clk,
		output => down_pulse
	);
	
	debounce_up: entity work.debouncePulse
	port map (
		input => bt_up,
		clock => clk,
		output => up_pulse
	);
	
	debounce_left: entity work.debouncePulse
	port map (
		input => bt_left,
		clock => clk,
		output => left_pulse
	);
	
	debounce_right: entity work.debouncePulse
	port map (
		input => bt_right,
		clock => clk,
		output => right_pulse
	);
	
	debounce_boost: entity work.debouncePulse
	port map (
		input => bt_boost,
		clock => clk,
		output => boost_flag
	);
	
	debounce_special: entity work.debouncePulse
	port map (
		input => bt_special,
		clock => clk,
		output => special_flag
	);
	
	direct: PROCESS(up_pulse,down_pulse,left_pulse,right_pulse)	
	BEGIN
		IF(up_pulse = '1') THEN
			direction <= DIRECTION_UP;
		ELSIF (down_pulse = '1') THEN
			direction <= DIRECTION_DOWN;
		ELSIF (left_pulse = '1') THEN
			direction <= DIRECTION_LEFT;
		ELSIF(right_pulse = '1') THEN
			direction <= DIRECTION_RIGHT;
		ELSE
		END IF;

	END PROCESS direct;
	
END;