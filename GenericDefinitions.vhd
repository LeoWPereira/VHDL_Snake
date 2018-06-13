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

	type BodySnakeX is array (WIN_SIZE-1 downto 0) of integer range 0 to VGA_MAX_HORIZONTAL;
	type BodySnakeY is array (WIN_SIZE-1 downto 0) of integer range 0 to VGA_MAX_VERTICAL;
end package;