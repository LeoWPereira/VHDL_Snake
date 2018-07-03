LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY sync_mod IS
	PORT (
		clk : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		start : IN STD_LOGIC;
		y_control : OUT INTEGER range 0 to 900;
		x_control : OUT INTEGER range 0 to 900;
		h_s : OUT STD_LOGIC;
		v_s : OUT STD_LOGIC;
		video_on : OUT STD_LOGIC
	);
END sync_mod;

ARCHITECTURE Behavioral OF sync_mod IS
	-- Video Parameters
	CONSTANT HR : INTEGER := 640;--Horizontal Resolution
	CONSTANT HFP : INTEGER := 16;--Horizontal Front Porch
	CONSTANT HBP : INTEGER := 48;--Horizontal Back Porch
	CONSTANT HRet : INTEGER := 96;--Horizontal retrace
	CONSTANT VR : INTEGER := 480;--Vertical Resolution
	CONSTANT VFP : INTEGER := 10;--Vertical Front Porch
	CONSTANT VBP : INTEGER := 33;--Vertical Back Porch
	CONSTANT VRet : INTEGER := 2;--Vertical Retrace
	--sync counter
	SIGNAL counter_h, counter_h_next : INTEGER RANGE 0 TO 799;
	SIGNAL counter_v, counter_v_next : INTEGER RANGE 0 TO 524;
	--mod 2 counter
	SIGNAL counter_mod2, counter_mod2_next : std_logic := '0';
	--State signals
	SIGNAL h_end, v_end : std_logic := '0';
	--Output Signals(buffer)
	SIGNAL hs_buffer, hs_buffer_next : std_logic := '0';
	SIGNAL vs_buffer, vs_buffer_next : std_logic := '0';
	--pixel cunter
	SIGNAL x_counter, x_counter_next : INTEGER RANGE 0 TO 900;
	SIGNAL y_counter, y_counter_next : INTEGER RANGE 0 TO 900;
	--video_on_of
	SIGNAL video : std_logic;
BEGIN
	--clk register
	PROCESS (clk, reset, start)
	BEGIN
		IF reset = '1' THEN
			counter_h <= 0;
			counter_v <= 0;
			hs_buffer <= '0';
			hs_buffer <= '0';
			counter_mod2 <= '0';
		ELSIF clk'EVENT AND clk = '1' THEN
			IF start = '1' THEN
				counter_h <= counter_h_next;
				counter_v <= counter_v_next;
				x_counter <= x_counter_next;
				y_counter <= y_counter_next;
				hs_buffer <= hs_buffer_next;
				vs_buffer <= vs_buffer_next;
				counter_mod2 <= counter_mod2_next;
			END IF;
		END IF;
	END PROCESS;
	--video on/off
	video <= '1' WHEN (counter_v >= VBP) AND (counter_v < VBP + VR) AND (counter_h >= HBP) AND (counter_h < HBP + HR)ELSE
	         '0';

	--mod 2 counter
	counter_mod2_next <= NOT counter_mod2;
	--end of Horizontal scanning 
	h_end <= '1' WHEN counter_h = 799 ELSE
	         '0'; 
	-- end of Vertical scanning
	v_end <= '1' WHEN counter_v = 524 ELSE
	         '0'; 
	-- Horizontal Counter
	PROCESS (counter_h, counter_mod2, h_end)
	BEGIN
		counter_h_next <= counter_h;
		IF counter_mod2 = '1' THEN
			IF h_end = '1' THEN
				counter_h_next <= 0;
			ELSE
				counter_h_next <= counter_h + 1;
			END IF;
		END IF;
	END PROCESS;

	-- Vertical Counter
	PROCESS (counter_v, counter_mod2, h_end, v_end)
	BEGIN
		counter_v_next <= counter_v;
		IF counter_mod2 = '1' AND h_end = '1' THEN
			IF v_end = '1' THEN
				counter_v_next <= 0;
			ELSE
				counter_v_next <= counter_v + 1;
			END IF;
		END IF;
	END PROCESS;

			--pixel x counter
	PROCESS (x_counter, counter_mod2, h_end, video)
	BEGIN
		x_counter_next <= x_counter;
		IF video = '1' THEN
			IF counter_mod2 = '1' THEN 
				IF x_counter = 639 THEN
					x_counter_next <= 0;
				ELSE
					x_counter_next <= x_counter + 1;
				END IF;
			END IF;
		ELSE
			x_counter_next <= 0;
		END IF;
	END PROCESS;

				--pixsel y counter
	PROCESS (y_counter, counter_mod2, h_end, counter_v)
	BEGIN
		y_counter_next <= y_counter;
		IF counter_mod2 = '1' AND h_end = '1' THEN
			IF counter_v > 32 AND counter_v < 512 THEN
				y_counter_next <= y_counter + 1;
			ELSE
				y_counter_next <= 0; 
			END IF;
		END IF;
	END PROCESS;

	--buffer
	hs_buffer_next <= '1' WHEN counter_h < 704 ELSE--(HBP+HGO+HFP)
							'0';
	vs_buffer_next <= '1' WHEN counter_v < 523 ELSE--(VBP+VGO+VFP)
							'0'; 
	--outputs
	y_control <= y_counter;
	x_control <= x_counter;
	h_s <= hs_buffer;
	v_s <= vs_buffer;
	video_on <= video;

END Behavioral;