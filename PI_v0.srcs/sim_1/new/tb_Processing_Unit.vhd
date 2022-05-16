library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Processing_Unit is
Generic ( NbBits    : integer := 16;
	      length    : integer := 13);
    
end tb_Processing_Unit;

architecture Behavioral of tb_Processing_Unit is

component Processing_Unit is
    Generic ( NbBits    : integer;
			  length    : integer);
    Port(   clk         : in std_logic;
            rst         : in std_logic;
            carry_in    : in std_logic_vector((NbBits-1) downto 0);
            value_in    : in std_logic_vector((NbBits-1) downto 0);
            start_UT    : in std_logic;
            
            done_UT     : out std_logic;
            carry_out   : out std_logic_vector((NbBits-1) downto 0);
            value_out   : out std_logic_vector((NbBits-1) downto 0);
            save_val_ram: out std_logic 
            );
end component;

signal s_rst         : std_logic;
signal s_clk         : std_logic;
signal s_carry_in    : std_logic_vector((NbBits-1) downto 0);
signal s_value_in    : std_logic_vector((NbBits-1) downto 0);
signal s_length      : std_logic_vector((NbBits-1) downto 0):= std_logic_vector(to_unsigned(13,NbBits));
signal s_start_UT    : std_logic;

signal s_done_UT     : std_logic;
signal s_carry_out   : std_logic_vector((NbBits-1) downto 0);
signal s_value_out   : std_logic_vector((NbBits-1) downto 0);
signal s_save_val_ram : std_logic;

constant clock_period: time := 10 ns;
signal stop_the_clock: boolean := false;		

begin

uut : Processing_Unit
Generic map(NbBits      => NbBits,
            length      => length)
Port map(   clk         => s_clk,
            rst         => s_rst,
            carry_in    => s_carry_in,
            value_in    => s_value_in,
            start_UT    => s_start_UT,
            done_UT     => s_done_UT,
            carry_out   => s_carry_out,
            value_out   => s_value_out,
            save_val_ram => s_save_val_ram
            );

clocking: process
begin
    while not stop_the_clock loop
        s_CLK <= '0', '1' after clock_period / 2;
        wait for clock_period;
        end loop;
        wait;
end process;

s_value_in <= std_logic_vector(to_unsigned(20, s_value_in'length));
s_start_UT <=  '0', '1' after 20ns, '0' after 40ns;
s_RST  <= '1','0' after 15ns;

end Behavioral;
