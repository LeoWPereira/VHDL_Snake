LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.GenericDefinitions.all;
USE ieee.math_real.all;

entity food is
		generic(			 
			 FCLK: NATURAL := 50_000_000			 				
			 );		 
	port (
		x_food		: out natural range 0 to VGA_MAX_HORIZONTAL;
	   x_special_food		: out natural range 0 to VGA_MAX_HORIZONTAL;
	   y_food	: out natural range 0 to VGA_MAX_VERTICAL;
	   y_special_food		: out natural range 0 to VGA_MAX_VERTICAL;			 
	   print_special_food			: out std_logic;	
	   eat_p1,eats_p1,eat_p2,eats_p2		: in std_logic;
	   testesf :in natural :=0;
		clk								: IN STD_LOGIC	
	);
end entity;

architecture food of food is		
	constant LIMIT_TIMER: natural := FCLK*10;		
	
begin	
	
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


end architecture;