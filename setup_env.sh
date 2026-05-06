#!/bin/bash
# 适用于魔搭预装镜像: ubuntu22.04-py311-torch2.3.1-1.35.0
# 功能: 快速配置大模型部署所需环境（跳过conda、PyTorch等已存在组件）

set -e  # 遇到错误立即退出

echo "=========================================="
echo "开始检查并配置环境..."
echo "=========================================="

# 1. 检查 Python 版本
PY_VER=$(python --version 2>&1 | awk '{print $2}')
echo "当前 Python 版本: $PY_VER"
if [[ ! "$PY_VER" =~ 3.11 ]]; then
    echo "警告: 预装镜像应为 Python 3.11，当前版本 $PY_VER，可能影响兼容性"
else
    echo "Python 版本 OK"
fi

# 2. 检查 PyTorch 是否可用
echo "检查 PyTorch..."
if python -c "import torch" 2>/dev/null; then
    TORCH_VER=$(python -c "import torch; print(torch.__version__)")
    echo "PyTorch 版本: $TORCH_VER"
else
    echo "错误: PyTorch 未安装或不可用，请确认使用的是预装镜像"
    exit 1
fi

# 3. 升级 pip（可选）
echo "升级 pip..."
pip install --upgrade pip -q

# 4. 安装作业所需额外依赖
echo "安装额外依赖 (intel-extension-for-transformers, neural-compressor, transformers, pydantic, fschat 等)..."
pip install "intel-extension-for-transformers==1.4.2" \
            "neural-compressor==2.5" \
            "transformers==4.33.3" \
            "pydantic==1.10.13" \
            -q

echo "安装 fschat (需要 PEP517 构建)..."
pip install fschat --use-pep517 -q

echo "安装辅助工具 (tqdm, huggingface-hub)..."
pip install tqdm huggingface-hub -q

# 5. 验证关键包导入
echo "验证关键包导入..."
python -c "
import torch
import transformers
import modelscope
import intel_extension_for_transformers
import neural_compressor
print('torch:', torch.__version__)
print('transformers:', transformers.__version__)
print('modelscope:', modelscope.__version__)
print('intel-extension-for-transformers: OK')
print('neural-compressor: OK')
print('fschat: OK')
"

echo "=========================================="
echo "环境配置完成！"
echo "接下来可以进入阶段二：下载模型并开始推理测试"
echo "=========================================="
EOF