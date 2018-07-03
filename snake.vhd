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
		player1_controller 			: in std_logic_vector(5 downto 0);
		player2_controller 			: in std_logic_vector(5 downto 0);
		increase_size_btn				: in std_logic; -- botao utilizado apenas para simular o pulso de aumento de tamanho
		-- Modulo VGA
		red, green, blue 				: out std_logic_vector (3 downto 0);
      Hsync, Vsync     				: out std_logic;
		start_btn						: in STD_LOGIC;
		led_p1,led_p2					: out std_logic
	);
end entity;

architecture snake of snake is
	signal x_snake_p1		: BodySnakeX;
	signal x_snake_p2		: BodySnakeX;
	signal y_snake_p1		: BodySnakeY;
	signal y_snake_p2		: BodySnakeY;
	signal boost_p1, boost_p2 			: std_logic;
	signal special_p1, special_p2 			: std_logic;
	signal game_won_p1, game_won_p2	: std_logic;
	signal x_food		: natural range 0 to VGA_MAX_HORIZONTAL:=32;
	signal x_special_food		: natural range 0 to VGA_MAX_HORIZONTAL:=30;
	signal y_food	: natural range 0 to VGA_MAX_VERTICAL:=24;
	signal y_special_food		: natural range 0 to VGA_MAX_VERTICAL:=30;
	
	signal size_p1, size_p2				: natural range 0 to WIN_SIZE;
	signal direction_player2, direction_player1 : PlayerDirection;
	signal animator : std_logic;
	signal print_special_food			: std_logic;
	
	-- sinais da saida da colisao que indicam que o respectivo player deve aumentar de tamanho
	signal increase_size_p1, increase_size_p2: std_logic; -- um pulso indica que houve uma colisao com a comida e, portanto, deve aumentar seu tamanho em uma unidade 
	signal increase_size_multi_p1, increase_size_multi_p2: std_logic; -- um pulso indica que houve uma colisao com a comida e, portanto, deve aumentar seu tamanho em uma unidade 
	
	signal win_p2,win_p1: std_logic;
	signal eat_p1		: std_logic:='0';  --flag comida normal
	signal eats_p1		: std_logic:='0';	 --flag comida especial
	signal eat_p2		: std_logic:='0';
	signal eats_p2		: std_logic:='0';
	signal p1_w			: std_logic:='0';  --flag led p1 win
	signal p2_w			: std_logic:='0';  --flag led p2 win
	signal start_game : std_logic:='0';
	signal game_over	: std_logic:='0';
	
	constant LIMIT_TIMER: natural := FCLK*10;
	
	signal testesf :natural :=0;
