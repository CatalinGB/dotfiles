" {{{ Plugins
" set runtimepath+=$HOME\.nvim\plugged
" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.nvim/plugged')

  " Make sure you use single quotes
  " Add or remove your plugins here:
  Plug 'Valloric/YouCompleteMe'
  "
  " Plug 'Shougo/deoplete.nvim'
  " Plug 'tweekmonster/deoplete-clang2'
  Plug 'w0rp/ale', {'for': ['xml']}
  Plug 'cocopon/vaffle.vim' " file manager
  Plug 'gcmt/taboo.vim' " rename tabs
  Plug 'Konfekt/vim-CtrlXA'
  " Plug 'autozimu/LanguageClient-neovim', {     'branch': 'master', 'for': ['c', 'xml', 'm4', 'h', 'c.m4', 'h.m4']}
  Plug 'autozimu/LanguageClient-neovim', {     'branch': 'next'}
  " Plug 'autozimu/LanguageClient-neovim', {     'branch': 'next',  'do': 'powershell -executionpolicy bypass -File install.ps1', 'for': ['c', 'xml', 'm4', 'h', 'c.m4', 'h.m4']}
  " Plug 'autozimu/LanguageClient-neovim/tree/master'
  Plug 'justinmk/vim-syntax-extra'
  " Plug 'ludovicchabant/vim-gutentags'
  " Plug 'majutsushi/tagbar'
 
  " Plug 'prabirshrestha/async.vim'
  " Plug 'prabirshrestha/vim-lsp'
  " Plug 'natebosch/vim-lsc'
  " Plug 'pdavydov108/vim-lsp-cquery'

  " Plug 'vim-latex/vim-latex', {'for': ['tex', 'latex']}

  Plug 'Shougo/vinarise.vim'
  Plug 'ryanoasis/vim-devicons'

  Plug 'gregsexton/VimCalc', {'on': 'Calc'}
  Plug 'ajh17/Spacegray.vim'

  Plug 'octol/vim-cpp-enhanced-highlight', {'for': ['c', 'cpp']}
  Plug 'justinmk/vim-syntax-extra', {'for': ['c', 'cpp']}
  Plug 'junegunn/vim-easy-align'
  Plug 'Olical/vim-enmasse'
  Plug 'mhinz/vim-signify', {'for': ['c', 'xml', 'm4', 'h', 'c.m4', 'h.m4']}
  Plug 'vimwiki/vimwiki'
  Plug 'rking/ag.vim'
  Plug 'tpope/vim-surround'
  Plug 'jiangmiao/auto-pairs'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'kshenoy/vim-signature'                 " bookmark management
  Plug 'tpope/vim-commentary'
  Plug 'tmhedberg/matchit'                     " extends %
  Plug 'itchyny/lightline.vim'
  Plug 'AndrewRadev/linediff.vim'
  Plug 'mbbill/undotree'
  Plug 'romainl/vim-qf'

" Initialize plugin system
call plug#end()
" }}}

" {{{ Editior settings

if has("win32")
  let userProfile = substitute($USERPROFILE,'\\','/','g')

  " Work specific things
  source $HOME/AppData/Local/nvim/eb.vim

  let g:python3_host_prog='C:\Python36\python.exe'
  let g:python_host_prog='C:\Python27\python.exe'
endif

syntax on
colorscheme Spacegray

set encoding=utf-8
scriptencoding utf-8

" map copy/paste
"set clipboard=unnamed
set clipboard+=unnamedplus

" folding
set foldmethod=marker

" set the curent directory
set autochdir

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" don't open folds when search match is found inside
set fdo-=search

" persistent undo
set undofile
set undodir=$HOME\vim_undo
set undolevels=10000
set undoreload=10000

" set the locaiton for swp files
set directory=$HOME\vim_undo
set backupdir=$HOME\vim_undo

" search
set hlsearch
set incsearch
set number
set ignorecase
vmap // y/\V<C-R>"<CR>

" set spelling
set sps=best,10

" flashes matching brackets or parentheses
set showmatch

" Display extra whitespace
set list
set listchars=trail:-,tab:>-,extends:>,precedes:<,conceal:+

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set nowrap

set scrolloff=5

set splitright " Puts new vsplit windows to the right of the current
set splitbelow " Puts new split windows to the bottom of the current

" set the language
set langmenu=none

