" vim: set ft=vim:
" -*- mode: vimrc -*-
"----------------------------
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=
set tags=./tags; "semicolon is important
set undodir=$HOME/.nvim/undo 
set grepprg=rg\ --vimgrep\ --no-heading
" ------------------------------------------------------------------------------
" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
"set viminfo='100,\"100,:20,%,n~/.viminfo
set viminfo='1000,f1,\"500,:1000,%,n~/.nviminfo
"----------------------------
syntax on
set isfname-=:
set nu
se smartcase
se hls
se incsearch
set tabstop=4 
set shiftwidth=4
set expandtab
set mouse+=a
set undofile   
set undolevels=100
set undoreload=1000
set showmatch
set autoread  
set wildmenu
set wildmode=longest:full,full
set ssop+=resize,winpos,winsize,blank,buffers,curdir,folds,help,options,tabpages
set completeopt=longest,menuone
set splitbelow
set splitright
set grepformat=%f:%l:%c:%m,%f:%l:%m
set diffopt+=vertical
set hidden
set laststatus=2
set modelines=5
set clipboard=unnamed
set history=2000
set cursorline
set t_BE=
se ic
set guifont=Hack\ 11
set signcolumn=yes
set cmdheight=2
se nowrap
cnoremap %s/ %smagic/

