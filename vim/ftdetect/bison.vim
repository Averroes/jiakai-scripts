let g:yacc_uses_cpp=1
fun BisonSetup()
	set indentkeys=0{,0},:,0#,!^F,o,O,e
	set indentexpr=
	set cindent
endfun

autocmd BufNewFile,BufRead *.y call BisonSetup()
autocmd BufNewFile,BufRead *.yy call BisonSetup()