begin

	led_p1<=p1_w;
	led_p2<=p2_w;

	-- se a flag nao estiver setada, nao printa a special food

	controller_p1: entity work.controle
	port map (
		clk => clk,
		bt_up => player1_controller(0),
		bt_down => player1_controller(1),
		bt_left => player1_controller(2),
		bt_right => player1_controller(3),
		bt_boost => player1_controller(4),
		bt_special => player1_controller(5),
		boost_flag => boost_p1,
		special_flag => special_p1,
		direction => direction_player1
	);
	
	controller_p2: entity work.controle
	port map (
		clk => clk,
		bt_up => player2_controller(0),
		bt_down => player2_controller(1),
		bt_left => player2_controller(2),
		bt_right => player2_controller(3),
		bt_boost => player2_controller(4),
		bt_special => player2_controller(5),
		boost_flag => boost_p2,
		special_flag => special_p2,
		direction => direction_player2
	);
	
	
	player1: entity work.player 
	generic map (
		 init_pos_x => init_pos_x_p1,
		 init_pos_y	=> init_pos_y_p1
	)
	port map (
		boost=>boost_p1,
		clk => clk,
		game_won => game_won_p1,
		increase_size => eat_p1,
		start_game=>start_game,
		game_over=>game_over,
		increase_size_multi => eats_p1,
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
		boost=>boost_p2,
		clk => clk,
		game_won => game_won_p2,
		start_game=>start_game,
		game_over=>game_over,
		increase_size => eat_p2,
		increase_size_multi => eats_p2,
		direction => direction_player2,
		x_snake => x_snake_p2,
		y_snake => y_snake_p2,
		current_size => size_p2
	);
	
	debounce_pulse: entity work.debouncePulse
	port map (
		input => increase_size_btn,
		clock => clk,
		output => increase_size_multi_p1
	);
	
	
	process(clk)
	begin 
		if rising_edge(clk) then
			if(start_btn ='0') then
			start_game <='1';
		end if;
		end if;
	end process;
	--  Hit detection

	process(clk)
	variable counter: natural range 0 to 10000000;
	begin
		if rising_edge(clk) then
			if(game_won_p1 = '1' or game_won_p2 = '1') then
				game_over <= '1';
			end if;
			--counter := counter + 1;
			--if counter = 10000000 - 1 then
				HITDETECTION_P1_P2: for i in 0 to WIN_SIZE-1 loop
				if i<size_p2 then
					if x_snake_p1(0)=x_snake_p2(i) and y_snake_p1(0)=y_snake_p2(i) then
						win_p2<='1';
						game_over<='1';
						p2_w<='1';					
					end if;
				end if;
				end loop HITDETECTION_P1_P2;
				HITDETECTION_P1_P1: for i in 3 to WIN_SIZE-1 loop
				IF i < size_p1 then
					if x_snake_p1(0)=x_snake_p1(i) and y_snake_p1(0)=y_snake_p1(i) then
						win_p2<='1';
						game_over<='1';
					end if;
				end if;
				end loop HITDETECTION_P1_P1;
				-- Hit food 
				if x_snake_p1(0)=x_food and y_snake_p1(0)=y_food then
					eat_p1<='1';
					--x_food <= 10;
					--y_food <= 14;
				else
					eat_p1<='0';					
				end if;
				-- Hit special food
				if x_snake_p1(0)=x_special_food and y_snake_p1(0)=y_special_food and 	print_special_food = '1' then
					eats_p1<='1';
					
					testesf<=1;
				else
					eats_p1<='0';
				end if;
				
				---- verificar atividade do baude para caso de comer mais de 1 comida ao mesmo tempo.
				
				HITDETECTION_P2_P1: for i in 0 to WIN_SIZE-1 loop
				IF i<size_p1 THEN
					if x_snake_p2(0)=x_snake_p1(i) and y_snake_p2(0)=y_snake_p1(i) then
						win_p1<='1';
						game_over<='1';
						p1_w<='1';
						
					end if;
				end if;
				end loop HITDETECTION_P2_P1;
				HITDETECTION_P2_P2: for i in 3 to WIN_SIZE-1 loop
				IF i < size_p2 then
					if x_snake_p2(0)=x_snake_p2(i) and y_snake_p2(0)=y_snake_p2(i) then
						win_p2<='1';
						game_over<='1';
					end if;
				end if;
				end loop HITDETECTION_P2_P2;
				-- Hit food P2
				if x_snake_p2(0)=x_food and y_snake_p2(0)=y_food then
					eat_p2<='1';
					--x_food <= 10;
					--y_food <= 14;
				else
					eat_p2<='0';
				end if;
				-- Hit special food P2
				if x_snake_p2(0)=x_special_food and y_snake_p2(0)=y_special_food and print_special_food = '1' then
					eats_p2<='1';
					testesf<=1;
				else
					eats_p2<='0';
				end if;
				
			--end if;
		end if;
	end process;
	
	
	---processo para causar delay do special_food
	process (clk)
	variable counter: natural := 0;
	variable hit_special_food : std_logic := '0';
	variable comecacontar : std_LOGIC :='0';

	begin

	if rising_edge(clk) then 
		if testesf=1 then
	if eats_p1='1' or eats_p2='1' then
		print_special_food<='0';
		counter:=0;
		comecacontar:='1';
	end if;
	if comecacontar='1' then
		counter:=counter +1;
	end if;
	
		if counter >= LIMIT_TIMER - 1 then
			

				print_special_food <= '1';
		
			comecacontar:='0';
			counter:=0;
		end if ;
		else
			print_special_food <= '1';
		
		end if;
		
		end if;
	end process;
	
	
	---food
	process(clk)
	variable counter_speed:natural;
	variable counteraleatorio1:natural;
	variable counteraleatorio2:natural;
	begin
		if rising_edge(clk) then		
		counter_speed := counter_speed + 1;
		counteraleatorio1:=counteraleatorio1+1;
		counteraleatorio2:=counteraleatorio2+1;
		--flag<='0';		
		
		if counteraleatorio1 >= VGA_MAX_HORIZONTAL then		
			counteraleatorio1 := 0;		
		end if;
		
		if counteraleatorio2 >= VGA_MAX_VERTICAL then		
			counteraleatorio2 := 0;		
		end if;
		
		if eat_p2='1' or eat_p1='1' then
			--flag<='1';
			x_food <= counteraleatorio1;
			y_food <= counteraleatorio2;			
		else
	
		if eats_p2='1' or eats_p1='1' then
			--flag<='1';
			x_special_food <= counteraleatorio1;
			y_special_food <= counteraleatorio2;			
		else 	
			--flag <= '0';
		end if;			
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
end architecture;