" autoindent
set ai

set wildmenu
set wildmode=full

" set visual bell -- i hate that damned beeping
set vb

" set history length
set history=1000

" disable the menu
set guioptions-=T
set guioptions-=L
set guioptions-=r
set guioptions-=m
set guioptions-=e

" show the current line
set cul

" set the font
" set guifont=Mononoki-Bold
" set guifont=Consolas:h14
set guifont="Hack NF":h18

" show the filename in the bottom of the window
set modeline
set ls=2

" allow backspacing over everything in insert-mode
set backspace=indent,eol,start

set shortmess=aoOTt

" If we have 'live substitution', enable it
if exists('&inccommand')
  set inccommand=nosplit
endif

" autoreads
set autoread

set title

let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat

set termguicolors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let &t_8b="\e[48;2;%ld;%ld;%ldm"

" C stuff
set cino+=(0             "Align paramater lists after newline under '('

set dictionary+=$HOME\words.txt

" }}}

" {{{ Mappings

" Leader mappings
let mapleader = "\<Space>"
nnoremap <Leader>sz :set scb!<CR> " syncronized scroll
nnoremap <Leader>db :call DeleteInactiveBufs()<CR>
nnoremap <Leader>dd :diffthis<CR>
nnoremap <Leader>do :diffoff<CR>
nnoremap <Leader>dp :diffput<CR>
nnoremap <Leader>dg :diffget<CR>
nnoremap <Leader>du :diffupdate<CR>
nnoremap <Leader>e  :Ag!  <C-R>=GetProj(2)<CR><C-Left><C-Left><C-Left><C-Left><C-Right><Right>
nnoremap <Leader>r  :Ag! <C-R><C-W> <C-R>=GetProj(2)<CR><C-Left><C-Left><C-Left><C-Left><C-Right><Right><CR>
nnoremap <Leader>m  :CtrlPMRUFiles<CR>
nnoremap <Leader>n  :CtrlP <C-R>=GetProj(2)<CR><CR>
nnoremap <Leader>st :call StripTrailingWhitespaces()<cr>
nnoremap <Leader>sw :set wrap!<CR>
nnoremap <Leader>tc :tabclose<CR>
nnoremap <Leader>tn :tabnew<CR>
nnoremap <silent><Leader>/ :nohlsearch<CR>
nnoremap <silent><Leader>c :call ToggleColorColumn()<CR>
if has("win32")
nnoremap <silent><Leader>sL :w<CR>:silent !start TortoiseProc.exe /command:log /path:<C-R>=GetProj(2)<CR> /notempfile /closeonend<CR>
nnoremap <silent><Leader>sb :w<CR>:silent !start TortoiseProc.exe /command:blame /path:% /notempfile /closeonend<CR>
nnoremap <silent><Leader>sc :w<CR>:silent !start TortoiseProc.exe /command:commit /path:<C-R>=GetProj(2)<CR> /notempfile /closeonend<CR>
nnoremap <silent><Leader>sd :w<CR>:silent !start TortoiseProc.exe /command:diff /path:<C-R>=GetProj(2)<CR> /notempfile /closeonend<CR>
nnoremap <silent><Leader>sl :w<CR>:silent !start TortoiseProc.exe /command:log /path:% /notempfile /closeonend<CR>
nnoremap <silent><Leader>sr :w<CR>:silent !start TortoiseProc.exe /command:repobrowser /path:<C-R>=GetProj(2)<CR> /notempfile /closeonend<CR>
nnoremap <silent><Leader>su :w<CR>:silent !start TortoiseProc.exe /command:update /path:<C-R>=GetProj(2)<CR> /notempfile /closeonend<CR>
nnoremap <silent><Leader><Leader>n :silent !"C:\Program Files (x86)\Notepad++\notepad++.exe" %:p<CR><CR>
nnoremap <leader>gn :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
nnoremap <leader>gd :let @*=substitute(expand("%"), "/", "\\", "g").":".line('.')<CR>
nnoremap <leader>gp :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>
endif

nnoremap <silent><leader>tt :terminal<CR>
nnoremap <silent><leader>tv :vnew<CR>:terminal<CR>
nnoremap <silent><leader>ts :new<CR>:terminal<CR>

nnoremap <silent><leader>S z=
nnoremap <silent><leader>s :set spell!<CR>

vmap <Leader>ld :Linediff<CR>
nnoremap <silent> <Leader>nn :call GetStep()<Left>
vmap ;' V'<O#if 0<Esc>'>o#endif<Esc>
nnoremap <C-s> :w<CR>

if has("win32")
map <C-F> :pyf C:\Program Files\LLVM\share\clang\clang-format.py<cr>
imap <C-F> <c-o>:pyf C:\Program Files\LLVM\share\clang\clang-format.py<cr>
endif

cnoremap <c-v> <c-r>+
map! <S-Insert> <C-R>+

nnoremap _ :e.<CR>
nnoremap gp `[v`]

