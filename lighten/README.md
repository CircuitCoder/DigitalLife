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
