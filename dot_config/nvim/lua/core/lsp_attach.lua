-- LSP buffer-local keymaps (Neovim 0.12 native)
--
-- Replaces the previous load_mappings("lspconfig", { buffer = bufnr }) pattern
-- which was wired through each language server's on_attach. With native
-- vim.lsp.config + a single LspAttach autocmd, every attached client
-- (typescript-tools, eslint, lua_ls, etc.) gets the same keymaps for free.

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- Navigation
    map("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
    map("n", "gd", vim.lsp.buf.definition, "LSP definition")
    map("n", "gi", vim.lsp.buf.implementation, "LSP implementation")
    map("n", "gr", vim.lsp.buf.references, "LSP references")
    map("n", "<leader>D", vim.lsp.buf.type_definition, "LSP type definition")

    -- Documentation / actions
    map("n", "K", vim.lsp.buf.hover, "LSP hover")
    map("n", "<leader>ls", vim.lsp.buf.signature_help, "LSP signature help")
    map("i", "<C-k>", vim.lsp.buf.signature_help, "LSP signature help")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
    map("v", "<leader>ca", vim.lsp.buf.code_action, "LSP code action")

    -- Diagnostics (0.12 deprecates goto_prev/goto_next in favor of jump)
    map("n", "<leader>lf", function()
      vim.diagnostic.open_float({ border = "rounded" })
    end, "Floating diagnostic")
    map("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = { border = "rounded" } })
    end, "Previous diagnostic")
    map("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = { border = "rounded" } })
    end, "Next diagnostic")
    map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostics to loclist")

    -- Workspace
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
    map("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "List workspace folders")
  end,
})
