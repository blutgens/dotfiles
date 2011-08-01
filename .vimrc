"------------------------------------------------------------------------
" Enable the use of the mouse for certain terminals.
"------------------------------------------------------------------------
if &term =~ "xterm"
	set t_Co=256
    colorscheme dante
endif
if &term =~ "linux"
	unset t_Co
	colorscheme default
endif
	
"
"------------------------------------------------------------------------
" Use of dictionaries
"------------------------------------------------------------------------
set complete+=k         " scan the files given with the 'dictionary' option
"
"------------------------------------------------------------------------
" Various settings
"------------------------------------------------------------------------
set noai
set ruler
set autoread            " read open files again when changed outside Vim
set autowrite           " write a modified buffer on each :next , ...
set browsedir=current   " which directory to use for the file browser
set incsearch           " use incremental search
set hlsearch			" highlight search
set shiftwidth=4        " number of spaces to use for each step of indent
set tabstop=4      		" number of spaces that a <Tab> in the file counts for
set expandtab			" convert tabs to spaces
"set textwidth=80
set shiftround			" always indent/outdent to nearest tabstop
set nodigraph
set modeline
set modelines=3
set visualbell            
syntax on
set shortmess=Iat
so $VIMRUNTIME/menu.vim
set background=dark
set report=0
set laststatus=2
set suffixes=.bak,~,.swp,.o,.info,.aux,.dvi,.idx,.out,.toc
"set foldcolumn=0
set backupdir=~/.vim/backup
set directory=~/.vim/backup
set list listchars=tab:▷⋅,trail:⋅,nbsp:⋅
set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\
            \ [%l/%L\ (%p%%)


set backspace=2
let loaded_matchparen = 1
"

au FileType spec map <buffer> <F5> <Plug>AddChangelogEntry
filetype plugin indent on
au FileType py set autoindent
au FileType py set smartindenD_tree config
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\.vim$', '\~$', '\.pyc$', '\.swp$']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\~$']
let NERDTreeShowBookmarks=1
map <F3> :NERDTreeToggle<CR>

" Syntax for multiple tag files are
" set tags=/my/dir1/tags, /my/dir2/tags
set tags=tags;$HOME/.vim/tags/

" TagList Plugin Configuration
let Tlist_Ctags_Cmd='/usr/bin/ctags'
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1
let Tlist_Use_Right_Window = 1
let Tlist_File_Fold_Auto_Close = 1
map <F7> :TlistToggle<CR>

" Viewport Controls
" ie moving between split panes
map <silent>,h <C-w>h
map <silent>,j <C-w>j
map <silent>,k <C-w>k
map <silent>,l <C-w>l

au FileType py set textwidth=79 " PEP-8 Friendly


"========================================================================
"------------------------------------------------------------------------
" Fast switching between buffers
" The current buffer will be saved before switching to the next one.
" Choose :bprevious or :bnext
"------------------------------------------------------------------------
 map  <silent> <s-tab>  <Esc>:if &modifiable && !&readonly && 
     \                  &modified <CR> :write<CR> :endif<CR>:bprevious<CR>
imap  <silent> <s-tab>  <Esc>:if &modifiable && !&readonly && 
     \                  &modified <CR> :write<CR> :endif<CR>:bprevious<CR>
nmap  <C-q>    :wqa<CR>
set wildmenu
set wildignore=*.bak,*.o,*.e,*~
"
