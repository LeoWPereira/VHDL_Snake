LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.GenericDefinitions.all;
USE ieee.math_real.all;

entity hitdetection is
		generic(			 
			 FCLK: NATURAL := 50_000_000
			 
			 );		 
	port (
		 x_food		: in natural range 0 to VGA_MAX_HORIZONTAL;
		 x_special_food		: in natural range 0 to VGA_MAX_HORIZONTAL;
		 y_food	: in natural range 0 to VGA_MAX_VERTICAL;
		 print_special_food			: in std_logic;
		 y_special_food		: in natural range 0 to VGA_MAX_VERTICAL;
		 eats_p1,eat_p2,eats_p2		: out std_logic;			 
		 testesf :out natural :=0; 
		 x_snake_p1		: IN BodySnakeX;
		 x_snake_p2		: IN BodySnakeX;
		 y_snake_p1		: IN BodySnakeY;
		 y_snake_p2		: IN BodySnakeY;
		clk								: IN STD_LOGIC;		      
		led_p1,led_p2					: out std_logic
	);
end entity;

architecture hitdetection of hitdetection is

	signal size_p1, size_p2				: natural range 0 to WIN_SIZE;	
	signal p1_w			: std_logic:='0';
	signal p2_w			: std_logic:='0';
	-- sinais da saida da colisao que indicam que o respectivo player deve aumentar de tamanho
	signal increase_size_p1, increase_size_p2: std_logic; -- um pulso indica que houve uma colisao com a comida e, portanto, deve aumentar seu tamanho em uma unidade 
	
	signal win_p2,win_p1,eat_p1		: std_logic;
	
	
	constant LIMIT_TIMER: natural := FCLK*10;
	
	
begin

	led_p1<=p1_w;
	led_p2<=p2_w;	
	
	--  Hit detection
	process(clk)
	variable counter: natural range 0 to 10000000;
	begin
		if rising_edge(clk) then			
				HITDETECTION_P1_P2: for i in 0 to WIN_SIZE-1 loop
				if i<size_p2 then
					if x_snake_p1(0)=x_snake_p2(i) and y_snake_p1(0)=y_snake_p2(i) then
						win_p2<='1';
						p2_w<='1';					
					end if;
				end if;
				end loop HITDETECTION_P1_P2;
				HITDETECTION_P1_P1: for i in 1 to WIN_SIZE-1 loop
					if x_snake_p1(0)=x_snake_p1(i) and y_snake_p1(0)=y_snake_p1(i) then
						win_p2<='1';
					end if;
				end loop HITDETECTION_P1_P1;
				-- Hit food 
				if x_snake_p1(0)=x_food and y_snake_p1(0)=y_food then
					eat_p1<='1';					
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
						p1_w<='1';					
					end if;
				end if;
				end loop HITDETECTION_P2_P1;
				HITDETECTION_P2_P2: for i in 1 to WIN_SIZE-1 loop
					if x_snake_p2(0)=x_snake_p2(i) and y_snake_p2(0)=y_snake_p2(i) then
						win_p2<='1';
					end if;
				end loop HITDETECTION_P2_P2;
				-- Hit food P2
				if x_snake_p2(0)=x_food and y_snake_p2(0)=y_food then
					eat_p2<='1';					
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
		end if;
	end process;
	
end architecture;