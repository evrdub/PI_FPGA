library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_UT is
    Generic ( length    : integer);
    Port ( clk          : in std_logic;
           rst          : in std_logic;
           done_div     : in std_logic;
           start_UT     : in std_logic;
           start_div    : out std_logic;
           digit_calc   : out std_logic;
           load_reg     : out std_logic;
           enable_D     : out std_logic;
           enable_U     : out std_logic;
           save_val_ram : out std_logic;
           done_UT      : out std_logic;
           load_R_carry : out std_logic;
           conf_first_l: out std_logic     -- afin de switcher le mux envoyant add_out ou value_in (premier calcul de la ligne)
           );
end FSM_UT;

architecture Behavioral of FSM_UT is

type STATE_TYPE is (INIT, LRC, TEMPO_PC, TEMPO_RAM, LOAD, EU, ST_DIV, DIV, ED_SVR, LRC2, TEMPO_PC2, TEMPO_RAM2, LR_10, ST2, DIV2, SAVELAST, STOP);
signal current_state : STATE_TYPE;
signal next_state : STATE_TYPE;

signal iterations : integer:=0;

begin

process(CLK,RST,next_state)
    begin
        if (CLK'EVENT AND CLK = '1') then
            if RST = '1' then
                iterations <= 0;
            else
                case next_state is
                    when INIT       => iterations <= 0;
                    when ST_DIV     => iterations <= iterations +1;
                    when others     => iterations <= iterations;
                end case;
            end if;
         end if;
    end process;

process (CLK, next_state)
    begin
        if (CLK'EVENT AND CLK = '1') then
            if RST = '1' then
                current_state <= INIT;
            else
                current_state <= next_state;
            end if;
         end if;
    end process;

process (current_state, start_UT, done_div)
    begin
        case current_state is 
            when INIT       => if(start_UT = '1') then
                                    next_state <= LRC;
                               end if;
            when LRC        => next_state <= TEMPO_PC;
            when TEMPO_PC   => next_state <= TEMPO_RAM;
            when TEMPO_RAM  => next_state <= LOAD;
            when LOAD       => next_state <= EU;
            when EU         => next_state <= ST_DIV;
            when ST_DIV     => next_state <= DIV;
            when DIV        => if( done_div='1' )then
                                    next_state <= ED_SVR;
                               end if;
            when ED_SVR        => if(iterations<length-1) then
                                    next_state <= LRC;
                               else
                                    next_state <= LRC2;
                               end if;
            when LRC2       => next_state <= TEMPO_PC2;
            when TEMPO_PC2  => next_state <= TEMPO_RAM2;
            when TEMPO_RAM2 => next_state <= LR_10;
            when LR_10      => next_state <= ST2;
            when ST2        => next_state <= DIV2;
            when DIV2       => if(done_div='1')then
                                    next_state <= SAVELAST;
                               end if;
            when SAVELAST   => next_state <= STOP;
            when STOP       => next_state <= INIT;
            when others     => next_state <= INIT;
        end case;
   end process;

process (current_state)
    begin
        case current_state is
            when INIT       =>  start_div       <= '0';
                                digit_calc      <= '0';
                                load_reg        <= '0';
                                enable_D        <= '0';
                                enable_U        <= '0';
                                --done_UT         <= '0';
                                save_val_ram    <= '0';
                                conf_first_l    <= '1';
                                load_R_carry    <= '0';
            
            when LRC        =>  start_div       <= '0';
                                digit_calc      <= '0';
                                load_reg        <= '0';
                                enable_D        <= '0';
                                enable_U        <= '0';
                                --done_UT         <= '0';
                                save_val_ram    <= '0';
                                --conf_first_l    <= '1';     -- non défini, donc 1 au début puis 0 par la suite
                                load_R_carry    <= '1';
            
            when TEMPO_PC    => start_div       <= '0';
                                digit_calc      <= '0';
                                load_reg        <= '0';
                                enable_D        <= '0';
                                enable_U        <= '0';
                                --done_UT         <= '0';
                                save_val_ram    <= '0';
                                --conf_first_l    <= '1';
                                load_R_carry    <= '0';
            
            when TEMPO_RAM   => start_div       <= '0';
                                digit_calc      <= '0';
                                load_reg        <= '0';
                                enable_D        <= '0';
                                enable_U        <= '0';
                                --done_UT         <= '0';
                                save_val_ram    <= '0';
                                --conf_first_l    <= '1';
                                load_R_carry    <= '0';
            
            when LOAD       =>  start_div       <= '0';
                                digit_calc      <= '0';
                                load_reg        <= '1';
                                enable_D        <= '0';
                                enable_U        <= '0';
                                --done_UT         <= '0';
                                save_val_ram    <= '0';
                                --conf_first_l    <= '1';
                                load_R_carry    <= '0';
                                
            when EU         =>  start_div       <= '0';
                                digit_calc      <= '0';
                                load_reg        <= '0';
                                enable_D        <= '0';
                                enable_U        <= '1';
                                done_UT         <= '0';
                                save_val_ram    <= '0';
                                conf_first_l    <= '0';
                                load_R_carry    <= '0';
            
            when ST_DIV     =>  start_div       <= '1';
                                digit_calc      <= '0';
                                load_reg        <= '0';
                                enable_D        <= '0';
                                enable_U        <= '0';
                                done_UT         <= '0';
                                save_val_ram    <= '0';
                                conf_first_l    <= '0';
                                load_R_carry    <= '0';
            
            when DIV        =>  start_div       <= '0';
                                digit_calc      <= '0';
                                load_reg        <= '0';
                                enable_D        <= '0';
                                enable_U        <= '0';
                                done_UT         <= '0';
                                save_val_ram    <= '0';
                                conf_first_l    <= '0';
                                load_R_carry    <= '0';
            
            when ED_SVR     =>  start_div       <= '0';
                                digit_calc      <= '0';
                                load_reg        <= '0';
                                enable_D        <= '1';
                                enable_U        <= '0';
                                done_UT         <= '0';
                                save_val_ram    <= '1';
                                conf_first_l    <= '0';
                                load_R_carry    <= '0';
            
            when LRC2       =>  start_div       <= '0';
                                digit_calc      <= '0';
                                load_reg        <= '0';
                                enable_D        <= '0';
                                enable_U        <= '0';
                                done_UT         <= '0';
                                save_val_ram    <= '0';
                                conf_first_l    <= '0';
                                load_R_carry    <= '1';
            
            when TEMPO_PC2   => start_div       <= '0';
                                digit_calc      <= '0';
                                load_reg        <= '0';
                                enable_D        <= '0';
                                enable_U        <= '0';
                                done_UT         <= '0';
                                save_val_ram    <= '0';
                                conf_first_l    <= '0';
                                load_R_carry    <= '0';
            
            when TEMPO_RAM2  => start_div       <= '0';
                                digit_calc      <= '0';
                                load_reg        <= '0';
                                enable_D        <= '0';
                                enable_U        <= '0';
                                done_UT         <= '0';
                                save_val_ram    <= '0';
                                conf_first_l    <= '0';
                                load_R_carry    <= '0';
            
            when LR_10      =>  start_div       <= '0';
                                digit_calc      <= '1';
                                load_reg        <= '1';
                                enable_D        <= '0';
                                enable_U        <= '0';
                                done_UT         <= '0';
                                save_val_ram    <= '0';
                                conf_first_l    <= '0';
                                load_R_carry    <= '0';
            
            when ST2        =>  start_div       <= '1';
                                digit_calc      <= '1';
                                load_reg        <= '0';
                                enable_D        <= '0';
                                enable_U        <= '0';
                                done_UT         <= '0';
                                save_val_ram    <= '0';
                                conf_first_l    <= '0';
                                load_R_carry    <= '0';
            
            when DIV2       =>  start_div       <= '0';
                                digit_calc      <= '1';
                                load_reg        <= '0';
                                enable_D        <= '0';
                                enable_U        <= '0';
                                done_UT         <= '0';
                                save_val_ram    <= '0';
                                conf_first_l    <= '0';
                                load_R_carry    <= '0';
                                
            when SAVELAST   =>  start_div       <= '0';
                                digit_calc      <= '0';
                                load_reg        <= '0';
                                enable_D        <= '0';
                                enable_U        <= '0';
                                done_UT         <= '0';
                                save_val_ram    <= '1';
                                conf_first_l    <= '0';
                                load_R_carry    <= '0';                
                                
            when STOP       =>  start_div       <= '0';
                                digit_calc      <= '0';
                                load_reg        <= '0';
                                enable_D        <= '0';
                                enable_U        <= '0';
                                done_UT         <= '1';
                                save_val_ram    <= '0';
                                conf_first_l    <= '0';
                                load_R_carry    <= '0';
       end case;
   end process;

end Behavioral;
