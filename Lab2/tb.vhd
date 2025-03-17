----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2025 12:15:50
-- Design Name: 
-- Module Name: tb - Behavioral
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

entity tb is
--  Port ( );
end tb;

architecture Behavioral of tb is
    component top
        port(
            clk_i : in STD_LOGIC;
            rst_i : in STD_LOGIC;
            led_o : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;
    
    signal clk_i : STD_LOGIC := '0';
    signal rst_i : STD_LOGIC := '1';
    signal led_o : STD_LOGIC_VECTOR (2 downto 0);

    constant CLK_PERIOD : time := 10 ns;
begin
    uut: top port map (
        clk_i => clk_i,
        rst_i => rst_i,
        led_o => led_o
    );


    clk_process: process
    begin
        while now < 300 ns loop
            clk_i <= '0';
            wait for CLK_PERIOD / 2;
            clk_i <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process clk_process;

    stim_process: process
    begin
        rst_i <= '1';
        wait for 2 * CLK_PERIOD;
        rst_i <= '0';

        wait for 40 ns;

        rst_i <= '1';
        wait for 2 * CLK_PERIOD;
        rst_i <= '0';

        wait for 100 ns;

        wait;
    end process stim_process;

end Behavioral;
