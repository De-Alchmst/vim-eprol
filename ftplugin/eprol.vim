" Vim plugin for EPROL
" Language: EPROL

" GUARD "
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" FILETYPE BASICS "
setlocal commentstring=(*\ %s\ *)
" TODO: fix broken indent
setlocal comments=s1:(*,mb:\ ,ex:*)
setlocal formatoptions+=croq

"  SMART INDENT EXPRESSION "

" indentexpr fires for every new line; indentkeys lists the chars that
" re-trigger it while you type (notably 'D' for END, 'E' for ELSE/ELSIF,
" and '=' re-indents the current line when you press =).
setlocal indentexpr=EprolIndent(v:lnum)
setlocal indentkeys+=0=END,0=ELSE,0=ELSIF,0=I32,0=I64,0=F32,0=F64,0=VAR,0=CONST,0=STATIC

" --- Indent function ----------------------------------------------------------
function! EprolIndent(lnum)
  " Fall back to zero for the very first line
  if a:lnum <= 1
    return 0
  endif

  " Find the previous non-blank line
  let prev_lnum = prevnonblank(a:lnum - 1)
  if prev_lnum == 0
    return 0
  endif

  let prev_line = getline(prev_lnum)
  let cur_line  = getline(a:lnum)
  let indent    = indent(prev_lnum)
  let sw        = shiftwidth()

  " OPENERS "
  " keywords
  if prev_line =~# '\<\(ENUM\|VAR\|CONST\|STATIC\|RECORD\|DO\|CASE\|LOOP\)\>'
    let indent += sw
  endif

  " types
  if prev_line =~# '^[IF]\(32\|64\)\>'
    let indent += 4
  endif

  " comments
  if prev_line =~ '(\*'
    let indent += 3
  endif
  
  " CLOSERS "
  " keywords
  if cur_line =~# '^\s*\(END\|ELIF\|ELSE\)\>'
    let indent -= sw
  endif

  if cur_line =~# '^\s*\(VAR\|CONST\|STATIC\)\>'
    let indent = 0
  endif

  " types
  if cur_line =~# '^\s\{,4\}[IF]\(32\|64\)\>'
    let indent = 0
  endif

  " comments
  if prev_line =~ '\*)'
    let indent -= 3
  endif

  " Never return negative indent
  return max([0, indent])
endfunction


" ABBREVIATIONS "
if exists("g:eprol_abbr")
  " trigger abbrevations on newline.
  " must be via <expr> will cause infinite recursion otherwise (even with noremap
  inore <buffer> <expr> <CR> "<C-]><CR>"
  iabbr <buffer> import IMPORT
  iabbr <buffer> export EXPORT
  iabbr <buffer> use USE
  iabbr <buffer> var VAR
  iabbr <buffer> const CONST
  iabbr <buffer> static STATIC
  iabbr <buffer> enum ENUM
  iabbr <buffer> record RECORD
  iabbr <buffer> do DO
  iabbr <buffer> end END
  iabbr <buffer> case CASE
  iabbr <buffer> of OF
  iabbr <buffer> loop LOOP
  iabbr <buffer> while WHILE
  iabbr <buffer> for FOR
  iabbr <buffer> from FROM
  iabbr <buffer> to TO
  iabbr <buffer> downto DOWNTO
  iabbr <buffer> step STEP
  iabbr <buffer> if IF
  iabbr <buffer> elif ELIF
  iabbr <buffer> else ELSE
  iabbr <buffer> as AS
  iabbr <buffer> next NEXT
  iabbr <buffer> break BREAK
  iabbr <buffer> proc PROC
  iabbr <buffer> i8 I8
  iabbr <buffer> i16 I16
  iabbr <buffer> i32 I32
  iabbr <buffer> i64 I64
  iabbr <buffer> u8 U8
  iabbr <buffer> u16 U16
  iabbr <buffer> u32 U32
  iabbr <buffer> u64 U64
  iabbr <buffer> f32 F32
  iabbr <buffer> f64 F64
  iabbr <buffer> give GIVE
  iabbr <buffer> return RETURN
  iabbr <buffer> accessor ACCESSOR
  iabbr <buffer> ref REF
  iabbr <buffer> until UNTIL
  iabbr <buffer> in IN
  iabbr <buffer> not NOT
  iabbr <buffer> and AND
  iabbr <buffer> or OR
  iabbr <buffer> xor XOR
  iabbr <buffer> nand NAND
  iabbr <buffer> nor NOR
  iabbr <buffer> nxor NXOR
  iabbr <buffer> bool BOOL
  iabbr <buffer> nbool NBOOL
endif
