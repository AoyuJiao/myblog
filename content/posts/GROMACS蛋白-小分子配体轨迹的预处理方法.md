+++
date = '2026-05-17T07:50:22+08:00'
draft = false
title = 'GROMACS蛋白-小分子配体轨迹的预处理方法'
+++

GROMACS是一款以普适及高性能著称的分子动力学模拟程序，广泛用于各类分子动力学模拟任务。本文针对蛋白-小分子配体的模拟结果提出一种通用化的轨迹预处理方法，可以用于各类非膜蛋白体系以及包括`none`，`linear`，`angular`等在内的各类平转动消除方法。

此预处理主要分成三个基本步骤，分别是时间连续、空间整理、清除平转动。以下假设工作目录中包含`md.xtc`和`md.tpr`两个生产动力学模拟文件，以及`index.ndx`索引文件[^1]。

## 时间连续化

此步骤用于消除周期性边界条件（PBC）所引起的边界跳跃，并使其紧凑。

```bash
gmx trjconv -f md.xtc -s md.tpr -pbc nojump -ur compact -o step1_nojump.xtc
```

如在后续要进行MM/PBSA等需要溶剂分子参与的活动，请选择输出`System`组，否则可以只输出蛋白-小分子配体复合物，实现提升性能的目的。但GROMACS本身默认索引并不提供此复合物的原子组，所以需要在命令中额外引入`-n index.ndx`索引文件，下同。

## 空间整理

此步骤用于修复被PBC切断的分子，以及将复合物居中。

```bash
gmx trjconv -f step1_nojump.xtc -s md.tpr -pbc mol -center -o step2_nojump.xtc
```

此处建议基于蛋白碳骨架（`C-alpha`）而非整个蛋白（`Protein`）或复合物进行居中计算。因为蛋白侧链波动幅度较大，可能会干扰计算；同时，蛋白骨架碳原子数量相比于全原子更少，可以提升计算速度。

## 消除平转动

如题，此步骤用于消除复合物的平转动。

```bash
gmx trjconv -f step2_nojump.xtc -s md.tpr -fit rot+trans -o md_clean.xtc
```

此处同样推荐基于蛋白碳骨架（`C-alpha`）而非整个蛋白（`Protein`）或复合物进行消除平转动计算。

## 抽帧

GROMACS默认的轨迹记录频率通常比较高，对于验证蛋白-小分子配体结合稳定性这样的需求，10ps的记录频率已经足够使用。此外，抽帧还可以提升帧之间的抽样独立性。

推荐大家在`.mdp`文件中直接指定`nstxout-compressed = 5000`，即可按10ps每帧的频率进行记录，无需在采样完成后进行额外处理。此外，对于原子数常小于10万的蛋白质水盒子体系，这个降低记录频率的举措也可用来降低PCIE数据传输量，提升模拟速度。

如果忘记在`.mdp`文件中调整轨迹输出频率，可以按如下命令进行抽帧：

```bash
gmx trjconv -f md_clean.xtc -s md.tpr -dt 10 -o md10.xtc
```

其中`-dt`参数定义了帧间隔，单位为ps.如果用于MM/PBSA或GBSA计算，此间隔可以被放宽至100ps甚至更多。

## 初始帧构象生成

如果只输出了`protein_lig`组，其处理后的`xtc`文件与`mdrun`自动生成的初始帧的`.gro`文件包含的内容不同，后者包含整个体系。因此若要在VMD等可视化软件中观看轨迹，不能直接载入原始的`.gro`文件，而需要根据处理后的`.xtc`文件重新生成一份，方法是：

```bash
gmx trjconv -f md10.xtc -s md.tpr -o md_protein_lig.gro -dump 0 -n index.ndx
```

选择输出`protein_lig`组即可，`md_protein_lig.gro`即为初始帧构象。

[^1]:目前针对蛋白-小分子配体复合物的模拟任务，V-rescale是已知最好的热浴方法，但仍未解决其从Berendsen遗传过来的"Flying Ice Cube"问题，也就是仍需要对溶质和溶剂进行分组控温，此`.ndx`索引文件就是为了定义复合物原子组，并将其作为溶质。如果你在模拟时没有分组控温，请先评估模拟结果的物理合理性。