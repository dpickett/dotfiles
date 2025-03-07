local options = {
  ensure_installed = {
    "lua-language-server",
    "html-lsp",
    "prettier",
    "solargraph",
    "pyright",
    "tailwindcss-language-server",
    "eslint-lsp",
    "eslint_d",
    "terraform-ls",
    "typescript-language-server",
    "vim-language-server"
  }, -- not an option from mason.nvim

  PATH = "skip",

  ui = {
    icons = {
      package_pending = " ",
      package_installed = "󰄳 ",
      package_uninstalled = " 󰚌",
    },

    keymaps = {
      toggle_server_expand = "<CR>",
      install_server = "i",
      update_server = "u",
      check_server_version = "c",
      update_all_servers = "U",
      check_outdated_servers = "C",
      uninstall_server = "X",
      cancel_installation = "<C-c>",
    },
  },

  max_concurrent_installers = 10,
}

local lspconfig = require "lspconfig"
local util = require "lspconfig.util"
lspconfig.tailwindcss.setup {}
lspconfig.eslint.setup {}
lspconfig.solargraph.setup {
  cmd = { os.getenv "HOME" .. "/.asdf/shims/solargraph", "stdio" },
  root_dir = lspconfig.util.root_pattern("Gemfile", ".git", "."),
  filetypes = { "ruby" },
  settings = {
    solargraph = {
      autoformat = false,
      formatting = false,
      completion = true,
      diagnostic = true,
      folding = true,
      references = true,
      rename = true,
      symbols = true,
      externalServer = {
        host = "localhost",
        port = "7658",
      },
    },
  },
}
lspconfig.rubocop.setup {
  cmd = { "bundle", "exec", "rubocop", "--lsp" },
  filetypes = { "ruby" },
  root_dir = util.root_pattern("Gemfile", ".git"),
}

lspconfig.pyright.setup {}

lspconfig.terraformls.setup {}
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.lsp.buf.format()
  end,
})

return options
