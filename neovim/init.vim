set number
set shiftwidth=4
set tabstop=4
set mouse=a
set linebreak
let mapleader = "<space>"

" Exit insert mode
inoremap jk <esc>

" Source init.vim
nnoremap <leader>sv :source $MYVIMRC

" Visual line-based movement
nnoremap j gj
nnoremap k gk

augroup Markdown
	autocmd!
	autocmd BufRead FileType markdown set wrap
	autocmd BufRead FileType markdown set linebreak
augroup end

call plug#begin('~/.vim/plugged')
	Plug 'SuneelFreimuth/vim-gemtext'
	Plug 'ziglang/zig.vim'
	Plug 'fatih/vim-go'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'psf/black'
call plug#end()
