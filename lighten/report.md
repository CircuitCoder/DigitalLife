---
documentclass:
  - ctexart
---

# Week 3 点亮数字人生

## 源代码
- **lighten.vhdl**: 主程序
- **tb.vhdl**: 测试程序，生成时钟序列

## 合成
VHDL 文件在 linux 环境下编写

合成、模拟程序是 GHDL 0.37-dev gcc:

```bash
# 合成
ghdl -a *.vhdl

# 以 tb 作为顶级 entity 进行模拟，1us 后自动停止，波形输出为 led.vcd
ghdl -r tb --stop-time=1000ns --vcd=led.vcd

# 使用 gtkwave 显示波形
gtkwave led.vcd
```

## 项目结构
lighten.vhdl 中共包含三个 entity: digital\_7, generator 和 main:

- **digital_7**: 七位数码管
- **generator**: 根据 clk 和 rst 生成自然数、正奇数和正偶数序列
- **main**: 顶级 entity，暴露需要的引脚，以及对下层的 generator 和 digital_7 进行 port map

其中，generator 的内部计数器自增和输出更新分别发生在时钟信号的下跳沿和上跳沿上，因此 rst 上跳的时候需要最多等待一个时钟周期才会更新到输出上。同时，当 rst 被持续置 1 的时候，generator 会停止内部的计数器自增。

tb.vhdl 中共一个 entity: tb，内部包含一个 main，不暴露任何接口，直接生成虚拟的时钟信号用于测试。

## 附: 源代码


### lighten.vhdl

```vhdl
-- Digital output

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

-- Sequence generator

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
  process(rst)
  begin
    if (rst'event and rst = '1') then
      counter_single <= "0000";
      counter_double <= "0000";
      output_nat <= "0000";
      output_even <= "0000";
      output_odd <= "0001";
    end if;
  end process;

  process(clk)
  begin
    if(clk'event and clk = '1') then
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

-- Top level entity

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity main is
  port (clk: in std_logic;
        rst: in std_logic;
        output: out std_logic_vector(6 downto 0);
        output2: out std_logic_vector(3 downto 0);
        output3: out std_logic_vector(3 downto 0)
      );
end main;

architecture bhv of main is
  component generator is
    port(clk, rst: in std_logic;
         output_nat: out std_logic_vector(3 downto 0);
         output_even: out std_logic_vector(3 downto 0);
         output_odd: out std_logic_vector(3 downto 0)
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
                          output_nat => data,
                          output_even => output2,
                          output_odd => output3 
                        );
end bhv;
```


### tb.vhdl

```vhdl
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
```
