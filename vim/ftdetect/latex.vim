autocmd filetype plaintex set ft=tex
fun Latex_settings()
	set grepprg=grep\ -nH\ $*
	let g:tex_flavor='latex'
	let g:Tex_CompileRule_pdf='xelatex --interaction=nonstopmode $*'
	let g:Tex_DefaultTargetFormat='pdf'
	let g:Tex_ViewRule_pdf='epdfview'
	let g:Tex_AutoFolding=0
    set textwidth=80
endfun
autocmd filetype tex call Latex_settings()
