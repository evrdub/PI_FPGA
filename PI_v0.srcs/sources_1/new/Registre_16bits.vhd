library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Registre_16bits is
    Generic(NbBits   : integer);
    Port (  data_in  : in  std_logic_vector ((NbBits-1) downto 0);
            clk      : in  std_logic;
            rst      : in  std_logic;
            load     : in  std_logic;
            data_out : out  std_logic_vector ((NbBits-1) downto 0)
            );
end Registre_16bits;

architecture Behavioral of Registre_16bits is

signal temp : std_logic_vector ((NbBits-1) downto 0);

begin

process(clk,rst)
   begin
	if rst='1' then
      temp <= (others => '0');
	elsif (clk'event and clk='1') then
	 if load ='1' then
		  temp <= data_in;
	 else 
		  temp <= temp;
     end if;
	end if;
end Process;

data_out <= temp;

end Behavioral;
