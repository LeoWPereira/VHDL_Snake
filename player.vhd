LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.GenericDefinitions.all;
use ieee.numeric_std.all;
USE ieee.math_real.all;

entity player is
		generic(
			 animation_time : INTEGER := 10000000;
			 init_pos_x : BodySnakeX;
			 init_pos_y : BodySnakeY
			 );           
		port (
			clk : 			in std_logic;
			increase_size: in std_logic; -- sinal correspondente a um pulso, que indica que a cobra deve aumentar seu tamanho, no momento da colisao
			direction : 	in PlayerDirection;
			y_snake :  		out BodySnakeY;
			x_snake :  		out BodySnakeX;
			current_size : out natural range 0 to WIN_SIZE -- retorna sempre o tamanho atual do player
		);
end entity;


architecture a_player of player is
	signal animator : 			std_logic;
	signal x_snake_buffer :  	BodySnakeX := init_pos_x;
	signal y_snake_buffer :		BodySnakeY := init_pos_y;
	signal my_size : 				natural range 0 to WIN_SIZE := INIT_SIZE;
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
	
	-- controle do tamanho da snake
	size: PROCESS(clk)
	BEGIN
		IF (rising_edge(clk)) THEN
			IF increase_size = '1' THEN
				my_size <= my_size + 1; -- incrementa o tamanho
			END IF;
		END IF;
	END PROCESS size;
	
	animation: PROCESS(animator)
	variable current_direction : PlayerDirection;
	begin
		IF (rising_edge(animator)) THEN
		
			if(current_direction = DIRECTION_UP and direction = DIRECTION_DOWN) then
				current_direction := current_direction;
			elsif(current_direction = DIRECTION_DOWN and direction = DIRECTION_UP) then
				current_direction := current_direction;
			elsif(current_direction = DIRECTION_LEFT and direction = DIRECTION_RIGHT) then
				current_direction := current_direction;
			elsif(current_direction = DIRECTION_RIGHT and direction = DIRECTION_LEFT) then
				current_direction := current_direction;
			else
				current_direction := direction;
			end if;	
			
			if(x_snake_buffer(0) >= VGA_MAX_HORIZONTAL) then
				x_snake_buffer(0) <= 0;
			elsif(x_snake_buffer(0) < 0) then
				x_snake_buffer(0) <= VGA_MAX_HORIZONTAL-1;
			elsif(y_snake_buffer(0) >= VGA_MAX_VERTICAL) then
				y_snake_buffer(0) <= 0;
			elsif(y_snake_buffer(0) < 0) then
				y_snake_buffer(0) <= VGA_MAX_VERTICAL-1;
			else
				if(current_direction = DIRECTION_RIGHT) then
					x_snake_buffer(0) <= x_snake_buffer(0) + 1;
				elsif(current_direction = DIRECTION_LEFT) then
					x_snake_buffer(0) <= x_snake_buffer(0) - 1;
				elsif(current_direction = DIRECTION_DOWN) then
					y_snake_buffer(0) <= y_snake_buffer(0) + 1;
				elsif(current_direction = DIRECTION_UP) then
					y_snake_buffer(0) <= y_snake_buffer(0) - 1;
				end if;
			end if;
			
			x_snake_buffer(x_snake_buffer'length - 1 downto 1) <= x_snake_buffer(x_snake_buffer'length - 2 downto 0);
			y_snake_buffer(y_snake_buffer'length - 1 downto 1) <= y_snake_buffer(y_snake_buffer'length - 2 downto 0);
			
		end if;
	
	end process animation;
	x_snake <= x_snake_buffer;
	y_snake <= y_snake_buffer;
	current_size <= my_size;
	
end;