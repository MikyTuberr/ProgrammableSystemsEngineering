library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top is
end tb_top;

architecture Behavioral of tb_top is

    -- Clock and baud rate constants
    constant clk_period : time := 10 ns;    -- 100 MHz
    shared variable bit_period : time := 104.17 us; -- 9600 bps

    -- Signals
    signal clk_i : STD_LOGIC := '0';
    signal RXD_i : STD_LOGIC := '1';  -- Default high (idle state)
    
    signal TXD_o : STD_LOGIC := '1';
    signal ld0 : STD_LOGIC := '0';

    signal led7_an_o : STD_LOGIC_VECTOR (3 downto 0);
    signal led7_seg_o : STD_LOGIC_VECTOR (7 downto 0);

    -- Component under test
    component top
        Port (
            clk_i : in STD_LOGIC;
            RXD_i : in STD_LOGIC;
            TXD_o : out STD_LOGIC;
            ld0 : out STD_LOGIC;
            led7_an_o : out STD_LOGIC_VECTOR (3 downto 0);
            led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

begin

    -- Instancja modu?u top
    dut: top
        port map (
            clk_i => clk_i,
            RXD_i => RXD_i,
            led7_an_o => led7_an_o,
            led7_seg_o => led7_seg_o
        );

    -- Generacja zegara 100 MHz
    clk_process: process
    begin
        while true loop
            clk_i <= '0';
            wait for clk_period / 2;
            clk_i <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Proces stymulacji
    stimulus_process: process
    begin
        wait for 1 ms;

        --(01010011) 0x93
        RXD_i <= '1'; wait for bit_period; -- Stan spoczynkowy (idle)
        RXD_i <= '0'; wait for bit_period; -- Start bit
        RXD_i <= '1'; wait for bit_period; -- Bit 0
        RXD_i <= '1'; wait for bit_period; -- Bit 1
        RXD_i <= '0'; wait for bit_period; -- Bit 2
        RXD_i <= '0'; wait for bit_period; -- Bit 3
        RXD_i <= '1'; wait for bit_period; -- Bit 4
        RXD_i <= '0'; wait for bit_period; -- Bit 5
        RXD_i <= '1'; wait for bit_period; -- Bit 6
        RXD_i <= '0'; wait for bit_period; -- Bit 7
        RXD_i <= '1'; wait for bit_period; -- Stop bit
        
                -- Wysłanie znaku Enter (0x0D)
        RXD_i <= '1'; wait for bit_period; -- idle
        RXD_i <= '0'; wait for bit_period; -- Start bit
        RXD_i <= '1'; wait for bit_period; -- Bit 0 (LSB)
        RXD_i <= '0'; wait for bit_period; -- Bit 1
        RXD_i <= '1'; wait for bit_period; -- Bit 2
        RXD_i <= '1'; wait for bit_period; -- Bit 3
        RXD_i <= '0'; wait for bit_period; -- Bit 4
        RXD_i <= '0'; wait for bit_period; -- Bit 5
        RXD_i <= '0'; wait for bit_period; -- Bit 6
        RXD_i <= '0'; wait for bit_period; -- Bit 7 (MSB)
        RXD_i <= '1'; wait for bit_period; -- Stop bit

        wait for 10 ms;
        assert false report "Koniec symulacji" severity failure;
    end process;

end Behavioral;