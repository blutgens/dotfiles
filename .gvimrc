set guifont=Monospace\ 9
colorscheme desert
set background=dark
if has("gui_running")
  " GUI is running or is about to start.
  " Maximize gvim window.
  set lines=999 columns=120
  au VimEnter *  NERDTree
else
  " This is console Vim.
  if exists("+lines")
    set lines=50
  endif
  if exists("+columns")
    set columns=120
  endif
endif

