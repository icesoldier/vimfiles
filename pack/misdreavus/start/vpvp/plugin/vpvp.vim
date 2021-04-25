" vpvp - a vim plugin for your vim plugins
" (c) 2021 QuietMisdreavus

if !exists('g:misdreavus_vpvp_root_dir')
    " attempt to set a default root dir - the `.vim`/`vimfiles` dir
    if has('unix')
        let vimfiles = expand('~/.vim')
    elseif has('win32')
        let vimfiles = expand('~/vimfiles')
    endif

    if exists('vimfiles') && isdirectory(vimfiles)
        let g:misdreavus_vpvp_root_dir = vimfiles
    endif
endif

if exists('g:misdreavus_vpvp_root_dir')
    " make the root dir an absolute path (which also adds a trailing slash)
    let g:misdreavus_vpvp_root_dir = fnamemodify(g:misdreavus_vpvp_root_dir, ':p')
endif

let g:misdreavus_vpvp_exclude_dirs = [
            \ 'pack',
            \ ]

let g:misdreavus_vpvp_include_dirs = [
            \ 'pack/color/start/sunshine-sorbet',
            \ 'pack/misdreavus',
            \ ]

function! s:filter_filename(filename)
    if !exists('g:misdreavus_vpvp_root_dir')
        " root dir could not be found, bail
        return 0
    endif

    if fnamemodify(a:filename, ':e') != 'vim' && match(a:filename, 'vimrc$') == -1
        " only look for .vim filenames
        return 0
    endif

    let fullname = fnamemodify(a:filename, ':p')

    for idir in g:misdreavus_vpvp_include_dirs
        let fullidir = g:misdreavus_vpvp_root_dir .. idir
        if match(fullname, fullidir) == 0
            " we've explicitly said to include these dirs
            return 1
        endif
    endfor

    for edir in g:misdreavus_vpvp_exclude_dirs
        let fulledir = g:misdreavus_vpvp_root_dir .. edir
        if match(fullname, fulledir) == 0
            " we've explicitly said to exclude these dirs
            return 0
        endif
    endfor

    " with no other filters, the filename is fine
    return 1
endfunction

function! s:lookup_file(filename)
    if !exists('g:misdreavus_vpvp_root_dir')
        return []
    endif

    let list = glob(g:misdreavus_vpvp_root_dir .. '**/' .. a:filename, v:false, v:true)
    let list = filter(list, { idx, val -> s:filter_filename(val) })

    return list
endfunction

let s:all_files = s:lookup_file('*')

let s:completion_files = []
for f in s:all_files
    call add(s:completion_files, fnamemodify(f, ':t'))
endfor
let s:completion_str = join(s:completion_files, "\n")

function! s:open_script(filename)
    if !exists('g:misdreavus_vpvp_root_dir')
        echoerr 'No root directory set'
        echoerr 'Help: Set g:misdreavus_vpvp_root_dir to your script directory'
        return
    endif

    let list = s:lookup_file(a:filename)

    if empty(list)
        echoerr 'Script not found'
        return
    endif

    if len(list) > 1
        echomsg 'More than one script matched; editing ' .. list[0]
    endif

    exec 'edit ' .. list[0]
endfunction

function! s:completion_func(A,L,P)
    return s:completion_str
endfunction

command! -nargs=1 -complete=custom,<SID>completion_func EditScript call <SID>open_script(<q-args>)
