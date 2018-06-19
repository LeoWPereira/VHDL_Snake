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
		clk								: IN STD_LOGIC;
		direction_player1 			: in PlayerDirection;
		direction_player2 			: in PlayerDirection;
		increase_size_btn				: in std_logic; -- botao utilizado apenas para simular o pulso de aumento de tamanho
		-- Modulo VGA
		red, green, blue 				: out std_logic_vector (3 downto 0);
      Hsync, Vsync     				: out std_logic
	);
end entity;

architecture snake of snake is
	signal x_snake_p1		: BodySnakeX;
	signal x_snake_p2		: BodySnakeX;
	signal y_snake_p1		: BodySnakeY;
	signal y_snake_p2		: BodySnakeY;
	
	signal x_food, x_special_food		: natural range 0 to VGA_MAX_HORIZONTAL;
	signal y_food, y_special_food		: natural range 0 to VGA_MAX_VERTICAL;
	
	signal size_p1, size_p2				: natural range 0 to WIN_SIZE;

	signal animator : std_logic;
	signal print_special_food			: std_logic;
	
	-- sinais da saida da colisao que indicam que o respectivo player deve aumentar de tamanho
	signal increase_size_p1, increase_size_p2: std_logic; -- um pulso indica que houve uma colisao com a comida e, portanto, deve aumentar seu tamanho em uma unidade 

begin

	--size_p1 <= 10;
	--size_p2 <= 3;
	
	x_food <= 20;
	y_food <= 20;
	x_special_food <= 30;
	y_special_food <= 30;
	-- se a flag nao estiver setada, nao printa a special food
	print_special_food <= '1';
	
	player1: entity work.player 
	generic map (
		 init_pos_x => init_pos_x_p1,
		 init_pos_y	=> init_pos_y_p1
	)
	port map (
		clk => clk,
		increase_size => increase_size_p1,
		direction => direction_player1,
		x_snake => x_snake_p1,
		y_snake => y_snake_p1,
		current_size => size_p1
	);
	
	player2: entity work.player 
	generic map (
		 init_pos_x => init_pos_x_p2,
		 init_pos_y	=> init_pos_y_p2
	)
	port map (
		clk => clk,
		increase_size => increase_size_p2,
		direction => direction_player2,
		x_snake => x_snake_p2,
		y_snake => y_snake_p2,
		current_size => size_p2
	);
	
	debounce_pulse: entity work.debouncePulse
	port map (
		input => increase_size_btn,
		clock => clk,
		output => increase_size_p1
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
end architecture;