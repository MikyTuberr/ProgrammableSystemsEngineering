----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2025 11:47:42
-- Design Name: 
-- Module Name: top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port( 
        clk_i : in STD_LOGIC;
        rst_i : in STD_LOGIC;
        led_o : out STD_LOGIC_VECTOR (2 downto 0)
    );
end top;

architecture Behavioral of top is
signal gray : STD_LOGIC_VECTOR (2 downto 0);
signal count : STD_LOGIC_VECTOR (2 downto 0);
begin

drff: process (clk_i, rst_i) is
begin
  if rst_i = '1' then
    count <= "000";
  elsif rising_edge(clk_i) then
    count <= std_logic_vector(unsigned(count) + 1);
  end if;
end process drff;

gray <= count xor ('0' & count(2 downto 1));

led_o <= gray;

end Behavioral;
