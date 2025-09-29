local options = {
  modes = {
    preview_float = {
      mode = "diagnostics",
      focus = false,
      win = {
        type = "float",
        relative = "cursor",
        border = "rounded",
        title = "Diagnostics",
        title_pos = "center",
        row = 1,
        col = 0,
        width = 60,
        height = 10,
        zindex = 200,
        wo = {
          wrap = true,
        },
      },
    },
    lsp_document_symbols = {
      mode = "lsp_document_symbols",
      focus = false,
      win = { position = "right", size = { width = 0.3 } },
      filter = {
        any = {
          kind = {
            "Class",
            "Constructor",
            "Enum",
            "Field",
            "Function",
            "Interface",
            "Method",
            "Module",
            "Namespace",
            "Package",
            "Property",
            "Struct",
            "Trait",
          },
        },
      },
    },
  },
}

return options
