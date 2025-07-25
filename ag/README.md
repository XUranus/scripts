# AI Agent


![](Screenshot.png)


```
AG - AI Command Line Assistant powered by Aliyun AI SDK
Usage:
  [command] | ag -d [prompt]
  ag [options]

Options:
  -m, --model MODEL     Specify LLM model (default: deepseek-r1)
  -d, --prompt PROMPT   Task description/prompt (required)
  -s, --session SESSION Switch to or create a new session to use
  -S, --select SESSION  Select session to use
  -r, --recover         Recover dialog in current session
  -c, --clean SESSION   Clear session history
  --plain               Plain text output
  -h, --help            Show this help message

Examples:
  Basics:
    man read | ag -d "Translate to Chinese"
    ag --model gpt-o1 -d "Explain quantum computing"

  Switch sessions:
    ag -s machine_learning
    ag -d what is machine learning
    ag -d tell me some algorithms about machine learning
    clear && ag -s rust_dev
    ag -d tell me how to install rust on archlinux
    clear && ag -s machine_learning
    ag --recover
    ag --clean=all

Available Models:
  deepseek-r1 (default)
  qwen-long
  qwen-turbo
  qwen-max
  qwen-max-longcontext
  qwen-plus
```


### install
```bash
sudo pip install openai python-dotenv tabulate pyfzf -i https://pypi.tuna.tsinghua.edu.cn/simple
```

```bash
# ~/zsh.rc
export AG_DASHSCOPE_API_KEY="sk-1234567890987654321" # Aliyun key
export AG_MODEL_DEFAULT="deepseek-r1"
alias ag='python3 $HOME/scripts/ag/ag.py'
```
