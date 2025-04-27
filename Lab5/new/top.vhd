----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2025 16:01:35
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
     RXD_i : in STD_LOGIC;
     TXD_o : out STD_LOGIC;
     ld0 : out STD_LOGIC;
     led7_an_o : out STD_LOGIC_VECTOR (3 downto 0);
    led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
     );
end top;

architecture Behavioral of top is
    COMPONENT char_mem
      PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) 
      );
    END COMPONENT;
    
    COMPONENT fifo_mem
      PORT (
        clk : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        rd_en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        full : OUT STD_LOGIC;
        empty : OUT STD_LOGIC 
      );
    END COMPONENT;


    signal digit_bus : STD_LOGIC_VECTOR (15 downto 0);
    
    signal input_char_bus : STD_LOGIC_VECTOR (7 downto 0);
    signal output_char_bus : STD_LOGIC_VECTOR (7 downto 0);
    
    signal rom_addr_bus : STD_LOGIC_VECTOR (11 downto 0);
    signal rom_data_bus : STD_LOGIC_VECTOR (7 downto 0);
    
    signal wr_en : STD_LOGIC;
    signal rd_en : STD_LOGIC;
    signal dout : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal full : STD_LOGIC;
    signal empty : STD_LOGIC;
    
begin

    rs232_receiver : entity work.rs232_receiver
        port map (
            clk_i => clk_i,   
            RXD_i => RXD_i,   
            digit_o => digit_bus,
            char_o => input_char_bus,
            wr_en_o => wr_en
        );
        
    rs232_transmiter : entity work.rs232_transmiter
        port map (
            clk_i => clk_i,   
            TXD_o => TXD_o,   
            char_i => output_char_bus
        );

    display_inst : entity work.display
        port map (
            clk_i => clk_i,     
            digit_i => digit_bus,
            led7_an_o => led7_an_o,
            led7_seg_o => led7_seg_o
        );
     
     rom_char_mem : char_mem
      PORT MAP (
        clka => clk_i,
        addra => rom_addr_bus,
        douta => rom_data_bus
      );
      
      fifo_input_mem : fifo_mem
      PORT MAP (
        clk => clk_i,
        din => input_char_bus,
        wr_en => wr_en,
        rd_en => rd_en,
        dout => dout,
        full => full,
        empty => empty
      );
      
      letter_enlarger : entity work.letter_enlarger
        port map (
            clk_i => clk_i,
            enlarged_char_o => output_char_bus,
    
            fifo_rd_en => rd_en,
            fifo_data => dout,
            fifo_empty => empty,
            fifo_full => full,
            
            led_o => ld_0,
            
            rom_addr_o => rom_addr_bus,
            rom_data => rom_data_bus
        );
     

end Behavioral;
