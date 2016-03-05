" Simple-status: A simple vim status line, for the terminal.
" Author: Adam Heins
" Last Updated: 2015-12-10
"
" Based on the NeatStatus plugin by Luke Maciak, which can found here:
" https://github.com/maciakl/vim-neatstatus

" ================================ General =================================== "

set ls=2 " Always show status line
let g:last_mode=""

" ================================= Colors =================================== "

" Purple
if !exists('g:StatusLine_color_normal')
  let g:StatusLine_color_normal = 'ctermfg=139 ctermbg=234'
endif

" Yellow
if !exists('g:StatusLine_color_insert')
  let g:StatusLine_color_insert = 'ctermfg=11 ctermbg=234'
endif

" Blue
if !exists('g:StatusLine_color_replace')
  let g:StatusLine_color_replace = 'ctermfg=4 ctermbg=234'
endif

" Purple
if !exists('g:StatusLine_color_visual')
  let g:StatusLine_color_visual = 'ctermfg=6 ctermbg=234'
endif

" Red
if !exists('g:StatusLine_color_modified')
  let g:StatusLine_color_modified = 'ctermfg=9 ctermbg=234'
endif

" Grey
if !exists('g:StatusLine_color_separator')
  let g:StatusLine_color_separator = 'ctermfg=243 ctermbg=234'
endif

" =========================== Utility functions ============================== "

" Set up the colors for the status bar
function! SetStatusLineColorscheme()
    exec 'hi User1 '.g:StatusLine_color_normal
    exec 'hi User2 '.g:StatusLine_color_separator
    exec 'hi User3 '.g:StatusLine_color_modified
endfunc

" Change color based on mode
function! Mode()
    redraw
    let l:mode = mode()

    if mode ==# "n"
      exec 'hi User1 '.g:StatusLine_color_normal
    elseif mode ==# "i"
      exec 'hi User1 '.g:StatusLine_color_insert
    elseif mode ==# "R"
      exec 'hi User1 '.g:StatusLine_color_replace
    elseif mode ==# "v"
      exec 'hi User1 '.g:StatusLine_color_visual
    elseif mode ==# "V"
      exec 'hi User1 '.g:StatusLine_color_visual
    elseif mode ==# ""
      exec 'hi User1 '.g:StatusLine_color_visual
    endif
    return ""
endfunc

" =============================== Statusline ================================= "

if has('statusline')

    " Set up color scheme now
    call SetStatusLineColorscheme()

    function! SetStatusLineStyle()
        " Current format:
        " (BUFFER) | FILE* ... [RO] PROGRESS% | COLUMN

        " Call Mode() to change color
        let &stl = "%{Mode()} "

        " Buffer number
        let &stl .= "%1*(%n) %2*|%0* "

        " File path
        " Truncate left side if too long
        let &stl .= "%<%F"

        " Unsaved marker
        let &stl .= "%3*%(%{&modified ? '*' : ''} %)%0*"

        " Right-align everything past this point
        let &stl .= "%= "

        " Readonly tag
        if &ro != 0
          let &stl .= "%3*[RO]"
          let &stl .= " %2*|%0* "
        endif

        " Percent progress
        let &stl .= "%p%2*%% |%0* "

        " Column number
        let &stl .= "%-3.c"
    endfunc

    " Whenever the color scheme changes re-apply the colors
    au ColorScheme * call SetStatusLineColorscheme()

    " Make sure the statusbar is reloaded late to pick up servername
    au ColorScheme,VimEnter * call SetStatusLineStyle()

    call SetStatusLineStyle()

    " Window title
    if has('title')
        set titlestring="%t%(\ [%R%M]%)".expand(v:servername)
    endif
endif
