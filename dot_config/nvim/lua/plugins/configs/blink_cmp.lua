local options = {}

options = {
  signature = { enabled = true },
  appearance = {
    use_nvim_cmp_as_default = false,
  },
  cmdline = {
    sources = { "cmdline", "path" }
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  keymap = {
    ["<CR>"] = { "accept", "fallback" },
    ["<C-k>"] = { 'show_signature', 'hide_signature', 'fallback' }
  }
}

return options

