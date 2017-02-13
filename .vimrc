" ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" ::::::::  NOTES ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
"
" Largely based off of these tutorials:
" - https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/
" - http://nvie.com/posts/how-i-boosted-my-vim/
"
" To start vim without using this .vimrc file, use:
"     vim -u NORC
" To start vim without loading any .vimrc or plugins, use:
"     vim -u NONE
"
" To remap capslock so that a tap = <Esc> and holding it with other letters =
" <Ctrl>, install Karabiner and check the boxes for:
"     - Control_L to Control_L: (+ When you type Control_L only, send Escape)
"     - Change Escape Key: Disable Escape



" ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" ::::::::  INSTALL PLUGINS ::::::::::::::::::::::::::::::::::::::::::::::::::
" ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set nocompatible   " required
filetype off       " required

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle (required)
Plugin 'VundleVim/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
Plugin 'benmills/vimux'                     " Allow vim to interact with tmux
Plugin 'blueyed/vim-diminactive'            " Dim inactive vim splits
Plugin 'christoomey/vim-tmux-navigator'     " Use same keys to move between tmux panes and vim splits
Plugin 'ctrlpvim/ctrlp.vim'                 " Search for almost anything from vim
Plugin 'jnurmine/Zenburn'                   " Color scheme
Plugin 'nvie/vim-flake8'                    " PEP8 checking
Plugin 'scrooloose/nerdtree'                " Add a file tree
Plugin 'scrooloose/syntastic'               " Syntax checking on save
Plugin 'tmhedberg/SimpylFold'               " Code folding
Plugin 'tmux-plugins/vim-tmux-focus-events' " Make FocusLost and FocusGained events work
Plugin 'tpope/vim-commentary'               " Toggle block comments with gc
Plugin 'tpope/vim-fugitive'                 " Run git within vim
Plugin 'tpope/vim-vinegar'                  " Do quicker simplified directory searching
Plugin 'Valloric/YouCompleteMe'             " Auto-completion
Plugin 'vim-scripts/indentpython.vim'       " Indentation

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Add powerline to vim from pip installed version of powerline. To get powerline set up:
" 1) While not in a virtualenv, run `pip install —user powerline-status`
" 2) Install a powerline-usable font so you can render the symbols correctly. I used
"    Inconsolata-g from here: https://github.com/powerline/fonts
" 3) Set that font as the ITerm2 default for non-ASCII text by going to
"    ITerms > Preferences > Profiles > Text > Change Font and changing 'Font' and
"   'Non-ASCII Font’ to use your chosen font
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup



" ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" ::::::::  CONFIGURE VIM SETTINGS :::::::::::::::::::::::::::::::::::::::::::
" ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set backspace=indent,eol,start " Allow backspacing over everything in insert mode
set clipboard=unnamed          " Use the system's clipboard by default
set colorcolumn=100            " Add ruler for line length; note that you'll want to add the
                               " following to ~/.config/flake8:   [flake8]
			       "                                  max-line-length = 100
set encoding=utf-8
" set foldlevel=99             " Don't fold anything by default
set hidden                     " Allow switching between buffers without saving and closing the first one
set hlsearch                   " Turn on highlighting for searches
set incsearch                  " Turn on incremental search highlighting for first match
set ignorecase                 " Ignore case if search pattern is all lowercase, otherwise use case sensitive (via 'set smartcase')
set mouse=n                    " Allow mouse usage in the GUI (e.g. for window resizing)
set noerrorbells               " Don't beep
set number                     " Turn on line numbers
set pastetoggle=<F2>           " Switch into 'paste mode' to prevent cascading indents on large pastes
set showmatch                  " Show matching parenthesis
set smartcase                  " Use case-sensitive search if a capital letter is in search term
set t_Co=256
set title                      " Turn on the title bar
set titleold=""                " Get rid of the 'Thanks for flying Vim' message
set titlestring=vim:\ %F       " Set the new title to the filename
set visualbell                 " Don't beep

let python_highlight_all=1     " Make code look pretty

colorscheme zenburn
syntax on                      " Make code look pretty

highlight ColorColumn ctermbg=236
highlight Normal ctermbg=239


" ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" ::::::::  CONFIGURE AUTO COMMANDS ::::::::::::::::::::::::::::::::::::::::::
" ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

" Add Python syntax highlighting for all .py* files
au BufNewFile,BufRead *.py.* set filetype=python

" Get standard four spaces on tabs and store file in unix format
au BufNewFile,BufRead *.py,*.py.*,*.yaml,*.yml
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |

" Do the same thing for front-end code
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |

" Trim whitespace on saving, preserving cursor position
function! TrimWhitespace()
    let l:save_cursor = getpos('.')
    %s/\s\+$//e
    call setpos('.', l:save_cursor)
