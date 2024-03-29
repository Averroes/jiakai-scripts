" Vim syntax file
" Language:	TeX
" Maintainer:	Dr. Charles E. Campbell, Jr. <NdrchipO@ScampbellPfamily.AbizM>
" Last Change:	Jan 10, 2012
" Version:	72
" URL:		http://mysite.verizon.net/astronaut/vim/index.html#vimlinks_syntax
"
" Notes: {{{1
"
" 1. If you have a \begin{verbatim} that appears to overrun its boundaries,
"    use %stopzone.
"
" 2. Run-on equations ($..$ and $$..$$, particularly) can also be stopped
"    by suitable use of %stopzone.
"
" 3. If you have a slow computer, you may wish to modify
"
"	syn sync maxlines=200
"	syn sync minlines=50
"
"    to values that are more to your liking.
"
" 4. There is no match-syncing for $...$ and $$...$$; hence large
"    equation blocks constructed that way may exhibit syncing problems.
"    (there's no difference between begin/end patterns)
"
" 5. If you have the variable "g:tex_no_error" defined then none of the
"    lexical error-checking will be done.
"
"    ie. let g:tex_no_error=1

" Version Clears: {{{1
" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
let s:keepcpo= &cpo
set cpo&vim
scriptencoding utf-8

" Define the default highlighting. {{{1
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_tex_syntax_inits")
 let did_tex_syntax_inits = 1
 if version < 508
  command -nargs=+ HiLink hi link <args>
 else
  command -nargs=+ HiLink hi def link <args>
 endif
endif
if exists("g:tex_tex") && !exists("g:tex_no_error")
 let g:tex_no_error= 1
endif

" let user determine which classes of concealment will be supported
"   a=accents/ligatures d=delimiters m=math symbols  g=Greek  s=superscripts/subscripts
if !exists("g:tex_conceal")
 let s:tex_conceal= 'admgs'
else
 let s:tex_conceal= g:tex_conceal
endif

" Determine whether or not to use "*.sty" mode {{{1
" The user may override the normal determination by setting
"   g:tex_stylish to 1      (for    "*.sty" mode)
"    or to           0 else (normal "*.tex" mode)
" or on a buffer-by-buffer basis with b:tex_stylish
let s:extfname=expand("%:e")
if exists("g:tex_stylish")
 let b:tex_stylish= g:tex_stylish
elseif !exists("b:tex_stylish")
 if s:extfname == "sty" || s:extfname == "cls" || s:extfname == "clo" || s:extfname == "dtx" || s:extfname == "ltx"
  let b:tex_stylish= 1
 else
  let b:tex_stylish= 0
 endif
endif

" handle folding {{{1
if !exists("g:tex_fold_enabled")
 let g:tex_fold_enabled= 0
elseif g:tex_fold_enabled && !has("folding")
 let g:tex_fold_enabled= 0
 echomsg "Ignoring g:tex_fold_enabled=".g:tex_fold_enabled."; need to re-compile vim for +fold support"
endif
if g:tex_fold_enabled && &fdm == "manual"
 setl fdm=syntax
endif

" (La)TeX keywords: uses the characters 0-9,a-z,A-Z,192-255 only... {{{1
" but _ is the only one that causes problems.
" One may override this iskeyword setting by providing
" g:tex_isk
if exists("g:tex_isk")
 exe "setlocal isk=".g:tex_isk
else
 setlocal isk=48-57,a-z,A-Z,192-255
endif
if b:tex_stylish
  setlocal isk+=@-@
endif
if exists("g:tex_nospell") && g:tex_nospell && !exists("g:tex_comment_nospell")
 let g:tex_comment_nospell= 1
endif

" Clusters: {{{1
" --------
syn cluster texCmdGroup		contains=texCmdBody,texComment,texDefParm,texDelimiter,texDocType,texInput,texLength,texLigature,texMathDelim,texMathOper,texNewCmd,texNewEnv,texRefZone,texSection,texSectionMarker,texSectionName,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle
if !exists("g:tex_no_error")
 syn cluster texCmdGroup	add=texMathError
endif
syn cluster texEnvGroup		contains=texMatcher,texMathDelim,texSpecialChar,texStatement
syn cluster texFoldGroup	contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texInputFile,texLength,texLigature,texMatcher,texMathZoneV,texMathZoneW,texMathZoneX,texMathZoneY,texMathZoneZ,texNewCmd,texNewEnv,texOnlyMath,texOption,texParen,texRefZone,texSection,texSectionMarker,texSectionZone,texSpaceCode,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texZone,@texMathZones,texTitle,texAbstract
if !exists("g:tex_nospell") || !g:tex_nospell
 syn cluster texMatchGroup	contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texLength,texLigature,texMatcher,texNewCmd,texNewEnv,texOnlyMath,texParen,texRefZone,texSection,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texZone,texInputFile,texOption,@Spell
 syn cluster texStyleGroup	contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texLength,texLigature,texNewCmd,texNewEnv,texOnlyMath,texParen,texRefZone,texSection,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texZone,texInputFile,texOption,texStyleStatement,@Spell,texStyleMatcher
else
 syn cluster texMatchGroup	contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texLength,texLigature,texMatcher,texNewCmd,texNewEnv,texOnlyMath,texParen,texRefZone,texSection,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texZone,texInputFile,texOption
 syn cluster texStyleGroup	contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texLength,texLigature,texNewCmd,texNewEnv,texOnlyMath,texParen,texRefZone,texSection,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texZone,texInputFile,texOption,texStyleStatement,texStyleMatcher
endif
syn cluster texRefGroup		contains=texMatcher,texComment,texDelimiter
if !exists("tex_no_math")
 syn cluster texMathZones	contains=texMathZoneV,texMathZoneW,texMathZoneX,texMathZoneY,texMathZoneZ
 syn cluster texMatchGroup	add=@texMathZones
 syn cluster texMathDelimGroup	contains=texMathDelimBad,texMathDelimKey,texMathDelimSet1,texMathDelimSet2
 syn cluster texMathMatchGroup	contains=@texMathZones,texComment,texDefCmd,texDelimiter,texDocType,texInput,texLength,texLigature,texMathDelim,texMathMatcher,texMathOper,texNewCmd,texNewEnv,texRefZone,texSection,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texZone
 syn cluster texMathZoneGroup	contains=texComment,texDelimiter,texLength,texMathDelim,texMathMatcher,texMathOper,texMathSymbol,texMathText,texRefZone,texSpecialChar,texStatement,texTypeSize,texTypeStyle
 if !exists("g:tex_no_error")
  syn cluster texMathMatchGroup	add=texMathError
  syn cluster texMathZoneGroup	add=texMathError
 endif
 syn cluster texMathZoneGroup add=@NoSpell
 " following used in the \part \chapter \section \subsection \subsubsection
 " \paragraph \subparagraph \author \title highlighting
 syn cluster texDocGroup		contains=texPartZone,@texPartGroup
 syn cluster texPartGroup		contains=texChapterZone,texSectionZone,texParaZone
 syn cluster texChapterGroup		contains=texSectionZone,texParaZone
 syn cluster texSectionGroup		contains=texSubSectionZone,texParaZone
 syn cluster texSubSectionGroup		contains=texSubSubSectionZone,texParaZone
 syn cluster texSubSubSectionGroup	contains=texParaZone
 syn cluster texParaGroup		contains=texSubParaZone
 if has("conceal") && &enc == 'utf-8'
  syn cluster texMathZoneGroup	add=texGreek,texSuperscript,texSubscript,texMathSymbol
  syn cluster texMathMatchGroup	add=texGreek,texSuperscript,texSubscript,texMathSymbol
 endif
endif

" Try to flag {} and () mismatches: {{{1
if !exists("g:tex_no_error")
 syn region texMatcher		matchgroup=Delimiter start="{" skip="\\\\\|\\[{}]"	end="}"		contains=@texMatchGroup,texError
 syn region texMatcher		matchgroup=Delimiter start="\["				end="]"		contains=@texMatchGroup,texError
else
 syn region texMatcher		matchgroup=Delimiter start="{" skip="\\\\\|\\[{}]"	end="}"		contains=@texMatchGroup
 syn region texMatcher		matchgroup=Delimiter start="\["				end="]"		contains=@texMatchGroup
endif
if !exists("g:tex_nospell") || !g:tex_nospell
 syn region texParen		start="("						end=")"		contains=@texMatchGroup,@Spell
else
 syn region texParen		start="("						end=")"		contains=@texMatchGroup
endif
if !exists("g:tex_no_error")
 syn match  texError		"[}\])]"
endif
if !exists("tex_no_math")
 if !exists("g:tex_no_error")
  syn match  texMathError	"}"	contained
 endif
 syn region texMathMatcher	matchgroup=Delimiter	start="{"          skip="\\\\\|\\}"     end="}" end="%stopzone\>"	contained contains=@texMathMatchGroup
" syn region texMathMatcher	matchgroup=Unique	start="[^\\]\zs{"  skip="\\\\\|\\[{}]"  end="}" end="%stopzone\>"	contained contains=@texMathMatchGroup
endif

" TeX/LaTeX keywords: {{{1
" Instead of trying to be All Knowing, I just match \..alphameric..
" Note that *.tex files may not have "@" in their \commands
if exists("g:tex_tex") || b:tex_stylish
  syn match texStatement	"\\[a-zA-Z@]\+"
else
  syn match texStatement	"\\\a\+"
  if !exists("g:tex_no_error")
   syn match texError		"\\\a*@[a-zA-Z@]*"
  endif
endif

" TeX/LaTeX delimiters: {{{1
syn match texDelimiter		"&"
syn match texDelimiter		"\\\\"
syn match texDelimiter		"[{}]"

" Tex/Latex Options: {{{1
syn match texOption	"[^\\]\zs#\d\+\|^#\d\+"

