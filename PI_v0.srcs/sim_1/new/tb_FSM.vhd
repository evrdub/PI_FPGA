library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity FSM_processor_tb is
end;

architecture bench of FSM_processor_tb is

  component FSM_processor
      Port ( clk 		   : in  std_logic;
             rst 		   : in  std_logic;
             done_colonne  : in  std_logic;
             done_ligne    : in  std_logic;
             enable        : in  std_logic;
             jaifini       : in  std_logic;
             start 	       : out std_logic;
             enable_mem    : out std_logic;
             rw            : out std_logic;
             reset_pc      : out std_logic);
  end component;

  signal clk: std_logic;
  signal rst: std_logic;
  signal done_colonne: std_logic;
  signal done_ligne: std_logic;
  signal enable: std_logic;
  signal jaifini: std_logic;
  signal start: std_logic;
  signal enable_mem: std_logic;
  signal rw: std_logic;
  signal reset_pc: std_logic;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: FSM_processor port map ( clk          => clk,
                                rst          => rst,
                                done_colonne => done_colonne,
                                done_ligne   => done_ligne,
                                enable       => enable,
                                jaifini      => jaifini,
                                start        => start,
                                enable_mem   => enable_mem,
                                rw           => rw,
                                reset_pc     => reset_pc );

  stimulus: process
  begin
  
    -- Put initialisation code here
    enable <= '1';
    rst <= '1';
    jaifini <= '0';
    done_colonne <= '0';
    wait for 5 ns;
    rst <= '0';
    wait for 5 ns;
    jaifini <= '1';
    wait for 10 ns ;
    jaifini <= '0';
    wait for 6 ns; 
    done_colonne <= '1';
    wait for 5 ns;
    done_colonne <= '0';
    wait for 10 ns;
    done_colonne <= '1';
    wait for 5 ns;
    done_colonne <= '0';
    wait for 15 ns;
    done_colonne <= '1';
    wait for 6 ns;
    done_colonne <= '0';
    done_ligne <= '1';
    -- Put test bench stimulus code here
    wait for 100 ns;
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