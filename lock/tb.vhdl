LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity tb is
end tb;

architecture bhv of tb is
  component lock is
    port(input:in std_logic_vector(3 downto 0);
         mode: in std_logic_vector(1 downto 0);
         clk: in std_logic;
         rst: in std_logic;
         succ: out std_logic;
         fail: out std_logic
       );
  end component;

  signal i: std_logic_vector(3 downto 0);
  signal m: std_logic_vector(1 downto 0);
  signal c: std_logic;
  signal r: std_logic;
  signal s: std_logic;
  signal f: std_logic;
begin
  process
  begin
    loop
      c <= '1';
      wait for 0.5 us;
      c <= '0';
      wait for 0.5 us;
    end loop;
  end process;

  l: lock port map(input => i, mode => m, clk => c, rst => r, succ => s, fail => f);

  process
  begin
    loop
      m <= "01";
      i <= "0000";
      r <= '1';
      wait for 1 us;
      r <= '0';
      wait for 10 us;

      i <= "0110";
      r <= '1';
      wait for 1 us;
      r <= '0';
      wait for 10 us;

      m <= "00";
      r <= '1';
      wait for 1 us;
      r <= '0';
      wait for 10 us;

      m <= "01";
      r <= '1';
      wait for 1 us;
      r <= '0';
      wait for 10 us;
      std.env.stop(0);
    end loop;
  end process;
end bhv;
