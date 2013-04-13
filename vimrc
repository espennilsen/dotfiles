" Vundle plugin management.
set nocompatible
filetype off  " required!
set t_Co=256
set rtp+=~/.vim/vundle.git/ 
call vundle#rc()

" My bundles
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdtree'
Bundle 'vim-scripts/Command-T'
Bundle 'Lokaltog/vim-powerline'
Bundle 'tangledhelix/vim-octopress'
"Required by vim-snipmate
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim' 
Bundle "honza/vim-snippets"
" End of vim-snipmate requirements
Bundle 'garbas/vim-snipmate'
Bundle 'desert.vim'

filetype plugin indent on     " required for Vundle!

" Setting
set nocompatible   " Disable vi-compatibility
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show unicode glyphs
set nowrap " don't wrap lines
set number " Show line numbers
set tabstop=4 " A tab is 4 spaces
set shiftwidth=4 " 4 spaces when you autoindent
set shiftround " use multiple shiftwidth when indenting with '<'
set smarttab " insert tabs on start according to shiftwidth, not tabstop.
set backspace=indent,eol,start " Allow backspaces of everything.
set autoindent " Always autoindent
set copyindent " Same for copying
set ignorecase " Ignore case on search
set smartcase " Except if something is uppercase.
set hlsearch " Highlight search matches
set incsearch " show search matches as you type.
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set visualbell " Shut up!
set noerrorbells " Dont beep!
set nobackup
set noswapfile
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.
set pastetoggle=<F2>
"set mouse=a
" Keyboard mappings

map <F6> :NERDTreeToggle<CR>
" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

nmap <silent> ,/ :nohlsearch<CR>
" Colorscheme settings
if &t_Co >= 256 || has("gui_running")
   colorscheme desert
endif

if &t_Co > 2 || has("gui_running")
   " switch syntax highlighting on, when the terminal has colors
   syntax on
endif

" Powerline settings:
let g:Powerline_symbols = 'unicode' " Simulates icons and arrows using similar unicode glyphs
" let g:Powerline_symbols = 'fancy' " Simulates icons and arrows using similar unicode glyphs
"
" Some octopress stuff
nnoremap 'bn :NewPost
command! -nargs=1 NewPost call NewPost("<args>")
fun! NewPost(args)
   let file = "~/dev/espennilsen.github.com/source/_posts/" . strftime("%Y-%m-%d") . "-" . tolower(substitute(a:args, " ", "-", "g")) . ".markdown"
   exe "e!" . file
   let g:post_title = a:args
endfun

nnoremap 'bs :SavePost
command! -nargs=1 SavePost call SavePost("<args>")
fun! SavePost(args)
   let file = "~/dev/espennilsen.github.com/source/_posts/" . strftime("%Y-%m-%d") . "-" . tolower(substitute(a:args, " ", "-", "g")) . ".markdown"
   exe "w!" . file
   let g:post_title = a:args
endfun

au BufNewFile,BufRead ~/dev/espennilsen.github.com/source/_posts/*.markdown setl completefunc=TagComplete | cd ~/dev/espennilsen.github.com/source
fun! TagComplete(findstart, base)
  if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\a'
      let start -= 1
    endwhile
    return start
  else
    let tags = split(system("ls /web/octopress/public/blog/tags"), "\n")
    let cats = split(system("ls /web/octopress/public/blog/categories"), "\n")
    return tags + cats
  endif
endfun
