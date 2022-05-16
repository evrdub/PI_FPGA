library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Toplevel is
    Generic ( NbBits        : integer := 16;
			  NbBitsAdr     : integer := 8;          -- bits nécéssaires pour aller de 0 à length
			  length        : integer := 10*64/3;    -- 10 * digits / 3                          
			  digits_max    : integer := 64);
    Port ( clk          : in  std_logic;
           rst          : in  std_logic;
           UART_check   : in  std_logic;
           digit        : out std_logic_vector ((Nbbits-1) downto 0);
           enable_UART  : out std_logic);
end Toplevel;

architecture Behavioral of Toplevel is

component RAM_SP_64_8 is
    Generic ( NbBits        : integer;
			  NbBitsAdr     : integer;
			  length        : integer);
    Port ( ADD              : in  STD_LOGIC_VECTOR ((NbBitsAdr-1) downto 0);
           DATA_IN          : in  STD_LOGIC_VECTOR ((NbBits-1) downto 0);
           R_W              : in  STD_LOGIC;
           ENABLE           : in  STD_LOGIC;
           clk              : in  STD_LOGIC;
           DATA_OUT         : out STD_LOGIC_VECTOR ((NbBits-1) downto 0)
          );
end component;

component Control_Unit is
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
end component;

component Registre_16bits is
    Generic(NbBits   : integer);
    Port(   data_in  : in  std_logic_vector ((NbBits-1) downto 0);
            clk      : in  std_logic;
            rst      : in  std_logic;
            load     : in  std_logic;
            data_out : out  std_logic_vector ((NbBits-1) downto 0)
            );
end component;

component Processing_Unit is
    Generic ( NbBits        : integer;
			  length        : integer);
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
 
component init_ram is
    Generic ( NbBits        : integer;
			  NbBitsAdr     : integer;
			  length        : integer);
    Port(   clk             : in STD_LOGIC;
            rst             : in STD_LOGIC;
            done_values     : inout STD_LOGIC;
            adresse         : out STD_LOGIC_VECTOR((NbBitsAdr-1) downto 0);
            donnee          : out STD_LOGIC_VECTOR ((NbBits-1) downto 0));
end component;

-- signaux RAM
signal s_data_in_ram    : std_logic_vector((NbBits-1) downto 0);
signal s_data_out_ram   : std_logic_vector((NbBits-1) downto 0); 
signal s_adr_ram        : std_logic_vector((NbBitsAdr-1)  downto 0); 

-- signaux UC
signal s_enable_mem 	: std_logic;
signal s_rw 		    : std_logic;
signal s_enable_UART    : std_logic;
signal s_adr_PC         : std_logic_vector((NbBitsAdr-1)  downto 0);
signal s_config_ram_in  : std_logic;

-- signaux UT
signal s_carry_in       : std_logic_vector((NbBits-1) downto 0);
signal s_start_UT       : std_logic;

signal s_done_UT        : std_logic;
signal s_carry_out      : std_logic_vector((NbBits-1) downto 0);
signal s_value_out      : std_logic_vector((NbBits-1) downto 0);
signal s_save_val_ram	: std_logic;

-- signaux init_ram
signal s_adresse        : std_logic_vector((NbBitsAdr-1)  downto 0);
signal s_donnee         : std_logic_vector((NbBits-1) downto 0);
signal s_done_values    : std_logic;

begin

s_data_in_ram   <= s_donnee  when s_config_ram_in = '0' else std_logic_vector(to_unsigned(10*to_integer(unsigned(s_carry_out)),s_data_in_ram'length));
s_adr_ram       <= s_adresse when s_config_ram_in = '0' else s_adr_PC;

UC : Control_Unit 
Generic map(NbBitsAdr             => NbBitsAdr,
		    length                => length,
		    digits_max            => digits_max)
Port map(   clk 				  => clk,
            rst 				  => rst,
            UART_check            => UART_check,
	        save_val_ram	      => s_save_val_ram,
	        done_ligne            => s_done_UT,
	        done_values           => s_done_values,
            enable_mem 			  => s_enable_mem,
            config_ram_in         => s_config_ram_in,
		    start 			      => s_start_UT,
            rw 		              => s_rw,
            enable_UART           => s_enable_UART,
		    adr_PC    		      => s_adr_PC
		    );
          
UT : Processing_Unit
Generic map(NbBits                => NbBits,
		    length                => length)
Port map(   clk                   => clk,
            rst                   => rst,
            carry_in              => s_carry_in,
            value_in              => s_data_out_ram,
            start_UT              => s_start_UT,
                                  
            done_UT               => s_done_UT,
            carry_out             => s_carry_out,
            value_out             => s_value_out,
            save_val_ram          => s_save_val_ram
            );
        
UM : RAM_SP_64_8
Generic map(NbBits                => NbBits,
	        NbBitsAdr             => NbBitsAdr,
	        length                => length)
Port map(   ADD                   => s_adr_ram,
            DATA_IN               => s_data_in_ram,
            R_W                   => s_rw,
            ENABLE                => s_enable_mem,
            clk                   => clk,
            DATA_OUT              => s_data_out_ram
            );

Initialisation : init_ram
Generic map(NbBits                => NbBits,
	        NbBitsAdr             => NbBitsAdr,
		    length                => length)
Port map(   clk                   => clk,
            rst                   => rst,
            done_values           => s_done_values,
            adresse               => s_adresse,
            donnee                => s_donnee
            );

end Behavioral;