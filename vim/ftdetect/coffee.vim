" use space instead of tab to indent python sources
fun SetupCoffeeEnv()
	set expandtab
	set textwidth=79
	"set tabstop=2
	"set shiftwidth=2
endfun

autocmd filetype coffee call SetupCoffeeEnv()
