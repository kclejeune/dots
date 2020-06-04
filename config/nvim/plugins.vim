" ###########################################
" PLUGINS
" ###########################################

" Install Vim-Plug if it isn't already there
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $HOME/.config/nvim/init.vim
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
    " Ignore language specific/IDE-esque features when using vscode
    if !exists('g:vscode')
        Plug 'tpope/vim-sensible'
        Plug 'tpope/vim-fugitive'
        Plug 'tpope/vim-surround'
        Plug 'tpope/vim-commentary'
        Plug 'ranger/ranger'
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
        Plug 'junegunn/fzf.vim'
        Plug 'neoclide/coc.nvim', {'branch': 'release'}
        Plug 'dense-analysis/ale'
        Plug 'vim-scripts/awk.vim'
        Plug 'justinmk/vim-sneak'
        Plug 'joshdick/onedark.vim'
        Plug 'alvan/vim-closetag'
    endif
call plug#end()


