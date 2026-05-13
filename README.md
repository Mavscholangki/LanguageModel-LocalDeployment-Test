# 大语言模型部署体验：Qwen / ChatGLM / Baichuan 对比测试

---

## 一、实验环境

- **实例类型**：CPU 8核 32GB  
- **预装镜像**：`ubuntu22.04-py311-torch2.3.1-1.35.0`（已预装 PyTorch 2.3.1 和 ModelScope 库）  
- **额外依赖**：通过 `setup_env.sh` 安装 `intel-extension-for-transformers`, `neural-compressor`, `fschat` 等  
- **模型存储路径**：`/mnt/data/`（魔搭实例默认数据盘）

---

## 二、测试模型列表

| 模型 | 来源 | 参数规模 | 本地路径 |
|------|------|----------|----------|
| 通义千问 Qwen-7B-Chat | [ModelScope](https://www.modelscope.cn/models/qwen/Qwen-7B-Chat/summary) | 7B | `/mnt/data/Qwen-7B-Chat` |
| 智谱 ChatGLM3-6B | [ModelScope](https://www.modelscope.cn/models/ZhipuAI/chatglm3-6b/summary) | 6B | `/mnt/data/chatglm3-6b` |
| 百川 Baichuan2-7B-Chat | [ModelScope](https://www.modelscope.cn/models/baichuan-inc/Baichuan2-7B-Chat/summary) | 7B | `/mnt/data/Baichuan2-7B-Chat` |

---

## 三、快速复现（在魔搭 CPU 实例上）

首先，克隆本仓库：
```bash
git clone https://github.com/Mavscholangki/LanguageModel-LocalDeployment-Test.git
cd LanguageModel-LocalDeployment-Test
```

首次或实例重启后，需要运行环境配置脚本。其他情况则可跳过：
```bash
bash setup_env.sh
```

随后，下载模型到 /mnt/data：
```bash
cd /mnt/data
git clone https://www.modelscope.cn/qwen/Qwen-7B-Chat.git
git clone https://www.modelscope.cn/ZhipuAI/chatglm3-6b.git
git clone https://www.modelscope.cn/baichuan-inc/Baichuan2-7B-Chat.git
```

运行测试脚本：
```bash
cd /mnt/workspace   # 建议把脚本复制到工作目录
python run_qwen.py
python run_glm.py
python run_baichuan.py
```

> 注意：魔搭实例的空闲超时时间为1小时，若环境丢失，重新运行 `bash setup_env.sh` 即可恢复依赖。

理论上，存储空间是足够一次性测试三个模型的，但如果更谨慎，需要逐步测试，则可以改为下述步骤：
```bash
# 测试Qwen
cd /mnt/data
git clone https://www.modelscope.cn/qwen/Qwen-7B-Chat.git
cd /mnt/workspace
python run_qwen.py

# 测试GLM
cd /mnt/data
git clone https://www.modelscope.cn/ZhipuAI/chatglm3-6b.git
cd /mnt/workspace
python run_glm.py

# 测试Baichuan
cd /mnt/data
git clone https://www.modelscope.cn/baichuan-inc/Baichuan2-7B-Chat.git
python run_baichuan.py
```

## 四、测试问题

为了全面评估模型的语义理解、逻辑推理及信息整合能力，我们设计了四道由浅入深的测试题，每题考察不同的能力维度。

| 序号 | 问题 | 考察目的 |
|------|------|----------|
| 1 | 请说出以下两句话区别在哪里？<br>1、冬天：能穿多少穿多少<br>2、夏天：能穿多少穿多少 | 测试模型对中文歧义句的辨析能力，尤其是理解“多少”在不同语境下的相反含义 |
| 2 | 明明明明明白白白喜欢他，可她就是不说。<br>这句话里，明明和白白谁喜欢谁？ | 测试模型的断句和指代消解能力，需要正确解析多层修饰的人名和代词 |
| 3 | 如果今天是周一，我就去图书馆还书。<br>今天不是周一，所以我不去还书。<br>请问：这个推理正确吗？请回答“正确”或“不正确”，并简要说明理由。 | 测试模型对基本逻辑谬误（否定前件）的识别能力，不涉及文字游戏 |
| 4 | 李华今年15岁，就读于市第一中学。他的物理老师是王敏，数学老师是张强。李华最喜欢的科目是物理，他曾获得校物理竞赛一等奖。他的好朋友小丽擅长英语，两人经常一起讨论学习问题。<br>请根据以上文本回答：<br>李华就读于哪所学校？他最喜欢的科目是什么？<br>文中提到了哪些老师？分别教什么科目？<br>李华的好朋友是谁？她擅长什么？<br>请用一段通顺的文字或分点列出答案，不要遗漏信息。 | 测试模型的信息提取、归纳总结和表达能力，没有歧义或推理转弯 |

**说明**：问题1～3具有一定难度，问题4为基础信息提取题，用以验证模型是否存在硬性理解缺陷。所有模型均采用相同的输入提示词。

## 五、测试结果

见项目目录下的`report.pdf`，篇幅原因，此处不额外重复。
