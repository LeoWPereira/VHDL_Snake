library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;

package GenericDefinitions is
	-- Os pixels serao pintados em quadrados de 10x10 pixels
	-- Sendo assim, o jogo será uma matriz de 64x48 posições
	-- Para o VGA, o numero maximo em X e Y é 10 pixels a menos
	-- E para simplificar, utiliza-se diretamente as posições (64x48)
	constant VGA_MAX_HORIZONTAL	:	natural := 63; 
	constant VGA_MAX_VERTICAL	:	natural := 47; 
	constant INIT_SIZE			:	natural := 3;
	constant WIN_SIZE 			:	natural := 10;
	constant SPECIAL_TIME		:	natural := 20;
	constant SPECIAL_POINTS		:	natural := 2;

	type BodySnakeX is array (WIN_SIZE-1 downto 0) of integer range -1 to VGA_MAX_HORIZONTAL+1;
	type BodySnakeY is array (WIN_SIZE-1 downto 0) of integer range -1 to VGA_MAX_VERTICAL+1;
	
	--Definir o tamanho inicial da cobra (3 é uma boa), ai ajustar as constantes de posição inicial. Definir constantes de posição inicial também
	constant init_pos_x_p1		: BodySnakeX := (0 => 9, 1 => 9, 2 => 9, 3 => 9, 4 => 9, 5 => 9, 6 => 9, 7 => 9, 8 => 9, 9 => 9, OTHERS => 0);
	constant init_pos_y_p1		: BodySnakeY := (0 => 34, 1 => 35, 2 => 36, 3 => 37, 4 => 38, 5 => 39, 6 => 40, 7 => 41, 8 => 42, 9 => 43, OTHERS => 0);
		
	constant init_pos_x_p2		: BodySnakeX := (0 => 15, 1 => 15, 2 => 16,  OTHERS => 0);
	constant init_pos_y_p2		: BodySnakeY := (0 => 10, 1 => 11, 2 => 11,  OTHERS => 0);
	
	--PESSOAL DA EQUIPE DO CONTROLE, FAZER AS MODIFICAÇÕES NECESSÁRIAS PRA COMPATIBILIZAR.
	subtype PlayerDirection is std_logic_vector(1 downto 0);
	
	constant DIRECTION_LEFT			: PlayerDirection := "10";
	constant DIRECTION_RIGHT		: PlayerDirection := "01";
	constant DIRECTION_UP			: PlayerDirection := "11";
	constant DIRECTION_DOWN			: PlayerDirection := "00";
end package;