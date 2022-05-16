library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity init_ram is
    Generic ( NbBits        : integer;
			  NbBitsAdr     : integer;
			  length        : integer);
    Port ( clk              : in STD_LOGIC;
           rst              : in STD_LOGIC;
           done_values      : inout STD_LOGIC;
           adresse          : out STD_LOGIC_VECTOR ((NbBitsAdr-1) downto 0);
           donnee           : out STD_LOGIC_VECTOR ((NbBits-1) downto 0));
end init_ram;

architecture Behavioral of init_ram is

signal done_after   : std_logic;
signal adr          : integer := 0;
signal data_out     : integer;

begin

process (clk, rst)
begin
    if rising_edge(clk) then
        if rst = '1' then
            adr         <= 0;
            done_values <= '0';
            done_after  <= '0';
        else
            if( done_values = '0') then
                if(adr+1<length)then
                    adr         <= adr + 1;
                else
                    done_after  <= '1';
                end if;
            end if;
        end if;    
    end if;
    
    if (done_after = '1') then
        done_values <= '1';
    end if;
    
end process;

--process(clk, rst)
--begin
--    if (rst = '1') then
--        data_out <= 30;
--    else
--        if rising_edge(clk) then
--            data_out <= data_out - 1;
--        end if;
--    end if;
--end process;

--donnee  <= std_logic_vector(to_unsigned(data_out,donnee'length));

donnee  <= std_logic_vector(to_unsigned(20,donnee'length));

process(adr)
begin
    if(adr<length)then
        adresse <= std_logic_vector(to_unsigned(adr,NbBitsAdr));
    end if;
end process;

end Behavioral;



