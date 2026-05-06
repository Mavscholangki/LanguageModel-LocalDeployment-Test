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

测试问题如下，来自课程的补充材料（可替换为其他问题测试）：
> 请说出以下两句话区别在哪里？
> 1、冬天：能穿多少穿多少
> 2、夏天：能穿多少穿多少

正确答案要点：\
冬天“能穿多少穿多少” = 穿得越多越好（保暖）夏天“能穿多少穿多少” = 穿得越少越好（散热）两句话字面相同，但语义完全相反。

## 五、测试结果

见项目目录下的`report.pdf`，篇幅原因，此处不额外重复。
