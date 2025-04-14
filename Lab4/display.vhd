----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2025 10:40:34 AM
-- Design Name: 
-- Module Name: display - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;

entity display is
    Port ( 
        clk_i : in STD_LOGIC;
        digit_i : in STD_LOGIC_VECTOR (15 downto 0);
        led7_an_o : out STD_LOGIC_VECTOR (3 downto 0);
        led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
    );
end display;

architecture Behavioral of display is
    signal current_display: STD_LOGIC_VECTOR (1 downto 0);
    signal count: NATURAL := 0;
begin

drff: process (clk_i) is
begin
    if rising_edge(clk_i) then
        count <= count + 1;
        if count = 100000 then
            case current_display is
                when "00" => 
                    led7_an_o <= "1101";
                    led7_seg_o <= digit_i(15 downto 8);
                    current_display <= "01";
                when "01" => 
                    led7_an_o <= "1110"; 
                    led7_seg_o <= digit_i(7 downto 0);
                    current_display <= "00";
                when others =>
                    current_display <= "00";
            end case;
            count <= 0;
        end if;
    end if;
end process drff;

end Behavioral;