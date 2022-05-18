library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity euclidean_divider is
    Generic(    NbBits      : integer);
    Port(       rst         : in std_logic;
                clk         : in std_logic;
                data_in1    : in std_logic_vector((NbBits-1) downto 0);
                data_in2    : in std_logic_vector((NbBits-1) downto 0);
                start       : in std_logic;
                done        : inout std_logic;
                quotient    : out std_logic_vector((NbBits-1) downto 0);
                remainder   : out std_logic_vector((NbBits-1) downto 0)
                );
end euclidean_divider;

architecture Behavioral of euclidean_divider is

type STATE_TYPE is (INIT, COMP, SET);
signal current_state : STATE_TYPE;
signal next_state : STATE_TYPE;

signal quotient_temp    : integer;
signal remainder_temp   : integer;

signal intdata_in1      : integer;
signal intdata_in2      : integer;

begin

intdata_in1 <= to_integer(unsigned(data_in1));
intdata_in2 <= to_integer(unsigned(data_in2));

process (CLK)
    begin
        if (CLK'EVENT AND CLK = '1') then
            if RST = '1' then
                current_state <= INIT;
            else
                current_state <= next_state;
            end if;
         end if;
    end process;

process (current_state, start, remainder_temp, intdata_in2, done)
    begin
        case current_state is 
            when INIT   => if (start = '1') then 
                                next_state <= SET;
                           end if;
            when SET    => next_state <= COMP;
            when COMP   => if( done = '0' ) then
                                next_state <= COMP;
                           else
                                next_state <= INIT;
                           end if;
            when others => next_state <= INIT;
        end case;
   end process;

process (current_state, remainder_temp, quotient_temp, intdata_in1, intdata_in2)
    begin
        case current_state is
            when INIT   => done            <= '0';
            when SET    => quotient_temp   <= 0;
                           remainder_temp  <= intdata_in1;
                           done            <= '0';
            when COMP   => if( remainder_temp >= intdata_in2 ) then
                                remainder_temp <= remainder_temp - intdata_in2;
                                quotient_temp  <= quotient_temp + 1;
                                done <= '0';
                           else
                                done <= '1';
                           end if;
       end case;
   end process;

remainder <= std_logic_vector(to_unsigned(remainder_temp,remainder'length));
quotient  <= std_logic_vector(to_unsigned(quotient_temp,quotient'length));

end Behavioral;
