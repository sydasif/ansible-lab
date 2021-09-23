" YAML Setting for ansible
autocmd FileType yaml setlocal et ts=2 ai sw=2 sts=0                                                                                                        2 autocmd FileType yaml setlocal et ts=2 ai sw=2 sts=0
set cursorline
set number
syntax on
" Defaults setting
set nocompatible    " Use Vim settings, rather than Vi settings
colorscheme zellner " Set nice looking colorscheme
set nobackup        " Disable backup files
set laststatus=2    "show status line
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\
set wildmenu        " Display command line's tab complete options as a menu.