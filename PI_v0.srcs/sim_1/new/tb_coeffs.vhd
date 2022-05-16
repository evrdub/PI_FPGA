library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_coeffs is
--  Port ( );
end tb_coeffs;

architecture Behavioral of tb_coeffs is

component coeffs is
    Generic( NbBits        : integer := 16);
    Port( clk       : in std_logic;
          rst       : in std_logic;
          enable    : in std_logic;
          length    : in std_logic_vector((NbBits-1) downto 0);

          U         : out std_logic_vector((NbBits-1) downto 0);
          D         : out std_logic_vector((NbBits-1) downto 0)
          );
end component;

constant NumberBits  : integer := 16; 
signal s_rst         : std_logic;
signal s_clk         : std_logic;
signal s_enable      : std_logic;
signal s_length      : std_logic_vector((NumberBits-1) downto 0);

signal s_U           : std_logic_vector((NumberBits-1) downto 0);
signal s_D           : std_logic_vector((NumberBits-1) downto 0);

constant clock_period: time := 10 ns;
signal stop_the_clock: boolean := false;


begin

    uut : coeffs
    Generic map(  NbBits      => NumberBits )
    Port map(     rst         => s_rst,
                  clk         => s_clk,
                  enable      => s_enable,
                  length      => s_length,
                  U           => s_U,
                  D           => s_D
                  ); 

clocking: process
begin
    while not stop_the_clock loop
        s_clk <= '0', '1' after clock_period / 2;
        wait for clock_period;
        end loop;
        wait;
end process;

s_rst  <= '1','0' after 15ns;
s_enable <= '1';
s_length <= std_logic_vector(to_unsigned(13,s_length'length));

end Behavioral;