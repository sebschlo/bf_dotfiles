"source $HOME/master.vimrc

set shell=/bin/bash

" =================== VUNDLE =========================
set nocompatible              " be iMproved, required
filetype off                  " required

"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
let g:ycm_confirm_extra_conf = 0

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'flazz/vim-colorschemes'
"Plugin 'SirVer/ultisnips'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'tell-k/vim-autopep8'
"Plugin 'mbbill/undotree'
Plugin 'simnalamburt/vim-mundo'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-rbenv'
Plugin 'tpope/vim-bundler'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'slim-template/vim-slim.git'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'tomtom/tcomment_vim'
Plugin 'junegunn/goyo.vim'
Plugin 'jceb/vim-orgmode'
Plugin 'pangloss/vim-javascript'
Plugin 'dense-analysis/ale'
#Plugin 'Shougo/deoplete.nvim'
Plugin 'roxma/nvim-yarp'
Plugin 'roxma/vim-hug-neovim-rpc'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" COLOR
set term=screen-256color
set t_Co=256
set ttyfast
let g:airline_theme='violet'
"colorscheme horseradish256
colorscheme seoul256

set showtabline=0
let g:airline#extensions#tabline#enabled = 0
let g:autopep8_max_line_length=100
let g:NERDTreeWinSize=45
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 3
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_enable_on_vim_startup = 0

let g:ale_open_list = 1
let g:ale_linters = {'javascript': ['eslint'], 'javascriptreact': ['eslint']} 
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 0

let g:deoplete#enable_at_startup = 1

" SHORTCUTS
nnoremap <M-n> :bnext<CR>
nnoremap <M-p> :bprevious<CR>
nnoremap <M-u> :MundoToggle<CR>
nnoremap <M-h> :NERDTreeToggle<CR>
nnoremap <M-j> :NERDTreeFind<CR>
nnoremap <M-f> :Rg<CR>
nnoremap <M-o> :FZF<CR>
nnoremap <M-i> :IndentGuidesToggle<CR>
nnoremap <M-w> :q<CR>
nnoremap <M-b> :MBEToggle<CR>

"let g:ycm_global_ycm_extra_conf = '/Users/sebs/.vim/bundle/ycm_extra_conf_fbcode.py'
"let g:ycm_path_to_python_interpreter =
"
:set clipboard=unnamedplus,unnamed,autoselect,exclude:cons\|linux

" ================ General Config ====================

function! StartUp()
  if 0 == argc()
    NERDTree
  end
endfunction

autocmd VimEnter * call StartUp()

set number                      "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
set hidden

"turn on syntax highlighting
syntax on
"set colorcolumn=100

" ================ Turn Off Swap Files ==============
set noswapfile
set nobackup
set nowb

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo') && !isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

" ================ Indentation ======================
set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Auto indent pasted text
"nnoremap p p=`]<C-o>
"nnoremap P P=`]<C-o>

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

set wrap
"au BufRead,BufNewFile *.md setlocal wrap "Except for markdown
set linebreak    "Wrap lines at convenient points

" ================ Folds ============================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

"
" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1
set mouse=a

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

" ================= Copy/Paste =====================
" Visual mode yank selected area to tmux paste buffer (clipboard)
map <C-c> "zy:silent! call SendZBufferToHomeDotClipboard()<cr>
" Put from tmux clipboard
"map <C-v> :silent! call HomeDotClipboardPut()<cr>

function! SendZBufferToHomeDotClipboard()
  " Yank the contents buffer z to file ~/.clipboard and tmux paste buffer
  " For use with HomeDotClipboardPut()
  silent! redir! > ~/.clipboard
  silent! echo @z
  silent! redir END 
  " the redir has a newline in front, so tail -n+2
  skips first line
  silent! !tail -n+2 ~/.clipboard >
  ~/.clipboard.1;mv ~/.clipboard.1 ~/.clipboard
  silent! !tmux load-buffer ~/.clipboard
  silent! !sh ~/.tmux/yank.sh
  silent! redraw!
endfunction

function! HomeDotClipboardPut()
  " Paste/Put the contents of file
  ~/.clipboard
  " For use with
  SendZBufferToHomeDotClipboard()
  silent! !tmux save-buffer
  ~/.clipboard
  silent! redraw!
  silent! let @z =
  system("cat
  ~/.clipboard")
  " put the z
  buffer on the
  line below
  silent! exe
  "norm
  o\<ESC>\"zp"
endfunction
