" ghost-machine - a configuration helper for vim
" (c) 2020 QuietMisdreavus

if !exists('g:misdreavus_ghost_machine_dir')
    " attempt to set a default machine dir - the `.vim`/`vimfiles` dir
    if has('unix')
        let vimfiles = expand('~/.vim')
    elseif has('win32')
        let vimfiles = expand('~/vimfiles')
    endif

    if exists('vimfiles') && isdirectory(vimfiles)
        let g:misdreavus_ghost_machine_dir = vimfiles
    endif
endif

function! s:do_startup()
    if exists('g:misdreavus_ghost_machine_dir')
        let g:misdreavus_ghost_machine_file =
                    \ g:misdreavus_ghost_machine_dir
                    \ . '/'
                    \ . hostname()
                    \ . '.vim'

        if !filereadable(g:misdreavus_ghost_machine_file) &&
                    \ match(hostname(), '.local$') != -1 || match(hostname(), '.lan$') != -1
            " sometimes hostnames in macOS show up as Name.local or Name.lan - strip
            " out the suffix and use that if the 'real' hostname turns up empty
            let g:misdreavus_ghost_machine_file =
                        \ g:misdreavus_ghost_machine_dir
                        \ . '/'
                        \ . fnamemodify(hostname(), ':r')
                        \ . '.vim'
        endif

        if filereadable(g:misdreavus_ghost_machine_file)
            execute 'source ' . g:misdreavus_ghost_machine_file
        endif
    endif
endfunction

function! s:edit_machine_file()
    if exists('g:misdreavus_ghost_machine_file')
        execute 'edit ' . g:misdreavus_ghost_machine_file
    else
        echoerr 'no directory set to store ghost-machine files'
        echoerr 'help: set g:misdreavus_ghost_machine_dir to a directory path in your vimrc'
    endif
endfunction

command! -nargs=0 EditMachineFile call s:edit_machine_file()

if v:vim_did_enter
    call s:do_startup()
else
    autocmd VimEnter * call s:do_startup()
endif
