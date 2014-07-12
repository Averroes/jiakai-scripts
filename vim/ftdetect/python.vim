" use space instead of tab to indent python sources
fun! SetupPythonEnv()
	set expandtab
	set textwidth=79

	let python_highlight_all=1
endfun

autocmd filetype python call SetupPythonEnv()
