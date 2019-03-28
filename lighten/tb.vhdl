library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb is
end tb;

architecture bhv of tb is
  component main
    port(clk: in std_logic;
         rst: in std_logic;
         output: out std_logic_vector(6 downto 0)
       );
  end component;

  signal clk: std_logic := '0';
  signal rst: std_logic := '0';
  signal output: std_logic_vector(6 downto 0);
begin
  m: main port map(
    clk => clk,
    rst => rst,
    output => output
  );

  process
  begin
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
  end process;
end bhv;
