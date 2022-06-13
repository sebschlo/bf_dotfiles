set shell=/bin/bash

" =================== VIMPLUG =========================
call plug#begin('~/.local/share/nvim/plugged')

Plug 'VundleVim/Vundle.vim'
Plug 'scrooloose/nerdtree'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'flazz/vim-colorschemes'
Plug 'tell-k/vim-autopep8'
Plug 'simnalamburt/vim-mundo'
Plug 'fholgado/minibufexpl.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'davidhalter/jedi-vim'
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'tomtom/tcomment_vim'
Plug 'junegunn/goyo.vim'
Plug 'jceb/vim-orgmode'
Plug 'pangloss/vim-javascript'
Plug 'dense-analysis/ale'
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'

call plug#end()

"==================  COLOR ============================
"set term=screen-256color
set t_Co=256
set ttyfast
let g:airline_theme='violet'
colorscheme horseradish256
"colorscheme seoul256

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

let g:python3_host_prog = '/opt/miniconda3/bin/python'
let g:deoplete#enable_at_startup = 1


" SHORTCUTS
" n
nnoremap <C-N> :bnext<CR>
" p
nnoremap <C-P> :bprevious<CR>
" u
nnoremap õ :MundoToggle<CR>
" h
nnoremap <C-T> :NERDTreeToggle<CR>
" j
nnoremap ê :NERDTreeFind<CR>
" f
"nnoremap <C-R> :Rg<CR>
" o
nnoremap <C-R> :FZF<CR>
" i
nnoremap é :IndentGuidesToggle<CR>
" w
nnoremap ÷ :q<CR>
" b
nnoremap â :MBEToggle<CR>
" c
nnoremap ã :e ~/.config/nvim/init.vim<CR>

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
set clipboard=unnamed
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
