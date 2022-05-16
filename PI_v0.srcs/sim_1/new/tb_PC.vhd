-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Counter_Prog_tb is
end;

architecture bench of Counter_Prog_tb is

  component Counter_Prog
      Generic (NbAdr   : integer := 7);
      Port  (clk       : in  std_logic;
             rst       : in  std_logic;
             enable    : in  std_logic;
             reset_pc  : in  std_logic;
             data_out  : out  std_logic_vector (6 downto 0));
  end component;

  signal clk: std_logic;
  signal rst: std_logic;
  signal enable: std_logic;
  signal reset_pc: std_logic;
  signal data_out: std_logic_vector (6 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: Counter_Prog generic map ( NbAdr    => 7 )
                       port map ( clk      => clk,
                                  rst      => rst,
                                  enable   => enable,
                                  reset_pc => reset_pc,
                                  data_out => data_out );

  stimulus: process
  begin
  
    -- Put initialisation code here

    rst <= '1';
    enable <= '0';
    reset_PC <= '0';
    wait for 10 ns;
    rst <= '0';
    wait for 6 ns;
    enable <= '1';
    wait for 7 ns;
    reset_PC <= '1';
    wait for 10 ns;
    reset_PC <= '0';
    wait for 20 ns;
    reset_PC <= '1';
    wait for 5ns;
    reset_PC <= '0';
    -- Put test bench stimulus code here
    wait for 200 ns;
    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
