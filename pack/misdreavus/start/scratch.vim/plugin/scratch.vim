" scratch.vim - a vim plugin to create scratch windows
" (c) QuietMisdreavus 2020

function! s:next_idx()
    if !exists('g:misdreavus_scratch_count')
        let g:misdreavus_scratch_count = 0
    endif

    let g:misdreavus_scratch_count += 1

    return g:misdreavus_scratch_count
endfunction

function! s:mk_buffer()
    let bufname = 'Scratch'
    let scratch_idx = s:next_idx()
    if scratch_idx != 1
        let bufname .= ' ' . scratch_idx
    endif

    let bufidx = bufadd(bufname)
    call setbufvar(bufidx, '&buftype', 'nofile')
    call setbufvar(bufidx, '&bufhidden', 'hide')
    call setbufvar(bufidx, '&swapfile', 0)
    call setbufvar(bufidx, '&buflisted', 1)

    return bufname
endfunction

function! s:edit_scratch()
    let bufname = s:mk_buffer()

    execute 'buffer ' . bufname
endfunction

function! s:split_scratch(is_vert = v:false)
    let bufname = s:mk_buffer()

    let command = ''
    if a:is_vert
        let command .= 'vertical '
    endif

    execute command . 'sbuffer ' . bufname
endfunction

command! -nargs=0 EditScratch call s:edit_scratch()
command! -nargs=0 SplitScratch call s:split_scratch()
command! -nargs=0 VSplitScratch call s:split_scratch(v:true)
