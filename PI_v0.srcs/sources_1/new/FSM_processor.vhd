library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_processor is
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
end FSM_processor;

architecture Behavioral of FSM_processor is

type type_etat is (Init, ResetPC, StartUT, Calc, StoreRam, IncrPC, Uart, Stop);
signal current_state, next_state : type_etat;

signal digits_cmpt : integer:=0;

begin

state_reg : process(clk, rst, current_state)
begin
    if rising_edge(clk) then
        if (rst='1') then
            current_state <= Init;
        else
            if(current_state = ResetPC) then
                digits_cmpt <= digits_cmpt + 1;
            end if;
            current_state <= next_state;
        end if;
    end if;
	
end process;

process (current_state, done_values, save_val_ram, done_ligne, digits_cmpt)
    begin
        case current_state is 
            when Init               =>  if(done_values = '1') then
                                            next_state <= ResetPC;
                                        end if;
            when ResetPC            =>  next_state <= StartUT;
            when StartUT            =>  next_state <= Calc;
            when Calc               =>  if(save_val_ram = '1') then
                                            next_state <= StoreRam;
                                        end if;
            when StoreRam           =>  next_state <= IncrPC;
            when IncrPC             =>  if(done_ligne = '1') then
                                            next_state <= Uart;
                                        else
                                            next_state <= Calc;
                                        end if;
            when Uart               =>  if(UART_check = '1') then
                                            if(digits_cmpt = digits_max) then
                                                next_state <= Stop;
                                            else
                                                next_state <= ResetPC;
                                            end if;
                                        else
                                            next_state <= Uart;
                                        end if;
            when Stop               =>  next_state <= Stop;
            when others             =>  next_state <= Init;
        end case;
   end process;

process (current_state)
    begin
        case current_state is
            when Init               =>  start 	        <= '0';
                                        enable_PC       <= '0';
                                        enable_UART     <= '0';
                                        enable_mem      <= '1';
                                        rw              <= '1';
                                        reset_pc        <= '0';
                                        config_ram_in   <= '0';
            
            when ResetPC            =>  start 	        <= '0';
                                        enable_PC       <= '0';
                                        enable_UART     <= '0';
                                        enable_mem      <= '1';
                                        rw              <= '0';
                                        reset_pc        <= '1';
                                        config_ram_in   <= '1';
            
            when StartUT            =>  start 	        <= '1';
                                        enable_PC       <= '0';
                                        enable_UART     <= '0';
                                        enable_mem      <= '0';
                                        rw              <= '0';
                                        reset_pc        <= '0';
                                        config_ram_in   <= '1';
            
            when Calc               =>  start 	        <= '0';
                                        enable_PC       <= '0';
                                        enable_UART     <= '0';
                                        enable_mem      <= '1';
                                        rw              <= '0';
                                        reset_pc        <= '0';
                                        config_ram_in   <= '1';
            
            when StoreRam           =>  start 	        <= '0';
                                        enable_PC       <= '0';
                                        enable_UART     <= '0';
                                        enable_mem      <= '1';
                                        rw              <= '1';
                                        reset_pc        <= '0';
                                        config_ram_in   <= '1';
           
            when IncrPC             =>  start 	        <= '0';
                                        enable_PC       <= '1';
                                        enable_UART     <= '0';
                                        enable_mem      <= '0';
                                        rw              <= '0';
                                        reset_pc        <= '0';
                                        config_ram_in   <= '1';
            
            when Uart               =>  start 	        <= '0';
                                        enable_PC       <= '0';
                                        enable_UART     <= '1';
                                        enable_mem      <= '0';
                                        rw              <= '0';
                                        reset_pc        <= '0';
                                        config_ram_in   <= '1';
            
            when Stop               =>  start 	        <= '0';
                                        enable_PC       <= '0';
                                        enable_UART     <= '0';
                                        enable_mem      <= '0';
                                        rw              <= '0';
                                        reset_pc        <= '0';
                                        config_ram_in   <= '1';
            
       end case;
   end process;

end Behavioral;

