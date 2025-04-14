library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;

entity rs232_receiver is
    Port ( 
        clk_i : in STD_LOGIC;
        rst_i : in STD_LOGIC;
        RXD_i : in STD_LOGIC;
        digit_i: out STD_LOGIC_VECTOR (15 downto 0)
     );
end rs232_receiver;

architecture Behavioral of rs232_receiver is
    signal counter : INTEGER := 0;
    signal prev_clk : STD_LOGIC := '0';
    signal DIVIDER : INTEGER := 10417;
    signal synchronized_clock : STD_LOGIC := '0';
    signal reading_input: STD_LOGIC := '0';
    signal read_bits_counter: INTEGER := 0;
    signal recieved_bits: STD_LOGIC_VECTOR (7 downto 0);
    signal transmission: STD_LOGIC := '0';
    signal temp_rxd_i_in: STD_LOGIC := '0';
    signal temp_rxd_i_out: STD_LOGIC := '0';
    
    
function digit_to_segment(input : in STD_LOGIC_VECTOR(3 downto 0)) return STD_LOGIC_VECTOR is
    begin
        case input is
            when "0000" => return "00000011"; -- Digit 0 0x03
            when "0001" => return "10011111"; -- Digit 1 0x9F
            when "0010" => return "00100101"; -- Digit 2 0x25
            when "0011" => return "00001101"; -- Digit 3 0x0D
            when "0100" => return "10011001"; -- Digit 4 0x99
            when "0101" => return "01001001"; -- Digit 5 0x49
            when "0110" => return "01000001"; -- Digit 6 0x41
            when "0111" => return "00011111"; -- Digit 7 0x1f
            when "1000" => return "00000001"; -- Digit 8 0x01
            when "1001" => return "00001001"; -- Digit 9 0x09
            when "1010" => return "00010001"; -- Letter A 0x11
            when "1011" => return "11000001"; -- Letter B 0xC1
            when "1100" => return "01100011"; -- Letter C 0x63
            when "1101" => return "10000101"; -- Letter D 0x85
            when "1110" => return "01100001"; -- Letter E 0x61
            when "1111" => return "01110001"; -- Letter F 0x71
            when others => return "11111111";
        end case;
    end function;

begin

    synchronizer: process (clk_i) 
    begin
        if rising_edge(clk_i) then
            if transmission = '1' then
                counter <= counter + 1;
                if read_bits_counter = 0 then
                    DIVIDER <= 15626;
                else
                    DIVIDER <= 10417;
                end if;
                if counter >= DIVIDER then
                    counter <= 0;
                    synchronized_clock <= '1';
                else
                    synchronized_clock <= '0';
                end if;
            end if;
        end if;
    end process;

-- synchronizacja RXD_i (przerzutnik synchronizuj?cy)
-- próbkowanie do momentu bitu startu
    read_bits: process (clk_i, rst_i)
    begin
        if rst_i = '1' then
            transmission <= '0';
            prev_clk <= '0';
            digit_i(15 downto 0) <= "0000000000000000";
        elsif rising_edge(clk_i) then
            temp_rxd_i_in <= RXD_i;
            temp_rxd_i_out <= temp_rxd_i_in;
            
            if transmission = '0' and temp_rxd_i_out = '0' then
                read_bits_counter <= 0;
                transmission <= '1';
            elsif synchronized_clock = '1' then  
                    read_bits_counter <= read_bits_counter + 1;
                    if read_bits_counter >= 8 then
                        digit_i(7 downto 0) <= digit_to_segment(recieved_bits(3 downto 0));
                        digit_i(15 downto 8) <= digit_to_segment(recieved_bits(7 downto 4));
                        transmission <= '0';
                    else
                        recieved_bits(read_bits_counter) <= temp_rxd_i_out;
                    end if;
               -- end if;
            end if;
            prev_clk <= synchronized_clock;  -- Aktualizacja poprzedniego stanu zegara
        end if;
    end process;     

end Behavioral;