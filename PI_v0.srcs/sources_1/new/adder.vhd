library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder is
    Generic( NbBits   : integer);
    Port(    data_in1 : in std_logic_vector((NbBits-1) downto 0);
             data_in2 : in std_logic_vector((NbBits-1) downto 0);
             data_out : out std_logic_vector((NbBits-1) downto 0)
             );
end adder;

architecture Behavioral of adder is

begin

data_out <= std_logic_vector(to_unsigned(to_integer(unsigned(data_in1)) + to_integer(unsigned(data_in2)),NbBits));
    
end Behavioral;
