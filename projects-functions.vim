" +=================================
" | Projects init functions
" +=================================
function! ProjectFindSkipVendor(...) abort
    let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs -g ''!vendor/**'' '
endfunction

function! ProjectAleLocalPhpstan(...) abort
    let g:ale_php_phpstan_executable = 'phpstan'
    let g:ale_php_phpstan_configuration = expand('~/Programy/phptools/phpstan.neon')
    let g:ale_php_phpstan_level = 7
endfunction

