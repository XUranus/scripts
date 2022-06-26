## Vim Configuration Guide

```bash
git clone https://github.com/XUranus/scripts
mkdir -p ~/.vim
cp scripts/.vimrc ~/.vimrc
cp scripts/coc-settings.json ~/.vim/coc-settings.json
```

enter vim and execute:
```bash
PluginInstall
CocInstall coc-sh
CocInstall coc-clangd  
CocInstall coc-cmake
CocInstall coc-rust-analyzer
CocInstall coc-json
CocInstall coc-webview
CocInstall coc-markdown-preview-enhanced
CocInstall coc-markmap
CocInstall coc-explorer
```
