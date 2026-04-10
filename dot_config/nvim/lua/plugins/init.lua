-- Plugin manager: Neovim 0.12 native vim.pack
--
-- This file replaces the previous lazy.nvim setup. vim.pack is built into
-- Neovim 0.12+ -- no bootstrap required. Plugins are eager-loaded; lazy
-- loading by event/cmd/ft is not supported. After cloning, vim.pack puts each
-- plugin on the runtimepath, then we configure them synchronously below.
--
-- The lockfile lives at ~/.config/nvim/nvim-pack-lock.json after first run
-- and should be tracked under chezmoi.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Run build hooks for plugins that need post-install steps. Must be registered
-- before vim.pack.add() so it fires for fresh installs in the same session.
-- For commands provided by plugins (TSUpdate), we defer to VimEnter since
-- those user commands are not registered until after plugin/* sources.
local pending_builds = {}
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(args)
    local data = args.data
    if data.kind ~= "install" and data.kind ~= "update" then
      return
    end
    if data.spec.name == "markdown-preview.nvim" then
      if vim.fn.executable("npx") == 1 then
        vim.fn.system({ "sh", "-c", "cd " .. vim.fn.shellescape(data.path) .. "/app && npx --yes yarn install" })
      end
    elseif data.spec.name == "nvim-treesitter" then
      pending_builds.tsupdate = true
    end
  end,
})
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    if pending_builds.tsupdate and vim.fn.exists(":TSUpdate") == 2 then
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({
  -- Color scheme & UI (lualine, bufferline, which-key, web-devicons replaced by mini.* in Phase 5)
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/zaldih/themery.nvim" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },

  -- File tree: replaced by mini.files (Phase 4) -- mini ships from mini.nvim below

  -- Pickers / search (plenary kept -- still required by obsidian, typescript-tools, codecompanion)
  { src = "https://github.com/nvim-lua/plenary.nvim" },

  -- Diagnostics / LSP UI
  { src = "https://github.com/folke/trouble.nvim" },

  -- LSP
  { src = "https://github.com/williamboman/mason.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/pmizio/typescript-tools.nvim" },

  -- Completion
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/onsails/lspkind.nvim" },

  -- Treesitter
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  { src = "https://github.com/tadmccorkle/markdown.nvim" },

  -- Editing (which-key replaced by mini.clue in Phase 5)
  { src = "https://github.com/numToStr/Comment.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },

  -- Git
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/tpope/vim-rhubarb" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },

  -- Language ergonomics
  { src = "https://github.com/tpope/vim-sleuth" },
  { src = "https://github.com/tpope/vim-rails" },
  { src = "https://github.com/vim-ruby/vim-ruby" },
  { src = "https://github.com/prisma/vim-prisma" },
  { src = "https://github.com/editorconfig/editorconfig-vim" },

  -- Markdown / notes
  { src = "https://github.com/iamcco/markdown-preview.nvim" },
  { src = "https://github.com/epwalsh/obsidian.nvim" },
  -- nvim-cmp is required by obsidian.nvim's completion = { nvim_cmp = true }
  -- (the rest of the config uses blink.cmp as the primary completion engine)
  { src = "https://github.com/hrsh7th/nvim-cmp" },

  -- Mini ecosystem
  { src = "https://github.com/echasnovski/mini.nvim" },
  { src = "https://github.com/echasnovski/mini.extra" },

  -- AI / chat
  { src = "https://github.com/olimorris/codecompanion.nvim" },
})

-- ----------------------------------------------------------------------------
-- Plugin configuration (replaces former Lazy `opts`/`config` blocks)
-- ----------------------------------------------------------------------------

vim.cmd.colorscheme("tokyonight-night")

require("themery").setup(require("plugins.configs.themery"))

require("blink.cmp").setup(require("plugins.configs.blink_cmp"))

require("trouble").setup(require("plugins.configs.trouble"))
require("core.utils").load_mappings("trouble")

require("gitsigns").setup(require("plugins.configs.gitsigns"))

-- Statusline / tabline / clue / icons all live in mini.* below.
-- Configured later in the mini block to ensure mini.icons is set up
-- before mini.statusline / mini.tabline / mini.files consume it.

require("ibl").setup({})

require("Comment").setup({})
require("core.utils").load_mappings("comment")

-- nvim-treesitter: the original lazy spec did not actually call setup()
-- (the keys at the top level of a lazy spec entry are ignored). We preserve
-- the same behavior here -- parsers are managed via :TSInstall / :TSUpdate
-- and highlight is enabled via filetype plugins. nvim-treesitter v1.0+
-- removed the `nvim-treesitter.configs` module anyway.

-- mini.files is set up in the mini block below; mappings come via M.files

local mason_opts = require("plugins.configs.mason")
require("mason").setup(mason_opts)
vim.api.nvim_create_user_command("MasonInstallAll", function()
  if mason_opts.ensure_installed and #mason_opts.ensure_installed > 0 then
    vim.cmd("MasonInstall " .. table.concat(mason_opts.ensure_installed, " "))
  end
end, {})
vim.g.mason_binaries_list = mason_opts.ensure_installed

-- LSP buffer-local keymaps -- single LspAttach autocmd handles every client
require("core.lsp_attach")

-- typescript-tools.nvim handles TS/JS LSP via its own setup. Capabilities
-- are passed in directly; the LspAttach autocmd above wires up keymaps for
-- every client (including this one).
require("typescript-tools").setup({
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Native LSP for every other server (lua_ls, html, tailwindcss, eslint,
-- pyright, vimls, solargraph, terraformls, prismals). nvim-lspconfig v3+
-- ships the presets at lsp/<name>.lua; we just enable them.
require("lsp_setup")

require("obsidian").setup({
  workspaces = {
    {
      name = "personal",
      path = os.getenv("OBSIDIAN_WORKSPACE_PATH"),
    },
  },
  daily_notes = {
    folder = "daily-notes",
    date_format = "%Y-%m-%d",
    template = "system/templater-templates/daily-note-template.md",
  },
  templates = {
    subdir = "system/templates",
  },
  completion = {
    nvim_cmp = true,
  },
  mappings = {
    ["gf"] = {
      action = function()
        return require("obsidian").util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true },
    },
  },
})

require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettierd", "eslint_d" },
    typescript = { "prettierd", "eslint_d" },
    javascriptreact = { "prettierd", "eslint_d" },
    typescriptreact = { "prettierd", "eslint_d" },
    css = { "prettierd" },
    json = { "prettierd" },
    lua = { "stylua" },
  },
  formatters = {
    eslint_d = {
      cwd = require("conform.util").root_file({
        "package.json", ".eslintrc.js", ".eslintrc.json", ".eslintrc.cjs",
        ".eslintrc.yaml", ".eslintrc.yml", "eslint.config.mjs", "eslint.config.js",
      }),
      require_cwd = false,
      timeout_ms = 5000,
    },
    prettierd = {
      cwd = require("conform.util").root_file({
        "package.json", ".prettierrc", ".prettierrc.json",
        ".prettierrc.js", ".prettierrc.cjs", "prettier.config.js",
      }),
      require_cwd = false,
      timeout_ms = 5000,
    },
  },
  format_on_save = {
    lsp_format = "fallback",
    async = false,
    timeout_ms = 5000,
  },
})

-- mini.icons must be set up FIRST so the other mini modules
-- (statusline, tabline, files, pick) pick it up. We then mock the
-- nvim-web-devicons API so any plugin that still imports it keeps working.
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

require("mini.animate").setup()
require("mini.notify").setup()
require("mini.pick").setup()
require("mini.extra").setup()
require("mini.files").setup({
  windows = {
    preview = true,
    width_focus = 30,
    width_preview = 50,
  },
})
require("mini.doc").setup({
  lsp = {
    signature = true,
    completion = true,
  },
})

require("mini.statusline").setup({
  use_icons = true,
})
require("mini.tabline").setup()

-- mini.clue replaces which-key.nvim. Triggers + clue groups for the
-- <leader>* prefixes the user has wired up across find/git/lsp/diagnostic.
do
  local miniclue = require("mini.clue")
  miniclue.setup({
    triggers = {
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },
      { mode = "n", keys = "<C-w>" },
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
    },
    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
      { mode = "n", keys = "<Leader>f", desc = "+Find" },
      { mode = "n", keys = "<Leader>h", desc = "+Git hunks" },
      { mode = "n", keys = "<Leader>l", desc = "+LSP" },
      { mode = "n", keys = "<Leader>w", desc = "+Workspace" },
      { mode = "n", keys = "<Leader>x", desc = "+Trouble/diagnostics" },
      { mode = "n", keys = "<Leader>c", desc = "+Code/copy" },
      { mode = "n", keys = "<Leader>g", desc = "+Git" },
      { mode = "n", keys = "<Leader>t", desc = "+Toggle" },
    },
    window = {
      delay = 300,
    },
  })
end

-- Promote mini.pick to primary picker (replaces telescope + fzf-lua).
-- Set vim.ui.select handler so :lua vim.ui.select() pickers (used by code
-- actions, refactors, etc.) flow through mini.pick.
vim.ui.select = MiniPick.ui_select
require("core.utils").load_mappings("pick")
require("core.utils").load_mappings("files")

require("codecompanion").setup(require("plugins.configs.codecompanion"))
