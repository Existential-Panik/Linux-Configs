--Plugins
local use = require('packer').use
require('packer').startup(function()
    use {'wbthomason/packer.nvim'} -- Plugin Manager
    use {'neovim/nvim-lspconfig', 'williamboman/nvim-lsp-installer'} -- Language server protocol
    use {'nvim-treesitter/nvim-treesitter'}
    use {"nvim-telescope/telescope.nvim", cmd = "Telescope"}
    use {"nvim-lua/plenary.nvim"}
    use {"mhinz/vim-startify"}
    use {"norcalli/nvim-colorizer.lua"}
    use {
			'kyazdani42/nvim-tree.lua',
			requires = 'kyazdani42/nvim-web-devicons',
			config =
				function()
					require'nvim-tree'.setup {
						view = {
							side = 'left'
						}
					}
				end
		}
	use {'navarasu/onedark.nvim'}
    use {'lewis6991/impatient.nvim', rocks='mpack'} -- Loadtime Optimiser
    use {'sbdchd/neoformat'}
    use {'christianchiarulli/nvcode-color-schemes.vim'}
	use {'nvim-lualine/lualine.nvim'}
    use {'kyazdani42/nvim-web-devicons'} -- Web icons
    use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'} 
    use {'hrsh7th/nvim-cmp'} -- Autocompletion plugin               
    use {'hrsh7th/cmp-nvim-lsp'} -- LSP source for nvim-cmp         
    use {'saadparwaiz1/cmp_luasnip'} -- Snippets source for nvim-cmp
    use {'L3MON4D3/LuaSnip'} -- Snippets plugin                     
    use {'mattn/emmet-vim'} -- Emmet
	-- generals
	use {'tpope/vim-commentary'}
	use {'jiangmiao/auto-pairs'}
end
)

-- Onedark setup
require('onedark').setup()

-- Impatient setup
require('impatient').enable_profile()

-- Colorizer setup
require'colorizer'.setup()

-- Lualine Setup
require('lualine').setup()

require('nvim-treesitter.configs').setup{
   ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
   highlight={
      enable=true,
   },
   incremental_selection={
      enable=true,
   },
   indent={
      enable=true
   },
   rainbow={
       enable=true,
       extened_mode=false,
       max_file_lines=nil,
   },
   autotag={
       enable=true,
   }
}



-- Buffer setup
local present, bufferline = pcall(require, "bufferline")
if not present then
    return
end

bufferline.setup {
  options = {
    numbers = function(opts)
      return string.format('%s', opts.id)
    end,
    diagnostics = "nvim_lsp",
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "left"
      },
      {
        filetype = "vista",
        text = "LspTags",
      }
    }
  }
}

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)


local nvim_lsp = require('lspconfig')
local protocol = require('vim.lsp.protocol')
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
  local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings
  local opts = { noremap=true, silent=true }
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  
end

-- Lsp setup
require('nvim-lsp-installer').on_server_ready(function(server)
    if server.name == "tsserver" then
        server:setup{
            on_attach = function(client, bufnr)
                client.resolved_capabilities.document_formatting = false
                on_attach(client, bufnr)
    end,
            capabilities = capabilities
        }
    else
        server:setup{on_attach = on_attach, capabilities = capabilities}
    end
end)

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
   snippet = {
      expand = function(args)
      require('luasnip').lsp_expand(args.body)
      end,
   },
   mapping = {
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm {
         behavior = cmp.ConfirmBehavior.Replace,
         select = true,
      },
      ['<Tab>'] = function(fallback)
      if cmp.visible() then
         cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
         luasnip.expand_or_jump()
      else
         fallback()
      end
      end,
      ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
         cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
         luasnip.jump(-1)
      else
         fallback()
      end
      end,
   },
   sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
   },
}

-- Disable indent-blankline on these pages
vim.g.indent_blankline_filetype_exclude = {"help", "terminal", "dashboard", "packer"}
vim.g.indent_blankline_buftype_exclude = { "terminal", 'lsp-installer', 'lspinfo' }

-- Nvimtree setup
local present, nvimtree = pcall(require, "nvim-tree")
--local git_status = require("core.utils").load_config().plugins.options.nvimtree.enable_git

if not present then
   return
end

local g = vim.g

vim.o.termguicolors = true
g.nvim_tree_indent_markers = 1
g.nvim_tree_highlight_opened_files = 0
g.nvim_tree_quit_on_open = 0 -- closes tree when file's opened
g.nvim_tree_git_hl = git_status
g.nvim_tree_gitignore = 0

g.nvim_tree_show_icons = {
   folders = 1,
   -- folder_arrows= 1
   files = 1,
   git = git_status,
}

g.nvim_tree_icons = {
   default = "",
   symlink = "",
   git = {
      deleted = "",
      ignored = "◌",
      renamed = "➜",
      staged = "✓",
      unmerged = "",
      unstaged = "✗",
      untracked = "★",
   },
   folder = {

      default = "",
      empty = "", -- 
      empty_open = "",
      open = "",
      symlink = "",
      symlink_open = "",
   },
}

nvimtree.setup {
   diagnostics = {
      enable = false,
      icons = {
         hint = "",
         info = "",
         warning = "",
         error = "",
      },
   },
   filters = {
      dotfiles = false,
   },
   disable_netrw = true,
   hijack_netrw = true,
   ignore_ft_on_setup = { "dashboard" },
   auto_close = false,
   open_on_tab = false,
   hijack_cursor = true,
   update_cwd = true,
   update_focused_file = {
      enable = true,
      update_cwd = false,
   },
   view = {
      allow_resize = true,
      side = "left",
      width = 25,
   },
}


