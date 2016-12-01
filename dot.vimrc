scriptencoding utf-8
language messages C
language time C
filetype plugin indent on
syntax enable
colorscheme desert

let s:plugindir = expand('~/.vim_plugin')
if has('vim_starting') && isdirectory(s:plugindir)
  execute 'set runtimepath+=' . join(glob(s:plugindir . '/*', 0, 1), ',')
endif

set encoding=utf-8 fileencodings=ucs-bom,iso-2022-jp,euc-jp,cp932
set fileformat=unix fileformats=unix,dos,mac ambiwidth=double
set shortmess& shortmess+=I visualbell t_vb=
set nonumber noruler nocursorline nocursorcolumn nowrap nopaste textwidth=0
set list listchars=tab:>\ ,trail:~
set cmdheight=1 showcmd showmode wildmenu wildmode=list:longest
set nobackup noswapfile noundofile
set ignorecase smartcase nohlsearch noincsearch nowrapscan
set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab shiftround
set autoindent smartindent
set splitbelow splitright equalalways
set autoread nohidden nostartofline backspace=indent,eol,start
set laststatus=2 statusline=%!StatusLine() showtabline=0

function! StatusLine()
  return '%m%r%y %f (%{&fileencoding},%{&fileformat})%=%l/%4L,%3c'
endfunction

augroup vimrc
autocmd!
augroup END
command! -nargs=* AutoCmd autocmd vimrc <args>

AutoCmd QuickFixCmdPost vimgrep copen
AutoCmd QuickFixCmdPost lvimgrep lopen
AutoCmd BufNewFile,BufRead *.h setlocal filetype=c
AutoCmd FileType c setlocal expandtab softtabstop=4 shiftwidth=4
AutoCmd FileType cpp setlocal expandtab softtabstop=4 shiftwidth=4
AutoCmd FileType haskell setlocal expandtab softtabstop=4 shiftwidth=4
AutoCmd FileType markdown setlocal wrap
AutoCmd FileType text setlocal wrap
AutoCmd FileType vim setlocal expandtab softtabstop=2 shiftwidth=2
AutoCmd FileType help nnoremap <buffer> q <C-w>c

nnoremap q <Nop>
nnoremap Q <Nop>
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Y y$
nnoremap gm `[v`]

nnoremap ,l :<C-u>setlocal list! list?<CR>
nnoremap ,n :<C-u>setlocal number! number?<CR>
nnoremap ,p :<C-u>setlocal paste! paste?<CR>
nnoremap ,w :<C-u>setlocal wrap! wrap?<CR>

inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-a> <Home>
inoremap <C-e> <End>

cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

vnoremap <expr><silent> I InsertFromBlockwiseVisual('I')
vnoremap <expr><silent> A InsertFromBlockwiseVisual('A')

function! InsertFromBlockwiseVisual(key)
  let mode = mode()
  if mode ==# 'v'
    return "\<C-v>" . a:key
  elseif mode ==# 'V'
    return "\<C-v>0o$" . a:key
  else
    return a:key
  endif
endfunction
