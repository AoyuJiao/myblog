+++
date = '2025-09-29T00:19:22+08:00'
draft = false
title = 'ChemBL数据库中mol文件的获取与使用方法'
+++

目前，全球规模最大的开放化学数据库是PubChem。然而，由于网络访问限制，国内用户有时无法正常使用该数据库，此时ChemBL便成为一个理想的替代选择。与PubChem不同，ChemBL并未在页面上直接提供结构文件下载按钮，这给不少用户带来操作上的困扰。本文将详细介绍如何在ChemBL中获取小分子的mol文件。

操作步骤如下：在ChemBL网站中搜索目标小分子，进入其详情页后，向下滚动至“Representations”栏目

![ChemBL的Representations栏目.webp](/images/ChemBL的Representations栏目.webp)

默认情况下，mol文件内容处于隐藏状态，点击“SHOW”即可展开显示。用户也可以直接点击“COPY TO CLIPBOARD”将mol文本内容复制到剪贴板。由于mol文件本质上是文本格式，接下来可在计算机上新建一个文本文件，将其命名为“分子名称.mol”，使用记事本打开该文件，粘贴之前复制的文本内容，保存后即可得到对应的.mol文件。

需要注意的是，mol文件无法保存小分子的三维结构信息，因此可能出现键合正确但三维构型错误的情况：

![小分子键合正确但三维结构错误.webp](/images/小分子键合正确但三维结构错误.webp)

为解决该问题，可将mol文件导入Chem3D软件，执行“MM2 Minimize”进行能量最小化计算。

![Chem3D软件的工具栏.webp](/images/Chem3D软件的工具栏.webp)

该算法将自动优化分子构象至能量最低状态，之后可将结果保存为支持三维结构信息的.sdf文件。

详细操作视频可参考[此微信视频号内容](https://weixin.qq.com/sph/AwSZKe3DU)。