LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.GenericDefinitions.all;
USE ieee.math_real.all;

entity player is
		generic(
			 animation_time : INTEGER := 10000000
			 );
		port (
			clk : in std_logic;
			direction : in std_logic_vector(1 downto 0);
			y_snake :  out BodySnakeY;
			x_snake :  out BodySnakeX
		);
end entity;


architecture a_player of player is
	signal animator : std_logic;
	signal current_direction : std_logic_vector(1 downto 0);
	signal y_snake_buffer :  BodySnakeY := (0 => 34, 1 => 35, 2 => 36, 3 => 37, 4 => 38, 5 => 39, 6 => 40, 7 => 41, 8 => 42, 9 => 43, OTHERS => 0);
	signal x_snake_buffer :  BodySnakeX := (0 => 9, 1 => 9, 2 => 9, 3 => 9, 4 => 9, 5 => 9, 6 => 9, 7 => 9, 8 => 9, 9 => 9, OTHERS => 0);
begin
	
	count: PROCESS(clk)
		VARIABLE temp : INTEGER RANGE 0 TO animation_time;
	BEGIN
		IF (rising_edge(clk)) THEN
			temp := temp + 1;
			IF(temp>=animation_time-1) then 
			temp:= 0;
			animator <= '1';
			ELSE animator <= '0';
			END IF;
		END IF;
	END PROCESS count;
	
	direction_check : PROCESS(current_direction) -- impede cobra de ir para posição oposta
	begin
		if(current_direction = "00" and direction = "11") then
			current_direction <= "00";
		elsif (current_direction = "01" and direction = "10") then
			current_direction <= "01";
		elsif (current_direction = "10" and direction = "01") then
			current_direction <= "10";
		elsif (current_direction = "11" and direction = "00") then
			current_direction <= "11";
		else
			current_direction <= direction;
		end if;
			
	END PROCESS direction_check;
	
	animation: PROCESS(animator)
	
	begin
		IF (rising_edge(animator)) THEN
			if(x_snake_buffer(0) >= VGA_MAX_HORIZONTAL) then
				x_snake_buffer(0) <= 0;
			elsif(x_snake_buffer(0) < 0) then
				x_snake_buffer(0) <= VGA_MAX_HORIZONTAL-1;
			elsif(y_snake_buffer(0) >= VGA_MAX_VERTICAL) then
				y_snake_buffer(0) <= 0;
			elsif(y_snake_buffer(0) < 0) then
				y_snake_buffer(0) <= VGA_MAX_VERTICAL-1;
			else
				if(current_direction = "01") then
					x_snake_buffer(0) <= x_snake_buffer(0) + 1;
				elsif(current_direction = "10") then
					x_snake_buffer(0) <= x_snake_buffer(0) - 1;
				elsif(current_direction = "00") then
					y_snake_buffer(0) <= y_snake_buffer(0) + 1;
				elsif(current_direction = "11") then
					y_snake_buffer(0) <= y_snake_buffer(0) - 1;
				end if;
			end if;
			x_snake_buffer(x_snake_buffer'length - 1 downto 1) <= x_snake_buffer(x_snake_buffer'length - 2 downto 0);
			y_snake_buffer(y_snake_buffer'length - 1 downto 1) <= y_snake_buffer(y_snake_buffer'length - 2 downto 0);
		end if;
	
	end process animation;
	x_snake <= x_snake_buffer;
	y_snake <= y_snake_buffer;
	
	
end;