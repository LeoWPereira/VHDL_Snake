library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity debouncePulse is
  port (
	 input, clock: in std_logic;
	 output: out std_logic
  );
end entity;

architecture arch of debouncePulse is
	
	-- sinais do Debounce
	signal flipflops: std_logic_vector(1 downto 0); --entrada flipflops
	signal counter_set: std_logic; --reset
	signal counter_out: integer := 0; --contador de saída
	signal result: std_logic; -- pulso resultado do debounce
begin

-- Botão de debounce

	counter_set <= flipflops(0) xor flipflops(1); --determina start/reset do contador
	
	process(clock)
	variable didSendOutput: boolean := false;
	begin
		if(rising_edge(clock)) then
			flipflops(0) <= input; --not input;
			flipflops(1) <= flipflops(0);
			if (counter_set = '1') then
				counter_out <= 0;
				didSendOutput := false;
			elsif (counter_out < 5000000) then -- tp (tempo de pressionamento) = 100ms
				counter_out <= counter_out + 1;
				output <= '0';
			else
				if flipflops(1) = '0' and not didSendOutput then -- pressionou o botao
					output <= '1';
					didSendOutput := true;
				else 
					output <= '0';
				end if;
			end if;
		end if;
	end process;
	
end architecture;