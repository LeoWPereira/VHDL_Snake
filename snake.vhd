LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.GenericDefinitions.all;
USE ieee.math_real.all;

entity snake is
		generic(
			 animation_time : INTEGER := 10000000;
			 FCLK: NATURAL := 50_000_000
			 );		 
	port (
		clk: IN STD_LOGIC;
		
		-- Modulo VGA
		red, green, blue 				: out std_logic_vector (3 downto 0);
      Hsync, Vsync     				: out std_logic
	);
end entity;

architecture snake of snake is
	signal x_snake_p1 : BodySnakeX;--:= (0 => 9, 1 => 9, 2 => 9, 3 => 9, 4 => 9, 5 => 9, 6 => 9, 7 => 9, 8 => 9, 9 => 9, OTHERS => 0);
	signal x_snake_p2		: BodySnakeX := (0 => 15, 1 => 15, 2 => 16,  OTHERS => 0);
	signal y_snake_p1 : BodySnakeY;-- := (0 => 34, 1 => 35, 2 => 36, 3 => 37, 4 => 38, 5 => 39, 6 => 40, 7 => 41, 8 => 42, 9 => 43, OTHERS => 0);  --(0 => 34, 1 => 34,  OTHERS => 0);
	signal y_snake_p2		: BodySnakeY :=  (0 => 10, 1 => 11, 2 => 11,  OTHERS => 0);
	
	signal x_food, x_special_food		: natural range 0 to VGA_MAX_HORIZONTAL;
	signal y_food, y_special_food		: natural range 0 to VGA_MAX_VERTICAL;
	
	signal size_p1, size_p2				: natural range 0 to WIN_SIZE;

	signal animator : std_logic;
	signal print_special_food			: std_logic;

begin

	size_p1 <= 10;
	size_p2 <= 3;
	
	x_food <= 20;
	y_food <= 20;
	x_special_food <= 30;
	y_special_food <= 30;
	-- se a flag nao estiver setada, nao printa a special food
	print_special_food <= '1';
	
	player1: entity work.player port map (
		clk => clk,
		direction => "01",
		x_snake => x_snake_p1,
		y_snake => y_snake_p1
	);

-- Display VGA
-- Para o controle do display VGA, utiliza-se dois vetores de inteiros (BodySnakeX e BodySnakeY) para cada cobra.
-- O tamanho do display é de 640x480, sendo que cada posicao da cobra ocupa 10x10 pixels. PS: Na tela é pintado somente 9x9 pixels para ver os segmentos.
-- Dessa forma, o jogo possui 64x48 posicoes.
-- O display ira pintar na tela um quadrado na posicao x e y do vetor BodySnake.
-- Por exemplo, sempre ira pintar a cabeca da cobra utilizando x_snake_p1(0) e y_snake_p1(0).
-- Para enderecar as coordenadas da cobra, deve-se colocar um valor X entre 0 e 63 e um valor Y entre 0 e 47.
-- O display ira pintar posicoes da cobra correspondendo ao seu tamanho (size_p1 e size_p2).
-- Por exemplo, com um tamanho size_p1 = 2, ira pintar somente {x_snake_p1(0), y_snake_p1(0)} e {x_snake_p1(1), y_snake_p1(1)}.
-- A comida sempre sera pintada nas coordenadas x_food e y_food.
-- A comida especial sera pintada nas coordenadas x_special_food e y_special_food quando print_special_food for igual a 1.
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
										x_special_food => x_special_food,
										y_special_food => y_special_food,
										y_food => y_food,
										size_p1 => size_p1,
										size_p2 => size_p2,
										print_special_food => print_special_food);	
}

end architecture;