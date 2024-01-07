local options = {
  ensure_installed = {
    "lua-language-server",
    "tailwindcss",
    "html-lsp",
    "prettier",
    "eslint",
    "solargraph"
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

local lspconfig = require("lspconfig")
lspconfig.tailwindcss.setup({})
lspconfig.eslint.setup({})
lspconfig.solargraph.setup({
  cmd = { os.getenv( "HOME" ) .. "/.asdf/shims/solargraph", 'stdio' },
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
          host = 'localhost',
          port = '7658',
        }
    },
  }
})

return options
