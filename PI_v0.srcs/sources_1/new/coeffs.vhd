library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity coeffs is
    Generic ( NbBits        : integer;
			  length        : integer);
    Port( clk               : in std_logic;
          rst               : in std_logic;
          enableD           : in std_logic;
          enableU           : in std_logic;
          U                 : out std_logic_vector((NbBits-1) downto 0);
          D                 : out std_logic_vector((NbBits-1) downto 0)
          );
end coeffs;

architecture Behavioral of coeffs is

signal U_int        : integer;
signal D_int        : integer;

begin

process(clk, rst)
    begin
    if (rst = '1') then
        U_int   <= length;
        D_int   <= 2*length-1;
    elsif (CLK'event and CLK = '1') then
        if (U_int-1 >= 0) then
            if (enableU = '1') then
                U_int   <= U_int-1;
            end if;
            if (enableD = '1') then
                D_int   <= D_int-2;
            end if;
        else
            U_int   <= length-1;
            D_int   <= 2*length-1;
        end if;
    end if;
end process;

U <= std_logic_vector(to_unsigned(U_int,U'length));
D <= std_logic_vector(to_unsigned(D_int,D'length));

end Behavioral;