" Replace a word with yanked text
nnoremap <leader>rp viw"0p

" Navigate 5x faster when holding down Ctrl
nmap <c-j> 5j
nmap <c-k> 5k
nmap <c-h> 5h
nmap <c-l> 5l
vmap <c-j> 5j
vmap <c-k> 5k
vmap <c-h> 5h
vmap <c-l> 5l

" Move normally between wrapped lines
nmap j gj
nmap k gk

" window navigation
nmap <silent> <A-k> :wincmd k<CR>
nmap <silent> <A-j> :wincmd j<CR>
nmap <silent> <A-h> :wincmd h<CR>
nmap <silent> <A-l> :wincmd l<CR>
tnoremap <silent> <A-k> :wincmd k<CR>
tnoremap <silent> <A-j> :wincmd j<CR>
tnoremap <silent> <A-h> :wincmd h<CR>
tnoremap <silent> <A-l> :wincmd l<CR>

" To map <Esc> to exit terminal-mode
tnoremap <Esc> <C-\><C-n>

" resize windows
nmap <silent> <S-k> :resize +5<CR>
nmap <silent> <S-j> :resize -5<CR>
nmap <silent> <S-l> :vertical resize +5<CR>
nmap <silent> <S-h> :vertical resize -5<CR>

" go to previous visited locations
nmap <silent> <A-Left>  <C-o>
nmap <silent> <A-Right> <C-i>

