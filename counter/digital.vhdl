-- Digital output

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

architecture bhv of counter is
  signal current_high: unsigned(3 downto 0) := "0000";
  signal current_low: unsigned(3 downto 0) := "0000";
begin
  process(clk, rst)
  begin
    if(rst = '1') then
      current_high <= "0000";
      current_low <= "0000";
    elsif(clk'event and clk = '1') then
      if(current_low = 9) then
        current_low <= "0000"; 
        if(current_high = 5) then
          current_high <= "0000";
        else
          current_high <= current_high + "0001";
        end if;
      else
        current_low <= current_low + "0001";
      end if;
    end if;
  end process;

  process(current_low)
  begin
    low <= std_logic_vector(current_low);
  end process;

  process(current_high)
  begin
    high <= std_logic_vector(current_high);
  end process;
end bhv;

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

  signal skip: integer range 0 to 1000000000 := 1;
  signal fake_clk: std_logic := '0';
begin
  t: top port map(clk => fake_clk,
                  rst => rst,
                  high => high,
                  low => low
                );

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
      -- TODO: change 1000 into 1000,000,000
      if(skip = 1000 - 1) then
        skip <= 0;
      else
        skip <= skip + 1;
      end if;
    end if;
  end process;
end bhv;
