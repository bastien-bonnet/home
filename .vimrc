""""""""""""""""""""""""""""""""""""
" FILE TYPE ASSOCIATIONS

" Indentation automatique selon le type de fichier
filetype indent on
" Chargement de plugins selon le type de fichier
filetype plugin on




set encoding=utf-8
set fileencodings=utf-8

" Ignore case when searching…
set ignorecase
" … except when using capital letters
set smartcase

" Use X11 clipboard
set clipboard=unnamedplus

" Enables mouse (needs vim compiled with certain options)
set mouse=a



""""""""""""""""""""""""""""""""""""
" APPEARANCE

" set bg=dark
colorscheme desert
set relativenumber
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber
set nuw=6

" Show the cursor position all the time
set ruler

" highlight search
set hlsearch

" Use visual bell instead of beeping when doing something wrong
set visualbell



""""""""""""""""""""""""""""""""""""
" INDENTATION

set autoindent
" Indentation with hard tabs, allowing each reader to view code with the amount of indentation they like
set shiftwidth=2
set tabstop=2
" Show indentation marks
set list listchars=tab:\ ❘,trail:·,extends:»,precedes:«,nbsp:×



""""""""""""""""""""""""""""""""""""
" SOFT LINES NAVIGATION

" Break lines at word gaps
set linebreak
" Show soft line break mark
let &showbreak = '↳'
" Navigation between soft lines
map <silent> <Up> gk
imap <silent> <Up> <C-o>gk
map <silent> <Down> gj
imap <silent> <Down> <C-o>gj
map <silent> <home> g<home>
imap <silent> <home> <C-o>g<home>
map <silent> <End> g<End>
imap <silent> <End> <C-o>g<End>

" Oneline a file
command Ol %s/\n//
" Indent a oneline XML file
map <F5> :set ft=xml<cr>:%s/></>\r</g<cr>gg=G
" Oneline an xml file
command Olx %s/\n// | s/>\s*</></g
" Replace normal spaces with unbreakable spaces (french rules)
command Ub %s/\([[:alnum:]]\) \(:\|;\|!\|?\|»\)/\1 \2/gce | %s/\(«\) \([[:alnum:]]\)/\1 \2/gce

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
" CONFIG FOR LATEX PLUGIN

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
