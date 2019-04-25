-- Half Adder

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity HalfAdder is
  port(
        lhs: in std_logic;
        rhs: in std_logic;
        result: out std_logic;
        carry: out std_logic
      );
end HalfAdder;

architecture bhv of HalfAdder is
begin
  process(lhs, rhs)
  begin
    result <= lhs xor rhs;
    carry <= lhs and rhs;
  end process;
end bhv;

-- Full Adder

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity FullAdder is
  port(
        lhs: in std_logic;
        rhs: in std_logic;
        lower: in std_logic;

        half_result: out std_logic;
        half_carry: out std_logic;
        result: out std_logic;
        carry: out std_logic
      );
end FullAdder;

architecture bhv of FullAdder is
  signal secondary_carry: std_logic;
  signal primary_result: std_logic;
  signal primary_carry: std_logic;

  component HalfAdder is
    port(
          lhs: in std_logic;
          rhs: in std_logic;
          result: out std_logic;
          carry: out std_logic
        );
  end component;
begin
  primary: HalfAdder port map(lhs => lhs, rhs => rhs, result => primary_result, carry => primary_carry);
  secondary: HalfAdder port map(lhs => lower, rhs => primary_result, result => result, carry => secondary_carry);

  process(primary_carry, secondary_carry)
  begin
    carry <= primary_carry or secondary_carry;
  end process;

  process(primary_result)
  begin
    half_result <= primary_result;
  end process;

  process(primary_carry)
  begin
    half_carry <= primary_carry;
  end process;
end bhv;

-- 4-bit Adder

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity Adder4 is
  port(
        lhs: in std_logic_vector(3 downto 0);
        rhs: in std_logic_vector(3 downto 0);
        lower: in std_logic;
        result: out std_logic_vector(3 downto 0);
        carry: out std_logic
      );
end Adder4;

architecture bhv of Adder4 is
  signal lower_carries: std_logic_vector(4 downto 0);
  component FullAdder is
    port(
          lhs: in std_logic;
          rhs: in std_logic;
          half_result: out std_logic;
          half_carry: out std_logic;
          lower: in std_logic;
          result: out std_logic;
          carry: out std_logic
        );
  end component;
begin
  gen_adders:
  for i in 0 to 3 generate
    adder: FullAdder port map(
                               lhs => lhs(i),
                               rhs => rhs(i),
                               lower => lower_carries(i),
                               half_result => open,
                               half_carry => open,
                               result => result(i),
                               carry => lower_carries(i+1)
                             );
  end generate gen_adders;

  process(lower)
  begin
    lower_carries(0) <= lower;
  end process;

  process(lower_carries(4))
  begin
    carry <= lower_carries(4);
  end process;
end bhv;

-- 4-bit Carry-lookahead adder

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity CLAdder4 is
  port(
        lhs: in std_logic_vector(3 downto 0);
        rhs: in std_logic_vector(3 downto 0);
        lower: in std_logic;
        result: out std_logic_vector(3 downto 0);
        carry: out std_logic
      );
end CLAdder4;

architecture bhv of CLAdder4 is
  signal half_carries: std_logic_vector(4 downto 0);
  signal half_results: std_logic_vector(4 downto 0);
  signal lower_carries: std_logic_vector(4 downto 0);
  component FullAdder is
    port(
          lhs: in std_logic;
          rhs: in std_logic;
          half_result: out std_logic;
          half_carry: out std_logic;
          lower: in std_logic;
          result: out std_logic;
          carry: out std_logic
        );
  end component;
begin
  gen_adders:
  for i in 0 to 3 generate
    adder: FullAdder port map(
                               lhs => lhs(i),
                               rhs => rhs(i),
                               half_result => half_results(i+1),
                               half_carry => half_carries(i+1),
                               lower => lower_carries(i),
                               result => result(i),
                               carry => open
                             );
  end generate gen_adders;

  process(half_carries, half_results)
  begin
    lower_carries(1) <= half_carries(1) or (half_results(1) and half_carries(0));
    lower_carries(2) <= half_carries(2) or (half_results(2) and half_carries(1)) or (half_results(2) and half_results(1) and half_carries(0));
    lower_carries(3) <= half_carries(3) or (half_results(3) and half_carries(2)) or (half_results(3) and half_results(2) and half_carries(1)) or (half_results(3) and half_results(2) and half_results(1) and half_carries(0));
    lower_carries(4) <= half_carries(4) or (half_results(4) and half_carries(3)) or (half_results(4) and half_results(3) and half_carries(2)) or (half_results(4) and half_results(3) and half_results(2) and half_carries(1)) or (half_results(4) and half_results(3) and half_results(2) and half_results(1) and half_carries(0));
  end process;

  process(lower)
  begin
    lower_carries(0) <= lower;
    half_carries(0) <= lower;
  end process;

  process(lower_carries(4))
  begin
    carry <= lower_carries(4);
  end process;
end bhv;
