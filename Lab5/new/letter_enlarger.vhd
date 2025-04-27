----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2025 22:28:14
-- Design Name: 
-- Module Name: letter_enlarger - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity letter_enlarger is
Port ( 
    clk_i : in STD_LOGIC;
    
    enlarged_char_o : out STD_LOGIC_VECTOR (7 downto 0) := "100000000";
    
    fifo_rd_en : buffer STD_LOGIC := '0';
    fifo_data : in STD_LOGIC_VECTOR (7 downto 0);
    fifo_empty : in STD_LOGIC;
    fifo_full : in STD_LOGIC;
    
    led_o : out STD_LOGIC;
    
    rom_addr_o : out STD_LOGIC_VECTOR (11 downto 0);
    rom_data : in STD_LOGIC_VECTOR (7 downto 0)
    
    );
end letter_enlarger;

architecture Behavioral of letter_enlarger is

    type data_array is array (0 to 18) of std_logic_vector (7 downto 0);
    signal char_array : data_array;
    
    signal array_index : INTEGER := 0;
    signal array_size : INTEGER := 0;
    
    type state_type is (IDLE, WAIT1, READ_FIFO, SENDING_ROM_SIGNAL, WAIT_ROM, SEND_TO_TRANSMITTER);
    signal state : state_type := IDLE;
    
    signal verse_counter : INTEGER := 0;
    signal verse_index : INTEGER := 0;
    
    signal counter : INTEGER := 0;
    signal DIVIDER : INTEGER := 10417;
    signal synchronized_clock : STD_LOGIC := '0';
    
    signal STAR_SIGN : std_logic_vector := x"2a";
    signal SPACE_SIGN : std_logic_vector := x"20";
    signal CR_SIGN : std_logic_vector := x"0D";
    signal LF_SIGN : std_logic_vector := x"0A";

    signal cr_sent : std_logic := '0';
    
begin

    synchronizer: process (clk_i) 
    begin
        if rising_edge(clk_i) then
            counter <= counter + 1;
            if counter >= DIVIDER then
                counter <= 0;
                synchronized_clock <= '1';
            else
                synchronized_clock <= '0';
            end if;
        end if;
    end process;

    fifo_full_led : process (clk_i)
    begin
        if rising_edge (clk_i) then
            if fifo_full = '1' then
                led_o <= '0';
            elsif fifo_full = '0' then
                led_o <= '1';
            end if;
        end if;
    end process;
    
    read_from_fifo : process (clk_i)
        variable temp_result : unsigned(11 downto 0);
    begin
        if rising_edge (clk_i) then
        
        case state is
            when IDLE =>
                if fifo_empty = '0' and array_size <= 18 then
                    fifo_rd_en <= '1';
                    state <= WAIT1;
                end if;
            
            when WAIT1 =>
                state <= READ_FIFO;
            
            when READ_FIFO =>
                if fifo_empty = '1' then
                    fifo_rd_en <= '0';
                    state <= IDLE;
                end if;
            
                char_array(array_index) <= fifo_data;
                array_index <= array_index + 1;
                array_size <= array_size + 1;
                
                if fifo_data = CR_SIGN then
                    fifo_rd_en <= '0';
                    array_index <= 0;
                    state <= SENDING_ROM_SIGNAL;
                elsif array_size = 17 then
                    char_array(18) <= CR_SIGN;
                    fifo_rd_en <= '0';
                    array_index <= 0;
                    state <= SENDING_ROM_SIGNAL;
                end if;
            
            when SENDING_ROM_SIGNAL =>
                
                if char_array(array_index) = CR_SIGN then
                    state <= SEND_TO_TRANSMITTER;
                
                else 
                    rom_addr_o <= char_array(array_index) & std_logic_vector(TO_UNSIGNED(verse_counter, 4));
                    state <= WAIT_ROM;
                end if;
                
            when WAIT_ROM =>
                state <= SEND_TO_TRANSMITTER;
            
            when SEND_TO_TRANSMITTER =>
                if synchronized_clock = '1' then
                    if char_array(array_index) = CR_SIGN then
                        if cr_sent = '0' then
                            enlarged_char_o <= CR_SIGN;
                            cr_sent <= '1';
                        elsif cr_sent = '1' then
                            enlarged_char_o <= LF_SIGN;
                            cr_sent <= '0';
                            -- signalize the end of the letter
                            verse_index <= 8;
                        end if;
                    -- ascii code less than 32
                    elsif char_array(array_index)(7) = '0' and char_array(array_index)(6) = '0' and char_array(array_index)(5) = '0' then
                        if rom_data(verse_index) = '1' then
                            enlarged_char_o <= STAR_SIGN;
                        elsif rom_data(verse_index) = '0' then
                            enlarged_char_o <= SPACE_SIGN;
                        end if;
                        verse_index <= verse_index + 1;
                    else
                        if rom_data(verse_index) = '1' then
                            enlarged_char_o <= char_array(array_index);
                        elsif rom_data(verse_index) = '0' then
                            enlarged_char_o <= SPACE_SIGN;
                        end if;
                        verse_index <= verse_index + 1;
                    
                    end if;
                    
                elsif synchronized_clock = '0' then
                    -- if verse finished load the next letter
                    if verse_index >= 8 then
                        verse_index <= 0;
                        state <= SENDING_ROM_SIGNAL;
                        -- if all letters done go down one verse
                        if array_index = array_size then
                            array_index <= 0;
                            verse_counter <= verse_counter + 1;
                            -- finished all the verses and all the letters
                            if verse_counter >= 15 then
                                array_index <= 0;
                                array_size <= 0;
                                verse_counter <= 0;
                                verse_index <= 0;
                                state <= IDLE;
                            end if;
                        else
                            array_index <= array_index + 1;
                        end if;
                        
                    end if;
                
                end if;
                
            when others =>
                state <= IDLE;
            
            end case;
    
        end if;
    
    end process;

end Behavioral;
