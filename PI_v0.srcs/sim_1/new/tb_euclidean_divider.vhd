library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_euclidean_divider is
--  Port ( );
end tb_euclidean_divider;

architecture Behavioral of tb_euclidean_divider is

component euclidean_divider is
    Generic(    NbBits      : integer := 16);
    Port(       rst         : in std_logic;
                clk         : in std_logic;
                data_in1    : in std_logic_vector((NbBits-1) downto 0);
                data_in2    : in std_logic_vector((NbBits-1) downto 0);
                
                start       : in std_logic;
                done        : inout std_logic;
                quotient    : out std_logic_vector((NbBits-1) downto 0);
                remainder   : out std_logic_vector((NbBits-1) downto 0)
                );
end component;

constant NumberBits  : integer := 16; 
signal s_rst         : std_logic;
signal s_clk         : std_logic;
signal s_data_in1    : std_logic_vector((NumberBits-1) downto 0);
signal s_data_in2    : std_logic_vector((NumberBits-1) downto 0);
signal s_start       : std_logic;
signal s_done        : std_logic;
signal s_quotient    : std_logic_vector((NumberBits-1) downto 0);
signal s_remainder   : std_logic_vector((NumberBits-1) downto 0);

constant clock_period: time := 10 ns;
signal stop_the_clock: boolean := false;


begin

    uut : euclidean_divider
    Generic map(  NbBits      => NumberBits )
    Port map(     rst         => s_rst,
                  clk         => s_clk,
                  data_in1    => s_data_in1,
                  data_in2    => s_data_in2,
                              
                  start       => s_start,
                  done        => s_done,
                  quotient    => s_quotient,
                  remainder   => s_remainder
                  );

clocking: process
begin
    while not stop_the_clock loop
        s_CLK <= '0', '1' after clock_period / 2;
        wait for clock_period;
        end loop;
        wait;
end process;

s_start <= '0', '1' after 25 ns, '0' after 30 ns, '1' after 65ns, '0' after 70ns;
s_RST  <= '1','0' after 15ns;
s_data_in1 <= std_logic_vector(to_unsigned(2345, s_data_in1'length));
s_data_in2 <= std_logic_vector(to_unsigned(7, s_data_in2'length));

end Behavioral;