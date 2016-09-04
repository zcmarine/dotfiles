" Largely based off of these tutorials:
" - https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/
" - http://nvie.com/posts/how-i-boosted-my-vim/
"
" To start vim without using this .vimrc file, use:
"     vim -u NORC
" To start vim without loading any .vimrc or plugins, use:
"     vim -u NONE

set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
" Plugin 'gmarik/Vundle.vim'
Plugin 'VundleVim/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
Plugin 'tmhedberg/SimpylFold'              " Code folding
Plugin 'vim-scripts/indentpython.vim'      " Indentation
Plugin 'Valloric/YouCompleteMe'            " Auto-completion
Plugin 'scrooloose/syntastic'              " Syntax checking on save
Plugin 'nvie/vim-flake8'                   " PEP8 checking
Plugin 'jnurmine/Zenburn'                  " Color scheme
Plugin 'altercation/vim-colors-solarized'  " Color scheme
Plugin 'scrooloose/nerdtree'               " Add a file tree
Plugin 'jistr/vim-nerdtree-tabs'           " Allow tab usage
Plugin 'ctrlpvim/ctrlp.vim'                " Search for almost anything from vim
Plugin 'tpope/vim-fugitive'                " Run git within vim
Plugin 'powerline/powerline'               " Add status/tabline


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Add virtualenv support (alternative: use jmcantrell/vim-virtualenv Plugin)
"py << EOF
"import os
"import sys
"if 'VIRTUAL_ENV' in os.environ:
"  project_base_dir = os.environ['VIRTUAL_ENV']
"  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"  execfile(activate_this, dict(__file__=activate_this))
"EOF

" Simplify shortcuts in split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap ; :

" Clear search buffer with ,/
nmap <silent> ,/ :nohlsearch<CR>

" Enable folding with the spacebar
nnoremap <space> za

" Allow switching between buffers without saving and closing the first one
set hidden

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Show matching parenthesis
set showmatch

" Ignore case when searching
set ignorecase

" Ignore case if search pattern is al lowercase; case-sensitive otherwise
set smartcase

" Don't beep
set visualbell
set noerrorbells

" Change terminal's title
set title

" Switch into 'paste mode' to prevent cascading indents on large pastes
set pastetoggle=<F2>

" Enable folding
set foldmethod=indent
set foldlevel=99

set encoding=utf-8

" Turn on line numbers
set nu

" Make OSX clipboard accessible by vim
set clipboard=unnamed

" Turn on highlighting for searches
set hls

" Add ruler for line length
set colorcolumn=78

" Make code look pretty
let python_highlight_all=1
syntax on

" Ensure auto-complete goes away after completion
let g:ycm_autoclose_preview_window_after_completion=1

" ignore .pyc files in NERDTree
let NERDTreeIgnore=['\.pyc$', '\~$']

" ignore .pyc files in CtrlP
set wildignore+=*/tmp/*,*.pyc,*/build/*,*/src/*

" show Flake8 markers in file
let g:flake8_show_in_file=1


" Definition comes up with <space>+g
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Simplify NERDTree shortcut
map <leader>kb  :NERDTree<CR>

" See docstrings for folded code
"let g:SimpylFold_docstring_preview=1

" Get standard four spaces on tabs, ensure line lengths don't pass 80
" characters, and store file in unix format
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    " \ set textwidth=79 |  " remove this to prevent text wrapping
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |

" Do the same thing for front-end code
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |

" Auto-run Flake8 on every .py save
" autocmd BufWritePost *.py call Flake8()

" Flag unnecessary whitespace
highlight BadWhitespace ctermbg=red guibg=red
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Define color scheme to use based upon VIM mode
" colorscheme solarized
colorscheme zenburn

" Switch between light and dark Solarized color theme with F5
call togglebg#map("<F5>")
