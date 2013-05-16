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

command! Do call do#OpenFile()
