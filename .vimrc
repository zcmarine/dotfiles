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
set t_Co=256

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
Plugin 'tpope/vim-vinegar'                 " Do quicker simplified directory searching
Plugin 'tpope/vim-commentary'              " Toggle block comments with gc
Plugin 'benmills/vimux'                    " Allow vim to interact with tmux

" Add powerline status/tabline
" Make sure to install a font with Powerline's symbols
" from here (I used Inconsolata-g): https://github.com/powerline/fonts
" You'll then have to set that font as the terminal/ITerm2
" default for non-ASCII text in Preferences
Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}  " Add status/tabline

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Simplify shortcuts in split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Switch between the two most recent tabs + add easier cycling
nnoremap <leader>s :b#<CR>
nnoremap <leader>b :bp<CR>
nnoremap <leader>f :bn<CR>

" Create a real delete command (not just a cut)
nnoremap <leader>d "_d

" Clear search buffer with ,/
nnoremap <silent> ,/ :nohlsearch<CR>

" Enable folding with the spacebar
nnoremap <space> za

" Definition comes up with <space>+g
nnoremap <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Toggle NERDTree
nnoremap <leader>kb :NERDTreeToggle<CR>

" Quick movement between buffers
let c = 1
while c < 10
    execute "nnoremap <leader>" . c . " :b" . c. "<CR>"
    let c += 1
endwhile

nnoremap ; :
nnoremap : ;

" Copy code to the clipboard and send it to other pane. You also need
" to `brew install reattach-to-user-namespace` in order for vim to
" access the OSX clipboard within tmux
vnoremap <leader>t "+y:call VimuxRunCommand("%paste")<CR>

" define the parameters for a new pane if Vimux has to create one
let g:VimuxHeight = "40"       " percent of screen size
let g:VimuxOrientation = "h"   " split to the right from the current pane

" Allow switching between buffers without saving and closing the first one
set hidden

" Allow the mouse to be used in the GUI (e.g. for window resizing)
set mouse=n

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

" Add ruler for line length; note that you'll want to add the following to
" ~/.config/flake8 as well:
"     [flake8]
"     max-line-length = 100
set colorcolumn=100

" Powerline settings
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

" ignore .pyc files in CtrlP
set wildignore+=*/tmp/*,*.pyc,*/build/*,*/src/*

" Make code look pretty
let python_highlight_all=1
syntax on
" add Python syntax highlighting for all .py* files
au BufNewFile,BufRead *.py.* set filetype=python

" Ensure auto-complete goes away after completion
let g:ycm_autoclose_preview_window_after_completion=1

" ignore .pyc files in NERDTree
let NERDTreeIgnore=['\.pyc$', '\~$']

" show Flake8 markers in file and gutter
let g:flake8_show_in_file=1
let g:flake8_show_in_gutter=1

" Remap leader with: let mapleader = ","


" See docstrings for folded code
"let g:SimpylFold_docstring_preview=1

" Get standard four spaces on tabs, ensure line lengths don't pass 80
" characters, and store file in unix format
au BufNewFile,BufRead *.py,*.py.*,*.yaml,*.yml
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

" Highlight NERDTree .py files
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('py', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('sql', 'red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('ipynb', 'blue', 'none', 'blue', '#151515')

" Define function to save cursor position, trim trailing white space, and restore cursor position
fun! TrimWhitespace()
    let l:save_cursor = getpos('.')
    %s/\s\+$//e
    call setpos('.', l:save_cursor)
endfun

" Trim whitespace when saving
autocmd BufWritePre * :call TrimWhitespace()
