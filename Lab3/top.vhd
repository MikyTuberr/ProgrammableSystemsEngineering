----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2025 10:40:34 AM
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port (
        clk_i : in STD_LOGIC;    
        btn_i : in STD_LOGIC_VECTOR (3 downto 0);
        sw_i : in STD_LOGIC_VECTOR (7 downto 0); 
        led7_an_o : out STD_LOGIC_VECTOR (3 downto 0);
        led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
    );
end top;

architecture Behavioral of top is
    signal digit_bus : STD_LOGIC_VECTOR (31 downto 0); 

begin

    encoder_inst : entity work.encoder_and_memory
        port map (
            clk_i => clk_i,     
            btn_i => btn_i,     
            sw_i => sw_i,       
            digit_i => digit_bus 
        );

    display_inst : entity work.display
        port map (
            clk_i => clk_i,     
            digit_i => digit_bus,
            led7_an_o => led7_an_o,
            led7_seg_o => led7_seg_o
        );

end Behavioral;