endfun

autocmd BufWritePre * :call TrimWhitespace()



" ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" ::::::::  CONFIGURE PLUGIN SETTINGS ::::::::::::::::::::::::::::::::::::::::
" ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

" CtrlP; set file to ignore
set wildignore+=*/tmp/*,*.pyc,*/build/*,*/src/*

" NERDTree
let NERDTreeIgnore=['\.pyc$', '\~$', '^build$', '^dist$', '\.egg-info', '__pycache__', 'junit-py[0-9]\+\.xml$']

function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('py',    'darkgreen',   'none', 'darkgreen',    '#151515')
call NERDTreeHighlightFile('sql',   'red',         'none', 'red',          '#151515')
call NERDTreeHighlightFile('ipynb', 'darkmagenta', 'none', 'darkmagenta',  '#151515')
call NERDTreeHighlightFile('json' , 'blue',        'none', 'blue',         '#151515')
call NERDTreeHighlightFile('yml',   'yellow',      'none', 'yellow',       '#151515')
call NERDTreeHighlightFile('yaml',  'yellow',      'none', 'yellow',       '#151515')

" Powerline
set laststatus=2               " Always display the statusline in all windows
set showtabline=2              " Always display the tabline, even if there is only one tab
set noshowmode                 " Hide default mode text (e.g. -- INSERT -- below the statusline)

" Simpylfold
let g:SimpylFold_fold_import = 0
let g:SimpylFold_docstring_preview = 1
autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<

" Vim-diminactive
let g:diminactive_use_colorcolumn = 1   " Hide the color column when panes are out of focus
let g:diminactive_enable_focus = 1      " Dim when focus is lost

" Vim-flake8
let g:flake8_show_in_file=1
let g:flake8_show_in_gutter=1

" Vimux
let g:VimuxHeight = "40"       " Define Vimux new pane percent of screen size
let g:VimuxOrientation = "h"   " Define Vimux new pane split is right of current pane
let NERDTreeQuitOnOpen=1       " Quit NERDTree after opening a file

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1



" ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" :::::::: REMAP / ADD SHORTCUTS :::::::::::::::::::::::::::::::::::::::::::::
" ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

" Open / reload ~/.vimrc
nnoremap <leader>r :so $MYVIMRC<CR>
nnoremap <leader>v :e $MYVIMRC<CR>

" Switch between the two most recent tabs + add easier cycling
nnoremap <leader>s :b#<CR>
nnoremap <leader>b :bp<CR>
nnoremap <leader>f :bn<CR>

" Remap the typical d and x to the 0 register and \d and \x to the clipboard
nnoremap d "0d
nnoremap <leader>d "*d
nnoremap x "0x
nnoremap <leader>x "*x
vnoremap d "0d
vnoremap <leader>d "*d
vnoremap x "0x
vnoremap <leader>x "*x
nnoremap <leader>p "0p
nnoremap <leader>P "0P

" Clear search buffer with ,/
nnoremap <silent> ,/ :nohlsearch<CR>

" Enable folding with the spacebar
nnoremap <space> za

nnoremap <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>\ :NERDTreeToggle<CR>

" Quick movement between buffers
let c = 1
while c < 10
    execute "nnoremap <leader>" . c . " :b" . c. "<CR>"
    let c += 1
endwhile

nnoremap ; :
nnoremap : ;

" Copy code to the clipboard and send it to other pane. You also need to
" `brew install reattach-to-user-namespace` in order for vim to access the
" OSX clipboard within tmux
vnoremap <leader>t "+y:call VimuxRunCommand("%paste")<CR>

" Increase / Decrease fold levels
function! IncreaseFoldLevel()
  let foldlevel = &foldlevel
  exec 'set foldlevel=' . (&foldlevel + 1)
endfunc
nnoremap <leader>m :call IncreaseFoldLevel()<CR>

function! DecreaseFoldLevel()
  let foldlevel = &foldlevel
  exec 'set foldlevel=' . (&foldlevel - 1)
endfunc
nnoremap <leader>l :call DecreaseFoldLevel()<CR>

" Toggle pane maximization
function! MaximizeToggle()
  if exists("s:maximize_session")
    exec "source " . s:maximize_session
    call delete(s:maximize_session)
    unlet s:maximize_session
    let &hidden=s:maximize_hidden_save
    unlet s:maximize_hidden_save
  else
    let s:maximize_hidden_save = &hidden
    let s:maximize_session = tempname()
    set hidden
    exec "mksession! " . s:maximize_session
    only
  endif
endfunction

nnoremap <leader>z :call MaximizeToggle()<CR>
