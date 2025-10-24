#!/bin/bash

# Backup existing .vimrc if it exists
if [ -f ~/.vimrc ]; then
    cp ~/.vimrc ~/.vimrc.backup.$(date +%Y%m%d_%H%M%S)
    echo "Backed up existing .vimrc"
fi

# Create/update .vimrc with enhanced configuration
cat << 'EOF' > ~/.vimrc
" ============================================================================
" General Settings
" ============================================================================

" Show line numbers
set number
set relativenumber

" Enable syntax highlighting
syntax on

" Show cursor position at the bottom
set ruler

" Highlight current line
set cursorline

" Enable mouse support
set mouse=a

" Show matching brackets
set showmatch

" Enable incremental search
set incsearch

" Highlight search results
set hlsearch

" Ignore case when searching
set ignorecase
set smartcase

" Enable auto-indentation
set autoindent
set smartindent

" ============================================================================
" Tab and Indentation Settings
" ============================================================================

" Set tab to 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4

" ============================================================================
" UI Enhancements
" ============================================================================

" Enable line wrapping
set wrap
set linebreak

" Show command in bottom bar
set showcmd

" Visual autocomplete for command menu
set wildmenu
set wildmode=longest:full,full

" Better backspace behavior
set backspace=indent,eol,start

" Display status line always
set laststatus=2

" Enhanced status line
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime('%Y/%m/%d\ %H:%M')}

" ============================================================================
" File and Buffer Settings
" ============================================================================

" Enable filetype detection
filetype on
filetype plugin on
filetype indent on

" Auto-read when file is changed from outside
set autoread

" Disable backup files
set nobackup
set nowritebackup
set noswapfile

" UTF-8 encoding
set encoding=utf-8
set fileencoding=utf-8

" ============================================================================
" Performance Settings
" ============================================================================

" Faster redrawing
set ttyfast

" Reduce update time
set updatetime=300

" Don't pass messages to ins-completion-menu
set shortmess+=c

" ============================================================================
" Code Folding
" ============================================================================

" Enable folding
set foldenable
set foldmethod=indent
set foldlevelstart=10
set foldnestmax=10

" ============================================================================
" Key Mappings
" ============================================================================

" Set leader key to space
let mapleader = " "

" Clear search highlighting with Esc
nnoremap <Esc> :noh<CR>

" Quick save
nnoremap <leader>w :w<CR>

" Quick quit
nnoremap <leader>q :q<CR>

" Quick save and quit
nnoremap <leader>x :x<CR>

" Split navigation shortcuts
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" ============================================================================
" Color Scheme
" ============================================================================

" Enable 256 colors
set t_Co=256

" Set colorscheme (default is used, uncomment if you have a specific one)
" colorscheme desert

" Set background
set background=dark

" ============================================================================
" Programming Specific
" ============================================================================

" Show whitespace characters
set list
set listchars=tab:→\ ,trail:·,extends:>,precedes:<,nbsp:+

" Highlight column 80
set colorcolumn=80

" Auto-close brackets (basic)
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap ' ''<Left>
inoremap " ""<Left>

" ============================================================================
" Clipboard Support
" ============================================================================

" Use system clipboard
if has('clipboard')
    set clipboard=unnamed,unnamedplus
endif

" ============================================================================
" Undo Persistence
" ============================================================================

" Keep undo history across sessions
if has('persistent_undo')
    set undodir=~/.vim/undodir
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

EOF

# Create undo directory if persistent undo is supported
mkdir -p ~/.vim/undodir

echo "=========================================="
echo "Vim configuration completed successfully!"
echo "=========================================="
echo ""
echo "Key features added:"
echo "  - Line numbers and relative numbers"
echo "  - Syntax highlighting and color scheme"
echo "  - Smart search (incremental, case-insensitive)"
echo "  - Auto-indentation"
echo "  - Enhanced status line"
echo "  - Code folding support"
echo "  - Custom key mappings (leader key: Space)"
echo "  - Clipboard integration"
echo "  - Persistent undo history"
echo "  - Whitespace visualization"
echo "  - Auto-closing brackets"
echo ""
echo "Restart Vim for changes to take effect."
echo ""
echo "Useful shortcuts:"
echo "  Space+w : Quick save"
echo "  Space+q : Quick quit"
echo "  Space+x : Save and quit"
echo "  Esc     : Clear search highlighting"
echo "  Ctrl+h/j/k/l : Navigate between splits"
echo ""
echo "Previous .vimrc backed up with timestamp."
echo "=========================================="

