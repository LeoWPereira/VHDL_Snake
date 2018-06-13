LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.GenericDefinitions.all;
USE ieee.math_real.all;

entity snake is
		generic(
			 animation_time : INTEGER := 10000000
			 );		 
	port (
		clk: IN STD_LOGIC;
		
		-- Modulo VGA
		red, green, blue 				: out std_logic_vector (3 downto 0);
      	Hsync, Vsync     				: out std_logic
	);
end entity;

architecture snake of snake is
	signal x_snake_p1 : BodySnakeX := (0 => 9, 1 => 9, 2 => 9, 3 => 9, 4 => 9, 5 => 9, 6 => 9, 7 => 9, 8 => 9, 9 => 9, OTHERS => 0);
	signal x_snake_p2		: BodySnakeX := (0 => 15, 1 => 15, 2 => 16,  OTHERS => 0);
	signal y_snake_p1 : BodySnakeY := (0 => 34, 1 => 35, 2 => 36, 3 => 37, 4 => 38, 5 => 39, 6 => 40, 7 => 41, 8 => 42, 9 => 43, OTHERS => 0);  --(0 => 34, 1 => 34,  OTHERS => 0);
	signal y_snake_p2		: BodySnakeY :=  (0 => 10, 1 => 11, 2 => 11,  OTHERS => 0);
	
	signal x_food						: natural range 0 to VGA_MAX_HORIZONTAL;
	signal y_food					 	: natural range 0 to VGA_MAX_VERTICAL;
	
	signal size_p1, size_p2				: natural range 0 to WIN_SIZE;

	signal animator : std_logic;
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
	
	animation_p1: PROCESS(animator)
	
	begin
		IF (rising_edge(animator)) THEN
			if(x_snake_p1(0) >= VGA_MAX_HORIZONTAL) then
				x_snake_p1(0) <= 0;
			else
				x_snake_p1(0) <= x_snake_p1(0) + 1;
			end if;
			x_snake_p1(x_snake_p1'length - 1 downto 1) <= x_snake_p1(x_snake_p1'length - 2 downto 0);
			
			if(y_snake_p1(0) >= VGA_MAX_VERTICAL) then
				y_snake_p1(0) <= 0;
			--else
				--x_snake_p1(0) <= x_snake_p1(0) + 1;
			end if;
			y_snake_p1(y_snake_p1'length - 1 downto 1) <= y_snake_p1(y_snake_p1'length - 2 downto 0);
			
		end if;
	
	end process animation_p1;
	
-- Testes
--	x_snake_p1(0) <= 10;
--	y_snake_p1(0) <= 34;
--	x_snake_p2(0) <= 15;
--	y_snake_p2(0) <= 10;
--	x_snake_p1(1) <= 11;
--	y_snake_p1(1) <= 34;
--	x_snake_p2(1) <= 15;
--	y_snake_p2(1) <= 11;
--	x_snake_p2(2) <= 16;
--	y_snake_p2(2) <= 11;
--	
	size_p1 <= 10;
	size_p2 <= 3;
	
	x_food <= 20;
	y_food <= 20;


--  display VGA
	vga: entity work.DisplayVGA PORT MAP (clk => clk,
										Hsync => Hsync,
										Vsync => Vsync,
										red => red,
										green => green,
										blue => blue,
										x_snake_p1 => x_snake_p1,
										x_snake_p2 => x_snake_p2,
										y_snake_p1 => y_snake_p1,
										y_snake_p2 => y_snake_p2,
										x_food => x_food,
										y_food => y_food,
										size_p1 => size_p1,
										size_p2 => size_p2);	

end architecture;