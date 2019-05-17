---
documentclass:
  - ctexart
---

# Week 11 计数器的设计

## 源代码
- **counter.vhdl**: 计数器以及其他功能
- **digital.vhdl**: 从点亮数字人生借来的七段数码管
- **tb.vhdl**: 测试程序，生成时钟序列

注：在模拟中，由于可以模拟的时长有限，因此在 1M 时钟下计数的是 us。具体见附在报告最后的源码中的 TODO 注释。

## 软件仿真

仿真结果位于 wave.vcd 文件中。生成的输入如下：

- 200us 的 1M 时钟，其中：
  - 开始给予 1us 的 reset
  - 101us - 111us，reset
  - 121us - 131us，停止计时

仿真中，代码工作的很合乎设计，计数器在一开始的复位后以60进制正常运行，reset 时重置，停止时不增加时间。

## 电路测试结果

烧写进入电路之前，改变了计数的单位（单个周期或者 1M 个周期），之后正常分析、烧写。

电路输入的时钟信号根据需要，连接到限位开关或者 1M 时钟上。RST 连接到限位开关上。停止计时连接到一个拨动开关。

结果和仿真基本一致，除了限位开关轻触可能造成多次时钟信号。推测是在开关临界状态的抖动导致的，和实现无关。使用 1M 时钟的时钟后，计时器相比于秒表没有明显的速度差距。

## 合成、仿真方法

在 Linux 环境使用 GHDL:
```bash
# Analyse all files
ghdl -a --std=08 *.vhdl

# Elaborate tb unit
ghdl -e --std=08 tb

# Run with tb as top-level unit
ghdl -r --std=08 tb --stop-time=200us --vcd=wave.vcd
```

之后会输出 wave.vcd 文件。使用 gtkwave 可以打开。