let  mapleader = ","
map <F3> <Esc>:Buffers<cr>
map <F5> <Esc>:History<cr>
map <c-o> <Esc>:BLines<cr>
map <c-h> <Esc>:History:<cr>
map <F6> :NERDTreeFind<cr>
map <F9> :bd <CR>
nmap <F9> :!clang-check -p . %:p<CR>
map <F10> :w <CR>:bd <CR>
map <F11> :w <CR>:bd <CR>
map <c-p> :Files<cr>
map <c-u> :GitFiles<cr>
map <F12> <Esc>:qa!<cr>
imap <F12> <Esc>:qa!<cr>
map <Esc>[1;5C <Esc>:bn<cr>
map <Esc>[1;5D <Esc>:bp<cr>
nnoremap <C-t> <C-O>
nnoremap <C-w> :bp\|bd #<CR>
nnoremap <leader>t <C-]>

let g:ycm_error_sym = '⚠'
let g:ycm_warning_sym = '⚑'
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_seed_identifiers_with_syntax = ['<TAB>', '<ENTER>']
let g:ycm_key_list_stop_completion = ['<C-y>']
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap t  :YcmCompleter GoToDefinitionElseDeclaration<CR>
map <leader>d  :YcmDiags<CR>

let g:cpp_member_variable_highlight = 1
let g:cpp_class_scope_highlight = 1
let g:cpp_class_decl_highlight = 1

map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

let g:python_support_python2_require = 0

set rtp+=~/.fzf
call plug#begin('~/.nvim/plugged')
Plug 'roxma/python-support.nvim'
Plug 'junegunn/fzf.vim'
Plug 'fszymanski/fzf-quickfix'
Plug 'bfrg/vim-cpp-modern'
Plug 'Shougo/echodoc.vim'
Plug 'flazz/vim-colorschemes'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/gv.vim'
"Plug 'scrooloose/nerdtree'
"Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'pacha/vem-tabline'
Plug 'google/vim-searchindex'
"--------------YCM---------------
"source prefix_root and then
"cd ~/.nvim/plugged/YouCompleteMe
"./install.sh --clang-completer --system-libclang
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --system-libclang' }
"-----------------------------
"Plug 'junegunn/rainbow_parentheses.vim'
"Plug 'arakashic/chromatica.nvim'
"Plug 'lyuts/vim-rtags'
"Plug 'octol/vim-cpp-enhanced-highlight'
"Plug 'ipod825/vim-netranger'
"Plug 'francoiscabrol/ranger.vim'
"Plug 'tpope/vim-surround'
"Plug 'ap/vim-buftabline'
"Plug 'bling/vim-bufferline'
call plug#end()

nmap <Leader>q <Plug>(fzf-quickfix)

let g:ranger_replace_netrw = 1
let g:NETRColors = {'file': 65} 

let g:LanguageClient_autoStart = 1
let g:LanguageClient_trace = 'verbose'

"---fzf list matching files containing word under cursor---
function! s:GrepList(param1)
  call fzf#vim#files('', {'source': 'rg -l --type cpp  --fixed-strings --ignore-case '.shellescape(a:param1)." |rg -v 'Test|_test|sct|CMake|tests|xml|cmake|UT|SCT'" })
endfunction
command! MyGrepList call s:GrepList(expand("<cword>"))
nnoremap <silent> <c-l> :MyGrepList<cr>

"---fzf project file---
function! s:FFiles()
call fzf#vim#files('', {'down': '40%', 'source': 'cat ~/tmp/project-files'})
endfunction
command! MyFiles call s:FFiles()
nnoremap <silent> <c-p> :MyFiles<cr>

"---fzf matching file under cursor---
function! s:FzFiles()
call fzf#vim#files('', {'down': '40%', 'source': 'cat ~/tmp/project-files', 'options':'-q"'.expand("<cword>").'"'})
endfunction
command! MyMatchingFiles call s:FzFiles()
nnoremap <silent> <c-k> :MyMatchingFiles<cr>

function! s:GrepAll(param1)
  call fzf#vim#grep('rg -t cpp --column --line-number --no-heading --fixed-strings --ignore-case --color "always" '.shellescape(a:param1), 1 )
endfunction
command!  MyGrepAll call s:GrepAll(expand("<cword>"))
nnoremap <silent> <c-b> :MyGrepAll<cr>

"---------------------------------------
" goto last position when reopening file
"---------------------------------------
if has("autocmd")
      au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  endif ""'")
"----------------------------

let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'signature'

let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:netrw_banner = 0
let g:netrw_list_hide = &wildignore

au FocusGained,BufEnter * :silent! !

command! -nargs=? Filter let @a='' | execute 'g/<args>/y A' | new | setlocal bt=nofile | put! a

"set background=light
"colo PaperColor
set background=dark
colo badwolf

"---grep word under cursor ---
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'cat ~/tmp/project-files | xargs rg  --column --line-number --no-heading --fixed-strings --ignore-case --color "always" '.expand("<cword>") , 1 ,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
nnoremap <silent> <c-f> :Rg <cr>

"map <F4> :e %:p:s,.hpp$,.X123X,:s,.cpp$,.hpp,:s,.X123X$,.cpp,<CR>
function! s:FindOtherFile()
    let filename= expand("%:t:r")
    let fileext= expand('%:e')
    let l:otherext = '.hpp'
    if l:otherext == fileext
        let l:otherext='.cpp'
    endif
    let otherfile = filename .  l:otherext
    let result = systemlist("rg -i " . otherfile . ' ~/tmp/project-files')
    "echo otherfile
    if len(result) == 0
        echo result
        return
    elseif len(result) == 1 
        execute "edit "  . result[0]
        "execute "split "  . result[0]
    else    
        call fzf#run({'source': result, 'sink': 'e', 'down': '20%'})
    endif
endfunction
command! GetOtherFile call s:FindOtherFile()
nnoremap <silent> <F4> :GetOtherFile<cr>

function! s:OpenFile()
    let filename= expand("<cfile>")
    let result = systemlist("rg -i " . filename. ' ~/tmp/project-files')
    if len(result) == 0
        echo result
        return
    elseif len(result) == 1 
        execute "edit "  . result[0]
    else    
        call fzf#run({'source': result, 'sink': 'e', 'down': '20%'})
    endif
endfunction
command! OpenFile call s:OpenFile()
nnoremap <silent> <F8> :OpenFile<cr>

map <S-Right> :bn<cr>
map <S-Left> :bp<cr>
