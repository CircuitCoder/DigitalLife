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

  signal i: std_logic_vector(3 downto 0) := "0000";
  signal m: std_logic_vector(1 downto 0) := "00";
  signal c: std_logic := '0';
  signal r: std_logic := '0';
  signal s: std_logic;
  signal f: std_logic;
begin
  l: lock port map(input => i, mode => m, clk => c, rst => r, succ => s, fail => f);

  process
  begin
    loop
      -- Verify default
      m <= "01";
      wait for 1 us;
      r <= '1';
      wait for 1 us;
      r <= '0';

      i <= "0001";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0010";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0100";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "1000";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      wait for 10 us;

      -- Set
      m <= "00";
      wait for 1 us;
      r <= '1';
      wait for 1 us;
      r <= '0';

      i <= "1000";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0100";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0010";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0001";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      wait for 10 us;

      -- Verify default
      m <= "01";
      wait for 1 us;
      r <= '1';
      wait for 1 us;
      r <= '0';

      i <= "0001";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0010";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0100";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "1000";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      wait for 10 us;

      -- Verify default
      m <= "01";
      wait for 1 us;
      r <= '1';
      wait for 1 us;
      r <= '0';

      i <= "0001";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0010";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0100";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "1000";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      wait for 10 us;

      -- Verify partial
      m <= "01";
      wait for 1 us;
      r <= '1';
      wait for 1 us;
      r <= '0';

      i <= "1000";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0100";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0010";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "1111";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      wait for 10 us;

      -- Now is locked

      -- Correct pass
      m <= "01";
      wait for 1 us;
      r <= '1';
      wait for 1 us;
      r <= '0';

      i <= "1000";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0100";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0010";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0001";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      wait for 10 us;

      -- Still locked

      -- Incorrect Admin
      m <= "10";
      wait for 1 us;
      r <= '1';
      wait for 1 us;
      r <= '0';

      i <= "0001";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0010";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0100";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "1001";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      wait for 10 us;

      -- Admin
      m <= "10";
      wait for 1 us;
      r <= '1';
      wait for 1 us;
      r <= '0';

      i <= "0001";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0010";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0100";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "1000";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      wait for 10 us;

      -- Correct pass
      m <= "01";
      wait for 1 us;
      r <= '1';
      wait for 1 us;
      r <= '0';

      i <= "1000";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0100";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0010";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      i <= "0001";
      wait for 1 us;
      c <= '1';
      wait for 1 us;
      c <= '0';

      wait for 10 us;

      std.env.stop(0);
    end loop;
  end process;
end bhv;
