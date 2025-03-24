#!/usr/bin/env python3

import argparse
import sys
from openai import OpenAI
import os
import json
import tempfile

# session management0(multiple chats records save to /tmp/.ag_sessions.json)
SESSION_FILE = os.path.join(tempfile.gettempdir(), ".ag_sessions.json")

def load_session():
    if os.path.exists(SESSION_FILE):
        with open(SESSION_FILE, 'r') as f:
            return json.load(f)
    return {}

def save_session(session):
    with open(SESSION_FILE, 'w') as f:
        json.dump(session, f)

def clean_session():
    if os.path.exists(SESSION_FILE):
        os.remove(SESSION_FILE)

def parse_args():
    parser = argparse.ArgumentParser(
        description='AG - AI Command Line Assistant',
        add_help=False)
    
    model_default = os.getenv("AG_MODEL_DEFAULT")
    if model_default is None:
        model_default = "deepseek-r1"
    
    parser.add_argument('-m', '--model', 
                       default=model_default,
                       help=f'LLM model (default: {model_default})')
    parser.add_argument('-d', '--prompt',
                       nargs=argparse.REMAINDER,  # capture all args left
                       required=False,
                       help='Task description/prompt')
    parser.add_argument('--clean',
                       action='store_true',
                       help='Clear session history')
    parser.add_argument('-h', '--help',
                       action='store_true',
                       help='Show help message')
    
    args = parser.parse_args()
    
    # concatenate args after option -d into single string
    if args.prompt:
        args.prompt = ' '.join(args.prompt)
    
    return args


def process_request(model, api_key, prompt_text, input_data):
    input_data = input_data[:57000]
    # print(f'model = {model}, prompt = {prompt_text}, input_data = {input_data}')
    
    client = OpenAI(
        api_key=api_key,
        base_url="https://dashscope.aliyuncs.com/compatible-mode/v1"
    )

    session = load_session()
    messages = session.get(model, [])
    
    if prompt_text is not None:
        full_prompt = f"{prompt_text}:\n{input_data}"
    else:
        full_prompt = input_data

    messages.append({"role": "user", "content": full_prompt})

    try:
        completion = client.chat.completions.create(
            model=model,
            messages=messages,
            stream=True,
            extra_body={
                "result_format": "message",
                "incremental_output": True
            }
        )

        # streaming output handling
        print("="*20 + f" 🤖 ({model}) "+ "="*20)
        response_content = ""
        for chunk in completion:
            if chunk.choices:
                delta = chunk.choices[0].delta
                if delta.content:
                    print(delta.content, end='', flush=True)
                    response_content += delta.content
        print("\n")
        
        # save session
        messages.append({"role": "assistant", "content": response_content})
        session[model] = messages
        save_session(session)
        
    except Exception as e:
        print(f"\nError: {str(e)}")
        sys.exit(1)


def show_help():
    help_text = """
AG - AI Command Line Assistant powered by Aliyun AI SDK
Usage:
  [command] | ag -d [prompt]
  ag [options]

Options:
  -m, --model MODEL   Specify LLM model (default: deepseek-r1)
  -d, --prompt PROMPT Task description/prompt (required)
  --clean             Clear session history
  -h, --help          Show this help message

Examples:
  man read | ag -d "Translate to Chinese"
  ag --model gpt-o1 -d "Explain quantum computing"

Available Models:
  deepseek-r1 (default)
  qwen-long
  qwen-turbo
  qwen-max
  qwen-max-longcontext
  qwen-plus
"""
    print(help_text)

def main():
    args = parse_args()
    
    if args.help:
        show_help()
        sys.exit()
        
    if args.clean:
        clean_session()
        print("Session history cleared")
        sys.exit()

    # read stdin pipe input
    if not sys.stdin.isatty():
        input_data = sys.stdin.read()
    else:
        input_data = ''
        
    # if no input given
    if len(input_data) == 0 and args.prompt is None:
        show_help()
        sys.exit()

    api_key = os.getenv("AG_DASHSCOPE_API_KEY")
    if api_key is None:
        print("env AG_DASHSCOPE_API_KEY not provided.")
        sys.exit(1)

    process_request(args.model, api_key, args.prompt, input_data)

if __name__ == "__main__":
    main()