" buffer navigation
nnoremap ]b :bnext<CR>
nnoremap [b :bprevious<CR>

nnoremap ]t :tabnext<CR>
nnoremap [t :tabprevious<CR>

" nnoremap ]l :ALENext<CR>
" nnoremap [l :ALEPrevious<CR>

map <C-Down> ]c
map <C-Up> [c
"

" faster indentaion
nmap > >>
nmap < <<

" F* mappings
nnoremap <F2> :cprevious<CR>
nnoremap <F3> :cnext<CR>
if has("win32")
nnoremap <F6> :silent !C:\totalcmd\TOTALCMD64.EXE /O <C-R>=getcwd()<CR><CR>
endif
nnoremap <F5> :silent !start cmd<CR>
nnoremap <F10> :call ToggleNumber()<cr>

" play macros with Q
nnoremap Q @a
vnoremap Q :norm @a<cr>
nnoremap qq ZZ<CR>

" search but don't jump to the next word
nnoremap * *``

" Fix for legacy vi inconsistency
map Y y$
map ; :

" Remap VIM 0 to first non-blank character
map 0 ^

" }}}

" {{{ Autocmds
au FileType {xdm} setlocal iskeyword=ENUMERATION
au FileType qf call AdjustWindowHeight(3, 5)
au FileType qf set nowrap

" Set file type
augroup project
  autocmd!
  autocmd BufRead,BufNewFile *.h,*.c,*.c.m4,*.h.m4 set filetype=c
  " autocmd BufRead,BufNewFile,WinEnter *.h,*.c,*.c.m4,*.h.m4 call SetCompOpt()
  autocmd BufRead,BufNewFile *.xdm,*.xdm.m4,*.arxml.m4,*xml.m4 set filetype=xml
augroup END

" Set row highlight
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
augroup END

" Set window position variable which is used in the diff mapping
augroup WinPos
    autocmd!
    " autocmd WinEnter * echo winnr()
    autocmd WinEnter * call MapDiffCmd(winnr())
    " autocmd WinLeave * unlet g:windPosition
augroup END
"
" At reopen jump at last position in file
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

augroup AutoSwap
        autocmd!
        autocmd SwapExists *  call AS_HandleSwapfile(expand('<afile>:p'), v:swapname)
augroup END

function! MapDiffCmd(number)
    if (a:number == 1)
      map <C-Right> :diffput<CR>
      map <C-Left> :diffget<CR>
    elseif (a:number == 2)
      map <C-Right> :diffget<CR>
      map <C-Left> :diffput<CR>
    else
    endif
endfunction

function! AS_HandleSwapfile (filename, swapname)
  " if swapfile is older than file itself, just get rid of it
  if getftime(v:swapname) < getftime(a:filename)
          call delete(v:swapname)
          let v:swapchoice = 'e'
  endif
endfunction

autocmd CursorHold,BufWritePost,BufReadPost,BufLeave *
  \ if isdirectory(expand("<amatch>:h")) | let &swapfile = &modified | endif

augroup checktime
    au!
    if !has("gui_running")
        "silent! necessary otherwise throws errors when using command
        "line window.
        autocmd BufEnter,CursorHold,CursorHoldI,CursorMoved,CursorMovedI,FocusGained,BufEnter,FocusLost,WinLeave * checktime
    endif
augroup END

augroup FileChangedAlert
  " Helps if you have to use another editor on the same file
  autocmd! FileChangedShell * echoerr "File has been changed outside of Vim."
augroup END

" }}}

" {{{ Plugin settings

" -----------Language server protocol-----------
" if executable('cquery')
"    au User lsp_setup call lsp#register_server({
"       \ 'name': 'cquery',
"       \ 'cmd': {server_info->['cquery']},
"       \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
"       \ 'initialization_options': { 'cacheDirectory': userProfile.'/vim_undo/cache' },
"       \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
"       \ })
"    let g:lsp_log_file = userProfile.'/cache/vim-lsp.log'
" endif

" if executable('clangd')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'clangd',
"         \ 'cmd': {server_info->['clangd']},
"         \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
"         \ })
" endif
" let g:lsc_server_commands = {
"    \ 'c': {
"    \    'command': 'clangd',
"    \    'message_hooks': {
"    \        'initialize': {
"    \            'initializationOptions': {'foo': 'bar'},
"    \        },
"    \        'textDocument/didOpen': {'metadata': {'extraFlags': ['-Wall', '-IC:\\MinGW\\include', '-I.']}},
"    \    },
"    \  },
"    \}
" }}}


" -----------Latex-----------
" let g:vimtex_fold_enabled = 0
" let g:Tex_Folding = 0

" -----------Gutentags-----------
" let g:gutentags_ctags_exclude = ['build']
" let g:gutentags_project_root=['.svn', 'META-INF', 'plugin.xml', 'util', 'current.mk']

" " let g:gutentags_gtags_options_file=userProfile."/ctags.cnf"

" let g:gutentags_ctags_extra_args = []
" let g:gutentags_ctags_extra_args += ['-D "FUNC(rettype, memclass) rettype"']
" let g:gutentags_ctags_extra_args += ['-D "VAR(vartype, memclass) vartype"']
" let g:gutentags_ctags_extra_args += ['-D "CONST(vartype, memclass) vartype"']
" let g:gutentags_ctags_extra_args += ['-D "CONSTP2FUNC(rettype, ptrclass, fctname) rettype (* const fctname)"']
" let g:gutentags_ctags_extra_args += ['-D "P2FUNC(rettype, ptrclass, fctname) rettype (* fctname) ptrclass"']
" let g:gutentags_ctags_extra_args += ['-D "CONSTP2CONST(ptrtype, memclass, ptrclass) ptrtype const * const ptrclass"']
" let g:gutentags_ctags_extra_args += ['-D "CONSTP2VAR(ptrtype, memclass, ptrclass) ptrtype * const ptrclass"']
" let g:gutentags_ctags_extra_args += ['-D "P2CONST(ptrtype, memclass, ptrclass) ptrtype const * ptrclass"']
" let g:gutentags_ctags_extra_args += ['-D "P2VAR(ptrtype, memclass, ptrclass) ptrtype * ptrclass"']
" let g:gutentags_ctags_extra_args += ['-D "FUNC_P2VAR(rettype, ptrclass, memclass) rettype *"']
" let g:gutentags_ctags_extra_args += ['-D "FUNC_P2CONST(rettype, ptrclass, memclass) const rettype *"']

" " Gutentags -- write tags files to this folder:
" " let g:gutentags_cache_dir = userProfile.'/vim_undo/tags'

" ------------Deoplete------------
"let g:deoplete#enable_at_startup = 1

"let g:deoplete#sources#clang#executable = "C:/Program Files/LLVM/bin/clang.exe"

"" Close the documentation window when completion is done
"autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
"" autocmd CmdwinEnter * let b:deoplete_sources = ['buffer']
"let g:deoplete_sources = ['buffer', 'member', 'file', 'dictionary', 'around', 'omni']
"call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])

"let g:clang_complete_auto = 0
"let g:clang_auto_select = 0
"let g:clang_omnicppcomplete_compliance = 0
"let g:clang_make_default_keymappings = 0
""let g:clang_use_library = 1

"if has("win32")
"" maybe someday
"" let g:deoplete#sources#clang#libclang_path="C:/Program Files/LLVM/lib/libclang.lib"
"" let g:deoplete#sources#clang#clang_header="C:/Program Files/LLVM/lib/clang"
"" let g:deoplete#sources#clang#flags = [
""       \ '-isystem',
""       \ 'C:/IncC',
""       \ '-DTS_ARCH_FAMILY=TS_WINDOWS',
""       \ '-DTS_ARCH_DERIVATE=TS_WIN32X86',
""       \ ]
"endif
"
" -----------Youcompleteme-------------
if has("win32")
let g:ycm_server_python_interpreter = 'C:/Python27/python.exe'
endif
let g:ycm_confirm_extra_conf = 0
let g:ycm_min_num_of_chars_for_completion = 3
let g:ycm_complete_in_strings = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_semantic_triggers = {
      \     'c,cpp,objcpp' : 're![a-zA-Z_]',
      \ }
