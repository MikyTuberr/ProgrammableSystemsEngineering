----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2025 10:40:34 AM
-- Design Name: 
-- Module Name: encoder_and_memory - Behavioral
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

entity encoder_and_memory is
    Port ( 
        clk_i : in STD_LOGIC;
        btn_i : in STD_LOGIC_VECTOR (3 downto 0);
        sw_i : in STD_LOGIC_VECTOR (7 downto 0);
        digit_i: out STD_LOGIC_VECTOR (31 downto 0)
     );
end encoder_and_memory;

architecture Behavioral of encoder_and_memory is
    signal rst_i: STD_LOGIC := '0';
function digit_to_segment(input : in STD_LOGIC_VECTOR(3 downto 0)) return STD_LOGIC_VECTOR is
    begin
        case input is
            when "0000" => return "0000001"; -- Digit 0
            when "0001" => return "1001111"; -- Digit 1
            when "0010" => return "0010010"; -- Digit 2
            when "0011" => return "0000110"; -- Digit 3
            when "0100" => return "1001100"; -- Digit 4
            when "0101" => return "0100100"; -- Digit 5
            when "0110" => return "0100000"; -- Digit 6
            when "0111" => return "0001111"; -- Digit 7
            when "1000" => return "0000000"; -- Digit 8
            when "1001" => return "0000100"; -- Digit 9
            when "1010" => return "0001000"; -- Letter A
            when "1011" => return "1100000"; -- Letter B
            when "1100" => return "0110001"; -- Letter C
            when "1101" => return "1000010"; -- Letter D
            when "1110" => return "0110000"; -- Letter E
            when "1111" => return "0111000"; -- Letter F
            when others => return "1111111";
        end case;
    end function;

begin

drff: process (clk_i, rst_i) is
begin
  if rst_i = '1' then
    digit_i <= (others => '0');
  elsif rising_edge(clk_i) then
    if btn_i(3) = '1' then
        digit_i(31 downto 25) <= digit_to_segment(sw_i(3 downto 0));
        
    elsif btn_i(2) = '1' then
        digit_i(23 downto 17) <= digit_to_segment(sw_i(3 downto 0));
        
    elsif btn_i(1) = '1' then
        digit_i(15 downto 9) <= digit_to_segment(sw_i(3 downto 0));
        
    elsif btn_i(0) = '1' then
        digit_i(7 downto 1) <= digit_to_segment(sw_i(3 downto 0));
        
    end if;
    digit_i(24) <= not sw_i(7);
    digit_i(16) <= not sw_i(6);
    digit_i(8) <= not sw_i(5);
    digit_i(0) <= not sw_i(4);
  end if;
end process drff;


end Behavioral;
