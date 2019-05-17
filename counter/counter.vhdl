-- D flip flop

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity DFlip is
  port(clk: in std_logic;
       d: in std_logic;
       clr: in std_logic;
       q: out std_logic;
       nq: out std_logic
     );
end DFlip;

architecture bhv of DFlip is
  signal state: std_logic := '0';
begin
  -- When state changes, mutate output
  process(state)
  begin
    q <= state;
    nq <= not state;
  end process;

  -- Mutate state when a clear signal invokes, or a clock edge is met
  process(clr, clk)
  begin
    if(clr = '1') then
      state <= '0';
    elsif(clk'event and clk = '1') then
      state <= d;
    end if;
  end process;
end bhv;

-- 4-bit counter
--
-- The counter work in range [0, limit)
-- So to get a counter working as a base-10 digit, set limit = "1010"
--
-- carry_clk is a clock signal intended to serve in cascade counter setups.
-- It should be fed into the next level. On its raising edge, the next counter should increment.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity Counter4 is
  port(clk: in std_logic;
       clr: in std_logic;
       carry_clk: out std_logic;
       output: out std_logic_vector(3 downto 0);
       limit: in std_logic_vector(3 downto 0)
     );
end Counter4;

architecture struct of Counter4 is
  component DFlip is
    port(clk: in std_logic;
         d: in std_logic;
         clr: in std_logic;
         q: out std_logic;
         nq: out std_logic
       );
  end component;

  -- Clock signals for levels
  signal clks: std_logic_vector(4 downto 0);

  -- Fake CLR: we need to reset both when clr = 1 and output reaches limit
  signal fake_clr: std_logic;

  -- Output buffer. Used to check if output reaches limit
  signal buf: std_logic_vector(3 downto 0);
begin
  gen_dflips:
  for i in 0 to 3 generate
    dflip_inst: DFlip port map(clk => clks(i),
                          d => clks(i+1),
                          clr => fake_clr,
                          q => buf(i),
                          nq => clks(i+1)
                        );
  end generate gen_dflips;

  -- Directly feed buf to output
  output <= buf;

  process(clr, limit, buf)
  begin
    fake_clr <= clr or
                ((buf(0) xnor limit(0))
                and (buf(1) xnor limit(1))
                and (buf(2) xnor limit(2))
                and (buf(3) xnor limit(3)));
  end process;

  -- First level clock
  process(clk)
  begin
    clks(0) <= clk;
  end process;

  -- Carry clock
  process(clks(4))
  begin
    carry_clk <= clks(4);
  end process;
end struct;

-- Base-60 counter

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity counter is
  port(clk: in std_logic;
       rst: in std_logic;
       high: out std_logic_vector(3 downto 0);
       low: out std_logic_vector(3 downto 0)
     );
end counter;

architecture struct of counter is
  component Counter4 is
    port(clk: in std_logic;
         clr: in std_logic;
         carry_clk: out std_logic;
         output: out std_logic_vector(3 downto 0);
         limit: in std_logic_vector(3 downto 0)
       );
  end component;

  signal carry: std_logic := '1';
  constant low_limit: std_logic_vector(3 downto 0) := "1010";
  constant high_limit: std_logic_vector(3 downto 0) := "0110";
begin
  low_counter: Counter4 port map(clk => clk,
                                 clr => rst,
                                 carry_clk => carry,
                                 output => low,
                                 limit => low_limit
                               );
  high_counter: Counter4 port map(clk => carry,
                                  clr => rst,
                                  carry_clk => open,
                                  output => high,
                                  limit => high_limit
                                );
end struct;

-- Top level counter, maps numerical output into digital_7 signal

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity top is
  port(clk: in std_logic;
       rst: in std_logic;
       high: out std_logic_vector(6 downto 0);
       low: out std_logic_vector(6 downto 0)
     );
end top;

architecture struct of top is
  component digital_7 is
    port(key:in std_logic_vector(3 downto 0);
         display: out std_logic_vector(6 downto 0);
         display_4: out std_logic_vector(3 downto 0)
       );
  end component;

  component counter is
    port(clk: in std_logic;
         rst: in std_logic;
         high: out std_logic_vector(3 downto 0);
         low: out std_logic_vector(3 downto 0)
       );
  end component;

  signal high_input: std_logic_vector(3 downto 0);
  signal low_input: std_logic_vector(3 downto 0);
begin
  cnt: counter port map(clk => clk,
                        rst => rst,
                        high => high_input,
                        low => low_input
                      );
  low_digital: digital_7 port map(key => low_input, display => low);
  high_digital: digital_7 port map(key => high_input, display => high);
end struct;

-- Timer
--
-- Provides rate control, and can be paused.
-- Embeds a counter

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity timer is
  port(clk: in std_logic;
       rst: in std_logic;
       stop: in std_logic;
       high: out std_logic_vector(6 downto 0);
       low: out std_logic_vector(6 downto 0)
     );
end timer;

architecture bhv of timer is
  component top is
    port(clk: in std_logic;
         rst: in std_logic;
         high: out std_logic_vector(6 downto 0);
         low: out std_logic_vector(6 downto 0)
       );
  end component;

  -- Skipped iterations
  signal skip: integer range 0 to 1000000000 := 1;

  -- Fake clock signal for the counter component
  signal fake_clk: std_logic := '0';
begin
  t: top port map(clk => fake_clk,
                  rst => rst,
                  high => high,
                  low => low
                );

  -- Increment counter when we skipped enough iterations
  process(skip)
  begin
    if(skip = 0) then
      fake_clk <= '1';
    else
      fake_clk <= '0';
    end if;
  end process;

  process(clk, rst)
  begin
    if(rst = '1') then
      skip <= 1;
    elsif(clk'event and clk = '1' and stop = '0') then
      -- Skipped iterations is determined by this constant
      -- TODO: change 1000 into 1000,000,000
      if(skip = 1000 - 1) then
        skip <= 0;
      else
        skip <= skip + 1;
      end if;
    end if;
  end process;
end bhv;
