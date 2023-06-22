set nocompatible "do not compatible with vi

set number! "show line number 
set expandtab
set autoindent  "set auto indent
set cindent  "set clang auto indent
set shiftwidth=4 
set softtabstop=4
set tabstop=4 

syntax on "set syntax highlight
autocmd BufNewFile,BufRead *.c set syntax=c

set cursorline "highlight current line
set showmatch "highlight bracket matching
set showmode "show current op mode at bottom
set bg=dark "set background color

set hlsearch "highlight search result


call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-default branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'

" coc.vim
Plug 'neoclide/coc.nvim', { 'branch': 'master', 'do': 'yarn install --frozen-lockfile' }

" Initialize plugin system
call plug#end()



autocmd BufNewFile *.html 0r ~/.vim/template/template.html

" call setTitle() automatically when create .h .c .hpp .cpp .sh .py
autocmd BufNewFile *.[ch],*.hpp,*.cpp,*.sh,*.py exec ":call SetTitle()"
" add comment
func SetComment()
    call setline(1,"/*================================================================")
    call append(line("."),   "*   Copyright (C) ".strftime("%Y")." XUranus All rights reserved.")
    call append(line(".")+1, "*   ")
    call append(line(".")+2, "*   File:         ".expand("%:t"))
    call append(line(".")+3, "*   Author:       XUranus")
    call append(line(".")+4, "*   Date:         ".strftime("%Y-%m-%d"))
    call append(line(".")+5, "*   Description:  ")
    call append(line(".")+6, "*")
    call append(line(".")+7, "================================================================*/")
    call append(line(".")+8, "")
    call append(line(".")+9, "")
endfunc
" comment for *.sh, *.py
func SetComment_script()
    call setline(3,"#*================================================================")
    call setline(4, "#*   Copyright (C) ".strftime("%Y")." XUranus All rights reserved.")
    call setline(5, "#*   ")
    call setline(6, "#*   File:         ".expand("%:t"))
    call setline(7, "#*   Author:       XUranus")
    call setline(8, "#*   Date:         ".strftime("%Y-%m-%d"))
    call setline(9, "#*   Description:  ")
    call setline(10, "#*")
    call setline(11, "#================================================================*/")
    call setline(12, "")
    call setline(13, "")
endfunc

" auto insert to head of file
func SetTitle()
    if &filetype == 'sh'
        call setline(1,"#!/usr/bin/bash")
        call setline(2,"")
        call SetComment_script()
    elseif &filetype == 'python'
        call setline(1,"#!/usr/bin/python")
        call setline(2,"")
        call SetComment_script()
    else
        call SetComment()
        if expand("%:e") == 'hpp'
            call append(line(".")+10, "#ifndef _".toupper(expand("%:t:r"))."_H")
            call append(line(".")+11, "#define _".toupper(expand("%:t:r"))."_H")
            call append(line(".")+12, "#ifdef __cplusplus")
            call append(line(".")+13, "extern \"C\"")
            call append(line(".")+14, "{")
            call append(line(".")+15, "#endif")
            call append(line(".")+16, "")
            call append(line(".")+17, "#ifdef __cplusplus")
            call append(line(".")+18, "}")
            call append(line(".")+19, "#endif")
            call append(line(".")+20, "#endif //".toupper(expand("%:t:r"))."_H")

        elseif expand("%:e") == 'h'
            call append(line(".")+10, "#pragma once")
        elseif &filetype == 'c'
            call append(line(".")+10,"#include \"".expand("%:t:r").".h\"")
        elseif &filetype == 'cpp'
            call append(line(".")+10, "#include \"".expand("%:t:r").".h\"")
        endif
    endif
endfunc
