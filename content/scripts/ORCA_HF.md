---
title: "orca_hf.inp"
description: "适用于ORCA 6.0.1的小分子几何优化和频率分析的输入文件模板"
download: "/files/orca_hf.inp"
---

本输入文件选用HF/6-31G*理论级别，与目前主流的AMBER等原子力场在开发时使用的级别保持一致。由此得到的`.hess`文件可结合Sobtop计算键参数，`.gbw`文件可结合Multiwfn计算RESP电荷。

# 使用方法

首先，调整`.inp`文件中此行的`16`至实际并行核心数：

```
%pal nprocs 16 end
```

然后，调整`.inp`文件中此行的`3000`调整每核心实际分配的运行内存，单位为MB：

```
%maxcore 3000
```

然后，调整`.inp`文件中此行的`0 1`至实际电荷和自旋多重度：

```
* xyz 0 1
```

然后，在`.inp`文件中两个`*`中间的行粘贴`.xyz`格式的原子坐标，准备好的文件应例如：

```
! HF 6-31G* Opt Freq
%pal nprocs 16 end
%maxcore 3000
* xyz 0 1
C      8.4730000000  -19.6330000000   15.3890000000
C     10.0180000000  -19.5090000000   15.4910000000
*
```

最后，运行如下命令启动运算：

```bash
orca orca_hf.inp > orca_hf.out
```

日志文件将以文本文件的形式保存至`orca_hf.out`

# 下载

[HF/6-31G*级别的ORCA输入模板](/files/orca_hf.inp)    [.xyz文件示例](/files/example.xyz)
