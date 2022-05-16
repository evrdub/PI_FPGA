library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multi is
    Generic (   NbBits : integer);
    Port    (   data_in1 : in STD_LOGIC_VECTOR((NbBits-1) downto 0);
                data_in2 : in STD_LOGIC_VECTOR((NbBits-1) downto 0);
                result   : out STD_LOGIC_VECTOR((NbBits-1) downto 0)
                );
end multi;

architecture Behavioral of multi is

signal calcul : integer:=0;

begin
    process (data_in1, data_in2)
    begin
    calcul <= to_integer(unsigned(data_in1)) * to_integer(unsigned(data_in2));
end process;

result <= std_logic_vector(to_unsigned(calcul,result'length));

end behavioral;
