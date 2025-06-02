" vim settings
set ruler
set number
set nowrap
set mouse=a
set showcmd
set showmode
set nobackup
set hlsearch
set smarttab
set syntax=on
set incsearch
set showmatch
set expandtab
set linebreak
set ignorecase
set noswapfile
set guicursor=
set scrolloff=4
set smartindent
set cursorline
set nocursorcolumn
filetype on
filetype plugin on
filetype indent on
set encoding=UTF-8
set clipboard=unnamedplus
set statusline=
set laststatus=2
set statusline+=%=
set statusline+=\ %F\ %M\ %Y\ %R
set statusline+=\ %l\ \ %c\ \ %p%%
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" Plugins
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdcommenter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'preservim/nerdtree'

call plug#end()

colorscheme catppuccin_macchiato

highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

set grepprg=rg\ --vimgrep\ --smart-case\ --follow

let mapleader = " "
nnoremap <C-p> :Files<Cr>
nnoremap <C-Q> :Rg<Cr>

nnoremap <leader>b :Buffer<CR>

function! TogglePaste()
    if(&paste == 0)
        set paste
        echo "Paste Mode Enabled"
    else
        set nopaste
        echo "Paste Mode Disabled"
    endif
endfunction

map <leader>p :call TogglePaste()<cr>

let NERDTreeShowHidden=1
function! NerdTreeToggleFind()
    if exists("g:NERDTree") && g:NERDTree.IsOpen()
        NERDTreeClose
    elseif filereadable(expand('%'))
        NERDTreeFind
    else
        NERDTree
    endif
endfunction

nnoremap <C-n> :call NerdTreeToggleFind()<CR>
autocmd BufEnter * if (winnr("$") == 1 && exists("g:NERDTree") && g:NERDTree.IsOpen()) | quit | endif
