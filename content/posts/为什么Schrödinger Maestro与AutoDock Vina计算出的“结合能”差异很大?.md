+++
date = '2025-07-12T00:14:52+08:00'
draft = false
title = '为什么Schrödinger Maestro与AutoDock Vina计算出的“结合能”差异很大?'
+++

目前用于受体-配体结合模式预测的主流软件有两个：其一为商业软件Schrödinger Maestro，它工作流清晰、GUI完善；其二为开源软件AutoDock Vina，它专为“懒人”设计，无需考虑细枝末节即可快速完成预测。

但我们可以发现，Maestro输出的自由能数据（`r_i_glide_energy`）与Vina输出的数据（`affinity`）差别很大。前者多在-7~-5kcal/mol，后者可达到最低-40kcal/mol，这对于包括我在内的初学者造成了一定困扰，到底谁才是真正的“结合自由能”？

我通过MM/GBSA方法验证了HMOX1与大量小分子的结合自由能，结果显示其与Maestro的输出结果高度一致，这表明Vina所输出的`affinity`并不是结合自由能。

通过查阅介绍Vina的文献[^1]，我发现Vina所输出的`affinity`尽管拥有与自由能相同的计量单位“kcal/mol”，但并不是自由能，其在文章中如是说：

>We see our approach to the scoring function as more of ”machine learning” than directly physics-based in its nature. It is ultimately justified by its performance on test problems rather than by theoretical considerations following some, possibly too strong, approximating assumptions.

也就是说，`affinity`是一个更偏向于“机器学习”的对接评分，而不是对自由能的物理计算。这个函数的推导结合了基于知识的势能和经验评分函数的某些优势，而这些优势是从受体-配体复合物的构象偏好和实验亲和力测量中提取得到的经验信息。
 
而Maestro在使用Glide模块对接后，也会输出一个列名为`r_i_docking_score`的对接打分，这个打分同样是使用kcal/mol作为计量单位，同样与MM/GBSA预测到的结果大相径庭。Mastro在其用户手册关于Glide方法论的介绍中作了如下解释：

>The individual terms (Emodel, Ecoul, and so on) in the GlideScore formula are parametrized in this calibration: these terms should therefore not be interpreted as quantitative calculations of energies.

也就是SP和XP GlideScore都已校准以重现某些实验结合亲和力。GlideScore 公式中的各个项（`Emodel`、`Ecoul`等）在校准中进行了参数化：因此这些项不应被解释为能量计算的定量结果。这就与Vina所提供的`affinity`很相似了。

因此我们已经可以确定，Vina计算得到的`affinity`和Maestro计算得到的`GlideScore`尽管都使用了kcal/mol作为计量单位，但都是人为定义的经过参数化的评分函数，而不是物理（或化学）意义上的结合自由能。评分函数作为一个结合模式的评分参考，应当与结合自由能共同纳入考虑，作为早期虚拟筛选的排序指标。



[^1]:Trott O, Olson AJ. AutoDock Vina: improving the speed and accuracy of docking with a new scoring function, efficient optimization, and multithreading. J Comput Chem. 2010 Jan 30;31(2):455-61. doi: 10.1002/jcc.21334. PMID: 19499576; PMCID: PMC3041641.