" texAccent (tnx to Karim Belabas) avoids annoying highlighting for accents: {{{1
if b:tex_stylish
  syn match texAccent		"\\[bcdvuH][^a-zA-Z@]"me=e-1
  syn match texLigature		"\\\([ijolL]\|ae\|oe\|ss\|AA\|AE\|OE\)[^a-zA-Z@]"me=e-1
else
  syn match texAccent		"\\[bcdvuH]\A"me=e-1
  syn match texLigature		"\\\([ijolL]\|ae\|oe\|ss\|AA\|AE\|OE\)\A"me=e-1
endif
syn match texAccent		"\\[bcdvuH]$"
syn match texAccent		+\\[=^.\~"`']+
syn match texAccent		+\\['=t'.c^ud"vb~Hr]{\a}+
syn match texLigature		"\\\([ijolL]\|ae\|oe\|ss\|AA\|AE\|OE\)$"

" \begin{}/\end{} section markers: {{{1
syn match  texSectionMarker	"\\begin\>\|\\end\>" nextgroup=texSectionName
syn region texSectionName	matchgroup=Delimiter start="{" end="}"  contained	nextgroup=texSectionModifier	contains=texComment
syn region texSectionModifier	matchgroup=Delimiter start="\[" end="]" contained	contains=texComment

" \documentclass, \documentstyle, \usepackage: {{{1
syn match  texDocType		"\\documentclass\>\|\\documentstyle\>\|\\usepackage\>"	nextgroup=texSectionName,texDocTypeArgs
syn region texDocTypeArgs	matchgroup=Delimiter start="\[" end="]"			contained	nextgroup=texSectionName	contains=texComment

" Preamble syntax-based folding support: {{{1
if g:tex_fold_enabled && has("folding")
 syn region texPreamble	transparent fold	start='\zs\\documentclass\>' end='\ze\\begin{document}'	contains=texStyle,@texMatchGroup
endif

" TeX input: {{{1
syn match texInput		"\\input\s\+[a-zA-Z/.0-9_^]\+"hs=s+7				contains=texStatement
syn match texInputFile		"\\include\(graphics\|list\)\=\(\[.\{-}\]\)\=\s*{.\{-}}"	contains=texStatement,texInputCurlies,texInputFileOpt
syn match texInputFile		"\\\(epsfig\|input\|usepackage\)\s*\(\[.*\]\)\={.\{-}}"		contains=texStatement,texInputCurlies,texInputFileOpt
syn match texInputCurlies	"[{}]"								contained
syn region texInputFileOpt	matchgroup=Delimiter start="\[" end="\]"			contained	contains=texComment

" Type Styles (LaTeX 2.09): {{{1
syn match texTypeStyle		"\\rm\>"
syn match texTypeStyle		"\\em\>"
syn match texTypeStyle		"\\bf\>"
syn match texTypeStyle		"\\it\>"
syn match texTypeStyle		"\\sl\>"
syn match texTypeStyle		"\\sf\>"
syn match texTypeStyle		"\\sc\>"
syn match texTypeStyle		"\\tt\>"

" Type Styles: attributes, commands, families, etc (LaTeX2E): {{{1
syn match texTypeStyle		"\\textbf\>"
syn match texTypeStyle		"\\textit\>"
syn match texTypeStyle		"\\textmd\>"
syn match texTypeStyle		"\\textrm\>"
syn match texTypeStyle		"\\textsc\>"
syn match texTypeStyle		"\\textsf\>"
syn match texTypeStyle		"\\textsl\>"
syn match texTypeStyle		"\\texttt\>"
syn match texTypeStyle		"\\textup\>"
syn match texTypeStyle		"\\emph\>"

syn match texTypeStyle		"\\mathbb\>"
syn match texTypeStyle		"\\mathbf\>"
syn match texTypeStyle		"\\mathcal\>"
syn match texTypeStyle		"\\mathfrak\>"
syn match texTypeStyle		"\\mathit\>"
syn match texTypeStyle		"\\mathnormal\>"
syn match texTypeStyle		"\\mathrm\>"
syn match texTypeStyle		"\\mathsf\>"
syn match texTypeStyle		"\\mathtt\>"

syn match texTypeStyle		"\\rmfamily\>"
syn match texTypeStyle		"\\sffamily\>"
syn match texTypeStyle		"\\ttfamily\>"

syn match texTypeStyle		"\\itshape\>"
syn match texTypeStyle		"\\scshape\>"
syn match texTypeStyle		"\\slshape\>"
syn match texTypeStyle		"\\upshape\>"

syn match texTypeStyle		"\\bfseries\>"
syn match texTypeStyle		"\\mdseries\>"

" Some type sizes: {{{1
syn match texTypeSize		"\\tiny\>"
syn match texTypeSize		"\\scriptsize\>"
syn match texTypeSize		"\\footnotesize\>"
syn match texTypeSize		"\\small\>"
syn match texTypeSize		"\\normalsize\>"
syn match texTypeSize		"\\large\>"
syn match texTypeSize		"\\Large\>"
syn match texTypeSize		"\\LARGE\>"
syn match texTypeSize		"\\huge\>"
syn match texTypeSize		"\\Huge\>"

" Spacecodes (TeX'isms): {{{1
" \mathcode`\^^@="2201  \delcode`\(="028300  \sfcode`\)=0 \uccode`X=`X  \lccode`x=`x
syn match texSpaceCode		"\\\(math\|cat\|del\|lc\|sf\|uc\)code`"me=e-1 nextgroup=texSpaceCodeChar
syn match texSpaceCodeChar    "`\\\=.\(\^.\)\==\(\d\|\"\x\{1,6}\|`.\)"	contained

" Sections, subsections, etc: {{{1
if !exists("g:tex_nospell") || !g:tex_nospell
 if g:tex_fold_enabled && has("folding")
  syn region texDocZone			matchgroup=texSection start='\\begin\s*{\s*document\s*}' end='\\end\s*{\s*document\s*}'											fold contains=@texFoldGroup,@texDocGroup,@Spell
  syn region texPartZone		matchgroup=texSection start='\\part\>'			 end='\ze\s*\\\%(part\>\|end\s*{\s*document\s*}\)'								fold contains=@texFoldGroup,@texPartGroup,@Spell
  syn region texChapterZone		matchgroup=texSection start='\\chapter\>'		 end='\ze\s*\\\%(chapter\>\|part\>\|end\s*{\s*document\s*}\)'							fold contains=@texFoldGroup,@texChapterGroup,@Spell
  syn region texSectionZone		matchgroup=texSection start='\\section\>'		 end='\ze\s*\\\%(section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'					fold contains=@texFoldGroup,@texSectionGroup,@Spell
  syn region texSubSectionZone		matchgroup=texSection start='\\subsection\>'		 end='\ze\s*\\\%(\%(sub\)\=section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'				fold contains=@texFoldGroup,@texSubSectionGroup,@Spell
  syn region texSubSubSectionZone	matchgroup=texSection start='\\subsubsection\>'		 end='\ze\s*\\\%(\%(sub\)\{,2}section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'				fold contains=@texFoldGroup,@texSubSubSectionGroup,@Spell
  syn region texParaZone		matchgroup=texSection start='\\paragraph\>'		 end='\ze\s*\\\%(paragraph\>\|\%(sub\)*section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'			fold contains=@texFoldGroup,@texParaGroup,@Spell
  syn region texSubParaZone		matchgroup=texSection start='\\subparagraph\>'		 end='\ze\s*\\\%(\%(sub\)\=paragraph\>\|\%(sub\)*section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'	fold contains=@texFoldGroup,@Spell
  syn region texTitle			matchgroup=texSection start='\\\%(author\|title\)\>\s*{' end='}'													fold contains=@texFoldGroup,@Spell
  syn region texAbstract		matchgroup=texSection start='\\begin\s*{\s*abstract\s*}' end='\\end\s*{\s*abstract\s*}'											fold contains=@texFoldGroup,@Spell
 else
  syn region texDocZone			matchgroup=texSection start='\\begin\s*{\s*document\s*}' end='\\end\s*{\s*document\s*}'											contains=@texFoldGroup,@texDocGroup,@Spell
  syn region texPartZone		matchgroup=texSection start='\\part\>'			 end='\ze\s*\\\%(part\>\|end\s*{\s*document\s*}\)'								contains=@texFoldGroup,@texPartGroup,@Spell
  syn region texChapterZone		matchgroup=texSection start='\\chapter\>'		 end='\ze\s*\\\%(chapter\>\|part\>\|end\s*{\s*document\s*}\)'							contains=@texFoldGroup,@texChapterGroup,@Spell
  syn region texSectionZone		matchgroup=texSection start='\\section\>'		 end='\ze\s*\\\%(section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'					contains=@texFoldGroup,@texSectionGroup,@Spell
  syn region texSubSectionZone		matchgroup=texSection start='\\subsection\>'		 end='\ze\s*\\\%(\%(sub\)\=section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'				contains=@texFoldGroup,@texSubSectionGroup,@Spell
  syn region texSubSubSectionZone	matchgroup=texSection start='\\subsubsection\>'		 end='\ze\s*\\\%(\%(sub\)\{,2}section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'				contains=@texFoldGroup,@texSubSubSectionGroup,@Spell
  syn region texParaZone		matchgroup=texSection start='\\paragraph\>'		 end='\ze\s*\\\%(paragraph\>\|\%(sub\)*section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'			contains=@texFoldGroup,@texParaGroup,@Spell
  syn region texSubParaZone		matchgroup=texSection start='\\subparagraph\>'		 end='\ze\s*\\\%(\%(sub\)\=paragraph\>\|\%(sub\)*section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'	contains=@texFoldGroup,@Spell
  syn region texTitle			matchgroup=texSection start='\\\%(author\|title\)\>\s*{' end='}'													contains=@texFoldGroup,@Spell
  syn region texAbstract		matchgroup=texSection start='\\begin\s*{\s*abstract\s*}' end='\\end\s*{\s*abstract\s*}'											contains=@texFoldGroup,@Spell
 endif
else
 if g:tex_fold_enabled && has("folding")
  syn region texDocZone			matchgroup=texSection start='\\begin\s*{\s*document\s*}' end='\\end\s*{\s*document\s*}'											fold contains=@texFoldGroup,@texDocGroup
  syn region texPartZone		matchgroup=texSection start='\\part\>'			 end='\ze\s*\\\%(part\>\|end\s*{\s*document\s*}\)'								fold contains=@texFoldGroup,@texPartGroup
  syn region texChapterZone		matchgroup=texSection start='\\chapter\>'		 end='\ze\s*\\\%(chapter\>\|part\>\|end\s*{\s*document\s*}\)'							fold contains=@texFoldGroup,@texChapterGroup
  syn region texSectionZone		matchgroup=texSection start='\\section\>'		 end='\ze\s*\\\%(section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'					fold contains=@texFoldGroup,@texSectionGroup
  syn region texSubSectionZone		matchgroup=texSection start='\\subsection\>'		 end='\ze\s*\\\%(\%(sub\)\=section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'				fold contains=@texFoldGroup,@texSubSectionGroup
  syn region texSubSubSectionZone	matchgroup=texSection start='\\subsubsection\>'		 end='\ze\s*\\\%(\%(sub\)\{,2}section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'				fold contains=@texFoldGroup,@texSubSubSectionGroup
  syn region texParaZone		matchgroup=texSection start='\\paragraph\>'		 end='\ze\s*\\\%(paragraph\>\|\%(sub\)*section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'			fold contains=@texFoldGroup,@texParaGroup
  syn region texSubParaZone		matchgroup=texSection start='\\subparagraph\>'		 end='\ze\s*\\\%(\%(sub\)\=paragraph\>\|\%(sub\)*section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'	fold contains=@texFoldGroup
  syn region texTitle			matchgroup=texSection start='\\\%(author\|title\)\>\s*{' end='}'													fold contains=@texFoldGroup
  syn region texAbstract		matchgroup=texSection start='\\begin\s*{\s*abstract\s*}' end='\\end\s*{\s*abstract\s*}'											fold contains=@texFoldGroup
 else
  syn region texDocZone			matchgroup=texSection start='\\begin\s*{\s*document\s*}' end='\\end\s*{\s*document\s*}'											contains=@texFoldGroup,@texDocGroup
  syn region texPartZone		matchgroup=texSection start='\\part\>'			 end='\ze\s*\\\%(part\>\|end\s*{\s*document\s*}\)'								contains=@texFoldGroup,@texPartGroup
  syn region texChapterZone		matchgroup=texSection start='\\chapter\>'		 end='\ze\s*\\\%(chapter\>\|part\>\|end\s*{\s*document\s*}\)'							contains=@texFoldGroup,@texChapterGroup
  syn region texSectionZone		matchgroup=texSection start='\\section\>'		 end='\ze\s*\\\%(section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'					contains=@texFoldGroup,@texSectionGroup
  syn region texSubSectionZone		matchgroup=texSection start='\\subsection\>'		 end='\ze\s*\\\%(\%(sub\)\=section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'				contains=@texFoldGroup,@texSubSectionGroup
  syn region texSubSubSectionZone	matchgroup=texSection start='\\subsubsection\>'		 end='\ze\s*\\\%(\%(sub\)\{,2}section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'				contains=@texFoldGroup,@texSubSubSectionGroup
  syn region texParaZone		matchgroup=texSection start='\\paragraph\>'		 end='\ze\s*\\\%(paragraph\>\|\%(sub\)*section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'			contains=@texFoldGroup,@texParaGroup
  syn region texSubParaZone		matchgroup=texSection start='\\subparagraph\>'		 end='\ze\s*\\\%(\%(sub\)\=paragraph\>\|\%(sub\)*section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'	contains=@texFoldGroup
  syn region texTitle			matchgroup=texSection start='\\\%(author\|title\)\>\s*{' end='}'													contains=@texFoldGroup
  syn region texAbstract		matchgroup=texSection start='\\begin\s*{\s*abstract\s*}' end='\\end\s*{\s*abstract\s*}'											contains=@texFoldGroup
 endif
endif

" Bad Math (mismatched): {{{1
if !exists("tex_no_math")
 syn match texBadMath		"\\end\s*{\s*\(array\|gathered\|bBpvV]matrix\|split\|subequations\|smallmatrix\|xxalignat\)\s*}"
 syn match texBadMath		"\\end\s*{\s*\(align\|alignat\|displaymath\|displaymath\|eqnarray\|IEEEeqnarray\|equation\|flalign\|gather\|math\|multline\|xalignat\)\*\=\s*}"
 syn match texBadMath		"\\[\])]"
endif

" Math Zones: {{{1
if !exists("tex_no_math")
 " TexNewMathZone: function creates a mathzone with the given suffix and mathzone name. {{{2
 "                 Starred forms are created if starform is true.  Starred
 "                 forms have syntax group and synchronization groups with a
 "                 "S" appended.  Handles: cluster, syntax, sync, and HiLink.
 fun! TexNewMathZone(sfx,mathzone,starform)
   let grpname  = "texMathZone".a:sfx
   let syncname = "texSyncMathZone".a:sfx
   if g:tex_fold_enabled
    let foldcmd= " fold"
   else
    let foldcmd= ""
   endif
   exe "syn cluster texMathZones add=".grpname
   exe 'syn region '.grpname.' start='."'".'\\begin\s*{\s*'.a:mathzone.'\s*}'."'".' end='."'".'\\end\s*{\s*'.a:mathzone.'\s*}'."'".' keepend contains=@texMathZoneGroup'.foldcmd
   exe 'syn sync match '.syncname.' grouphere '.grpname.' "\\begin\s*{\s*'.a:mathzone.'\*\s*}"'
   exe 'syn sync match '.syncname.' grouphere '.grpname.' "\\begin\s*{\s*'.a:mathzone.'\*\s*}"'
   exe 'hi def link '.grpname.' texMath'
   if a:starform
    let grpname  = "texMathZone".a:sfx.'S'
    let syncname = "texSyncMathZone".a:sfx.'S'
    exe "syn cluster texMathZones add=".grpname
    exe 'syn region '.grpname.' start='."'".'\\begin\s*{\s*'.a:mathzone.'\*\s*}'."'".' end='."'".'\\end\s*{\s*'.a:mathzone.'\*\s*}'."'".' keepend contains=@texMathZoneGroup'.foldcmd
    exe 'syn sync match '.syncname.' grouphere '.grpname.' "\\begin\s*{\s*'.a:mathzone.'\*\s*}"'
    exe 'syn sync match '.syncname.' grouphere '.grpname.' "\\begin\s*{\s*'.a:mathzone.'\*\s*}"'
    exe 'hi def link '.grpname.' texMath'
   endif
 endfun

 " Standard Math Zones: {{{2
 call TexNewMathZone("A","align",1)
 call TexNewMathZone("B","alignat",1)
 call TexNewMathZone("C","displaymath",1)
 call TexNewMathZone("D","eqnarray",1)
 call TexNewMathZone("E","equation",1)
 call TexNewMathZone("F","flalign",1)
 call TexNewMathZone("G","gather",1)
 call TexNewMathZone("H","math",1)
 call TexNewMathZone("I","multline",1)
 call TexNewMathZone("J","subequations",0)
 call TexNewMathZone("K","xalignat",1)
 call TexNewMathZone("L","xxalignat",0)
 call TexNewMathZone("M","IEEEeqnarray",1)

 " Inline Math Zones: {{{2
 if has("conceal") && &enc == 'utf-8' && s:tex_conceal =~ 'd'
  syn region texMathZoneV	matchgroup=Delimiter start="\\("			matchgroup=Delimiter end="\\)\|%stopzone\>"	keepend concealends contains=@texMathZoneGroup
  syn region texMathZoneW	matchgroup=Delimiter start="\\\["			matchgroup=Delimiter end="\\]\|%stopzone\>"	keepend concealends contains=@texMathZoneGroup
  syn region texMathZoneX	matchgroup=Delimiter start="\$" skip="\\\\\|\\\$"	matchgroup=Delimiter end="\$" end="%stopzone\>"		concealends contains=@texMathZoneGroup
  syn region texMathZoneY	matchgroup=Delimiter start="\$\$" 			matchgroup=Delimiter end="\$\$" end="%stopzone\>"	concealends keepend		contains=@texMathZoneGroup
 else
  syn region texMathZoneV	matchgroup=Delimiter start="\\("			matchgroup=Delimiter end="\\)\|%stopzone\>"	keepend contains=@texMathZoneGroup
  syn region texMathZoneW	matchgroup=Delimiter start="\\\["			matchgroup=Delimiter end="\\]\|%stopzone\>"	keepend contains=@texMathZoneGroup
  syn region texMathZoneX	matchgroup=Delimiter start="\$" skip="\\\\\|\\\$"	matchgroup=Delimiter end="\$" end="%stopzone\>"	contains=@texMathZoneGroup
  syn region texMathZoneY	matchgroup=Delimiter start="\$\$" 			matchgroup=Delimiter end="\$\$" end="%stopzone\>"	keepend		contains=@texMathZoneGroup
 endif
 syn region texMathZoneZ	matchgroup=texStatement start="\\ensuremath\s*{"	matchgroup=texStatement end="}" end="%stopzone\>"	contains=@texMathZoneGroup

 syn match texMathOper		"[_^=]" contained

 " Text Inside Math Zones: {{{2
 if !exists("g:tex_nospell") || !g:tex_nospell
  syn region texMathText matchgroup=texStatement start='\\\(\(inter\)\=text\|mbox\)\s*{'	end='}'	contains=@texFoldGroup,@Spell
 else
  syn region texMathText matchgroup=texStatement start='\\\(\(inter\)\=text\|mbox\)\s*{'	end='}'	contains=@texFoldGroup
 endif

 " \left..something.. and \right..something.. support: {{{2
 syn match   texMathDelimBad	contained		"\S"
 if has("conceal") && &enc == 'utf-8' && s:tex_conceal =~ 'm'
  syn match   texMathDelim	contained		"\\left\\{\>"	skipwhite nextgroup=texMathDelimSet1,texMathDelimSet2,texMathDelimBad contains=texMathSymbol cchar={
  syn match   texMathDelim	contained		"\\right\\}\>"	skipwhite nextgroup=texMathDelimSet1,texMathDelimSet2,texMathDelimBad contains=texMathSymbol cchar=}
  let s:texMathDelimList=[
     \ ['<'            , '<'] ,
     \ ['>'            , '>'] ,
     \ ['('            , '('] ,
     \ [')'            , ')'] ,
     \ ['\['           , '['] ,
     \ [']'            , ']'] ,
     \ ['\\{'          , '{'] ,
     \ ['\\}'          , '}'] ,
     \ ['|'            , '|'] ,
     \ ['\\|'          , '‖'] ,
     \ ['\\backslash'  , '\'] ,
     \ ['\\downarrow'  , '↓'] ,
     \ ['\\Downarrow'  , '⇓'] ,
     \ ['\\langle'     , '<'] ,
     \ ['\\lbrace'     , '['] ,
     \ ['\\lceil'      , '⌈'] ,
     \ ['\\lfloor'     , '⌊'] ,
     \ ['\\lgroup'     , '⌊'] ,
     \ ['\\lmoustache' , '⎛'] ,
     \ ['\\rangle'     , '>'] ,
     \ ['\\rbrace'     , ']'] ,
     \ ['\\rceil'      , '⌉'] ,
     \ ['\\rfloor'     , '⌋'] ,
     \ ['\\rgroup'     , '⌋'] ,
     \ ['\\rmoustache' , '⎞'] ,
     \ ['\\uparrow'    , '↑'] ,
     \ ['\\Uparrow'    , '↑'] ,
     \ ['\\updownarrow', '↕'] ,
     \ ['\\Updownarrow', '⇕']]
  syn match texMathDelim	'\\[bB]igg\=[lr]' contained nextgroup=texMathDelimBad
  for texmath in s:texMathDelimList
   exe "syn match texMathDelim	'\\\\[bB]igg\\=[lr]\\=".texmath[0]."'	contained conceal cchar=".texmath[1]
  endfor

 else
  syn match   texMathDelim	contained		"\\\(left\|right\)\>"	skipwhite nextgroup=texMathDelimSet1,texMathDelimSet2,texMathDelimBad
  syn match   texMathDelim	contained		"\\[bB]igg\=[lr]\=\>"	skipwhite nextgroup=texMathDelimSet1,texMathDelimSet2,texMathDelimBad
  syn match   texMathDelimSet2	contained	"\\"		nextgroup=texMathDelimKey,texMathDelimBad
  syn match   texMathDelimSet1	contained	"[<>()[\]|/.]\|\\[{}|]"
  syn keyword texMathDelimKey	contained	backslash       lceil           lVert           rgroup          uparrow
  syn keyword texMathDelimKey	contained	downarrow       lfloor          rangle          rmoustache      Uparrow
  syn keyword texMathDelimKey	contained	Downarrow       lgroup          rbrace          rvert           updownarrow
  syn keyword texMathDelimKey	contained	langle          lmoustache      rceil           rVert           Updownarrow
  syn keyword texMathDelimKey	contained	lbrace          lvert           rfloor
 endif
 syn match   texMathDelim	contained		"\\\(left\|right\)arrow\>\|\<\([aA]rrow\|brace\)\=vert\>"
 syn match   texMathDelim	contained		"\\lefteqn\>"
endif

" Special TeX characters  ( \$ \& \% \# \{ \} \_ \S \P ) : {{{1
syn match texSpecialChar	"\\[$&%#{}_]"
if b:tex_stylish
  syn match texSpecialChar	"\\[SP@][^a-zA-Z@]"me=e-1
else
  syn match texSpecialChar	"\\[SP@]\A"me=e-1
endif
syn match texSpecialChar	"\\\\"
if !exists("tex_no_math")
 syn match texOnlyMath		"[_^]"
endif
syn match texSpecialChar	"\^\^[0-9a-f]\{2}\|\^\^\S"

" Comments: {{{1
"    Normal TeX LaTeX     :   %....
"    Documented TeX Format:  ^^A...	-and-	leading %s (only)
if !exists("g:tex_comment_nospell") || !g:tex_comment_nospell
 syn cluster texCommentGroup	contains=texTodo,@Spell
else
 syn cluster texCommentGroup	contains=texTodo,@NoSpell
endif
syn case ignore
syn keyword texTodo		contained		combak	fixme	todo	xxx
syn case match
if s:extfname == "dtx"
  syn match texComment		"\^\^A.*$"	contains=@texCommentGroup
  syn match texComment		"^%\+"		contains=@texCommentGroup
else
  if g:tex_fold_enabled
   " allows syntax-folding of 2 or more contiguous comment lines
   " single-line comments are not folded
   syn match  texComment	"%.*$"		contains=@texCommentGroup
   syn region texComment	start="^\zs\s*%.*\_s*%"	skip="^\s*%"	end='^\ze\s*[^%]' fold
  else
   syn match texComment		"%.*$"		contains=@texCommentGroup
  endif
endif

" Separate lines used for verb` and verb# so that the end conditions {{{1
" will appropriately terminate.
" If g:tex_verbspell exists, then verbatim texZones will permit spellchecking there.
if exists("g:tex_verbspell") && g:tex_verbspell
 syn region texZone		start="\\begin{[vV]erbatim}"		end="\\end{[vV]erbatim}\|%stopzone\>"	contains=@Spell
 " listings package:
 syn region texZone		start="\\begin{lstlisting}"		end="\\end{lstlisting}\|%stopzone\>"	contains=@Spell
 " moreverb package:
 syn region texZone		start="\\begin{verbatimtab}"		end="\\end{verbatimtab}\|%stopzone\>"	contains=@Spell
 syn region texZone		start="\\begin{verbatimwrite}"		end="\\end{verbatimwrite}\|%stopzone\>"	contains=@Spell
 syn region texZone		start="\\begin{boxedverbatim}"		end="\\end{boxedverbatim}\|%stopzone\>"	contains=@Spell
 if version < 600
  syn region texZone		start="\\verb\*\=`"			end="`\|%stopzone\>"			contains=@Spell
  syn region texZone		start="\\verb\*\=#"			end="#\|%stopzone\>"			contains=@Spell
 else
   if b:tex_stylish
    syn region texZone		start="\\verb\*\=\z([^\ta-zA-Z@]\)"	end="\z1\|%stopzone\>"			contains=@Spell
   else
    syn region texZone		start="\\verb\*\=\z([^\ta-zA-Z]\)"	end="\z1\|%stopzone\>"			contains=@Spell
   endif
 endif
else
 syn region texZone		start="\\begin{[vV]erbatim}"		end="\\end{[vV]erbatim}\|%stopzone\>"
 " listings package:
 syn region texZone		start="\\begin{lstlisting}"		end="\\end{lstlisting}\|%stopzone\>"
 " moreverb package:
 syn region texZone		start="\\begin{verbatimtab}"		end="\\end{verbatimtab}\|%stopzone\>"
 syn region texZone		start="\\begin{verbatimwrite}"		end="\\end{verbatimwrite}\|%stopzone\>"
 syn region texZone		start="\\begin{boxedverbatim}"		end="\\end{boxedverbatim}\|%stopzone\>"
 if version < 600
  syn region texZone		start="\\verb\*\=`"			end="`\|%stopzone\>"
  syn region texZone		start="\\verb\*\=#"			end="#\|%stopzone\>"
 else
   if b:tex_stylish
     syn region texZone		start="\\verb\*\=\z([^\ta-zA-Z@]\)"	end="\z1\|%stopzone\>"
   else
     syn region texZone		start="\\verb\*\=\z([^\ta-zA-Z]\)"	end="\z1\|%stopzone\>"
   endif
 endif
endif

" Tex Reference Zones: {{{1
syn region texZone		matchgroup=texStatement start="@samp{"			end="}\|%stopzone\>"	contains=@texRefGroup
syn region texRefZone		matchgroup=texStatement start="\\nocite{"		end="}\|%stopzone\>"	contains=@texRefGroup
syn region texRefZone		matchgroup=texStatement start="\\bibliography{"		end="}\|%stopzone\>"	contains=@texRefGroup
syn region texRefZone		matchgroup=texStatement start="\\label{"		end="}\|%stopzone\>"	contains=@texRefGroup
syn region texRefZone		matchgroup=texStatement start="\\\(page\|eq\)ref{"	end="}\|%stopzone\>"	contains=@texRefGroup
syn region texRefZone		matchgroup=texStatement start="\\v\=ref{"		end="}\|%stopzone\>"	contains=@texRefGroup
syn match  texRefZone		'\\cite\%([tp]\*\=\)\=' nextgroup=texRefOption,texCite
syn region texRefOption	contained	matchgroup=Delimiter start='\[' end=']'		contains=@texRefGroup,texRefZone	nextgroup=texRefOption,texCite
syn region texCite	contained	matchgroup=Delimiter start='{' end='}'		contains=@texRefGroup,texRefZone,texCite

" Handle newcommand, newenvironment : {{{1
syn match  texNewCmd				"\\newcommand\>"			nextgroup=texCmdName skipwhite skipnl
syn region texCmdName contained matchgroup=Delimiter start="{"rs=s+1  end="}"		nextgroup=texCmdArgs,texCmdBody skipwhite skipnl
syn region texCmdArgs contained matchgroup=Delimiter start="\["rs=s+1 end="]"		nextgroup=texCmdBody skipwhite skipnl
syn region texCmdBody contained matchgroup=Delimiter start="{"rs=s+1 skip="\\\\\|\\[{}]"	matchgroup=Delimiter end="}" contains=@texCmdGroup
syn match  texNewEnv				"\\newenvironment\>"			nextgroup=texEnvName skipwhite skipnl
syn region texEnvName contained matchgroup=Delimiter start="{"rs=s+1  end="}"		nextgroup=texEnvBgn skipwhite skipnl
syn region texEnvBgn  contained matchgroup=Delimiter start="{"rs=s+1  end="}"		nextgroup=texEnvEnd skipwhite skipnl contains=@texEnvGroup
syn region texEnvEnd  contained matchgroup=Delimiter start="{"rs=s+1  end="}"		skipwhite skipnl contains=@texEnvGroup

" Definitions/Commands: {{{1
syn match texDefCmd				"\\def\>"				nextgroup=texDefName skipwhite skipnl
if b:tex_stylish
  syn match texDefName contained		"\\[a-zA-Z@]\+"				nextgroup=texDefParms,texCmdBody skipwhite skipnl
  syn match texDefName contained		"\\[^a-zA-Z@]"				nextgroup=texDefParms,texCmdBody skipwhite skipnl
else
  syn match texDefName contained		"\\\a\+"				nextgroup=texDefParms,texCmdBody skipwhite skipnl
  syn match texDefName contained		"\\\A"					nextgroup=texDefParms,texCmdBody skipwhite skipnl
endif
syn match texDefParms  contained		"#[^{]*"	contains=texDefParm	nextgroup=texCmdBody skipwhite skipnl
syn match  texDefParm  contained		"#\d\+"

" TeX Lengths: {{{1
syn match  texLength		"\<\d\+\([.,]\d\+\)\=\s*\(true\)\=\s*\(bp\|cc\|cm\|dd\|em\|ex\|in\|mm\|pc\|pt\|sp\)\>"

" TeX String Delimiters: {{{1
syn match texString		"\(``\|''\|,,\)"

" makeatletter -- makeatother sections
if !exists("g:tex_no_error")
 syn region texStyle			matchgroup=texStatement start='\\makeatletter' end='\\makeatother'	contains=@texStyleGroup contained
 syn match  texStyleStatement		"\\[a-zA-Z@]\+"	contained
 syn region texStyleMatcher		matchgroup=Delimiter start="{" skip="\\\\\|\\[{}]"	end="}"		contains=@texStyleGroup,texError	contained
 syn region texStyleMatcher		matchgroup=Delimiter start="\["				end="]"		contains=@texStyleGroup,texError	contained
endif

" Conceal mode support (supports set cole=2) {{{1
if has("conceal") && &enc == 'utf-8'

 " Math Symbols {{{2
 " (many of these symbols were contributed by Björn Winckler)
 if s:tex_conceal =~ 'm'
  let s:texMathList=[
    \ ['|'		, '‖'],
    \ ['aleph'		, 'ℵ'],
    \ ['amalg'		, '∐'],
    \ ['angle'		, '∠'],
    \ ['approx'		, '≈'],
    \ ['ast'		, '∗'],
    \ ['asymp'		, '≍'],
    \ ['backepsilon'	, '∍'],
    \ ['backsimeq'	, '≃'],
    \ ['backslash'	, '∖'],
    \ ['barwedge'	, '⊼'],
    \ ['because'	, '∵'],
    \ ['between'	, '≬'],
    \ ['bigcap'		, '∩'],
    \ ['bigcirc'	, '○'],
    \ ['bigcup'		, '∪'],
    \ ['bigodot'	, '⊙'],
    \ ['bigoplus'	, '⊕'],
    \ ['bigotimes'	, '⊗'],
    \ ['bigsqcup'	, '⊔'],
    \ ['bigtriangledown', '∇'],
    \ ['bigtriangleup'	, '∆'],
    \ ['bigvee'		, '⋁'],
    \ ['bigwedge'	, '⋀'],
    \ ['blacksquare'	, '∎'],
    \ ['bot'		, '⊥'],
    \ ['bowtie'	        , '⋈'],
    \ ['boxdot'		, '⊡'],
    \ ['boxminus'	, '⊟'],
    \ ['boxplus'	, '⊞'],
    \ ['boxtimes'	, '⊠'],
    \ ['bullet'	        , '•'],
    \ ['bumpeq'		, '≏'],
    \ ['Bumpeq'		, '≎'],
    \ ['cap'		, '∩'],
    \ ['Cap'		, '⋒'],
    \ ['cdot'		, '·'],
    \ ['cdots'		, '⋯'],
    \ ['circ'		, '∘'],
    \ ['circeq'		, '≗'],
    \ ['circlearrowleft', '↺'],
    \ ['circlearrowright', '↻'],
    \ ['circledast'	, '⊛'],
    \ ['circledcirc'	, '⊚'],
    \ ['clubsuit'	, '♣'],
    \ ['complement'	, '∁'],
    \ ['cong'		, '≅'],
    \ ['coprod'		, '∐'],
    \ ['copyright'	, '©'],
    \ ['cup'		, '∪'],
    \ ['Cup'		, '⋓'],
    \ ['curlyeqprec'	, '⋞'],
    \ ['curlyeqsucc'	, '⋟'],
    \ ['curlyvee'	, '⋎'],
    \ ['curlywedge'	, '⋏'],
    \ ['dagger'	        , '†'],
    \ ['dashv'		, '⊣'],
    \ ['ddagger'	, '‡'],
    \ ['ddots'	        , '⋱'],
    \ ['diamond'	, '⋄'],
    \ ['diamondsuit'	, '♢'],
    \ ['div'		, '÷'],
    \ ['doteq'		, '≐'],
    \ ['doteqdot'	, '≑'],
    \ ['dotplus'	, '∔'],
    \ ['dots'		, '…'],
    \ ['dotsb'		, '⋯'],
    \ ['dotsc'		, '…'],
    \ ['dotsi'		, '⋯'],
    \ ['dotso'		, '…'],
    \ ['doublebarwedge'	, '⩞'],
    \ ['downarrow'	, '↓'],
    \ ['Downarrow'	, '⇓'],
    \ ['ell'		, 'ℓ'],
    \ ['emptyset'	, '∅'],
    \ ['eqcirc'		, '≖'],
    \ ['eqsim'		, '≂'],
    \ ['eqslantgtr'	, '⪖'],
    \ ['eqslantless'	, '⪕'],
    \ ['equiv'		, '≡'],
    \ ['exists'		, '∃'],
    \ ['fallingdotseq'	, '≒'],
    \ ['flat'		, '♭'],
    \ ['forall'		, '∀'],
    \ ['frown'		, '⁔'],
    \ ['ge'		, '≥'],
    \ ['geq'		, '≥'],
    \ ['geqq'		, '≧'],
    \ ['gets'		, '←'],
    \ ['gg'		, '⟫'],
    \ ['gneqq'		, '≩'],
    \ ['gtrdot'		, '⋗'],
    \ ['gtreqless'	, '⋛'],
    \ ['gtrless'	, '≷'],
    \ ['gtrsim'		, '≳'],
    \ ['hbar'		, 'ℏ'],
    \ ['heartsuit'	, '♡'],
    \ ['hookleftarrow'	, '↩'],
    \ ['hookrightarrow'	, '↪'],
    \ ['iiint'		, '∭'],
    \ ['iint'		, '∬'],
    \ ['Im'		, 'ℑ'],
    \ ['imath'		, 'ɩ'],
    \ ['in'		, '∈'],
    \ ['infty'		, '∞'],
    \ ['int'		, '∫'],
    \ ['lceil'		, '⌈'],
    \ ['ldots'		, '…'],
    \ ['le'		, '≤'],
    \ ['leadsto'	, '↝'],
    \ ['left('		, '('],
    \ ['left\['		, '['],
    \ ['left\\{'	, '{'],
    \ ['leftarrow'	, '⟵'],
    \ ['Leftarrow'	, '⟸'],
    \ ['leftarrowtail'	, '↢'],
    \ ['leftharpoondown', '↽'],
    \ ['leftharpoonup'	, '↼'],
    \ ['leftrightarrow'	, '⇔'],
    \ ['Leftrightarrow'	, '⇔'],
    \ ['leftrightsquigarrow', '↭'],
    \ ['leftthreetimes'	, '⋋'],
    \ ['leq'		, '≤'],
    \ ['leq'		, '≤'],
    \ ['leqq'		, '≦'],
    \ ['lessdot'	, '⋖'],
    \ ['lesseqgtr'	, '⋚'],
    \ ['lesssim'	, '≲'],
    \ ['lfloor'		, '⌊'],
    \ ['ll'		, '≪'],
    \ ['lmoustache'     , '╭'],
    \ ['lneqq'		, '≨'],
    \ ['ltimes'		, '⋉'],
    \ ['mapsto'		, '↦'],
    \ ['measuredangle'	, '∡'],
    \ ['mid'		, '∣'],
    \ ['models'		, '╞'],
    \ ['mp'		, '∓'],
    \ ['nabla'		, '∇'],
    \ ['natural'	, '♮'],
    \ ['ncong'		, '≇'],
    \ ['ne'		, '≠'],
    \ ['nearrow'	, '↗'],
    \ ['neg'		, '¬'],
    \ ['neq'		, '≠'],
    \ ['nexists'	, '∄'],
    \ ['ngeq'		, '≱'],
    \ ['ngeqq'		, '≱'],
    \ ['ngtr'		, '≯'],
    \ ['ni'		, '∋'],
    \ ['nleftarrow'	, '↚'],
    \ ['nLeftarrow'	, '⇍'],
    \ ['nLeftrightarrow', '⇎'],
    \ ['nleq'		, '≰'],
    \ ['nleqq'		, '≰'],
    \ ['nless'		, '≮'],
    \ ['nmid'		, '∤'],
    \ ['notin'		, '∉'],
    \ ['nprec'		, '⊀'],
    \ ['nrightarrow'	, '↛'],
    \ ['nRightarrow'	, '⇏'],
    \ ['nsim'		, '≁'],
    \ ['nsucc'		, '⊁'],
    \ ['ntriangleleft'	, '⋪'],
    \ ['ntrianglelefteq', '⋬'],
    \ ['ntriangleright'	, '⋫'],
    \ ['ntrianglerighteq', '⋭'],
    \ ['nvdash'		, '⊬'],
    \ ['nvDash'		, '⊭'],
    \ ['nVdash'		, '⊮'],
    \ ['nwarrow'	, '↖'],
    \ ['odot'		, '⊙'],
    \ ['oint'		, '∮'],
    \ ['ominus'		, '⊖'],
    \ ['oplus'		, '⊕'],
    \ ['oslash'		, '⊘'],
    \ ['otimes'		, '⊗'],
    \ ['owns'		, '∋'],
    \ ['P'	        , '¶'],
    \ ['parallel'	, '║'],
    \ ['partial'	, '∂'],
    \ ['perp'		, '⊥'],
    \ ['pitchfork'	, '⋔'],
    \ ['pm'		, '±'],
    \ ['prec'		, '≺'],
    \ ['precapprox'	, '⪷'],
    \ ['preccurlyeq'	, '≼'],
    \ ['preceq'		, '⪯'],
    \ ['precnapprox'	, '⪹'],
    \ ['precneqq'	, '⪵'],
    \ ['precsim'	, '≾'],
    \ ['prime'		, '′'],
    \ ['prod'		, '∏'],
    \ ['propto'		, '∝'],
    \ ['rceil'		, '⌉'],
    \ ['Re'		, 'ℜ'],
    \ ['rfloor'		, '⌋'],
    \ ['right)'		, ')'],
    \ ['right]'		, ']'],
    \ ['right\\}'	, '}'],
    \ ['rightarrow'	, '⟶'],
    \ ['Rightarrow'	, '⟹'],
    \ ['rightarrowtail'	, '↣'],
    \ ['rightleftharpoons', '⇌'],
    \ ['rightsquigarrow', '↝'],
    \ ['rightthreetimes', '⋌'],
    \ ['risingdotseq'	, '≓'],
    \ ['rmoustache'     , '╮'],
    \ ['rtimes'		, '⋊'],
    \ ['S'	        , '§'],
    \ ['searrow'	, '↘'],
    \ ['setminus'	, '∖'],
    \ ['sharp'		, '♯'],
    \ ['sim'		, '∼'],
    \ ['simeq'		, '⋍'],
    \ ['smile'		, '‿'],
    \ ['spadesuit'	, '♠'],
    \ ['sphericalangle'	, '∢'],
    \ ['sqcap'		, '⊓'],
    \ ['sqcup'		, '⊔'],
    \ ['sqsubset'	, '⊏'],
    \ ['sqsubseteq'	, '⊑'],
    \ ['sqsupset'	, '⊐'],
    \ ['sqsupseteq'	, '⊒'],
    \ ['star'		, '✫'],
    \ ['subset'		, '⊂'],
    \ ['Subset'		, '⋐'],
    \ ['subseteq'	, '⊆'],
    \ ['subseteqq'	, '⫅'],
    \ ['subsetneq'	, '⊊'],
    \ ['subsetneqq'	, '⫋'],
    \ ['succ'		, '≻'],
    \ ['succapprox'	, '⪸'],
    \ ['succcurlyeq'	, '≽'],
    \ ['succeq'		, '⪰'],
    \ ['succnapprox'	, '⪺'],
    \ ['succneqq'	, '⪶'],
    \ ['succsim'	, '≿'],
    \ ['sum'		, '∑'],
    \ ['supset'		, '⊃'],
    \ ['Supset'		, '⋑'],
    \ ['supseteq'	, '⊇'],
    \ ['supseteqq'	, '⫆'],
    \ ['supsetneq'	, '⊋'],
    \ ['supsetneqq'	, '⫌'],
    \ ['surd'		, '√'],
    \ ['swarrow'	, '↙'],
    \ ['therefore'	, '∴'],
    \ ['times'		, '×'],
    \ ['to'		, '→'],
    \ ['top'		, '⊤'],
    \ ['triangle'	, '∆'],
    \ ['triangleleft'	, '⊲'],
    \ ['trianglelefteq'	, '⊴'],
    \ ['triangleq'	, '≜'],
    \ ['triangleright'	, '⊳'],
    \ ['trianglerighteq', '⊵'],
    \ ['twoheadleftarrow', '↞'],
    \ ['twoheadrightarrow', '↠'],
    \ ['uparrow'	, '↑'],
    \ ['Uparrow'	, '⇑'],
    \ ['updownarrow'	, '↕'],
    \ ['Updownarrow'	, '⇕'],
    \ ['varnothing'	, '∅'],
    \ ['vartriangle'	, '∆'],
    \ ['vdash'		, '⊢'],
    \ ['vDash'		, '⊨'],
    \ ['Vdash'		, '⊩'],
    \ ['vdots'		, '⋮'],
    \ ['vee'		, '∨'],
    \ ['veebar'		, '⊻'],
    \ ['Vvdash'		, '⊪'],
    \ ['wedge'		, '∧'],
    \ ['wp'		, '℘'],
    \ ['wr'		, '≀']]
"    \ ['jmath'		, 'X']
"    \ ['uminus'	, 'X']
"    \ ['uplus'		, 'X']
  for texmath in s:texMathList
   if texmath[0] =~ '\w$'
    exe "syn match texMathSymbol '\\\\".texmath[0]."\\>' contained conceal cchar=".texmath[1]
   else
    exe "syn match texMathSymbol '\\\\".texmath[0]."' contained conceal cchar=".texmath[1]
   endif
  endfor

  if &ambw == "double"
   syn match texMathSymbol '\\gg\>'			contained conceal cchar=≫
   syn match texMathSymbol '\\ll\>'			contained conceal cchar=≪
  else
   syn match texMathSymbol '\\gg\>'			contained conceal cchar=⟫
   syn match texMathSymbol '\\ll\>'			contained conceal cchar=⟪
  endif

  syn match texMathSymbol '\\hat{a}' contained conceal cchar=â
  syn match texMathSymbol '\\hat{A}' contained conceal cchar=Â
  syn match texMathSymbol '\\hat{c}' contained conceal cchar=ĉ
  syn match texMathSymbol '\\hat{C}' contained conceal cchar=Ĉ
  syn match texMathSymbol '\\hat{e}' contained conceal cchar=ê
  syn match texMathSymbol '\\hat{E}' contained conceal cchar=Ê
  syn match texMathSymbol '\\hat{g}' contained conceal cchar=ĝ
  syn match texMathSymbol '\\hat{G}' contained conceal cchar=Ĝ
  syn match texMathSymbol '\\hat{i}' contained conceal cchar=î
  syn match texMathSymbol '\\hat{I}' contained conceal cchar=Î
  syn match texMathSymbol '\\hat{o}' contained conceal cchar=ô
  syn match texMathSymbol '\\hat{O}' contained conceal cchar=Ô
  syn match texMathSymbol '\\hat{s}' contained conceal cchar=ŝ
  syn match texMathSymbol '\\hat{S}' contained conceal cchar=Ŝ
  syn match texMathSymbol '\\hat{u}' contained conceal cchar=û
  syn match texMathSymbol '\\hat{U}' contained conceal cchar=Û
  syn match texMathSymbol '\\hat{w}' contained conceal cchar=ŵ
  syn match texMathSymbol '\\hat{W}' contained conceal cchar=Ŵ
  syn match texMathSymbol '\\hat{y}' contained conceal cchar=ŷ
  syn match texMathSymbol '\\hat{Y}' contained conceal cchar=Ŷ
 endif

 " Greek {{{2
 if s:tex_conceal =~ 'g'
  fun! s:Greek(group,pat,cchar)
    exe 'syn match '.a:group." '".a:pat."' contained conceal cchar=".a:cchar
  endfun
  call s:Greek('texGreek','\\alpha\>'		,'α')
  call s:Greek('texGreek','\\beta\>'		,'β')
  call s:Greek('texGreek','\\gamma\>'		,'γ')
  call s:Greek('texGreek','\\delta\>'		,'δ')
  call s:Greek('texGreek','\\epsilon\>'		,'ϵ')
  call s:Greek('texGreek','\\varepsilon\>'	,'ε')
  call s:Greek('texGreek','\\zeta\>'		,'ζ')
  call s:Greek('texGreek','\\eta\>'		,'η')
  call s:Greek('texGreek','\\theta\>'		,'θ')
  call s:Greek('texGreek','\\vartheta\>'		,'ϑ')
  call s:Greek('texGreek','\\kappa\>'		,'κ')
  call s:Greek('texGreek','\\lambda\>'		,'λ')
  call s:Greek('texGreek','\\mu\>'		,'μ')
  call s:Greek('texGreek','\\nu\>'		,'ν')
  call s:Greek('texGreek','\\xi\>'		,'ξ')
  call s:Greek('texGreek','\\pi\>'		,'π')
  call s:Greek('texGreek','\\varpi\>'		,'ϖ')
  call s:Greek('texGreek','\\rho\>'		,'ρ')
  call s:Greek('texGreek','\\varrho\>'		,'ϱ')
  call s:Greek('texGreek','\\sigma\>'		,'σ')
  call s:Greek('texGreek','\\varsigma\>'		,'ς')
  call s:Greek('texGreek','\\tau\>'		,'τ')
  call s:Greek('texGreek','\\upsilon\>'		,'υ')
  call s:Greek('texGreek','\\phi\>'		,'φ')
  call s:Greek('texGreek','\\varphi\>'		,'ϕ')
  call s:Greek('texGreek','\\chi\>'		,'χ')
  call s:Greek('texGreek','\\psi\>'		,'ψ')
  call s:Greek('texGreek','\\omega\>'		,'ω')
  call s:Greek('texGreek','\\Gamma\>'		,'Γ')
  call s:Greek('texGreek','\\Delta\>'		,'Δ')
  call s:Greek('texGreek','\\Theta\>'		,'Θ')
  call s:Greek('texGreek','\\Lambda\>'		,'Λ')
  call s:Greek('texGreek','\\Xi\>'		,'Χ')
  call s:Greek('texGreek','\\Pi\>'		,'Π')
  call s:Greek('texGreek','\\Sigma\>'		,'Σ')
  call s:Greek('texGreek','\\Upsilon\>'		,'Υ')
  call s:Greek('texGreek','\\Phi\>'		,'Φ')
  call s:Greek('texGreek','\\Psi\>'		,'Ψ')
  call s:Greek('texGreek','\\Omega\>'		,'Ω')
  delfun s:Greek
 endif

 " Superscripts/Subscripts {{{2
 if s:tex_conceal =~ 's'
  syn region texSuperscript	matchgroup=Delimiter start='\^{'	skip="\\\\\|\\[{}]" end='}'	contained concealends contains=texSpecialChar,texSuperscripts,texStatement,texSubscript,texSuperscript,texMathMatcher
  syn region texSubscript	matchgroup=Delimiter start='_{'		skip="\\\\\|\\[{}]" end='}'	contained concealends contains=texSpecialChar,texSubscripts,texStatement,texSubscript,texSuperscript,texMathMatcher
  fun! s:SuperSub(group,leader,pat,cchar)
    exe 'syn match '.a:group." '".a:leader.a:pat."' contained conceal cchar=".a:cchar
    exe 'syn match '.a:group."s '".a:pat."' contained conceal cchar=".a:cchar.' nextgroup='.a:group.'s'
  endfun
  call s:SuperSub('texSuperscript','\^','0','⁰')
  call s:SuperSub('texSuperscript','\^','1','¹')
  call s:SuperSub('texSuperscript','\^','2','²')
  call s:SuperSub('texSuperscript','\^','3','³')
  call s:SuperSub('texSuperscript','\^','4','⁴')
  call s:SuperSub('texSuperscript','\^','5','⁵')
  call s:SuperSub('texSuperscript','\^','6','⁶')
  call s:SuperSub('texSuperscript','\^','7','⁷')
  call s:SuperSub('texSuperscript','\^','8','⁸')
  call s:SuperSub('texSuperscript','\^','9','⁹')
  call s:SuperSub('texSuperscript','\^','a','ᵃ')
  call s:SuperSub('texSuperscript','\^','b','ᵇ')
  call s:SuperSub('texSuperscript','\^','c','ᶜ')
  call s:SuperSub('texSuperscript','\^','d','ᵈ')
  call s:SuperSub('texSuperscript','\^','e','ᵉ')
  call s:SuperSub('texSuperscript','\^','f','ᶠ')
  call s:SuperSub('texSuperscript','\^','g','ᵍ')
  call s:SuperSub('texSuperscript','\^','h','ʰ')
  call s:SuperSub('texSuperscript','\^','i','ⁱ')
  call s:SuperSub('texSuperscript','\^','j','ʲ')
  call s:SuperSub('texSuperscript','\^','k','ᵏ')
  call s:SuperSub('texSuperscript','\^','l','ˡ')
  call s:SuperSub('texSuperscript','\^','m','ᵐ')
  call s:SuperSub('texSuperscript','\^','n','ⁿ')
  call s:SuperSub('texSuperscript','\^','o','ᵒ')
  call s:SuperSub('texSuperscript','\^','p','ᵖ')
  call s:SuperSub('texSuperscript','\^','r','ʳ')
  call s:SuperSub('texSuperscript','\^','s','ˢ')
  call s:SuperSub('texSuperscript','\^','t','ᵗ')
  call s:SuperSub('texSuperscript','\^','u','ᵘ')
  call s:SuperSub('texSuperscript','\^','v','ᵛ')
  call s:SuperSub('texSuperscript','\^','w','ʷ')
  call s:SuperSub('texSuperscript','\^','x','ˣ')
  call s:SuperSub('texSuperscript','\^','y','ʸ')
  call s:SuperSub('texSuperscript','\^','z','ᶻ')
  call s:SuperSub('texSuperscript','\^','A','ᴬ')
  call s:SuperSub('texSuperscript','\^','B','ᴮ')
  call s:SuperSub('texSuperscript','\^','D','ᴰ')
  call s:SuperSub('texSuperscript','\^','E','ᴱ')
  call s:SuperSub('texSuperscript','\^','G','ᴳ')
  call s:SuperSub('texSuperscript','\^','H','ᴴ')
  call s:SuperSub('texSuperscript','\^','I','ᴵ')
  call s:SuperSub('texSuperscript','\^','J','ᴶ')
  call s:SuperSub('texSuperscript','\^','K','ᴷ')
  call s:SuperSub('texSuperscript','\^','L','ᴸ')
  call s:SuperSub('texSuperscript','\^','M','ᴹ')
  call s:SuperSub('texSuperscript','\^','N','ᴺ')
  call s:SuperSub('texSuperscript','\^','O','ᴼ')
  call s:SuperSub('texSuperscript','\^','P','ᴾ')
  call s:SuperSub('texSuperscript','\^','R','ᴿ')
  call s:SuperSub('texSuperscript','\^','T','ᵀ')
  call s:SuperSub('texSuperscript','\^','U','ᵁ')
  call s:SuperSub('texSuperscript','\^','W','ᵂ')
  call s:SuperSub('texSuperscript','\^',',','︐')
  call s:SuperSub('texSuperscript','\^',':','︓')
  call s:SuperSub('texSuperscript','\^',';','︔')
  call s:SuperSub('texSuperscript','\^','+','⁺')
  call s:SuperSub('texSuperscript','\^','-','⁻')
  call s:SuperSub('texSuperscript','\^','<','˂')
  call s:SuperSub('texSuperscript','\^','>','˃')
  call s:SuperSub('texSuperscript','\^','/','ˊ')
  call s:SuperSub('texSuperscript','\^','(','⁽')
  call s:SuperSub('texSuperscript','\^',')','⁾')
  call s:SuperSub('texSuperscript','\^','\.','˙')
  call s:SuperSub('texSuperscript','\^','=','˭')
  call s:SuperSub('texSubscript','_','0','₀')
  call s:SuperSub('texSubscript','_','1','₁')
  call s:SuperSub('texSubscript','_','2','₂')
  call s:SuperSub('texSubscript','_','3','₃')
  call s:SuperSub('texSubscript','_','4','₄')
  call s:SuperSub('texSubscript','_','5','₅')
  call s:SuperSub('texSubscript','_','6','₆')
  call s:SuperSub('texSubscript','_','7','₇')
  call s:SuperSub('texSubscript','_','8','₈')
  call s:SuperSub('texSubscript','_','9','₉')
  call s:SuperSub('texSubscript','_','a','ₐ')
  call s:SuperSub('texSubscript','_','e','ₑ')
  call s:SuperSub('texSubscript','_','i','ᵢ')
  call s:SuperSub('texSubscript','_','o','ₒ')
  call s:SuperSub('texSubscript','_','u','ᵤ')
  call s:SuperSub('texSubscript','_',',','︐')
  call s:SuperSub('texSubscript','_','+','₊')
  call s:SuperSub('texSubscript','_','-','₋')
  call s:SuperSub('texSubscript','_','/','ˏ')
  call s:SuperSub('texSubscript','_','(','₍')
  call s:SuperSub('texSubscript','_',')','₎')
  call s:SuperSub('texSubscript','_','\.','‸')
  call s:SuperSub('texSubscript','_','r','ᵣ')
  call s:SuperSub('texSubscript','_','v','ᵥ')
  call s:SuperSub('texSubscript','_','x','ₓ')
  call s:SuperSub('texSubscript','_','\\beta\>' ,'ᵦ')
  call s:SuperSub('texSubscript','_','\\delta\>','ᵨ')
  call s:SuperSub('texSubscript','_','\\phi\>'  ,'ᵩ')
  call s:SuperSub('texSubscript','_','\\gamma\>','ᵧ')
  call s:SuperSub('texSubscript','_','\\chi\>'  ,'ᵪ')
  delfun s:SuperSub
 endif

 " Accented characters: {{{2
 if s:tex_conceal =~ 'a'
  if b:tex_stylish
   syn match texAccent		"\\[bcdvuH][^a-zA-Z@]"me=e-1
   syn match texLigature		"\\\([ijolL]\|ae\|oe\|ss\|AA\|AE\|OE\)[^a-zA-Z@]"me=e-1
  else
   fun! s:Accents(chr,...)
     let i= 1
     for accent in ["`","\\'","^",'"','\~','\.',"c","H","k","r","u","v"]
      if i > a:0
       break
      endif
      if strlen(a:{i}) == 0 || a:{i} == ' ' || a:{i} == '?'
       let i= i + 1
       continue
      endif
      if accent =~ '\a'
       exe "syn match texAccent '".'\\'.accent.'\(\s*{'.a:chr.'}\|\s\+'.a:chr.'\)'."' conceal cchar=".a:{i}
      else
       exe "syn match texAccent '".'\\'.accent.'\s*\({'.a:chr.'}\|'.a:chr.'\)'."' conceal cchar=".a:{i}
      endif
      let i= i + 1
     endfor
   endfun
   "                  \`  \'  \^  \"  \~  \.  \c  \H  \k  \r  \u  \v
   call s:Accents('a','à','á','â','ä','ã','ȧ',' ',' ','ą','å','ă','ă')
   call s:Accents('A','À','Á','Â','Ä','Ã','Ȧ',' ',' ','Ą','Å','Ă','Ă')
   call s:Accents('c',' ','ć','ĉ',' ',' ','ċ','ç',' ',' ',' ',' ','č')
   call s:Accents('C',' ','Ć','Ĉ',' ',' ','Ċ','Ç',' ',' ',' ',' ','Č')
   call s:Accents('d',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','ď')
   call s:Accents('D',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','Ď')
   call s:Accents('e','è','é','ê','ë','ẽ','ė','ȩ',' ','ę',' ','ĕ','ě')
   call s:Accents('E','È','É','Ê','Ë','Ẽ','Ė','Ȩ',' ','Ę',' ','Ĕ','Ě')
   call s:Accents('g',' ','ǵ','ĝ',' ',' ','ġ','ģ',' ',' ',' ','ğ',' ')
   call s:Accents('G',' ','Ǵ','Ĝ',' ',' ','Ġ','Ģ',' ',' ',' ','Ğ',' ')
   call s:Accents('h',' ',' ','ĥ',' ',' ',' ',' ',' ',' ',' ',' ','ȟ')
   call s:Accents('H',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','Ȟ')
   call s:Accents('i','ì','í','î','ï','ĩ','į',' ',' ',' ',' ','ĭ',' ')
   call s:Accents('I','Ì','Í','Î','Ï','Ĩ','İ',' ',' ',' ',' ','Ĭ',' ')
   call s:Accents('J',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','ǰ')
   call s:Accents('k',' ',' ',' ',' ',' ',' ','ķ',' ',' ',' ',' ',' ')
   call s:Accents('K',' ',' ',' ',' ',' ',' ','Ķ',' ',' ',' ',' ',' ')
   call s:Accents('l',' ','ĺ','ľ',' ',' ',' ','ļ',' ',' ',' ',' ','ľ')
   call s:Accents('L',' ','Ĺ','Ľ',' ',' ',' ','Ļ',' ',' ',' ',' ','Ľ')
   call s:Accents('n',' ','ń',' ',' ','ñ',' ','ņ',' ',' ',' ',' ','ň')
   call s:Accents('N',' ','Ń',' ',' ','Ñ',' ','Ņ',' ',' ',' ',' ','Ň')
   call s:Accents('o','ò','ó','ô','ö','õ','ȯ',' ','ő','ǫ',' ','ŏ',' ')
   call s:Accents('O','Ò','Ó','Ô','Ö','Õ','Ȯ',' ','Ő','Ǫ',' ','Ŏ',' ')
   call s:Accents('r',' ','ŕ',' ',' ',' ',' ','ŗ',' ',' ',' ',' ','ř')
   call s:Accents('R',' ','Ŕ',' ',' ',' ',' ','Ŗ',' ',' ',' ',' ','Ř')
   call s:Accents('s',' ','ś','ŝ',' ',' ',' ','ş',' ','ȿ',' ',' ','š')
   call s:Accents('S',' ','Ś','Ŝ',' ',' ',' ','Ş',' ',' ',' ',' ','Š')
   call s:Accents('t',' ',' ',' ',' ',' ',' ','ţ',' ',' ',' ',' ','ť')
   call s:Accents('T',' ',' ',' ',' ',' ',' ','Ţ',' ',' ',' ',' ','Ť')
   call s:Accents('u','ù','ú','û','ü','ũ',' ',' ','ű','ų','ů','ŭ','ǔ')
   call s:Accents('U','Ù','Ú','Û','Ü','Ũ',' ',' ','Ű','Ų','Ů','Ŭ','Ǔ')
   call s:Accents('w',' ',' ','ŵ',' ',' ',' ',' ',' ',' ',' ',' ',' ')
   call s:Accents('W',' ',' ','Ŵ',' ',' ',' ',' ',' ',' ',' ',' ',' ')
   call s:Accents('y','ỳ','ý','ŷ','ÿ','ỹ',' ',' ',' ',' ',' ',' ',' ')
   call s:Accents('Y','Ỳ','Ý','Ŷ','Ÿ','Ỹ',' ',' ',' ',' ',' ',' ',' ')
   call s:Accents('z',' ','ź',' ',' ',' ','ż',' ',' ',' ',' ',' ','ž')
   call s:Accents('Z',' ','Ź',' ',' ',' ','Ż',' ',' ',' ',' ',' ','Ž')
   call s:Accents('\\i','ì','í','î','ï','ĩ','į',' ',' ',' ',' ','ĭ',' ')
   "                  \`  \'  \^  \"  \~  \.  \c  \H  \k  \r  \u  \v
   delfun s:Accents
   syn match texAccent   '\\aa\>'	conceal cchar=å
   syn match texAccent   '\\AA\>'	conceal cchar=Å
   syn match texAccent	'\\o\>'		conceal cchar=ø
   syn match texAccent	'\\O\>'		conceal cchar=Ø
   syn match texLigature	'\\AE\>'	conceal cchar=Æ
   syn match texLigature	'\\ae\>'	conceal cchar=æ
   syn match texLigature	'\\oe\>'	conceal cchar=œ
   syn match texLigature	'\\OE\>'	conceal cchar=Œ
   syn match texLigature	'\\ss\>'	conceal cchar=ß
  endif
 endif
endif

" ---------------------------------------------------------------------
" LaTeX synchronization: {{{1
syn sync maxlines=200
syn sync minlines=50

syn  sync match texSyncStop			groupthere NONE		"%stopzone\>"

" Synchronization: {{{1
" The $..$ and $$..$$ make for impossible sync patterns
" (one can't tell if a "$$" starts or stops a math zone by itself)
" The following grouptheres coupled with minlines above
" help improve the odds of good syncing.
if !exists("tex_no_math")
 syn sync match texSyncMathZoneA		groupthere NONE		"\\end{abstract}"
 syn sync match texSyncMathZoneA		groupthere NONE		"\\end{center}"
 syn sync match texSyncMathZoneA		groupthere NONE		"\\end{description}"
 syn sync match texSyncMathZoneA		groupthere NONE		"\\end{enumerate}"
 syn sync match texSyncMathZoneA		groupthere NONE		"\\end{itemize}"
 syn sync match texSyncMathZoneA		groupthere NONE		"\\end{table}"
 syn sync match texSyncMathZoneA		groupthere NONE		"\\end{tabular}"
 syn sync match texSyncMathZoneA		groupthere NONE		"\\\(sub\)*section\>"
endif

" ---------------------------------------------------------------------
" Highlighting: {{{1
if did_tex_syntax_inits == 1
 let did_tex_syntax_inits= 2
  " TeX highlighting groups which should share similar highlighting
  if !exists("g:tex_no_error")
   if !exists("tex_no_math")
    HiLink texBadMath		texError
    HiLink texMathDelimBad	texError
    HiLink texMathError		texError
    if !b:tex_stylish
      HiLink texOnlyMath	texError
    endif
   endif
   HiLink texError		Error
  endif

  HiLink texCite		texRefZone
  HiLink texDefCmd		texDef
  HiLink texDefName		texDef
  HiLink texDocType		texCmdName
  HiLink texDocTypeArgs		texCmdArgs
  HiLink texInputFileOpt	texCmdArgs
  HiLink texInputCurlies	texDelimiter
  HiLink texLigature		texSpecialChar
  if !exists("tex_no_math")
   HiLink texMathDelimSet1	texMathDelim
   HiLink texMathDelimSet2	texMathDelim
   HiLink texMathDelimKey	texMathDelim
   HiLink texMathMatcher	texMath
   HiLink texAccent		texStatement
   HiLink texGreek		texStatement
   HiLink texSuperscript	texStatement
   HiLink texSubscript		texStatement
   HiLink texSuperscripts 	texSuperscript
   HiLink texSubscripts 	texSubscript
   HiLink texMathSymbol		texStatement
   HiLink texMathZoneV		texMath
   HiLink texMathZoneW		texMath
   HiLink texMathZoneX		texMath
   HiLink texMathZoneY		texMath
   HiLink texMathZoneV		texMath
   HiLink texMathZoneZ		texMath
  endif
  HiLink texSectionMarker	texCmdName
  HiLink texSectionName		texSection
  HiLink texSpaceCode		texStatement
  HiLink texStyleStatement	texStatement
  HiLink texTypeSize		texType
  HiLink texTypeStyle		texType

   " Basic TeX highlighting groups
  HiLink texCmdArgs		Number
  HiLink texCmdName		Statement
  HiLink texComment		Comment
  HiLink texDef			Statement
  HiLink texDefParm		Special
  HiLink texDelimiter		Delimiter
  HiLink texInput		Special
  HiLink texInputFile		Special
  HiLink texLength		Number
  HiLink texMath		Special
  HiLink texMathDelim		Statement
  HiLink texMathOper		Operator
  HiLink texNewCmd		Statement
  HiLink texNewEnv		Statement
  HiLink texOption		Number
  HiLink texRefZone		Special
  HiLink texSection		PreCondit
  HiLink texSpaceCodeChar	Special
  HiLink texSpecialChar		SpecialChar
  HiLink texStatement		Statement
  HiLink texString		String
  HiLink texTodo		Todo
  HiLink texType		Type
  HiLink texZone		PreCondit

  delcommand HiLink
endif

" Cleanup: {{{1
unlet s:extfname
let   b:current_syntax = "tex"
let &cpo               = s:keepcpo
unlet s:keepcpo
" vim: ts=8 fdm=marker
