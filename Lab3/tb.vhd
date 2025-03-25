----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2025 11:49:23 AM
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

entity tb_top is
    -- No ports as this is a testbench
end tb_top;

architecture Behavioral of tb_top is

    -- Clock period: 10 ns (100 MHz clock)
    constant clk_period : time := 10 ns;

    -- Signals for DUT inputs
    signal clk_i : STD_LOGIC := '0';
    signal btn_i : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal sw_i : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

    -- Signals for DUT outputs
    signal led7_an_o : STD_LOGIC_VECTOR (3 downto 0);
    signal led7_seg_o : STD_LOGIC_VECTOR (7 downto 0);

    -- Device Under Test (DUT) component
    component top
        Port (
            clk_i : in STD_LOGIC;
            btn_i : in STD_LOGIC_VECTOR (3 downto 0);
            sw_i : in STD_LOGIC_VECTOR (7 downto 0);
            led7_an_o : out STD_LOGIC_VECTOR (3 downto 0);
            led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

begin

    dut: top
        port map (
            clk_i => clk_i,
            btn_i => btn_i,
            sw_i => sw_i,
            led7_an_o => led7_an_o,
            led7_seg_o => led7_seg_o
        );

    -- Clock generation
    clk_process: process
    begin
        while true loop
            clk_i <= '0';
            wait for clk_period / 2;
            clk_i <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    stimulus_process: process
    begin
        sw_i <= "11110000";
        wait for 5 ms;

        btn_i(3) <= '1';
        wait for 1 ms;
        btn_i(3) <= '0';
        wait for 2 ms;
        sw_i(3 downto 0) <= "0001";
        wait for 5 ms;

        btn_i(2) <= '1';
        wait for 1 ms;
        btn_i(2) <= '0';
        wait for 2 ms;
        sw_i(3 downto 0) <= "0010";
        wait for 5 ms;

        sw_i(7 downto 4) <= "0011";
        wait for 5 ms;

        btn_i(1) <= '1'; 
        wait for 1 ms;
        btn_i(1) <= '0';
        wait for 2 ms;
        sw_i(3 downto 0) <= "0011"; 
        wait for 5 ms;
        
        btn_i(0) <= '1'; 
        wait for 1 ms;
        btn_i(0) <= '0';
        wait for 2 ms;
        sw_i(3 downto 0) <= "1011"; 
        wait for 5 ms;

        sw_i(7 downto 4) <= "0100"; 
        wait for 10 ms;

        wait for 100 ms;

        wait;
    end process;

end Behavioral;