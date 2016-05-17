if has("gui_running")
  " GUI is running or is about to start.
    set guifont=Terminus\ 10
    colorscheme badwolf
  set lines=72 columns=140
elseif &term =~ "xterm"
	set t_Co=256
    colorscheme badwolf
elseif &term =~ "linux"
	unset t_Co
	colorscheme badwolf
endif

set complete+=k         " scan the files given with the 'dictionary' option
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
" in case this doesn't exist, don't load it. 
if !empty(glob("$VIMRUNTIME/menu.vim"))
    so $VIMRUNTIME/menu.vim
endif
execute pathogen#infect()
set background=dark
set report=0
set laststatus=2
set suffixes=.bak,~,.swp,.o,.info,.aux,.dvi,.idx,.out,.toc
set foldcolumn=0
set backupdir=~/.vim/backup
set directory=~/.vim/backup
set list listchars=tab:▷⋅,trail:⋅,nbsp:⋅
"set statusline=%t\ %y\ format:\ %{&ff};\ [%c,%l]----%{fugitive#statusline()}
set statusline=%t\ %y\ fmt:\ %{&ff};\ [%c,%l]

" Include Git info on statusline if fugitive is present
set statusline+=--%{exists('g:loaded_fugitive')?fugitive#statusline():''}
"set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}
"
autocmd Filetype gitcommit setlocal spell textwidth=72

autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <F4> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

noremap <F6> :set invnumber<CR>
noremap <F6> <C-O>:set invnumber<CR>

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

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
au BufRead,BufNewFile ~/ansible-plays/*.yml set ft=ansible
let g:ansible_options = {'ignore_blank_lines': 0,'{documentation_mapping': '<C-K>'}



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
"noremap <F5> <ESC>:w<CR>:silent execute "!python %"<CR><CR>

"au BufEnter *.py if getline(1) == "" | :call setline(1, "#!/usr/bin/env python") | endif
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
