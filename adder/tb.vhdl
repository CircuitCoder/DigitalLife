library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb is
end tb;

architecture bhv of tb is
  component Adder4 is
    port(
          lhs: in std_logic_vector(3 downto 0);
          rhs: in std_logic_vector(3 downto 0);
          lower: in std_logic;
          result: out std_logic_vector(3 downto 0);
          carry: out std_logic
        );
  end component;

  component CLAdder4 is
    port(
          lhs: in std_logic_vector(3 downto 0);
          rhs: in std_logic_vector(3 downto 0);
          lower: in std_logic;
          result: out std_logic_vector(3 downto 0);
          carry: out std_logic
        );
  end component;

  signal current_lower: std_logic := '0'; -- This is fixed to 0
  signal current_lhs: std_logic_vector(3 downto 0) := "0000";
  signal current_rhs: std_logic_vector(3 downto 0) := "0000";

  signal expected_result: std_logic_vector(3 downto 0);
  signal expected_carry: std_logic;
  signal temp: unsigned(4 downto 0);

  signal result: std_logic_vector(3 downto 0);
  signal carry: std_logic;
  signal correct: std_logic := '1';

  signal clresult: std_logic_vector(3 downto 0);
  signal clcarry: std_logic;
  signal clcorrect: std_logic := '1';
begin
  adder: Adder4 port map(
    lhs => current_lhs,
    rhs => current_rhs,
    lower => current_lower,
    result => result,
    carry => carry
  );

  cladder: CLAdder4 port map(
    lhs => current_lhs,
    rhs => current_rhs,
    lower => current_lower,
    result => clresult,
    carry => clcarry
  );

  process
  begin
    wait for 1 ns;
    current_lhs <= std_logic_vector(unsigned(current_lhs) + 1);
  end process;

  process(current_lhs(3))
  begin
    if current_lhs(3)'event and current_lhs(3) = '0' then
      current_rhs <= std_logic_vector(unsigned(current_rhs) + 1);
    end if;
  end process;

  process(current_rhs(3))
  begin
    if current_rhs(3)'event and current_rhs(3) = '0' then
      report "PASSED";
      std.env.stop(0);
    end if;
  end process;

  process(current_lhs, current_rhs)
  begin
    temp <= unsigned('0' & current_lhs) + unsigned(current_rhs);
  end process;

  process(temp)
  begin
    expected_result <= std_logic_vector(temp(3 downto 0));
    expected_carry <= std_logic(temp(4));
  end process;

  process(expected_result, expected_carry, result, carry)
  begin
    if expected_result = result and expected_carry = carry then
      correct <= '1';
    else
      correct <= '0';
    end if;
  end process;

  process(expected_result, expected_carry, clresult, clcarry)
  begin
    if expected_result = clresult and expected_carry = clcarry then
      clcorrect <= '1';
    else
      clcorrect <= '0';
    end if;
  end process;

  process
  begin
    loop
      wait until falling_edge(correct);
      wait for 0.1 ns;
      if correct = '0' then
        report "Failed";
        std.env.stop(1);
      end if;
    end loop;
  end process;

  process
  begin
    loop
      wait until falling_edge(clcorrect);
      wait for 0.1 ns;
      if clcorrect = '0' then
        report "Failed on CLAdder";
        report "lhs=" & to_hstring(current_lhs);
        report "rhs=" & to_hstring(current_rhs);
        report "result=" & to_hstring(clresult);
        std.env.stop(1);
      end if;
    end loop;
  end process;
end bhv;
