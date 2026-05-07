" Vim plugin for EPROL
" Language: EPROl

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
 
" Case-sensitive: EPROL keywords ARE case-sensitive (uppercase).
syntax case match
 
" COMMENTS "
" EPROL comments are (* … *) and they nest.
syntax region  EprolComment  start="(\*"  end="\*)"  contains=EprolComment  fold
highlight default link EprolComment Comment
 
" STRINGS/CHARS "
syntax region  EprolString   start=+"+   end=+"+   oneline
highlight default link EprolString String
syntax region  EprolChar   start=+'+   end=+'+   oneline
highlight default link EprolChar Character
 
" NUMBERS "
syntax match   EprolNumber   '\<\d\+\(\.\d\+\)\?\>'
syntax match   EprolNumber   '\<#[0-9A-F]\>' " hex
highlight default link EprolNumber Number
 
" TYPES "
syntax keyword EprolType I8 I16 I32 I64 U8 U16 U32 U64 F32 F64 REF
highlight default link EprolType Type
 
" KEYWORDS "
syntax keyword EprolKeyword
  \ IMPORT EXPORT USE VAR CONST STATIC ENUM RECORD CASE OF LOOP WHILE FOR FROM
  \ TO DOWNTO STEP IF ELIF ELSE DO END AS NEXT BREAK PROC GIVE RETURN ACCESSOR
  \ UNTIL EXTENDS
highlight default link EprolKeyword Keyword
 
" CONSTANTS (uppercase idents)"
syntax match EprolConstant    '\<[A-Z_][A-Z0-9_.]*\>'
highlight default link EprolConstant Constant

" PROCEDURE CALL "
" Match any identifier immediately followed by '(' that is NOT already
" matched as a keyword/builtin. We use a zero-width look-ahead via \ze to
" colour only the identifier, not the paren itself.
" 'contained' is NOT set so it matches at top level; keywords above take
" priority because syn keyword has higher priority than syn match.
syntax match   EprolProcCall  '\<[A-Za-z_][A-Za-z0-9_.]*\ze\s*('
highlight default link EprolProcCall Function
 
" NAME/NAMESPACE DEFINITION" 
syntax match   EprolDefName   '\(VAR\|CONST\)\@<=\s*:\s*[A-Za-z_][A-Za-z0-9_.]*'
syntax match   EprolDefName   '\(PROC\|RECORD\|ENUM\|AS\|ACCESSOR\)\@<=\s*[A-Za-z_][A-Za-z0-9_.]*\(\s*:\s*[A-Za-z_][A-Za-z0-9_.]*\)\?'
highlight default link EprolDefName Identifier

" OPERATORS "
syntax match   EprolOperator  '\.\?[+\-*/]\.\?'
syntax match   EprolOperator  '\.\?\(<=\|>=\|<\|>\|\<>\)\.\?'
syntax match   EprolOperator  'N\?\(AND\|OR\|XOR\)'
syntax match   EprolOperator  '\(NOT\|BOOL\|NBOOL\)'
syntax match   EprolOperator  '[^:]\zs=' " not if in ':='
syntax keyword EprolOperator  MOD DIV IN AND OR NOT
highlight default link EprolOperator Operator
 
let b:current_syntax = "eprol"
