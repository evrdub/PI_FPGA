library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Control_Unit is
    Generic ( NbBitsAdr          : integer;
			  length             : integer;
			  digits_max         : integer);
    Port ( clk 					 : in  STD_LOGIC;
           rst 					 : in  STD_LOGIC;
           UART_check            : in  STD_LOGIC;
	       save_val_ram			 : in  STD_LOGIC;
	       done_ligne            : in  STD_LOGIC;
	       done_values           : in  STD_LOGIC;
           enable_mem 			 : out STD_LOGIC;
           config_ram_in         : out STD_LOGIC;
		   start 			     : out STD_LOGIC;
           rw 		             : out STD_LOGIC;
           enable_UART           : out STD_LOGIC;   
		   adr_PC    		     : out STD_LOGIC_VECTOR((NbBitsAdr-1) downto 0)
		   );
end Control_Unit;

architecture Behavioral of Control_Unit is

component FSM_processor is
    Generic(digits_max   : integer);
    Port ( clk 			 : in  std_logic;
           rst 			 : in  std_logic;
           save_val_ram  : in  std_logic; -- signal pour store la carry de sortie dans la RAM
           done_ligne    : in  std_logic; -- signal pour fin de ligne   
           UART_check    : in  std_logic; -- signal pour s'assurer que l'UART a bien pris la valeur
           done_values   : in  std_logic; -- signal pour fin d'initialisation de la ram
           
           start 	     : out std_logic; -- signaux pour Processing Unit
           enable_PC     : out std_logic;
           enable_UART   : out std_logic;
           config_ram_in : out std_logic;           
           
           enable_mem    : out std_logic; -- signaux pour la RAM
           rw            : out std_logic;
           
           reset_pc      : out std_logic); --signal pour le reset du PC           
end component;

component Counter_Prog
    Generic(NbBitsAdr: integer;
            length   : integer);
    Port (  clk      : in  std_logic;
            rst      : in  std_logic;
            enable   : in  std_logic;
            data_out : out std_logic_vector((NbBitsAdr-1) downto 0);
            reset_pc : in  std_logic);
end component;

signal s_enable_PC      : std_logic;
signal s_reset_PC       : std_logic;

begin

Fsm : FSM_processor
Generic map(digits_max     => digits_max)
Port map (  clk 	       =>  clk,
            rst 	       =>  rst,
            save_val_ram   =>  save_val_ram,
            done_ligne     =>  done_ligne,
            UART_check     =>  UART_check,  
            done_values    =>  done_values, 
                                       
            start 	       =>  start,
            enable_PC      =>  s_enable_PC,   
            enable_UART    =>  enable_UART,
            config_ram_in  =>  config_ram_in, 
                                       
            enable_mem     =>  enable_mem,  
            rw             =>  rw,          
                        
            reset_pc       =>  s_reset_pc  
            );


PC : Counter_Prog
Generic map(NbBitsAdr   => NbBitsAdr,
            length      => length)
Port map (clk           => clk, 
          rst           => rst,
          enable        => s_enable_PC,
          data_out      => adr_PC,
          reset_pc      => s_reset_PC);
          
end Behavioral;

