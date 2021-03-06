" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
"
" BUPTCZQ's VIM dotfile
" Create at 2018.4
"
" }

" Environment {

    " pythonx {
        if has('python3')
            set pyx=3
        else
            set pyx=2
        endif
    " }

    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        set nocompatible        " Must be first line
        if !WINDOWS()
            set shell=/bin/sh
            let $VIMRC_ROOT = $HOME
            let $VIMBUNDLE_ROOT = $VIMRC_ROOT . '/.vim/bundle'
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
            set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
            let $VIMRC_ROOT = $VIM
            let $VIMBUNDLE_ROOT = $VIMRC_ROOT . '/bundle'
        endif
    " }

    " Arrow Key Fix {
        " https://github.com/spf13/spf13-vim/issues/780
        if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
            inoremap <silent> <C-[>OC <RIGHT>
        endif
    " }

" }

" Use before config if available {
    if filereadable(expand("$VIMRC_ROOT/.vimrc.before"))
        source $VIMRC_ROOT/.vimrc.before
    endif
" }

" Use bundles config {
    if filereadable(expand("$VIMRC_ROOT/.vimrc.bundles"))
        source $VIMRC_ROOT/.vimrc.bundles
    endif
" }

" General {

    set background=dark         " Assume a dark background

    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=""                " Disable mouse
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    " Most prefer to automatically switch to the current file directory when
    " a new buffer is opened; to prevent this behavior, add the following to
    " your .vimrc.before.local file:
    "   let g:spf13_no_autochdir = 1
    if !exists('g:spf13_no_autochdir')
        autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
        " Always switch to the current file directory
    endif

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set nospell                           " Spell checking off
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    " To disable this, add the following to your .vimrc.before.local file:
    "   let g:spf13_no_restore_cursor = 1
    if !exists('g:spf13_no_restore_cursor')
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
    endif

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

        " To disable views add the following to your .vimrc.before.local file:
        "   let g:spf13_no_views = 1
        if !exists('g:spf13_no_views')
            " Add exclusions to mkview and loadview
            " eg: *.*, svn-commit.tmp
            let g:skipview_files = [
                \ '\[example pattern\]'
                \ ]
        endif
    " }

" }

" Vim UI {

    if !exists('g:override_spf13_bundles') && isdirectory(expand("$VIMBUNDLE_ROOT/space-vim-dark"))
        colorscheme space-vim-dark             " Load a colorscheme
    endif

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        if !exists('g:override_spf13_bundles')
            set statusline+=%{fugitive#statusline()} " Git Hotness
        endif
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set nofoldenable                " No auto fold code
    set nolist
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" }

" Formatting {

    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    " To disable the stripping of whitespace, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_keep_trailing_whitespace = 1
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> if !exists('g:spf13_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
    autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
    " preceding line best in a plugin but here for now.

    autocmd BufNewFile,BufRead *.coffee set filetype=coffee

    " Workaround vim-commentary for Haskell
    autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    autocmd FileType haskell,rust setlocal nospell

" }

" Key (re)Mappings {

    " The default leader is '\', but many people prefer ',' as it's in a standard
    " location. To override this behavior and set it back to '\' (or any other
    " character) add the following to your .vimrc.before.local file:
    "   let g:spf13_leader='\'
    if !exists('g:spf13_leader')
        let mapleader = ' '
    else
        let mapleader=g:spf13_leader
    endif
    if !exists('g:spf13_localleader')
        let maplocalleader = '_'
    else
        let maplocalleader=g:spf13_localleader
    endif

    " The default mappings for editing and applying the spf13 configuration
    " are <leader>ev and <leader>sv respectively. Change them to your preference
    " by adding the following to your .vimrc.before.local file:
    "   let g:spf13_edit_config_mapping='<leader>ec'
    "   let g:spf13_apply_config_mapping='<leader>sc'
    if !exists('g:spf13_edit_config_mapping')
        let s:spf13_edit_config_mapping = '<leader>fed'
    else
        let s:spf13_edit_config_mapping = g:spf13_edit_config_mapping
    endif
    if !exists('g:spf13_apply_config_mapping')
        let s:spf13_apply_config_mapping = '<leader>fer'
    else
        let s:spf13_apply_config_mapping = g:spf13_apply_config_mapping
    endif

    " Easier moving in tabs and windows
    " The lines conflict with the default digraph mapping of <C-K>
    " If you prefer that functionality, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_no_easyWindows = 1
    if !exists('g:spf13_no_easyWindows')
        map <C-J> <C-W>j<C-W>_
        map <C-K> <C-W>k<C-W>_
        map <C-L> <C-W>l<C-W>_
        map <C-H> <C-W>h<C-W>_
    endif

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " End/Start of line motion keys act relative to row/wrap width in the
    " presence of `:set wrap`, and relative to line for `:set nowrap`.
    " Default vim behaviour is to act relative to text line in both cases
    " If you prefer the default behaviour, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_no_wrapRelMotion = 1
    if !exists('g:spf13_no_wrapRelMotion')
        " Same for 0, home, end, etc
        function! WrapRelativeMotion(key, ...)
            let vis_sel=""
            if a:0
                let vis_sel="gv"
            endif
            if &wrap
                execute "normal!" vis_sel . "g" . a:key
            else
                execute "normal!" vis_sel . a:key
            endif
        endfunction

        " Map g* keys in Normal, Operator-pending, and Visual+select
        noremap $ :call WrapRelativeMotion("$")<CR>
        noremap <End> :call WrapRelativeMotion("$")<CR>
        noremap 0 :call WrapRelativeMotion("0")<CR>
        noremap <Home> :call WrapRelativeMotion("0")<CR>
        noremap ^ :call WrapRelativeMotion("^")<CR>
        " Overwrite the operator pending $/<End> mappings from above
        " to force inclusive motion with :execute normal!
        onoremap $ v:call WrapRelativeMotion("$")<CR>
        onoremap <End> v:call WrapRelativeMotion("$")<CR>
        " Overwrite the Visual+select mode mappings from above
        " to ensure the correct vis_sel flag is passed to function
        vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
        vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
        vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
    endif

    " The following two lines conflict with moving to top and
    " bottom of the screen
    " If you prefer that functionality, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_no_fastTabs = 1
    if !exists('g:spf13_no_fastTabs')
        map <S-H> gT
        map <S-L> gt
    endif

    " Stupid shift key fixes
    if !exists('g:spf13_no_keyfixes')
        if has("user_commands")
            command! -bang -nargs=* -complete=file E e<bang> <args>
            command! -bang -nargs=* -complete=file W w<bang> <args>
            command! -bang -nargs=* -complete=file Wq wq<bang> <args>
            command! -bang -nargs=* -complete=file WQ wq<bang> <args>
            command! -bang Wa wa<bang>
            command! -bang WA wa<bang>
            command! -bang Q q<bang>
            command! -bang QA qa<bang>
            command! -bang Qa qa<bang>
        endif

        cmap Tabe tabe
    endif

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$


    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " Find merge conflict markers
    map <leader>sc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    " cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
    " map <leader>ew :e %%
    " map <leader>es :sp %%
    " map <leader>ev :vsp %%
    " map <leader>et :tabe %%

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    " nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " Easier formatting
    " nnoremap <silent> <leader>q gwip

    " Buffer
    nnoremap <silent> <Leader>bn :bn<CR>
    nnoremap <silent> <Leader>bp :bp<CR>
    nnoremap <silent> <Leader>bd :bdelete<CR>
    nnoremap <silent> <Leader><Tab> :e#<CR>
    " File
    nnoremap <silent> <Leader>fs :w<CR>
    nnoremap <silent> <Leader>fS :wa<CR>
    nnoremap <silent> <Leader>w :w<CR>
    nnoremap <silent> <Leader>q :wq<CR>
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

" }

" Plugins {

    " TextObj Sentence {
        if count(g:spf13_bundle_groups, 'writing')
            augroup textobj_sentence
              autocmd!
              autocmd FileType markdown call textobj#sentence#init()
              autocmd FileType textile call textobj#sentence#init()
              autocmd FileType text call textobj#sentence#init()
            augroup END
        endif
    " }

    " TextObj Quote {
        if count(g:spf13_bundle_groups, 'writing')
            augroup textobj_quote
                autocmd!
                autocmd FileType markdown call textobj#quote#init()
                autocmd FileType textile call textobj#quote#init()
                autocmd FileType text call textobj#quote#init({'educate': 0})
            augroup END
        endif
    " }

    " nerdcommenter {
        if isdirectory(expand("$VIMBUNDLE_ROOT/nerdcommenter/"))
            " Add extra space around delimiters when commenting, remove them when
            " uncommenting
            let g:NERDSpaceDelims = 1
            let g:NERDCreateDefaultMappings = 0

            " Always remove the extra spaces when uncommenting regardless of whether
            " NERDSpaceDelims is set
            let g:NERDRemoveExtraSpaces = 1

            " Use compact syntax for prettified multi-line comments
            let g:NERDCompactSexyComs = 1

            " Align line-wise comment delimiters flush left instead of following code
            " indentation
            let g:NERDDefaultAlign = 'left'

            " Allow commenting and inverting empty lines (useful when commenting a
            " region)
            let g:NERDCommentEmptyLines = 1

            " Enable trimming of trailing whitespace when uncommenting
            let g:NERDTrimTrailingWhitespace = 1

            " Always use alternative delimiter
            let g:NERD_c_alt_style = 1
            let g:NERDCustomDelimiters = {'c': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' }}

            map <Leader>; <Plug>NERDCommenterToggle
            map <Leader>cl <Plug>NERDCommenterComment
            map <Leader>cL <Plug>NERDCommenterInvert
        endif
    " }

    " Ack.vim {
        if isdirectory(expand("$VIMBUNDLE_ROOT/ack.vim/"))
            map <Leader>ss :Ack<Space>
            let g:ack_autoclose = 1
        endif
    " }

    " PIV {
        if isdirectory(expand("$VIMBUNDLE_ROOT/PIV"))
            "let g:DisableAutoPHPFolding = 0
            let g:PIVAutoClose = 0
        endif
    " }

    " EasyMotion {
        if isdirectory(expand("$VIMBUNDLE_ROOT/vim-easymotion/"))
            let g:EasyMotion_do_mapping = 0
            " Turn on case insensitive feature
            let g:EasyMotion_smartcase = 1
            nmap <Leader>jj <Plug>(easymotion-overwin-f)
            nmap <Leader>jJ <Plug>(easymotion-overwin-f2)
            map <Leader>jf <Plug>(easymotion-j)
            map <Leader>jb <Plug>(easymotion-k)
            map  <Leader>jw <Plug>(easymotion-bd-w)
            nmap <Leader>jw <Plug>(easymotion-overwin-w)
        endif
    " }

    " YankRing {
        if isdirectory(expand("$VIMBUNDLE_ROOT/YankRing.vim/"))
            nnoremap <silent> <Leader>wy :YRShow<CR>
        endif
    " }

    " emmet.vim {
        if isdirectory(expand("$VIMBUNDLE_ROOT/emmet-vim/"))
            nmap   <Leader>xee   <plug>(emmet-expand-abbr)
            nmap   <Leader>xew   <plug>(emmet-expand-word)
            nmap   <Leader>xeu   <plug>(emmet-update-tag)
        endif
    " }

    " Misc {
        if isdirectory(expand("$VIMBUNDLE_ROOT/nerdtree"))
            let g:NERDShutUp=1
        endif
        if isdirectory(expand("$VIMBUNDLE_ROOT/matchit.zip"))
            let b:match_ignorecase = 1
        endif
        if isdirectory(expand("$VIMBUNDLE_ROOT/auto-pairs-gentle"))
            let g:AutoPairsUseInsertedCount = 1
        endif
    " }

    " AutoCloseTag {
        " Make it so AutoCloseTag works for xml and xhtml files as well
        au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
        nmap <Leader>lac <Plug>ToggleAutoCloseMappings
    " }

    " SnipMate {
        " Setting the author var
        " If forking, please overwrite in your .vimrc.local file
        let g:snips_author = 'BUPTCZQ <zpcczq@gmail.com>'
    " }

    " NerdTree {
        if isdirectory(expand("$VIMBUNDLE_ROOT/nerdtree"))
            map <leader>ft <plug>NERDTreeTabsToggle<CR>
            map <leader>fT :NERDTreeFind<CR>
            "nmap <leader>nt :NERDTreeFind<CR>

            let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
            let NERDTreeChDirMode=0
            let NERDTreeQuitOnOpen=1
            let NERDTreeMouseMode=2
            let NERDTreeShowHidden=1
            let NERDTreeKeepTreeInNewTab=1
            let g:nerdtree_tabs_open_on_gui_startup=0
        endif
    " }

    " Tabularize {
        if isdirectory(expand("$VIMBUNDLE_ROOT/tabular"))
            nmap <Leader>xa& :Tabularize /&<CR>
            vmap <Leader>xa& :Tabularize /&<CR>
            nmap <Leader>xa= :Tabularize /^[^=]*\zs=<CR>
            vmap <Leader>xa= :Tabularize /^[^=]*\zs=<CR>
            nmap <Leader>xa=> :Tabularize /=><CR>
            vmap <Leader>xa=> :Tabularize /=><CR>
            nmap <Leader>xa: :Tabularize /:<CR>
            vmap <Leader>xa: :Tabularize /:<CR>
            nmap <Leader>xa:: :Tabularize /:\zs<CR>
            vmap <Leader>xa:: :Tabularize /:\zs<CR>
            nmap <Leader>xa, :Tabularize /,<CR>
            vmap <Leader>xa, :Tabularize /,<CR>
            nmap <Leader>xa,, :Tabularize /,\zs<CR>
            vmap <Leader>xa,, :Tabularize /,\zs<CR>
            nmap <Leader>xa<Bar> :Tabularize /<Bar><CR>
            vmap <Leader>xa<Bar> :Tabularize /<Bar><CR>
        endif
    " }

    " Session List {
        set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
        if isdirectory(expand("$VIMBUNDLE_ROOT/sessionman.vim/"))
            nmap <leader>pp :SessionList<CR>
            nmap <leader>ps :SessionSave<CR>
            nmap <leader>pc :SessionClose<CR>
        endif
    " }

    " JSON {
        nmap <leader>xjj <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
        let g:vim_json_syntax_conceal = 0
    " }

    " LeaderF {
        if isdirectory(expand("$VIMBUNDLE_ROOT/LeaderF/"))
            let g:Lf_ShortcutF = '<Leader>ff'
            let g:Lf_ShortcutB = '<Leader>fb'
            nnoremap <Leader>fh :LeaderfMru<cr>
            nnoremap <Leader>tt :LeaderfFunction<cr>
            "let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }

            "let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
            "let g:Lf_WorkingDirectoryMode = 'Ac'
            let g:Lf_WindowHeight = 0.30
            let g:Lf_CacheDirectory = expand('~/.vim/cache')
            "let g:Lf_ShowRelativePath = 0
            let g:Lf_HideHelp = 1
            let g:Lf_StlColorscheme = 'powerline'
        endif
    "}

    " TagBar {
        if isdirectory(expand("$VIMBUNDLE_ROOT/tagbar/"))
            nnoremap <silent> <leader>tt :TagbarToggle<CR>
        endif
    "}

    " Rainbow {
        if isdirectory(expand("$VIMBUNDLE_ROOT/rainbow/"))
            let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
        endif
    "}

    " Goyo {
        if isdirectory(expand("$VIMBUNDLE_ROOT/goyo.vim/"))
            autocmd! User GoyoEnter Limelight
            autocmd! User GoyoLeave Limelight!
            nnoremap <silent> <leader>tl :Goyo<CR>
            let g:goyo_width = 85
            let g:goyo_height = "80%"
            let g:goyo_linenr = 0

        endif
    "}

    " Fugitive {
        if isdirectory(expand("$VIMBUNDLE_ROOT/vim-fugitive/"))
            nnoremap <silent> <leader>gs :Gstatus<CR>
            nnoremap <silent> <leader>gd :Gdiff<CR>
            nnoremap <silent> <leader>gc :Gcommit<CR>
            nnoremap <silent> <leader>gb :Gblame<CR>
            nnoremap <silent> <leader>gl :Glog<CR>
            nnoremap <silent> <leader>gp :Git push<CR>
            nnoremap <silent> <leader>gr :Gread<CR>
            nnoremap <silent> <leader>gw :Gwrite<CR>
            nnoremap <silent> <leader>ge :Gedit<CR>
            " Mnemonic _i_nteractive
            nnoremap <silent> <leader>gi :Git add -p %<CR>
            nnoremap <silent> <leader>gg :SignifyToggle<CR>
        endif
    "}

    " coc.nvim {
        if count(g:spf13_bundle_groups, 'coc')
            inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
            inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
            inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
            " Use `[c` and `]c` for navigate diagnostics
            nmap <silent> [c <Plug>(coc-diagnostic-prev)
            nmap <silent> ]c <Plug>(coc-diagnostic-next)

            " Remap keys for gotos
            nmap <silent> gd <Plug>(coc-definition)
            nmap <silent> gy <Plug>(coc-type-definition)
            nmap <silent> gi <Plug>(coc-implementation)
            nmap <silent> gr <Plug>(coc-references)

            " Use K for show documentation in preview window
            nnoremap <silent> K :call <SID>show_documentation()<CR>

            function! s:show_documentation()
                if &filetype == 'vim'
                    execute 'h '.expand('<cword>')
                else
                    call CocAction('doHover')
                endif
            endfunction

            " Highlight symbol under cursor on CursorHold
            autocmd CursorHold * silent call CocActionAsync('highlight')
    " }
    "
    " Normal Vim omni-completion {
    " To disable omni complete, add the following to your .vimrc.before.local file:
    "   let g:spf13_no_omni_complete = 1
        elseif !exists('g:spf13_no_omni_complete')
            " Enable omni-completion.
            autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
            autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
            autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
            autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
            autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
            autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
            autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

        endif
    " }

    " Snippets {
        if count(g:spf13_bundle_groups, 'neocomplcache') ||
                    \ count(g:spf13_bundle_groups, 'neocomplete')

            " Use honza's snippets.
            let g:neosnippet#snippets_directory='$VIMBUNDLE_ROOT/vim-snippets/snippets'

            " Enable neosnippet snipmate compatibility mode
            let g:neosnippet#enable_snipmate_compatibility = 1

            " For snippet_complete marker.
            if !exists("g:spf13_no_conceal")
                if has('conceal')
                    set conceallevel=2 concealcursor=i
                endif
            endif

            " Enable neosnippets when using go
            let g:go_snippet_engine = "neosnippet"

            " Disable the neosnippet preview candidate window
            " When enabled, there can be too much visual noise
            " especially when splits are used.
            set completeopt-=preview
        endif
    " }

    " ALE {
        if isdirectory(expand("$VIMBUNDLE_ROOT/ale/"))
            let g:ale_sign_column_always = 1
            let g:ale_set_highlights = 0
            let g:airline#extensions#ale#enabled = 1
            nmap <silent> <Leader>ep <Plug>(ale_previous)
            nmap <silent> <Leader>en <Plug>(ale_next)
            nmap <silent> <Leader>ec <Plug>(ale_reset)
        endif
    " }

    " UndoTree {
        if isdirectory(expand("$VIMBUNDLE_ROOT/undotree/"))
            nnoremap <Leader>wu :UndotreeToggle<CR>
            " If undotree is opened, it is likely one wants to interact with it.
            let g:undotree_SetFocusWhenToggle=1
        endif
    " }

    " indent_guides {
        if isdirectory(expand("$VIMBUNDLE_ROOT/vim-indent-guides/"))
            let g:indent_guides_start_level = 2
            let g:indent_guides_guide_size = 1
            let g:indent_guides_enable_on_vim_startup = 1
        endif
        "indentLine
        if isdirectory(expand("$VIMBUNDLE_ROOT/indentLine/"))
            let g:indentLine_char='┆'
            let g:indentLine_enabled = 1
        endif
    " }

    " Wildfire {
    let g:wildfire_objects = {
                \ "*" : ["i'", 'i"', "i)", "i]", "i}", "ip"],
                \ "html,xml" : ["at"],
                \ }
    " }

    " vim-airline {
        " Set configuration options for the statusline plugin vim-airline.
        " Use the powerline theme and optionally enable powerline symbols.
        " To use the symbols , , , , , , and .in the statusline
        " segments add the following to your .vimrc.before.local file:
        "   let g:airline_powerline_fonts=1
        " If the previous symbols do not render for you then install a
        " powerline enabled font.

        " See `:echo g:airline_theme_map` for some more choices
        " Default in terminal vim is 'dark'
        if isdirectory(expand("$VIMBUNDLE_ROOT/vim-airline-themes/"))
            if !exists('g:airline_symbols')
                let g:airline_symbols = {}
            endif
            let g:airline_symbols.linenr = ''
            let g:airline_symbols.whitespace = ''
            let g:airline_symbols.maxlinenr = ''
            if !exists('g:airline_theme')
                let g:airline_theme = 'deus'
            endif
            if !exists('g:airline_powerline_fonts')
                " Use the default set of separators with a few customizations
                let g:airline_left_sep='›'  " Slightly fancier than '>'
                let g:airline_right_sep='‹' " Slightly fancier than '<'
            endif
        endif
    " }

" }

" GUI Settings {

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        "set guioptions-=T           " Remove the toolbar
        set lines=40                " 40 lines of text instead of 24
        if !exists("g:spf13_no_big_font")
            if LINUX() && has("gui_running")
                set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
            elseif OSX() && has("gui_running")
                set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
            elseif WINDOWS() && has("gui_running")
                set guifont=Andale_Mono:h12,Menlo:h12,Consolas:h12,Courier_New:h12
                set mouse=a                 " Enable mouse in Windows
            endif
        endif
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif

" }

" Functions {

    " Initialize directories {
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        " To specify a different directory in which to place the vimbackup,
        " vimviews, vimundo, and vimswap files/directories, add the following to
        " your .vimrc.before.local file:
        "   let g:spf13_consolidated_directory = <full path to desired directory>
        "   eg: let g:spf13_consolidated_directory = $HOME . '/.vim/'
        if exists('g:spf13_consolidated_directory')
            let common_dir = g:spf13_consolidated_directory . prefix
        else
            let common_dir = parent . '/.' . prefix
        endif

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
    " }

    " Initialize NERDTree as needed {
    function! NERDTreeInitAsNeeded()
        redir => bufoutput
        buffers!
        redir END
        let idx = stridx(bufoutput, "NERD_tree")
        if idx > -1
            NERDTreeMirror
            NERDTreeFind
            wincmd l
        endif
    endfunction
    " }

    " Strip whitespace {
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    " }

    " Shell command {
    function! s:RunShellCommand(cmdline)
        botright new

        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal nobuflisted
        setlocal noswapfile
        setlocal nowrap
        setlocal filetype=shell
        setlocal syntax=shell

        call setline(1, a:cmdline)
        call setline(2, substitute(a:cmdline, '.', '=', 'g'))
        execute 'silent $read !' . escape(a:cmdline, '%#')
        setlocal nomodifiable
        1
    endfunction

    command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
    " }

    function! s:ExpandFilenameAndExecute(command, file)
        execute a:command . " " . expand(a:file, ":p")
    endfunction

    function! s:EditSpf13Config()
        call <SID>ExpandFilenameAndExecute("tabedit", "$VIMRC_ROOT/.vimrc")
        call <SID>ExpandFilenameAndExecute("vsplit", "$VIMRC_ROOT/.vimrc.before")
        call <SID>ExpandFilenameAndExecute("vsplit", "$VIMRC_ROOT/.vimrc.bundles")

        execute bufwinnr(".vimrc") . "wincmd w"
        call <SID>ExpandFilenameAndExecute("split", "$VIMRC_ROOT/.vimrc.local")
        wincmd l
        call <SID>ExpandFilenameAndExecute("split", "$VIMRC_ROOT/.vimrc.before.local")
        wincmd l
        call <SID>ExpandFilenameAndExecute("split", "$VIMRC_ROOT/.vimrc.bundles.local")
        execute bufwinnr(".vimrc.local") . "wincmd w"
    endfunction

    execute "noremap " . s:spf13_edit_config_mapping " :call <SID>EditSpf13Config()<CR>"
    execute "noremap " . s:spf13_apply_config_mapping . " :source $VIMRC_ROOT/.vimrc<CR>"
" }

" Use local vimrc if available {
    if filereadable(expand("$VIMRC_ROOT/.vimrc.local"))
        source $VIMRC_ROOT/.vimrc.local
    endif
" }

" Use local gvimrc if available and gui is running {
    if has('gui_running')
        if filereadable(expand("$VIMRC_ROOT/.gvimrc.local"))
            source $VIMRC_ROOT/.gvimrc.local
        endif
    endif
" }
