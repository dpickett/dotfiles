-- Native LSP wiring (Neovim 0.12)
--
-- nvim-lspconfig v3+ ships server presets as runtime files at lsp/<name>.lua.
-- Calling vim.lsp.enable({...}) loads those presets and starts the clients
-- against matching filetypes. We only need to:
--   1. Set a wildcard config to inject blink.cmp's capabilities for every server
--   2. Enumerate the servers we want enabled
--
-- Per-server overrides go in dot_config/nvim/lsp/<name>.lua. Currently no
-- overrides are needed -- the lspconfig defaults already cover the user's
-- previous customizations (e.g. tailwindcss/eslint already include js+ts
-- variants in their default filetypes list).
--
-- typescript-tools.nvim is NOT enabled here -- it has its own setup() in
-- plugins/init.lua and registers as its own LSP client. The shared
-- LspAttach autocmd in core/lsp_attach.lua picks up its keymaps too.

vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.enable({
  "lua_ls",
  "html",
  "tailwindcss",
  "eslint",
  "pyright",
  "vimls",
  "solargraph",
  "terraformls",
  "prismals",
})
