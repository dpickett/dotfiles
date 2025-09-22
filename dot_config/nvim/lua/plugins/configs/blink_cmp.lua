local options = {}

options = {
  appearance = {
    use_nvim_cmp_as_default = false,
  },
  cmdline = {
    sources = { "cmdline", "path" }
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
}

return options

