library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;

entity top is
 Port ( 
    clk_i : in STD_LOGIC;
    rst_i : in STD_LOGIC;
    RXD_i : in STD_LOGIC;
    led7_an_o : out STD_LOGIC_VECTOR (3 downto 0);
    led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
 );
end top;

architecture Behavioral of top is
    signal digit_bus : STD_LOGIC_VECTOR (15 downto 0);
begin

    rs232_receiver : entity work.rs232_receiver
        port map (
            clk_i => clk_i,     
            rst_i => rst_i,  
            RXD_i => RXD_i,   
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