----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:49:10 02/15/2011 
-- Design Name: 
-- Module Name:    Counter_Prog - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity Counter_Prog is
    Generic(NbBitsAdr: integer;
            length   : integer);
    Port  ( clk       : in  std_logic;
            rst       : in  std_logic;
            enable    : in  std_logic;
            reset_pc  : in  std_logic;
            data_out  : out  std_logic_vector ((NbBitsAdr-1) downto 0));
end Counter_Prog;

architecture Behavioral of Counter_Prog is

signal temp : unsigned((NbBitsAdr-1) downto 0);

begin

Process(clk,rst)
Begin
	if (rst='1' or reset_pc='1') then
      temp <= to_unsigned(0,temp'length);
	elsif (clk'event and clk='1') then
       if (enable ='1' and temp+1<length) then
          temp <= temp + 1;
       else 
          temp <= temp; 
       end if;
    end if;
	
 end process;

data_out <= std_logic_vector(temp);

end Behavioral;

