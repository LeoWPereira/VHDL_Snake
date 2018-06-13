LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.GenericDefinitions.all;
USE ieee.math_real.all;

entity snake is
	port (
		clk: IN STD_LOGIC;
		
		-- Modulo VGA
		red, green, blue 				: out std_logic_vector (3 downto 0);
      	Hsync, Vsync     				: out std_logic
	);
end entity;

architecture snake of snake is
	signal x_snake_p1, x_snake_p2		: BodySnakeX;
	signal y_snake_p1, y_snake_p2		: BodySnakeY;
	
	signal x_food						: natural range 0 to VGA_MAX_HORIZONTAL;
	signal y_food					 	: natural range 0 to VGA_MAX_VERTICAL;
	
	signal size_p1, size_p2				: natural range 0 to WIN_SIZE;

begin
	
-- Testes
	x_snake_p1(0) <= 10;
	y_snake_p1(0) <= 34;
	x_snake_p2(0) <= 15;
	y_snake_p2(0) <= 10;
	x_snake_p1(1) <= 11;
	y_snake_p1(1) <= 34;
	x_snake_p2(1) <= 15;
	y_snake_p2(1) <= 11;
	x_snake_p2(2) <= 16;
	y_snake_p2(2) <= 11;
	size_p1 <= 2;
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