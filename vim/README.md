## Vim Configuration Guide

```bash
git clone https://github.com/XUranus/scripts
mkdir -p ~/.vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
cp scripts/vim/.vimrc ~/.vimrc
cp scripts/vim/coc-settings.json ~/.vim/coc-settings.json
```

enter vim and execute in command mode:
```bash
PlugInstall
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
