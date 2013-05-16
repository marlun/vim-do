" ============================================================================
" File:        do.vim
" Description: Launches different objects
" Author:      Martin Lundberg <martin.lundberg@gmail.com>
" Licence:     Vim licence
" Website:     https://github.com/marlun/vim-do
" Version:     0.1.0
" Note:        This plugin was heavily inspired by FuzzyFinder but since the
"              author has abandoned FuzzyFinder and I don't like ctrlp, I
"              decided to create my own launcher.
" ============================================================================

if exists('g:loaded_do')
	finish
end

let g:loaded_do = 1

let s:lastCol = -1

function! CompleteFiles(findstart, base)
	if a:findstart
		return 1
	endif
	if empty(a:base)
		return
	endif
	let items = []
	let excludes = []
	let excludes = split('node_modules,.git', ',')
	let prunes = []
	for pattern in excludes
		echom 'PATTERN: ' . pattern
		call add(prunes, '-name ' . pattern . ' -prune')
	endfor
	let prunesstr = ''
	if !empty(prunes)
		let prunesstr = join(prunes, ' -o ')
	endif
	if !empty(prunesstr)
		let prunesstr = prunesstr . ' -o '
	endif
	echom prunesstr
	let files = system('find . ' . prunesstr . '-type f')
	for f in split(files, '\n')
		if f =~ a:base
			call add(items, f)
		endif
	endfor
	if !empty(items)
		call feedkeys("\<C-p>\<Down>", 'n')
	endif
	return items
endfunction

set omnifunc=CompleteFiles

function! s:onCursorMovedI()
	call setline('.', getline('.'))
	if col('.') > strlen(getline('.')) && col('.') != s:lastCol
		" if the cursor is placed on the end of the line and has been actually moved.
		let s:lastCol = col('.')
		let s:lastPattern = getline('.')
		call feedkeys("\<C-x>\<C-o>", 'n')
	endif
endfunction

function! s:onInsertLeave()
	bdelete!
endfunction

function! s:open()
	echom getline('.')
	echom 'opening file?'
	bdelete!
endfunction

function! do#OpenFile()
	topleft 1new
	" file Searching\ for\ files
	resize 1
	setlocal completeopt=menuone
	setlocal buflisted noswapfile bufhidden=delete modifiable noreadonly buftype=nofile
	setlocal statusline=%=Searching\ for\ files
	" call setline(1, '>')
	call feedkeys("A", 'n')
	inoremap <buffer> <CR> :<C-U>call <SID>open()<CR>
	verbose map <CR>
	augroup SigneLocal
		autocmd!
		autocmd CursorMovedI <buffer> call s:onCursorMovedI()
		autocmd InsertLeave <buffer> nested call s:onInsertLeave()
	augroup END
endfunction