" TODO: ignore some of the files. eg. os
" TODO: adapt SetCompOpt for ycm

nmap <silent> gd :YcmCompleter GoTo<cr>
nmap <silent> gt :YcmCompleter GetType<cr>
nmap <silent> gf :YcmCompleter GetParent<cr>
nmap <silent> gr :YcmCompleter FixIt<cr>
nmap <silent> gD :YcmCompleter GetDoc<cr>

" let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

" Ale works faster? (not necessarily, investigate deeper)
" let g:ycm_show_diagnostics_ui = 0

" -----------Ale-----------
let g:ale_set_quickfix = 0

let g:ale_linters = {
\   'c': ['gcc'],
\   'xml': ['xmllint'],
\}

" if has("win32")
" let g:ale_c_gcc_options = "-c -pipe -std=iso9899:199409 -ffreestanding -pedantic -Wall -Wextra -Winit-self -Wswitch-default -Wunused-parameter -Wunused-label -Wunused-variable -Wunknown-pragmas -Wstrict-aliasing=3 -Wstrict-overflow=2 -Warray-bounds=1 -Wduplicated-cond -Wtrampolines -Wstack-usage=500 -Wjump-misses-init -Wsign-conversion -Wfloat-conversion -Wno-aggressive-loop-optimizations -fno-sanitize-recover -fsanitize=undefined -fsanitize=shift -fsanitize=integer-divide-by-zero -fsanitize=vla-bound -fsanitize=null -fsanitize=signed-integer-overflow -fsanitize=bounds -fsanitize=bounds-strict -fsanitize=alignment -fsanitize=object-size -fsanitize=float-divide-by-zero -fsanitize=float-cast-overflow -fsanitize=bool -fsanitize-undefined-trap-on-error -fstack-protector-strong -Wfloat-equal -Wdeclaration-after-statement -Wundef -Wno-endif-labels -Wshadow -Wbad-function-cast -Wcast-qual -Wcast-align -Wwrite-strings -Wdouble-promotion -Wnull-dereference -Wshift-negative-value -Wshift-overflow -Wunused-const-variable=2 -Wuninitialized   -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wredundant-decls -Wnested-externs -Wvla -Wvolatile-register-var -Wparentheses -Wjump-misses-init -g -Os -fno-strict-aliasing -ftree-vrp -DNOGDI -D_X86_ -D_WIN32X86_C_GCC_  -DCOMPILERCFG_EXTENSION_FILE=Compiler_CfgExt.h -DTS_ARCH_FAMILY=TS_WINDOWS -DTS_ARCH_DERIVATE=TS_WIN32X86 -DATOMICS_USE_GENERIC_IMPL=0 -DOS_KERNEL_TYPE=OS_SYSTEM_CALL -DOS_USE_TRACE=0 -DOS_DEVELOPMENT_SANITY_CHECKS=0 -DOS_MEMMAP=0 -DOS_N_CORES=1 -DOS_SCHEDULING_ALGORITHM=OS_CLZ_QUEUE -DOS_INITCORE=0 -DOS_NPERCORE_RESOURCES=0 -DOS_CPU=OS_WIN32X86 -DOS_TOOL=OS_gnu -DOS_ARCH=OS_WINDOWS -DOS_RELEASE_SUFFIX=OS_AS403 -DOS_USE_POSIX_SIGNALS_FOR_THREAD_CONTROL=0 -D_WIN32_WINNT=0x0601 -DWINVER=0x0601 -DOS_ARCH_HAS_64BIT=0 -IC:\\IncC"
" let g:ale_c_gcc_executable = "C:/mingw64/bin/gcc.exe"
" endif


