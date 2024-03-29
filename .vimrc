"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM Configuration
" BUPTCZQ
" Version 24.03
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Goodbye VI
set nocompatible

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'liuchengxu/space-vim-dark'
Plug 'vim-scripts/matchit.zip'
Plug 'vim-scripts/visualstar.vim'
Plug 'vim-scripts/auto-pairs-gentle'
Plug 'vim-scripts/bufexplorer.zip'
Plug 'scrooloose/nerdcommenter'
Plug 'ton/vim-alternate'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mhinz/vim-startify'
Plug 'WeiChungWu/vim-SystemVerilog'
Plug 'mileszs/ack.vim'
Plug 'maxbrunsfeld/vim-yankstack'

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'prabirshrestha/asyncomplete-tags.vim'

Plug 'vim-scripts/taglist.vim'
Plug 'ludovicchabant/vim-gutentags'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" InitializeDirectories
function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'views': 'viewdir',
                \ 'undo': 'undodir' }
    let common_dir = parent . '/.' . prefix
    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()

" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
let mapleader = " "

" We love JK
inoremap jk <Esc>

" Clipboard
if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif

set iskeyword-=.                    " '.' is an end of word designator
set iskeyword-=#                    " '#' is an end of word designator
set iskeyword-=-                    " '-' is an end of word designator

" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" Always switch to the current file directory
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position
set ruler

" Highlight current line"
set cursorline

" Height of the command bar
set cmdheight=1

" Line numbers on
set number

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" Highlight problematic whitespace
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. 

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable syntax highlighting
syntax enable

" Enable 256 colors palette
if &term == 'xterm' || &term == 'screen' || &term == 'linux'
    set t_Co=256
endif

try
    colorscheme space-vim-dark
catch
    try
        colorscheme desert
    catch
    endtry
endtry

set background=dark

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set noswapfile

" persistent undo
set undofile
set undolevels=1000
set undoreload=10000

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

" Find merge conflict markers
map <leader>sc /\v^[<\|=>]{7}( .*\|$)<CR>

" Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Easier horizontal scrolling
map zl zL
map zh zH

" Buffer
nnoremap <silent> <Leader>bb :bn<CR>
nnoremap <silent> <Leader>bn :bn<CR>
nnoremap <silent> <Leader>bp :bp<CR>
nnoremap <silent> <Leader>bd :bdelete<CR>
nnoremap <silent> <Leader>bc :bdelete<CR>
nnoremap <silent> <Leader><Tab> :e#<CR>

" File
nnoremap <silent> <Leader>fs :w<CR>
nnoremap <silent> <Leader>fS :wa<CR>
nnoremap <silent> <Leader>w :w<CR>
nnoremap <silent> <Leader>q :q<CR>
nnoremap <silent> <C-_> <C-T>

" Windows
nnoremap <Leader>wj <C-W>j<C-W>_
nnoremap <Leader>wk <C-W>k<C-W>_
nnoremap <Leader>wl <C-W>l<C-W>_
nnoremap <Leader>wh <C-W>h<C-W>_
nnoremap <Leader>ww <C-W>w<C-W>_
nnoremap <silent> <Leader>ws :split<CR>
nnoremap <silent> <Leader>wv :vsplit<CR>
map <Leader>w= <C-w>=
map <Leader>wd <C-w>c

" Toggle
nnoremap <silent> <Leader>ts :setlocal spell!<CR>
nnoremap <silent> <Leader>tn :setlocal nonumber!<CR>
nnoremap <silent> <Leader>tl :setlocal nolist!<CR>
nnoremap <silent> <Leader>th :set hlsearch!<CR>
nnoremap <silent> <Leader>tw :setlocal wrap! breakindent!<CR>

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=1
catch
endtry

" Return to last edit position when opening files (You want this!)
function! ResCur()
    if line("'\"") <= line("$")
        silent! normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END

" Completion
set pumheight=15
inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<tab>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-j> ((pumvisible())?("\<C-n>"):("\<C-x><c-i>"))
inoremap <expr> <C-k> ((pumvisible())?("\<C-p>"):("\<C-x><c-o>"))

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""

" Always show the status line
set laststatus=2

set statusline=
set statusline +=%#StatusLine#\ B%n\                "buffer number
set statusline +=%#Normal#\ %<%t                    "filename
set statusline +=%#Cursor#%m                        "modified flag
set statusline +=%#Normal#%=                        "split
set statusline +=%#String#%y\ %{&ff}\               "file format
set statusline +=%{''.(&fenc!=''?&fenc:&enc).''}    "file encoding
set statusline +=%#Keyword#%5l                      "current line
set statusline +=%#Normal#/                         "split
set statusline +=%#Constant#%L                      "total lines
set statusline +=%#Keyword#\ :%3v\                  "virtual column number
set statusline +=%#Number#0x%04B\                   "character under cursor

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Better Unix / Windows compatibility
set viewoptions=folds,options,cursor,unix,slash

" Allow for cursor beyond last character
set virtualedit=onemore

" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" NERDTree
let g:NERDShutUp=1
map <leader>fT :NERDTree<CR>
map <leader>ft :NERDTreeFind<CR>
let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0

" matchit
let b:match_ignorecase = 1

" AutoPairs
let g:AutoPairsUseInsertedCount = 1

" Commenter
let g:NERDSpaceDelims = 1
let g:NERDCreateDefaultMappings = 0
let g:NERDRemoveExtraSpaces = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERD_c_alt_style = 1
let g:NERDCustomDelimiters = {'c': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' }}
map <Leader>; <Plug>NERDCommenterToggle
map <Leader>cl <Plug>NERDCommenterComment
map <Leader>cL <Plug>NERDCommenterInvert

" Alternate
map <Leader>a :Alternate<CR>

" ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
nmap <Leader>ff <C-p>

" lsp
nnoremap <Leader>d :vsp<cr>:LspDefinition<CR>
let g:lsp_diagnostics_enabled = 1

" ack
cnoreabbrev Ack Ack!
nnoremap <Leader>ss :Ack!<Space>

" buffer explorer
nnoremap <Leader>be :BufExplorerHorizontalSplit<CR>
nnoremap <Leader>bt :BufExplorerHorizontalSplit<CR>
let g:bufExplorerDisableDefaultKeyMapping=1
let g:bufExplorerSplitHorzSize=10
let g:bufExplorerSplitBelow=1

" yankstack
let g:yankstack_map_keys = 0
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste

" complete
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'allowlist': ['*'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 5000000,
    \  },
    \ }))

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'allowlist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
    \ 'name': 'tags',
    \ 'allowlist': ['c'],
    \ 'completor': function('asyncomplete#sources#tags#completor'),
    \ 'config': {
    \    'max_file_size': 50000000,
    \  },
    \ }))

function! s:fix_buffer_complete() abort
    let l:info = asyncomplete#get_source_info('buffer')
    call l:info.on_event(l:info, {}, 'BufWinEnter')
endfunction
autocmd User asyncomplete_setup call s:fix_buffer_complete()

" taglist
let g:gutentags_project_root = ['.editorconfig', '.clang-format', '.vscode']
let Tlist_Show_One_File=1
let Tlist_Use_Right_window=1
nnoremap <Leader>gt :vert winc ]<CR>
nnoremap <silent> <Leader>tt :TlistOpen<CR>
set tags=tags;

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

