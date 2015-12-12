" setup the pathogen_disabled variable so we can disable certain plugins
" depending on if we're in a GUI or not
let g:pathogen_disabled = []

if has('gui_running')
	" bump our gui font
	set guifont=Ubuntu\ Mono\ 13,DejaVu\ Sans\ Mono\ 13,Monaco:h13
endif

if argc() == 0
	" Show NERDTree on startup in each tab if we're started without
	" any arguments
	let g:nerdtree_tabs_open_on_console_startup=1
endif

" Show line numbers
set number

" Let pathogen manage our plugins
execute pathogen#infect()

" Dark Solarized
set background=dark
colorscheme solarized
let g:solarized_termcolors=256

filetype plugin on
filetype indent on
syntax enable
set ai

set statusline=%<%f\ %h%m%r%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k\ %-14.(%l,%c%V%)\ %P
set laststatus=2

set modeline modelines=2

autocmd BufRead,BufNewFile *.c set ts=4 sw=4 et sts=4
autocmd BufRead,BufNewFile *.css set ts=2 sw=2 et sts=2
autocmd BufRead,BufNewFile *.go set ts=4 sw=4 ai
autocmd BufRead,BufNewFile *.h set ts=4 sw=4 et sts=4
autocmd BufRead,BufNewFile *.html set ts=4 sw=4 et sts=4
autocmd BufRead,BufNewFile *.tmpl set ts=4 sw=4 et sts=4
autocmd BufRead,BufNewFile *.js set ts=4 sw=4 et sts=4
autocmd BufRead,BufNewFile *.sh set ts=4 sw=4 et sts=4
autocmd BufRead,BufNewFile *.less set ts=4 sw=4 et sts=4
autocmd BufRead,BufNewFile *.m set ts=4 sw=4 et sts=4
autocmd BufRead,BufNewFile *.php set ts=4 sw=4 ai
autocmd BufRead,BufNewFile *.pp set ft=puppet
autocmd BufRead,BufNewFile *.py set ts=4 sw=4 et sts=4
autocmd BufRead,BufNewFile *.rb set ts=2 sw=2 et sts=2 ai
autocmd BufRead,BufNewFile *.scss set ts=2 sw=2 et sts=2
autocmd BufRead,BufNewFile *.jade set ts=2 sw=2 et sts=2
autocmd BufRead,BufNewFile *.tpl set ts=4 sw=4 et sts=4 ai
autocmd BufRead,BufNewFile *.xml set ts=4 sw=4 et sts=4 ai

" prefer pylint over flake8
let g:syntastic_python_checkers = ['pylint']

" source our global vim overrides if they exist
if filereadable(glob("~/.vimrc.local")) 
	source ~/.vimrc.local
endif

" source our per-project overrides if they exist
if filereadable('.vimrc.local')
	source .vimrc.local
endif

" show hidden files in ctrlp
let g:ctrlp_show_hidden = 1

" hide non project files
" https://www.debuggex.com/i/nW65R5Ko_5uEeA_m.png
let g:ctrlp_custom_ignore = '\v[\/](.git|.vagrant|.virtualenv|node_modules|bower_components|build|vendor)$'