" -----------LanguageClient-----------
" let g:LanguageClient_serverCommands = {
"     \ 'c': ['clangd']
"     \ }

if has("win32")
  let g:LanguageClient_serverCommands = {
        \ 'c': ['c:/MinGW/bin/cquery.exe', '--language-server','--log-stdin-stdout-to-stderr', '--log-file=C:/Temp/cq.log']
        \ }
  let g:LanguageClient_serverCommands = {
        \   'c': ['-IC:/MinGW/include']
        \ }
  let g:LanguageClient_autoStart = 1
  let g:LanguageClient_trace = 'verbose'
endif

" -----------Lightline-----------
let g:lightline = {
      \ 'colorscheme': 'hybrid',
      \ 'active': {
      \ 'left': [ [ 'mode', 'paste' ],
      \           [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'charvaluehex', 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ }

let g:lightline.tab = {
    \ 'active': [ 'tabnum', 'filename', 'modified' ],
    \ 'inactive': [ 'tabnum', 'filename', 'modified' ],
    \ 'right': [ [ 'close', 'percent' ] ] }

let g:lightline = {
  \ 'separator': { 'left': "\uE0B0", 'right': "\uE0B2" },
  \ 'subseparator': { 'left': "\uE0B1", 'right': "\uE0B3" }
  \ }
function! LightlineReadonly()
  return &readonly ? '¿' : ''
endfunction

" -----------Signify-----------
" let g:signify_disable_by_default = 0
let g:signify_vcs_list = [ 'svn' ]

" -----------EasyAlign-----------
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

let s:easy_align_delimiters = {
\  ' ': { 'pattern': ' ',  'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 },
\  '=': { 'pattern': '===\|<=>\|\(&&\|||\|<<\|>>\)=\|=\~[#?]\?\|=>\|[:+/*!%^=><&|.-]\?=[#?]\?',
\                          'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
\  ':': { 'pattern': ':',  'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 },
\  ',': { 'pattern': ',',  'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 },
\  '|': { 'pattern': '|',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
\  '.': { 'pattern': '\.', 'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 },
\  '#': { 'pattern': '#\+', 'delimiter_align': 'l', 'ignore_groups': ['!Comment']  },
\  '&': { 'pattern': '\\\@<!&\|\\\\',
\                          'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
\  '{': { 'pattern': '(\@<!{',
\                          'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
\  '}': { 'pattern': '}',  'left_margin': 1, 'right_margin': 0, 'stick_to_left': 0 },
\ ']': {
\     'pattern':       '[[\]]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ ')': {
\     'pattern':       '[()]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   }
\ }

" -----------Ag-----------
let g:ag_prg="rg -H -S --vimgrep --ignore-file $HOME\ignore"
" " let g:ag_prg="sift -n"
let g:ag_highlight=1
" let g:ag_format="%f:%l:%m"
let g:ag_format="%f:%l:%c:%m"
let g:ag_working_path_mode='r'

" -----------Ctrlp-----------
let g:ctrlp_max_history = 1000
let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
let g:ctrlp_use_caching = 0


" -----------Vaffle-----------
function! s:customize_vaffle_mappings() abort
  " Customize key mappings here
  nmap <buffer> <Bslash> <Plug>(vaffle-open-root)
  nmap <buffer> u        <Plug>(vaffle-open-parent)
  nmap <buffer> K        <Plug>(vaffle-mkdir)
  nmap <buffer> N        <Plug>(vaffle-new-file)
endfunction

augroup vimrc_vaffle
  autocmd!
  autocmd FileType vaffle call s:customize_vaffle_mappings()
augroup END

" }}}

" {{{ Functions and commands

" Toggle ColorColumn
function! ToggleColorColumn()
    if &colorcolumn != ''
        setlocal colorcolumn&
    else
        setlocal colorcolumn=100
    endif
endfunction

" toggle between number and relativenumber
function! ToggleNumber()
  if(&relativenumber == 1)
    set norelativenumber
    set number
  else
    set relativenumber
  endif
endfunc

function! StripTrailingWhitespaces()
  " save last search & cursor position
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  let @/=_s
  call cursor(l, c)
endfunction

function! AdjustWindowHeight(minheight, maxheight)
  let l = 1
  let n_lines = 0
  let w_width = winwidth(0)
  while l <= line('$')
    " number to float for division
    let l_len = strlen(getline(l)) + 0.0
    let line_width = l_len/w_width
    let n_lines += float2nr(ceil(line_width))
    let l += 1
  endw
  exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
endfunction

function! DeleteInactiveBufs()
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor

    "Below originally inspired by Hara Krishna Dara and Keith Roberts
    "http://tech.groups.yahoo.com/group/vim/message/56425
    let nWipeouts = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' i
            let nWipeouts = nWipeouts + 1
        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
endfunction

" Scratchpad
command! -nargs=0 Scratch enew | call Scratch()
command! -nargs=0 SScratch split | Scratch
command! -nargs=0 VScratch vsplit | Scratch
" define function to turn current buffer into a scratch buffer
function! Scratch()
  setlocal buftype=nofile bufhidden=hide noswapfile
endfunction

function! Nr2Bin(nr)
 let n = a:nr
 let r = ""
 while n
   let r = '01'[n % 2] . r
   let n = n / 2
 endwhile
 return r
endfunc

nnoremap gn :call DecAndHex(expand("<cWORD>"))<CR>

function! DecAndHex(number)
  let ns = '[.,;:''"<>()^_uUlL]'      " number separators
  if a:number =~? '^' . ns. '*[-+]\?\d\+' . ns . '*$'
     let dec = substitute(a:number, '[^0-9+-]*\([+-]\?\d\+\).*','\1','')
     let @+ = dec . printf(' 0x%X 0b%b', dec, Nr2Bin(dec))
     echo dec . printf(' 0x%X 0b%b', dec, Nr2Bin(dec))
  elseif a:number =~? '^' . ns. '*\%\(h''\|0x\|#\)\?\(\x\+\)' . ns . '*$'
     let hex = substitute(a:number, '.\{-}\%\(h''\|0x\|#\)\?\(\x\+\).*','\1','')
     let @+ = '0x' . hex . printf(' %d 0b%b', eval('0x'.hex), Nr2Bin(a:number))
     echon '0x' . hex . printf(' %d 0b%b', eval('0x'.hex), Nr2Bin(a:number))
  else
     echo "NaN"
  endif
endfunction

" " show the current funtion name
" fun! ShowFuncName()
"   let lnum = line(".")
"   let col = col(".")
"   echohl ModeMsg
"   let funcLine = getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
"   echo funcLine
"   " line number
"   let x = search("\\%" . lnum . "l" . "\\%" . col . "c")
"   echohl None
" endfun
" map gf :call ShowFuncName() <CR>

function! ToggleVerbose()
    if !&verbose
        set verbosefile=$HOME\vim_undo\vb.txt
        set verbose=12
    else
        set verbose=0
        set verbosefile=
    endif
endfunction

function! SplitData(Prefix, Suffix, NumChars, NewLine)
  " Splits the content of the buffer into chunks of specified number of chars,
  " adding the prefix, suffix and newline
  "
  " Example: to split a long number (12345678) into 4 digit-sized chunks,
  " adding the 0x suffix, comma prefix and starting each chunk on a new line,
  " use the following command:
  " :call SplitData("0x", ",", 4, 1)
  if (a:NewLine == 1)
    let newLine = '\r'
  else
    let newLine = ''
  endif

  :execute '%substitute/\(.\{'.a:NumChars.'\}\)/'.a:Prefix.'\1'.a:Suffix.''.newLine.'/g'
endfunction
