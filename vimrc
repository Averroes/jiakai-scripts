" $File: .vimrc
" $Date: Sat Oct 19 11:16:02 2013 +0800
" $Author: Jiakai <jia.kai66@gmail.com>
"
" Features:
"	* update file header: $Date: and $File: automatically
"
"	* press L to lookup the word under cursor using sdcv
"
"	* if $MAKEFLAGS: exist in the header, the
"	  rest of the line will be appended to makeprg (c, cpp, pascal)
"	* command R: execute the file
"	* command Hexmode: toggle hex mode

if exists("g:__vimrc__loaded__")
	finish
endif

let g:__vimrc__loaded__ = 1

" script settings
let s:MYHEADER_MAX_HEIGHT = 10
let s:MAKEFLAGS_PAT = '^[^a-zA-Z]*\$MAKEFLAGS: \(.*\)$'
let s:session_yank_file = "/tmp/permanent/vim_yank.txt"


" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

language en_US.UTF-8
let $LC_ALL = 'en_US.UTF-8'

" enable persistent-undo feature for vim 7.3
if has('persistent_undo')
	set undofile
	let &undodir='/tmp'
endif


" Automatically updates the time and date in the head of the file
autocmd BufWritePre,FileWritePre *  call LastMod()
fun LastMod()
	let save_cursor = getpos(".")
	let l = line("$")
	if l > s:MYHEADER_MAX_HEIGHT
		let l = s:MYHEADER_MAX_HEIGHT
	endif
	execute '1,' . l . 'substitute/' . '^\([^a-zA-Z]*\$Date:\).*$' . '/\1 ' . strftime('%a %b %d %H:%M:%S %Y %z') . '/e'
	execute '1,' . l . 'substitute/' . '^\([^a-zA-Z]*\$File:\).*$' . '/\1 ' . expand('<afile>:t') . '/e'
	call setpos('.', save_cursor)
endfun

" enable pathogen plugin
call pathogen#infect()

" line break for Chinese
set formatoptions+=m

" enable file type detection, and load corresponding plugin and indent
" files
filetype plugin indent on

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\   exe "normal g`\"" |
			\ endif



" begin of make-related functions
fun ReadMakeflags()
	let save_cursor = getpos(".")
	let l = line("$")
	if l > s:MYHEADER_MAX_HEIGHT
		let l = s:MYHEADER_MAX_HEIGHT
	endif
	call cursor(1, 1)
	let l = search(s:MAKEFLAGS_PAT, '', l)
	if l > 0
		let b:makeflags = substitute(getline(l), s:MAKEFLAGS_PAT, ' \1', '')
	else
		let b:makeflags = ''
	endif
	call setpos(".", save_cursor)
endfun

fun RunMake(cmd, ...)
	let makeprg0 = &l:makeprg
	let &l:makeprg = a:cmd . b:makeflags
	for s in a:000
		let &l:makeprg .= " " . s
	endfor
	make
	let &l:makeprg = makeprg0
endfun

fun SetMakeGcc(compiler)
	call ReadMakeflags()
	compiler gcc
	let &l:makeprg = a:compiler . " % -o %:r -Wall -Wextra -O2" . b:makeflags
	let b:compiler = a:compiler

	command! -buffer -nargs=* Makegdb call RunMake(b:compiler . " % -o %:r -ggdb -Wall -Wextra -DDEBUG", <f-args>)
	command! -buffer -nargs=* Makepg call RunMake(b:compiler . " % -o %:r -pg -Wall -Wextra", <f-args>)
	command! -buffer -nargs=* TryCompile call RunMake(b:compiler . " % -o /tmp/vim_try_compile -Wall -Wextra -c", <f-args>)
endfun

fun SetMakeFpc()
	call ReadMakeflags()
	compiler fpc
	let &l:makeprg = 'fpc %' . b:makeflags
endfun

autocmd FileType c call SetMakeGcc('gcc')
autocmd FileType cpp call SetMakeGcc('g++')
autocmd FileType pascal call SetMakeFpc()
autocmd FileType java let &l:makeprg = '~/script/runjava %'
autocmd FileType tex let &l:makeprg = 'tex2pdf %'

