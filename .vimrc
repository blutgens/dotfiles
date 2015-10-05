if has("gui_running")
  " GUI is running or is about to start.
    set guifont=Terminus\ 9
    colorscheme flattr
  set lines=48 columns=90
endif


if &term =~ "xterm"
	set t_Co=256
    colorscheme flattr
endif
if &term =~ "linux"
	unset t_Co
	colorscheme molokai
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
set cursorline
set noai
set ruler
set autoread            " read open files again when changed outside Vim
set autowrite           " write a modified buffer on each :next , ...
set browsedir=current   " which directory to use for the file browser
set incsearch           " use incremental search
set hlsearch			" highlight search
set shiftwidth=4        " number of spaces to use for each step of indent
set tabstop=4           " number of spaces that a <Tab> in the file counts for
set softtabstop=4       " number of spaces in tab when editing
set expandtab			" convert tabs to spaces
set textwidth=80
set shiftround			" always indent/outdent to nearest tabstop
set nodigraph
set modeline
set modelines=3
set visualbell
syntax on
set shortmess=Iat
if !empty(glob("$VIMRUNTIME/menu.vim"))
    so $VIMRUNTIME/menu.vim
endif
set background=dark
set report=0
set laststatus=2
set suffixes=.bak,~,.swp,.o,.info,.aux,.dvi,.idx,.out,.toc
set foldcolumn=0
set backupdir=~/.vim/backup
set directory=~/.vim/backup
set list listchars=tab:▷⋅,trail:⋅,nbsp:⋅
set statusline=%t\ %y\ format:\ %{&ff};\ [%c,%l]
set backspace=2
let loaded_matchparen = 1
filetype plugin indent on
au FileType py set autoindent
" Viewport Controls
" ie moving between split panes
map <silent>,h <C-w>h
map <silent>,j <C-w>j
map <silent>,k <C-w>k
map <silent>,l <C-w>l

au FileType py set textwidth=79 " PEP-8 Friendly


"------------------------------------------------------------------------
" Fast switching between buffers
" The current buffer will be saved before switching to the next one.
" Choose :bprevious or :bnext
"------------------------------------------------------------------------
 map  <silent> <S-tab>  <Esc>:if &modifiable && !&readonly && 
     \                  &modified <CR> :write<CR> :endif<CR>:bprevious<CR>
imap  <silent> <S-tab>  <Esc>:if &modifiable && !&readonly && 
     \                  &modified <CR> :write<CR> :endif<CR>:bprevious<CR>
nmap  <C-q>    :wqa<CR>
set wildmenu
set wildignore=*.bak,*.o,*.e,*~
set number
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
autocmd FileType python set complete+=k~/.vim/syntax/python.vim isk+=.,(
"
noremap <F5> <ESC>:w<CR>:silent execute "!python %"<CR><CR>

au BufEnter *.py if getline(1) == "" | :call setline(1, "#!/usr/bin/env python") | endif
" Automatically chmod +x Shell and Perl scripts
au BufWritePost   *.sh              silent !chmod +x %
au BufWritePost   *.pl              silent !chmod +x %
au BufWritePost   *.py              silent !chmod +x %


" Append modeline after last line in buffer.
" " Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" " files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
  endfunction
  nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
