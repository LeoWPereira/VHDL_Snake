Library IEEE;
use IEEE.STD_Logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
USE work.GenericDefinitions.all;

entity DisplayVGA is

    port (
	    clk            				: in std_logic;
	    red, green, blue 			: out std_logic_vector (3 downto 0);
	    Hsync, Vsync     			: out std_logic;
		
		x_snake_p1, x_snake_p2		: in BodySnakeX;
		y_snake_p1, y_snake_p2		: in BodySnakeY;
		
		x_food, x_special_food		: in natural range 0 to VGA_MAX_HORIZONTAL;
		y_food, y_special_food	 	: in natural range 0 to VGA_MAX_VERTICAL;
		
		size_p1, size_p2 			: in natural range 0 to WIN_SIZE;

		print_special_food			: in std_logic
    );
end;

architecture DisplayVGA of DisplayVGA is
	signal reset:     STD_LOGIC;
	signal start:     STD_LOGIC;
	signal y_control: natural range 0 to 900;
	signal x_control: natural range 0 to 900;
	signal video_on:  STD_LOGIC;
begin
	
	start <= '1';
	reset <= '0';
	
	vga_sync: entity work.sync_mod PORT MAP (clk => clk, 
											 reset => reset,
											 start => start,
											 y_control => y_control,
											 x_control => x_control,
											 h_s => Hsync,
											 v_s => Vsync,
											 video_on => video_on);
   
   process (video_on)
		variable x_screen, y_screen : natural;
		variable print_pixel : std_logic;
   begin
		if video_on = '1' then
			
			x_screen := x_control;
			y_screen := y_control;
			print_pixel := '0';
			
			DISPLAY_PLAYER1: for i in 0 to (WIN_SIZE - 1) loop
				-- Snake Player 1
				if (x_screen >= (x_snake_p1(i)*10 + 1)) and x_screen <= (x_snake_p1(i)*10 + 9) and 
					(y_screen >= (y_snake_p1(i)*10 + 1)) and (y_screen <= (y_snake_p1(i)*10 + 9)) and (i < size_p1) then
					red <= (others => '0');
					green <= (others => '0');
					blue <= (others => '0');
					print_pixel := '1';
				end if;
			end loop DISPLAY_PLAYER1;

			DISPLAY_PLAYER2: for i in 0 to (WIN_SIZE - 1) loop
				-- Snake Player 2
				if (x_screen >= (x_snake_p2(i)*10 + 1)) and (x_screen <= (x_snake_p2(i)*10 + 9)) and 
					(y_screen >= (y_snake_p2(i)*10 + 1)) and (y_screen <= (y_snake_p2(i)*10 + 9)) and (i < size_p2) then
					red <= (others => '0');
					green <= (others => '0');
					blue <= (others => '1');
					print_pixel := '1';
				end if;
			end loop DISPLAY_PLAYER2;
			
			-- Food
			if (x_screen >= (x_food*10 + 1)) and (x_screen <= (x_food*10 + 9)) and
				(y_screen >= (y_food*10 + 1)) and (y_screen <= (y_food*10 + 9)) then
				red <= (others => '1');
				green <= (others => '0');
				blue <= (others => '0');
				print_pixel := '1';
			end if;

			-- Special Food
			if (x_screen >= (x_special_food*10 + 1)) and (x_screen <= (x_special_food*10 + 9)) and
				(y_screen >= (y_special_food*10 + 1)) and (y_screen <= (y_special_food*10 + 9)) and print_special_food = '1' then
				red <= (others => '0');
				green <= (others => '1');
				blue <= (others => '0');
				print_pixel := '1';
			end if;
				
			if print_pixel = '0' then
				red <= (others => '1');
				green <= (others => '1');
				blue <= (others => '1');			
			end if;
		else 
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '0');
		end if;
   end process;
end architecture;