from transformers import AutoTokenizer, AutoModelForCausalLM, TextStreamer
import torch

# 本地模型路径
model_name = "/mnt/data/Baichuan2-7B-Chat"

# 测试问题（你可以换用补充材料2中的其他问题）
prompt = "请说出以下两句话区别在哪里？\n1、冬天：能穿多少穿多少\n2、夏天：能穿多少穿多少"

tokenizer = AutoTokenizer.from_pretrained(model_name, trust_remote_code=True)
model = AutoModelForCausalLM.from_pretrained(
    model_name,
    trust_remote_code=True,
    torch_dtype="auto",
    low_cpu_mem_usage=True
).eval()

formatted_prompt = f"<reserved_106>{prompt}<reserved_107>"

print("格式化后的输入：", formatted_prompt)
inputs = tokenizer(formatted_prompt, return_tensors="pt").input_ids


# 流式输出
streamer = TextStreamer(tokenizer, skip_prompt=True)
print("\n模型回答：")
model.generate(inputs, streamer=streamer, max_new_tokens=500)