"filetype indent on
filetype plugin on

set encoding=utf-8
set fileencodings=utf-8

" Use X11 clipboard
set clipboard=unnamedplus

" Enables mouse (needs vim compiled with certain options)
set mouse=a



""""""""""""""""""""""""""""""""""""
" FIND & REPLACE

" Ignore case when searching…
set ignorecase
" … except when using capital letters
set smartcase

" Local variable rename
nnoremap gr yiw[{V%::s/<C-R>"//gc<left><left><left>
" Global variable rename
nnoremap gR yiw:%s/<C-R>"//gc<left><left><left>



""""""""""""""""""""""""""""""""""""
" APPEARANCE

" set bg=dark
colorscheme desert
set relativenumber
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber
set cursorline
set nuw=6

" Show the cursor position all the time
set ruler

" :help statusline for placeholder description
" :so $VIMRUNTIME/syntax/hitest.vim
set statusline=%#ToolbarLine#%t " tail of the filename, i.e. filename
set statusline+=%m " modified flag, displayed as [+]
set statusline+=\ [%{strlen(&fenc)?&fenc.',':''} " file encoding
set statusline+=%{&ff}] " file format, e.g. 'unix'
set statusline+=\ %y " filetype, e.g. [vim]
set statusline+=\ %r " read only flag
set statusline+=%= " left/right separator
set statusline+=%c " cursor column
set statusline+=\ %l/%L " cursor line/total lines
set statusline+=\ %P " percent through file

set rulerformat=%#LineNR#
set rulerformat+=\ %l\ /\ %L " (cursor line)/(total lines)
set rulerformat+=%= " left/right separator
set rulerformat+=\ %P " percent through file

" highlight search
set hlsearch
set incsearch
highlight Search cterm=NONE ctermfg=darkgreen ctermbg=brown

" Use visual bell instead of beeping when doing something wrong
set visualbell



""""""""""""""""""""""""""""""""""""
" INDENTATION

set autoindent
" Indentation with hard tabs, allowing each reader to view code with the amount of indentation they like
" Indentation added by >>, =, etc. If not divisible by tabstop, vim will use a mix of spaces & tabs
set shiftwidth=6
" How many columns wide is a tab character worth?
set tabstop=6

" Show indentation marks
set list listchars=tab:❘\ ,trail:·,extends:»,precedes:«,nbsp:×
" Set color for eol, extends and precedes
"hi NonText ctermfg=7 guifg=gray
" Set color for nbsp, tab, and trail
hi SpecialKey ctermfg=8 guifg=darkgray

" Oneline a file
command Ol %s/\n//

" Indent a oneline XML file
map <F5> :set ft=xml<cr>:%s/></>\r</g<cr>gg=G

" Oneline an XML file
command Olx %s/\n// | s/>\s*</></g


""""""""""""""""""""""""""""""""""""
" SOFT LINES NAVIGATION

" Break lines at word gaps
set linebreak
" Show soft line break mark
let &showbreak = '↳ '
" Navigation between soft lines
map <silent> <Up> gk
imap <silent> <Up> <C-o>gk
map <silent> <Down> gj
imap <silent> <Down> <C-o>gj
map <silent> <home> g<home>
imap <silent> <home> <C-o>g<home>
map <silent> <End> g<End>
imap <silent> <End> <C-o>g<End>

" Replace normal spaces with unbreakable spaces (french rules)
command Ub %s/\([[:alnum:]]\) \(:\|;\|!\|?\|»\)/\1 \2/gce | %s/\(«\) \([[:alnum:]]\)/\1 \2/gce

" Search visually selected text
vnoremap // y/\V<C-R>"<CR>

""""""""""""""""""""""""""""""""""""
" TABS

" to map :execute TabLeft()
function TabLeft()
   let tab_number = tabpagenr() - 1
   if tab_number == 0
      execute "tabm" tabpagenr('$') - 1
   else
      execute "tabm" tab_number - 1
   endif
endfunction

function TabRight()
   let tab_number = tabpagenr() - 1
   let last_tab_number = tabpagenr('$') - 1
   if tab_number == last_tab_number
      execute "tabm" 0
   else
      execute "tabm" tab_number + 1
   endif
endfunction

nmap <C-t> :tabnew<cr>
nmap <C-Up> :tab split +E<cr>
nmap <C-Down> :tabclose<cr>
nmap <C-Right> :tabnext<cr>
nmap <C-Left> :tabprevious<cr>
nmap <C-S-Left> :execute TabLeft()<cr>
nmap <C-S-Right> :execute TabRight()<cr>

""""""""""""""""""""""""""""""""""""
" CONFIG FOR LATEX PLUGIN

" Chargement de plugins selon le type de fichier
filetype plugin on
" Permet a vim-latex d'appeler correctement latex (win32 specific ?)
set shellslash
" Change la manière d'appeler grep pour toujours avoir le nom de fichier
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'
let g:Tex_CompileRule_pdf='pdflatex -interaction nonstopmode $*'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_IgnoreLevel=0
