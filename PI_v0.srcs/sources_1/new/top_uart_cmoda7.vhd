library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity top_uart_cmoda7 is
    Port ( 
           CLK          : in  STD_LOGIC;
           RESET        : in  STD_LOGIC;
           LED 		    : out STD_LOGIC_VECTOR (1 downto 0);
           UART_TXD_IN  : in  STD_LOGIC;
           UART_RXD_OUT : out STD_LOGIC
	);
end top_uart_cmoda7;

architecture Behavioral of top_uart_cmoda7 is
	SIGNAL   dat  : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');

	SIGNAL   data_from_uart    : STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL   data_from_uart_en : STD_LOGIC;

	SIGNAL   data_to_uart      : STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL   data_to_uart_en   : STD_LOGIC;

	SIGNAL   input_data        : UNSIGNED (15 downto 0) := (others=>'0');
	SIGNAL   output_data       : UNSIGNED (15 downto 0) := (others=>'0');

	SIGNAL   read_uart_data    : STD_LOGIC;
	SIGNAL   uart_is_sending   : STD_LOGIC;

	SIGNAL   RESETN            : STD_LOGIC;
	
	SIGNAL   clk_wiz           : STD_LOGIC;

	SIGNAL   fifo_full         : STD_LOGIC;
	SIGNAL   fifo_full_n       : STD_LOGIC;
	
    SIGNAL   digit_out         : STD_LOGIC_VECTOR((16-1) downto 0);     -- Replace 16 by the NbBits
    SIGNAL   X40               : STD_LOGIC_VECTOR(7 downto 0) := x"30";
    
    attribute mark_debug : string;
    attribute keep       : string;

    attribute mark_debug of data_from_uart    : signal is "true";
    attribute mark_debug of data_from_uart_en : signal is "true";
    attribute mark_debug of data_to_uart      : signal is "true";
    attribute mark_debug of data_to_uart_en   : signal is "true";
    attribute mark_debug of input_data        : signal is "true";
    attribute mark_debug of output_data       : signal is "true";
    attribute mark_debug of fifo_full         : signal is "true";
    attribute mark_debug of fifo_full_n       : signal is "true";

BEGIN

    CLOCK_WIZ : ENTITY work.clk_wiz_0
    PORT MAP(
    
        clk_in1  => CLK,
        clk_out1 => clk_wiz
    );

    PROCESS(clk_wiz)
    BEGIN
        IF clk_wiz'event AND clk_wiz = '1' THEN
            RESETN <= NOT RESET;
        END IF;
    END PROCESS;


	----------------------------------------------------------
	------                LED Control                  -------
	----------------------------------------------------------


    PROCESS(clk_wiz)
    BEGIN
        IF clk_wiz'event AND clk_wiz = '1' THEN
            IF RESET = '1' THEN
                input_data <= (others=>'0');
            ELSIF data_from_uart_en = '1' THEN
                input_data <= input_data + TO_UNSIGNED(1, 1);
            END IF;
        END IF;
    END PROCESS;


	----------------------------------------------------------
	------                LED Control                  -------
	----------------------------------------------------------


    PROCESS(clk_wiz)
    BEGIN
        IF clk_wiz'event AND clk_wiz = '1' THEN
            IF RESET = '1' THEN
                output_data <= (others=>'0');
            ELSIF data_to_uart_en = '1' THEN
                output_data <= output_data + TO_UNSIGNED(1, 1);
            END IF;
        END IF;
    END PROCESS;


	----------------------------------------------------------
	------                LED Control                  -------
	----------------------------------------------------------


    rcv : ENTITY work.UART_recv
    PORT MAP(
        RESET  => RESET,
          clk  => clk_wiz,
           rx  => UART_TXD_IN,
          dat  => data_from_uart,
       dat_en  => data_from_uart_en
    );


	----------------------------------------------------------
	------                LED Control                  -------
	----------------------------------------------------------


--    PROCESSING : ENTITY work.kernel_4_hls_0
--    PORT MAP(
    
--        ap_clk            => clk_wiz,
--        ap_rst_n          => RESETN,

--        strm_in_TDATA   => data_from_uart,
--        strm_in_TVALID  => data_from_uart_en,

--        strm_out_TDATA  => data_to_uart,
--        strm_out_TREADY => fifo_full_n,
--        strm_out_TVALID => data_to_uart_en
--    );
    
    
    
    PROCESSING : ENTITY work.Toplevel
    Generic map( NbBits        => 16,
			     NbBitsAdr     => 16,
			     length        => 10*128/3,
			     digits_max    => 128)
    Port map(    clk          => clk_wiz,
                 rst          => RESET,
                 UART_check   => fifo_full_n,
                 digit        => digit_out,
                 enable_UART  => data_to_uart_en);
    
    
    data_to_uart <= std_logic_vector( unsigned(digit_out(7 downto 0))+unsigned(X40) );
    
	----------------------------------------------------------
	------                LED Control                  -------
	----------------------------------------------------------    
    
    LED <= "00" WHEN RESET = '0' ELSE (OTHERS => '1');


	----------------------------------------------------------
	------                LED Control                  -------
	----------------------------------------------------------


	snd : ENTITY work.UART_fifoed_send
	PORT MAP(
		RESET   => RESET,
   clk_100MHz   => clk_wiz,
     fifo_empty => uart_is_sending,
     fifo_afull => OPEN,
     fifo_full  => fifo_full,
         tx     => UART_RXD_OUT,
        dat     => data_to_uart,
     dat_ena    => data_to_uart_en);

    fifo_full_n <= not fifo_full;

end Behavioral;