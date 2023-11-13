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
    let g:ale_use_global_executables = 1
endfunction

" Python
function! ProjectVirtualenv(...) abort
    " set virtualenv path for CoC
    call coc#config('python.pythonPath', fnamemodify('venv/bin/python', ':p'))
    call coc#config('python.venvPath', fnamemodify('venv', ':p'))
    " skip venv dir in FZF search
    let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs -g ''!venv/**'' -g ''!*.pyc'' '
endfunction
