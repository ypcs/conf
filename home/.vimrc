call pathogen#infect()
call pathogen#helptags()

:set modeline
:syntax on

autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd FileType html,htmldjango,jinjahtml,eruby,mako let b:closetag_html_style=1
autocmd FileType html,xhtml,xml,htmldjango,jinjahtml,eruby,mako source ~/.vim/bundle/closetag/plugin/closetag.vim

