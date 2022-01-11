set nu
set relativenumber
set tabstop=4 softtabstop=4
set shiftwidth=4
set smartindent
set smarttab
set expandtab
set noerrorbells
set nowrap
set nocompatible
filetype off
set hidden
set scrolloff=8
set termguicolors
syntax enable

" setting the leader key
let mapleader=','

" Remap splits navigation to just CTRL + hjkl                     
nnoremap <C-h> <C-w>h                                               
nnoremap <C-j> <C-w>j                                               
nnoremap <C-k> <C-w>k                                               
nnoremap <C-l> <C-w>l

" Searching options
set incsearch
set ignorecase
set smartcase
set showmatch
set hlsearch

" clear seach higlights                                                                                                                       
nnoremap <leader>h :nohl<CR>

""" Nvim tree
nnoremap <space>i :NvimTreeToggle<CR>
nnoremap <space>o :NvimTreeFocus<CR>

""" Buffer switching
nnoremap <space>j :BufferLineCyclePrev<CR>
nnoremap <space>k :BufferLineCycleNext<CR>

""" Buffer moving
nnoremap <space>, :BufferLineMovePrev<CR>
nnoremap <space>. :BufferLineMoveNext<CR>

""" Switch toggle
nnoremap <space>s :Switch<CR>

""" Buffer closing
nnoremap <space>x :bdelete<CR>

""" Vista toggle
nnoremap <space>v :Vista!!<CR>

""" Table mode
nnoremap <space>tm :TableModeToggle<CR>

""" Undo tree
nnoremap <space>u :UndotreeToggle<CR>
nnoremap <space>uf :UndotreeFocus<CR>

""" Comment toggle
nnoremap <space>c :Commentary<CR>

""" Toggle terminal
nnoremap <space>t :ToggleTerm<CR>

""" Zen mode
nnoremap <space>q :TZFocus<CR>
nnoremap <space>w :TZMinimalist<CR>
nnoremap <space>e :TZAtaraxis<CR>

""" Telescope
nnoremap <space>fw :Telescope live_grep<CR>
nnoremap <space>gt :Telescope git_status<CR>
nnoremap <space>cm :Telescope git_commits<CR>
nnoremap <space>ff :Telescope find_files<CR>
nnoremap <space>fp :lua require('telescope').extensions.media_files.media_files()<CR>
nnoremap <space>fb :Telescope buffers<CR>
nnoremap <space>fh :Telescope help_tags<CR>
nnoremap <space>fo :Telescope oldfiles<CR>

set history=1000

"KEY MAPPING
cmap w!! %!sudo tee > /dev/null
imap <C-p> <Esc>:w<CR>:!python3 %<CR>

" toggle vim transparency with  this line
" hi Normal guibg=NONE ctermbg=NONE

colorscheme onedark

" to set ctrl+s to save
:nmap <c-s> :w<CR>

"" Plugins through lua

lua require('impatient')
lua require('plugins')

" compile packer file sourcing it for plugins.lua
augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end

" formatting with Neoformat on save
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END


" configure nvcode-color-schemes
let g:nvcode_termcolors=256

syntax on
colorscheme onedark " Or whatever colorscheme you make


" checks if your terminal has 24-bit color support
if (has("termguicolors"))
    set termguicolors
    hi LineNr ctermbg=NONE guibg=NONE
endif
