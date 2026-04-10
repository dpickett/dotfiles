local M = {}

M.general = {
  n = {
    ["<C-s>"] = { "<cmd> w <CR>", "Save file" },
    ["<Esc>"] = { "<cmd> noh <CR>", "Clear highlights" },
    -- switch between windows
    ["<C-h>"] = { "<C-w>h", "Window left" },
    ["<C-l>"] = { "<C-w>l", "Window right" },
    ["<C-j>"] = { "<C-w>j", "Window down" },
    ["<C-k>"] = { "<C-w>k", "Window up" },

    -- line numbers
    ["<leader>n"] = { "<cmd> set nu! <CR>", "Toggle line number" },
    ["<leader>rn"] = { "<cmd> set rnu! <CR>", "Toggle relative number" },

    ["<leader>fm"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      "LSP formatting",
    },

    ["<leader>cr"] = { "<cmd> CopyRelPath <CR>", "Copy relative path of file in current buffer" },
  },

  v = {
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
    ["<"] = { "<gv", "Indent line" },
    [">"] = { ">gv", "Indent line" },
  },
}

M.pick = {
  plugin = true,

  -- Phase 3: telescope and fzf-lua were replaced by mini.pick + mini.extra.
  -- Same <leader>f* prefixes preserved for muscle-memory continuity.
  n = {
    -- find
    ["<leader>ff"] = {
      function() require("mini.pick").builtin.files() end,
      "Find files",
    },
    ["<leader>fa"] = {
      function()
        require("mini.pick").builtin.cli({
          command = { "rg", "--files", "--hidden", "--no-ignore", "--follow" },
        })
      end,
      "Find all (hidden + ignored)",
    },
    ["<leader>fw"] = {
      function() require("mini.pick").builtin.grep_live() end,
      "Live grep",
    },
    ["<leader>fb"] = {
      function() require("mini.pick").builtin.buffers() end,
      "Find buffers",
    },
    ["<leader>fh"] = {
      function() require("mini.pick").builtin.help() end,
      "Help tags",
    },
    ["<leader>fo"] = {
      function() require("mini.extra").pickers.oldfiles() end,
      "Old files",
    },
    ["<leader>fz"] = {
      function() require("mini.extra").pickers.buf_lines({ scope = "current" }) end,
      "Find in current buffer",
    },

    -- git
    ["<leader>cm"] = {
      function() require("mini.extra").pickers.git_commits() end,
      "Git commits",
    },
    ["<leader>gt"] = {
      function() require("mini.extra").pickers.git_hunks() end,
      "Git hunks",
    },

    -- marks
    ["<leader>ma"] = {
      function() require("mini.extra").pickers.marks() end,
      "Marks",
    },
  },
}

-- Phase 4: nvim-tree replaced by mini.files. mini.files is modal
-- (column-based, opens in a floating window) rather than a persistent
-- sidebar. <C-n> toggles open/close in cwd; <leader>e opens with the
-- current file revealed and selected.
M.files = {
  plugin = true,

  n = {
    ["<C-n>"] = {
      function()
        if not require("mini.files").close() then
          require("mini.files").open()
        end
      end,
      "Toggle file explorer",
    },
    ["<leader>e"] = {
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      "Reveal current file",
    },
  },
}

M.comment = {
  plugin = true,

  -- toggle comment in both modes
  n = {

    ["<leader>/"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "Toggle comment",
    },

  },


  v = {
    ["<leader>/"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "Toggle comment",
    },
  },
}

-- M.lspconfig: removed in Phase 2 of the 0.12 modernization. LSP keymaps are
-- now wired up by the LspAttach autocmd in lua/core/lsp_attach.lua, which
-- runs once per attached client (typescript-tools, lua_ls, eslint, etc.) and
-- avoids the indirection through load_mappings("lspconfig", ...).

M.trouble = {
  n = {
    ["<leader>xx"] = {
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    ["<leader>xD"] = {
      function()
        vim.diagnostic.open_float(nil, {
          scope = "line",
          border = "rounded",
          wrap = true,
          max_width = 80,
        })
      end,
      "Show diagnostic for the line in a float",
    },
    ["<[leader>xX"] = {
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    ["<[leader>cs"] = {
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    ["<[leader>cl"] = {
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    ["<[leader>xL"] = {
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    ["<[leader>xQ"] = {
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  }
}

M.codecompanion = {
  n = {
    ["<leader>."] = {
      "<cmd>CodeCompanionActions<cr>",
      desc = "CodeCompanion Actions"
    },
    ["<leader>/"] = {
      "<cmd>CodeCompanionChat Toggle<cr>",
      desc = "Toggle CodeCompanionChat"
    }
  }
}

return M
