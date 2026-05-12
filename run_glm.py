from transformers import AutoTokenizer, AutoModelForCausalLM, TextStreamer

# 本地模型路径
model_name = "/mnt/data/chatglm3-6b"

# 测试问题
prompt = "请说出以下两句话区别在哪里？\n1、冬天：能穿多少穿多少\n2、夏天：能穿多少穿多少"
# prompt = "他知道我知道你知道他不知道吗？ 这句话里，到底谁不知道"

# 加载分词器和模型
print("正在加载模型，请稍等...")
tokenizer = AutoTokenizer.from_pretrained(model_name, trust_remote_code=True)
model = AutoModelForCausalLM.from_pretrained(model_name, trust_remote_code=True, torch_dtype="auto").eval()

# 编码输入
inputs = tokenizer(prompt, return_tensors="pt").input_ids

# 流式输出
streamer = TextStreamer(tokenizer, skip_prompt=True)
print("\n模型回答：")
model.generate(inputs, streamer=streamer, max_new_tokens=500)