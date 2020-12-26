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

        if filereadable(g:misdreavus_ghost_machine_file)
            execute 'source ' . g:misdreavus_ghost_machine_file
        endif
    endif
endfunction

if v:vim_did_enter
    call s:do_startup()
else
    autocmd VimEnter * call s:do_startup()
endif
