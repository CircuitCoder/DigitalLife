library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb is
end tb;

architecture bhv of tb is
  component timer is
    port(clk: in std_logic;
         rst: in std_logic;
         stop: in std_logic;
         high: out std_logic_vector(6 downto 0);
         low: out std_logic_vector(6 downto 0)
       );
  end component;

  signal clk: std_logic := '0';
  signal rst: std_logic := '0';
  signal stop: std_logic := '0';
  signal high: std_logic_vector(6 downto 0);
  signal low: std_logic_vector(6 downto 0);
begin
  t: timer port map(
                     clk => clk,
                     rst => rst,
                     stop => stop,
                     high => high,
                     low => low
                   );

  -- Clock loop, T=1ns, f=1MHz
  process
  begin
    wait for 0.5 ns;
    clk <= not clk;
  end process;

  process
  begin
    -- Initial reset
    rst <= '1';
    wait for 1 us;
    rst <= '0';

    -- Reset for 10us
    wait for 100 us;
    rst <= '1';
    wait for 10 us;
    rst <= '0';

    wait for 10 us;

    -- Stop for 10us
    stop <= '1';
    wait for 10 us;
    stop <= '0';
  end process;

end bhv;
