scriptencoding utf-8
set nocompatible
language messages C
language time C
let $LANG = 'C'
filetype plugin indent on

let s:plugindir = expand('~/.vim_plugin')
if has('vim_starting') && isdirectory(s:plugindir)
  execute 'set runtimepath+=' . join(glob(s:plugindir . '/*', 0, 1), ',')
endif

augroup vimrc
  autocmd!
augroup END
command! -bang -nargs=* AutoCmd autocmd<bang> vimrc <args>

set encoding=utf-8 fileencodings=ucs-bom,iso-2022-jp,euc-jp,cp932
set fileformat=unix fileformats=unix,dos,mac ambiwidth=double
set shortmess& shortmess+=I visualbell t_vb=
set nonumber noruler nocursorline nocursorcolumn nowrap nopaste textwidth=0
set list listchars=tab:>\ ,trail:~
set cmdheight=1 showcmd showmode wildmenu wildmode=list:longest
set nobackup noswapfile noundofile
set ignorecase smartcase nohlsearch noincsearch nowrapscan
set tabstop=8 softtabstop=8 shiftwidth=8 expandtab shiftround autoindent smartindent
set splitbelow splitright equalalways
set autoread nohidden nostartofline scrolloff=3 backspace=indent,eol,start
set laststatus=2 statusline=%!StatusLine() showtabline=2 tabline=%!TabLine()

let g:vim_indent_cont = 0

function! StatusLine()
  return '%m%r%y %f [%{&fileencoding}:%{&fileformat}]%=%l/%4L,%3c'
endfunction

function! TabLine()
  return '%#TabLineFill#' . fnamemodify(getcwd(), ':~') . '%=tab:' . printf('%2d/%2d', tabpagenr(), tabpagenr('$'))
endfunction

syntax enable
colorscheme desert

command! -nargs=1 -bang -bar -complete=file Rename saveas<bang> <args> | call delete(expand('#'))

command! -bar DeleteTrailingSpace call s:delete_trailing_space()
function! s:delete_trailing_space()
  let save_cursor = getpos('.')
  %s/\s\+$//e
  call setpos('.', save_cursor)
endfunction

AutoCmd BufReadPost * if &modifiable && !search('[^\x00-\x7F]', 'cnw') | setlocal fileencoding=utf-8 | endif
AutoCmd BufWritePre * if !isdirectory(expand('<afile>:p:h')) | call mkdir(expand('<afile>:p:h'), 'p') | endif

AutoCmd TabEnter * if exists('t:cwd') | cd `=fnameescape(t:cwd)` | endif
AutoCmd TabLeave * let t:cwd = getcwd()

AutoCmd QuickFixCmdPost vimgrep copen
AutoCmd QuickFixCmdPost lvimgrep lopen

AutoCmd BufNewFile,BufRead *.md setlocal filetype=markdown
AutoCmd FileType * setlocal nofoldenable
AutoCmd FileType c,cpp setlocal noexpandtab tabstop=8 softtabstop=8 shiftwidth=8
AutoCmd FileType haskell setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4
AutoCmd FileType text setlocal wrap noexpandtab tabstop=8 softtabstop=8 shiftwidth=8
AutoCmd FileType vim setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
AutoCmd FileType help call s:ft_help()
AutoCmd FileType qf call s:ft_qf()

function! s:ft_help()
  if &l:buftype ==# 'help'
    nnoremap <buffer> q <C-w>c
  else
    setlocal list tabstop=8 shiftwidth=8 softtabstop=8 noexpandtab
    setlocal textwidth=78 colorcolumn=+1 conceallevel=0
    AutoCmd BufLeave <buffer> setlocal colorcolumn&
  endif
endfunction

function! s:ft_qf()
  setlocal statusline+=\ %L
  nnoremap <buffer> p <CR>zz<C-w>p
  nnoremap <buffer> q <C-w>c
endfunction

nnoremap q <Nop>
nnoremap Q <Nop>
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Y y$

nnoremap <silent> ,, :<C-u>edit $MYVIMRC<CR>
nnoremap <silent> ,. :<C-u>source $MYVIMRC<CR>
nnoremap <silent> ,l :<C-u>source %<CR>

nnoremap gm `[v`]
onoremap gm :<C-u>normal gm<CR>
vnoremap gm :<C-u>normal gm<CR>

nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz

nnoremap ,tl :<C-u>setlocal list! list?<CR>
nnoremap ,tn :<C-u>setlocal number! number?<CR>
nnoremap ,tp :<C-u>setlocal paste! paste?<CR>
nnoremap ,tw :<C-u>setlocal wrap! wrap?<CR>
nnoremap ,tc :<C-u>setlocal colorcolumn=
nnoremap ,tf :<C-u>setfiletype<Space>

nnoremap mh :<C-u>help<Space>
nnoremap mmh :<C-u>help<Space><C-r><C-w><CR>
nnoremap ml :<C-u>lvimgrep //j %<Left><Left><Left><Left>
nnoremap mml :<C-u>lvimgrep /<C-r><C-w>/j %<CR>
nnoremap mg :<C-u>lvimgrep //j **/*<Left><Left><Left><Left><Left><Left><Left>
nnoremap mmg :<C-u>lvimgrep /<C-r><C-w>/j **/*<CR>

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

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

cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <C-o> <C-\>e(getcmdtype() == '/' ? '\<' . getcmdline() . '\>' : getcmdline())<CR>

vnoremap <expr><silent> I <SID>niceblock('I')
vnoremap <expr><silent> A <SID>niceblock('A')

function! s:niceblock(key)
  let mode = mode()
  if mode ==# 'v'
    return "\<C-v>" . a:key
  elseif mode ==# 'V'
    return "\<C-v>0o$" . a:key
  else
    return a:key
  endif
endfunction