" run make and open quick fix window
command! -nargs=* Make call RunMake('make', <f-args>) | cwindow 3 | botright cwindow

" end of make-related functions


" execute current file
command R execute "!" . expand('%:p:r')

" lookup the word under cursor using sdcv
fun LookUpWord()
	let cmd = "sdcv " . expand("<cword>") . " 2>&1 | less"
	execute '!' . cmd
endfun
map L :call LookUpWord() <CR>

" move cursor in insert mode
inoremap <c-h> <Left>
inoremap <c-j> <Down>
inoremap <c-k> <Up>
inoremap <c-l> <Right>
inoremap <c-c> <Home>
inoremap <c-e> <End>
inoremap <c-f> <Esc>lwi
inoremap <c-b> <Esc>bi
" jump to previous line (convenient for C code editing)
inoremap <c-o> <Esc>O
imap <c-]> <Plug>IMAP_JumpForward
	" IMAP_JumpForward uses c-j by default

" move cursor between the displayed lines instead of the physical lines
noremap  <silent> k gk
noremap  <silent> j gj

" various settings
set backspace=indent,eol,start
syntax on
set history=50
set showcmd
set incsearch
set hlsearch
set number
set shiftwidth=4
set softtabstop=4
set tabstop=4
set fileencodings=utf-8,gb2312,gbk,iso-8859,ucs-bom
set nobackup
set title
set ruler
set wildmenu
set formatoptions+=ro

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p :let current_reg = @"gvs=current_reg

" toggle gundo plugin
nnoremap <F5> :GundoToggle<CR>

" toggle NERDTree plugin
nnoremap <F9> :NERDTreeToggle<CR>


" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
	" hex mode should be considered a read-only operation
	" save values for modified and read-only for restoration later,
	" and clear the read-only flag for now
	let l:modified=&mod
	let l:oldreadonly=&readonly
	let &readonly=0
	let l:oldmodifiable=&modifiable
	let &modifiable=1
	if !exists("b:editHex") || !b:editHex
		" save old options
		let b:oldft=&ft
		let b:oldbin=&bin
		" set new options
		setlocal binary " make sure it overrides any textwidth, etc.
		let &ft="xxd"
		" set status
		let b:editHex=1
		" switch to hex editor
		%!xxd
	else
		" restore old options
		let &ft=b:oldft
		if !b:oldbin
			setlocal nobinary
		endif
		" set status
		let b:editHex=0
		" return to normal editing
		%!xxd -r
	endif
	" restore values for modified and read only state
	let &mod=l:modified
	let &readonly=l:oldreadonly
	let &modifiable=l:oldmodifiable
endfunction

" copy and paste between vim sessions
" see http://vim.wikia.com/wiki/Copy_and_paste_between_Vim_instances
map <silent> <Leader>y :call SessionYank()<CR>
vmap <silent> <Leader>y y:call SessionYank()<CR>
vmap <silent> <Leader>Y Y:call SessionYank()<CR>
nmap <silent> <Leader>p :call SessionPaste("p")<CR>
nmap <silent> <Leader>P :call SessionPaste("P")<CR>

" search tags file to parent dirs
set tags=./tags,tags;

function SessionYank()
  new
  call setline(1, getregtype())
  put
  silent exec 'wq! ' . s:session_yank_file
  exec 'bdelete ' . s:session_yank_file
endfunction

function SessionPaste(command)
  silent exec 'sview ' . s:session_yank_file
  let l:opt=getline(1)
  silent 2,$yank
  if (l:opt == 'v')
    call setreg('"', strpart(@",0,strlen(@")-1), l:opt) " strip trailing endline ?
  else
    call setreg('"', @", l:opt)
  endif
  exec 'bdelete ' . s:session_yank_file
  exec 'normal ' . a:command
endfunction

" If you prefer the Omni-Completion tip window to close when a selection is
" " made, these lines close it on movement in insert mode or when leaving
" " insert mode
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=100
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction


" search raw string
command! -nargs=1 S let @/ = escape('<args>', '\')
nmap <Leader>S :execute(":S " . input('Regex-off: /'))<CR>

let g:EclimCompletionMethod = 'omnifunc'
