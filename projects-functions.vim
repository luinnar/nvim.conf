" +=================================
" | Projects init functions
" +=================================
" PHP
function! ProjectFindSkipVendor(...) abort
    let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs -g ''!vendor/**'' '
endfunction

function! ProjectAlePhpstan(...) abort
    let g:ale_php_phpstan_executable = 'phpstan'
    let g:ale_php_phpstan_configuration = expand('~/Programy/phptools/phpstan.neon')
    let g:ale_php_phpstan_level = 7
endfunction

" Python
function! ProjectVirtualenv(...) abort
    " set virtualenv path for CoC
    call coc#config('python.venvPath', getcwd() + '/venv')
    " skip venv dir in FZF search
    let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs -g ''!venv/**'' '
endfunction
