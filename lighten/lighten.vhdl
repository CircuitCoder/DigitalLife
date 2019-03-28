LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity digital_7 is
  port(key:in std_logic_vector(3 downto 0);
       display: out std_logic_vector(6 downto 0);
       display_4: out std_logic_vector(3 downto 0)
     );
end digital_7;

architecture bhv of digital_7 is
begin
  display_4 <= key;

  process(key)
  begin
    case key is
      when "0000" => display <= "1111110"; --0
      when "0001" => display <= "0110000"; --1
      when "0010" => display <= "1101101"; --2
      when "0011" => display <= "1111001"; --3
      when "0100" => display <= "0110011"; --4
      when "0101" => display <= "1011011"; --5
      when "0110" => display <= "0011111"; --6
      when "0111" => display <= "1110000"; --7
      when "1000" => display <= "1111111"; --8
      when "1001" => display <= "1110011"; --9
      when "1010" => display <= "1110111"; --a
      when "1011" => display <= "0111110"; --b
      when "1100" => display <= "1001110"; --c
      when "1101" => display <= "0111110"; --d
      when "1110" => display <= "1001111"; --e
      when "1111" => display <= "1000111"; --f
      when others => display <= "0000000";
    end case;
  end process;
end bhv;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity generator is
  port (output_nat: out std_logic_vector(3 downto 0);
        output_even: out std_logic_vector(3 downto 0);
        output_odd: out std_logic_vector(3 downto 0);
        clk: in std_logic;
        rst: in std_logic
      );
end generator;

architecture bhv of generator is
  signal counter_single: std_logic_vector(3 downto 0) := "0000";
  signal counter_double: std_logic_vector(3 downto 0) := "0000";
begin
  process(clk, rst)
  begin
    if (rst'event and rst = '1') then
      counter_single <= "0000";
      counter_double <= "0000";
    elsif(clk'event and clk = '1') then
      output_nat <= counter_single;
      output_even <= counter_double;
      output_odd <= std_logic_vector(unsigned(counter_double) + 1);
    elsif(clk'event and clk = '0') then
      if rst = '0' then -- Only increment when rst is not pressed
        counter_single <= std_logic_vector(unsigned(counter_single) + 1);
        counter_double <= std_logic_vector(unsigned(counter_double) + 1);
      end if;
    end if;
  end process;
end bhv;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity main is
  port (clk: in std_logic;
        rst: in std_logic;
        output: out std_logic_vector(6 downto 0)
      );
end main;

architecture bhv of main is
  component generator is
    port(clk, rst: in std_logic;
         output_nat: out std_logic_vector(3 downto 0)
       );
  end component;

  component digital_7 is
    port(key: in std_logic_vector(3 downto 0);
        display: out std_logic_vector(6 downto 0)
       );
  end component;
  signal data: std_logic_vector(3 downto 0);
begin
  disp: digital_7 port map(key => data,
                           display => output);
  gen: generator port map(clk,
                          rst,
                          output_nat => data);
end bhv;
