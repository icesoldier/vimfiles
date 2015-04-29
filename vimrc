execute pathogen#infect()

filetype plugin indent on
syntax on
set encoding=utf-8
set number
set tabstop=4
set shiftwidth=4
set autoindent
set cursorline
set hidden

"navigate buffers like you would tabs
nnoremap gB :<C-U>exe ':' . v:count . 'bprevious'<CR>
nnoremap gb :<C-U>exe (v:count ? ':' . v:count . 'b' : ':bnext')<CR>

autocmd Filetype rust setlocal expandtab
autocmd Filetype rust setlocal foldmethod=syntax
autocmd Filetype rust setlocal foldlevel=9

let g:zenburn_force_dark_Background = 1
colorscheme zenburn

set sessionoptions-=options

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif

autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
let g:neocomplete#sources#omni#input_patterns.cs = '.*[^=\);]'

command -nargs=0 -complete=file Saveoff :mksession! session.vim | :qa

let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#fnamemod = ':t'
set laststatus=2
set ttimeoutlen=500

if filereadable("session.vim") && filewritable("session.vim") && argc() == 0
	source session.vim
endif
