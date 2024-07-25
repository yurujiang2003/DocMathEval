#!/bin/bash

export CUDA_VISIBLE_DEVICES=0,1,2,3 # 4 * A100-80G
export PYTHONPATH=$PYTHONPATH:$(pwd)

models=(
  # gemma
  google/gemma-2b-it
  google/gemma-7b-it
  # google/gemma-2-9b-it
  # google/gemma-2-27b-it
  # Llama
  "meta-llama/Llama-2-7b-chat-hf"
  "meta-llama/Llama-2-70b-chat-hf"

  "meta-llama/Meta-Llama-3-8B-Instruct"
  "meta-llama/Meta-Llama-3-70B-Instruct"

  "meta-llama/Meta-Llama-3.1-8B-Instruct"
  "meta-llama/Meta-Llama-3.1-70B-Instruct"
  # Phi-3
  "microsoft/Phi-3-medium-128k-instruct"
  "microsoft/Phi-3-mini-128k-instruct"
  # Yi
  '01-ai/Yi-1.5-34B-Chat'
  '01-ai/Yi-1.5-9B-Chat'
  # Deepseek
  'deepseek-ai/DeepSeek-V2-Chat' # MOE OOM, requires 8 * 80G
  'deepseek-ai/DeepSeek-V2-Lite-Chat'
  'deepseek-ai/DeepSeek-Coder-V2-Lite-Instruct'
  'deepseek-ai/deepseek-coder-33b-instruct'
  'deepseek-ai/deepseek-math-7b-instruct'

  # Qwen
  'Qwen/Qwen2-7B-Instruct'
  'Qwen/Qwen2-72B-Instruct-AWQ'



  # Mistral
  'mistralai/Codestral-22B-v0.1'
  'mistralai/Mixtral-8x7B-Instruct-v0.1' # MOE
  'MaziyarPanahi/Mixtral-8x22B-Instruct-v0.1-AWQ' # MOE together AI, requires together ai
  'mistralai/Mistral-7B-Instruct-v0.3'

  # InternLM
  'internlm/internlm2-math-plus-7b'
  'internlm/internlm2-chat-7b'

  # wizardMath
  'WizardLMTeam/WizardMath-7B-V1.1'
  'MaziyarPanahi/WizardLM-2-8x22B-AWQ'
  'lucyknada/microsoft_WizardLM-2-7B'
  'WizardLMTeam/WizardCoder-33B-V1.1'

  # starcoder 2
  'bigcode/starcoder2-15b-instruct-v0.1'

  # Command R
  'alpindale/c4ai-command-r-plus-GPTQ'
  'CohereForAI/aya-23-8B'
  'CohereForAI/aya-23-35B'
  # dbrx
  'databricks/dbrx-instruct' # MOE, OOM, together ai api
  # chatglm
  'THUDM/chatglm3-6b'
  'THUDM/glm-4-9b-chat'
)

sets=(
  "compshort_testmini"
  "compshort_test"
  "simpshort_testmini"
  "simpshort_test"
  "simplong_testmini"
  "simplong_test"
)

for model in "${models[@]}"; do
  for set in "${sets[@]}"; do
    echo "Running inference for model: $model on $set"
    ret=""

    python run_llm.py \
        --model_name "$model" \
        --gpu_memory_utilization 0.9 \
        --prompt_type cot \
        --output_dir outputs \
        --subset "$set" \
        --max_tokens 512
      
    python run_llm.py \
        --model_name "$model" \
        --gpu_memory_utilization 0.9 \
        --prompt_type pot \
        --output_dir outputs \
        --subset "$set" \
        --max_tokens 512
  done
done