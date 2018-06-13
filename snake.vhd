LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.GenericDefinitions.all;
USE ieee.math_real.all;

entity snake is
	generic(
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
	signal x_snake_p1, x_snake_p2		: BodySnakeX;
	signal y_snake_p1, y_snake_p2		: BodySnakeY;
	
	signal x_food, x_special_food		: natural range 0 to VGA_MAX_HORIZONTAL;
	signal y_food, y_special_food		: natural range 0 to VGA_MAX_VERTICAL;
	
	signal size_p1, size_p2				: natural range 0 to WIN_SIZE;

	signal print_special_food			: std_logic;

	constant TMAX: NATURAL := FCLK * 5;
	CONSTANT TEMPO_500MS: NATURAL := FCLK / 10;

begin
	
-- Testes
	-- cobra se movendo, posicao y 34
	y_snake_p1(0) <= 34;
	y_snake_p1(1) <= 34;
	y_snake_p1(2) <= 34;

	-- cabeca da cobra em 15,10
	x_snake_p2(0) <= 15;
	y_snake_p2(0) <= 10;
	-- corpo 1 cobra 15,11
	x_snake_p2(1) <= 15;
	y_snake_p2(1) <= 11;
	-- corpo 2 cobra 16,11
	x_snake_p2(2) <= 16;
	y_snake_p2(2) <= 11;
	size_p1 <= 3;
	size_p2 <= 3;
	x_food <= 20;
	y_food <= 20;
	x_special_food <= 30;
	y_special_food <= 30;
	-- se a flag nao estiver setada, nao printa a special food
	print_special_food <= '1';

-- TESTE COBRAS
process(clk)
variable counter: natural range 0 to TMAX;
variable x_p1_counter: BodySnakeX;
variable body_index: natural range 0 to WIN_SIZE;
begin
	if rising_edge(clk) then
		counter := counter + 1;
		if counter = TEMPO_500MS - 1 then
			DISPLAY_PLAYER1: for i in 0 to (WIN_SIZE - 1) loop
				body_index := WIN_SIZE - 1 - i;
				-- se for corpo (i>0) e nao cabeca, posicao iguala a posicao anterior - 1
				if body_index < size_p1  and body_index > 0 then
					x_p1_counter(body_index) := x_p1_counter(body_index - 1);
				-- Retorna posicao x para 0 (passou a tela)
				elsif x_p1_counter(body_index) = 63 and body_index < size_p1 then
					x_p1_counter(body_index) := 0;
				-- cabeca, incrementa posicao
				elsif body_index < size_p1 then
					x_p1_counter(body_index) := x_p1_counter(body_index) + 1;
				end if;
				
				x_snake_p1(body_index) <= x_p1_counter(body_index);
			end loop DISPLAY_PLAYER1;
			counter := 0;
		end if;
	end if;
end process;


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