----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2025 18:32:26
-- Design Name: 
-- Module Name: rs232_transmiter - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rs232_transmiter is
Port ( 
        clk_i : in STD_LOGIC;
        TXD_o : out STD_LOGIC := '1';
        char_i : in STD_LOGIC_VECTOR (7 downto 0)
     );
end rs232_transmiter;

architecture Behavioral of rs232_transmiter is
    signal sent_bits_counter: INTEGER := 0;
    signal synchronised_clock_counter: INTEGER := 0;
    signal DIVIDER : INTEGER := 10417;
    signal transmission: STD_LOGIC := '0';
    signal temp_char_in:  STD_LOGIC_VECTOR (7 downto 0);
    signal temp_char_out:  STD_LOGIC_VECTOR (7 downto 0);


begin

    send_bits: process (clk_i)
    begin
    if rising_edge (clk_i) then
        if transmission = '0' then
            temp_char_in <= char_i;
            temp_char_out <= temp_char_in;
            
            if temp_char_out(7) = '0' then
                transmission <= '1';
                sent_bits_counter <= 0;
                synchronised_clock_counter <= 0;
                TXD_o <= '0';
            end if;
        elsif transmission = '1' then
            synchronised_clock_counter <= synchronised_clock_counter + 1;
            if synchronised_clock_counter = DIVIDER then
                sent_bits_counter <= sent_bits_counter + 1;
                if sent_bits_counter = 8 then
                    TXD_o <= '1';
                    transmission <= '0';
                elsif sent_bits_counter <= 7 then
                    TXD_o <= temp_char_out(sent_bits_counter);
                end if;
                
            end if;
        end if;
       
    end if;
    
    end process;


end Behavioral;