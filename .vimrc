set runtimepath+=/usr/share/vim/addons/

set encoding=utf-8
set fileencodings=utf-8
set clipboard=unnamedplus

set mouse=a
" set bg=dark
colorscheme desert
set number
set nuw=6
set ignorecase
" Interpret tab as an indent command instead of insert-a-tab command
set softtabstop=2
" Indentation width when tab key hit
set shiftwidth=2
" Number of spaces displayed for tab file-character
set tabstop=4
" Insert spaces when tab key is pressed
set expandtab
" Autoindent
set autoindent
" Do not cut words
set linebreak
" Show the cursor position all the time
set ruler

" Chargement de plugins selon le type de fichier
filetype plugin on
" Permet a vim-latex d'appeler correctement latex (win32 specific ?)
set shellslash
" Change la manière d'appeler grep pour toujours avoir le nom de fichier
set grepprg=grep\ -nH\ $*
" Indentation automatique selon le type de fichier
filetype indent on
" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'
let g:Tex_CompileRule_pdf='pdflatex -interaction nonstopmode $*'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_IgnoreLevel=0

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
