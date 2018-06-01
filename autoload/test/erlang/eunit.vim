if !exists('g:test#erlang#eunit#file_pattern')
  let g:test#erlang#eunit#file_pattern = '\v_tests\.erl$'
endif

function! test#erlang#eunit#test_file(file) abort
  return a:file =~# g:test#erlang#eunit#file_pattern
endfunction

function! test#erlang#eunit#build_position(type, position) abort
    let mod = substitute(a:position['file'], 'test\/', '', '')
    let mod = substitute(mod, '\.erl', '', '')
    if a:type == 'nearest'
        let name = s:nearest_test(a:position)
        if !empty(name)
            return ['--suite='.mod, '--case='.name]
        else
            return ['--suite='.mod]
        endif
    elseif a:type == 'file'
        return ['--module='.mod]
    else
        return []
    endif
endfunction

function! test#erlang#eunit#build_args(args) abort
  return  ['eunit'] + a:args
endfunction

function! test#erlang#eunit#executable() abort
  return 'rebar3'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#erlang#patterns)
  return join(name['test'])
endfunction
