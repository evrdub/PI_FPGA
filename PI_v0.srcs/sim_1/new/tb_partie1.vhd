library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Toplevel_tb is
Generic( NbBits        : integer := 16;         
	     NbBitsAdr     : integer := 8;        -- bits nécéssaires pour aller de 0 à length
		 length        : integer := 10*10/3;   -- 10 * digits / 3
		 digits_max    : integer := 10);
end;

architecture bench of Toplevel_tb is

component Toplevel
  Generic ( NbBits        : integer;
			NbBitsAdr     : integer;
			length        : integer;
			digits_max    : integer);
  Port(   clk          : in  std_logic;
          rst          : in  std_logic;
          UART_check   : in  std_logic;
          digit        : out std_logic_vector((NbBits-1) downto 0);
          enable_UART  : out std_logic);
end component;

signal clk             : std_logic;
signal rst             : std_logic;
signal UART_check      : std_logic;
signal digit           : std_logic_vector((NbBits-1) downto 0);
signal enable_UART     : std_logic;

constant clock_period: time := 10 ns;
signal stop_the_clock: boolean;

begin

uut: Toplevel 
Generic map( NbBits        => NbBits,
	         NbBitsAdr     => NbBitsAdr,
		     length        => length,
		     digits_max    => digits_max)
port map(    clk         => clk,
             rst         => rst,
             UART_check  => UART_check,
             digit       => digit,
             enable_UART => enable_UART );

--stimulus: process
--begin

--rst <= '0';
--wait for 15 ns;
--rst <= '1';
--wait for 15 ns;
--rst <= '0';
--wait for 60 ns;
--UART_check <= '1';
--wait for 10000 ns;

--end process;

rst         <= '0', '1' after 15 ns, '0' after 30 ns;
UART_check  <= '1';

clocking: process
begin
  while not stop_the_clock loop
    clk <= '0', '1' after clock_period / 2;
    wait for clock_period;
  end loop;
  wait;
end process;

end;




 