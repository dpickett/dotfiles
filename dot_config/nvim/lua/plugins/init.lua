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
-- For commands provided by plugins (TSUpdate, CocInstall), we defer to VimEnter
-- since those user commands are not registered until after plugin/* sources.
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
  -- Color scheme & UI
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/zaldih/themery.nvim" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/akinsho/bufferline.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },

  -- File tree
  { src = "https://github.com/nvim-tree/nvim-tree.lua" },

  -- Pickers / search
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/ibhagwan/fzf-lua" },

  -- Diagnostics / LSP UI
  { src = "https://github.com/folke/trouble.nvim" },
  { src = "https://github.com/nvimdev/lspsaga.nvim" },
  { src = "https://github.com/ray-x/lsp_signature.nvim" },

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

  -- Editing
  { src = "https://github.com/numToStr/Comment.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/folke/which-key.nvim" },

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

  -- AI / chat
  { src = "https://github.com/olimorris/codecompanion.nvim" },

  -- Prisma LSP holdover (removed in Phase 2)
  { src = "https://github.com/neoclide/coc.nvim", version = "release" },
})

-- ----------------------------------------------------------------------------
-- Plugin configuration (replaces former Lazy `opts`/`config` blocks)
-- ----------------------------------------------------------------------------

vim.cmd.colorscheme("tokyonight-night")

require("themery").setup(require("plugins.configs.themery"))

require("blink.cmp").setup(require("plugins.configs.blink_cmp"))

require("fzf-lua").setup({})

require("trouble").setup(require("plugins.configs.trouble"))
require("core.utils").load_mappings("trouble")

require("gitsigns").setup(require("plugins.configs.gitsigns"))

local telescope = require("telescope")
telescope.setup(require("plugins.configs.telescope"))
require("core.utils").load_mappings("telescope")

do
  local trouble = require("trouble")
  local symbols = trouble.statusline({
    mode = "lsp_document_symbols",
    groups = {},
    title = false,
    filter = { range = true },
    format = "{kind_icon}{symbol.name:Normal}",
    hl_group = "lualine_c_normal",
  })
  require("lualine").setup({
    options = {
      icons_enabled = true,
      component_separators = "|",
      section_separators = "",
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = {
        { "filename", file_status = true, path = 0 },
        { symbols.get, cond = symbols.has },
      },
      lualine_x = {
        { "diagnostics", symbols = { error = ' ', warn = ' ', info = ' ' } },
        "encoding",
        "filetype",
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    tabline = {},
    extensions = { "fugitive" },
  })
end

require("ibl").setup({})

require("Comment").setup({})
require("core.utils").load_mappings("comment")

-- nvim-treesitter: the original lazy spec did not actually call setup()
-- (the keys at the top level of a lazy spec entry are ignored). We preserve
-- the same behavior here -- parsers are managed via :TSInstall / :TSUpdate
-- and highlight is enabled via filetype plugins. nvim-treesitter v1.0+
-- removed the `nvim-treesitter.configs` module anyway.

require("nvim-tree").setup(require("plugins.configs.nvimtree"))
require("core.utils").load_mappings("nvimtree")

local mason_opts = require("plugins.configs.mason")
require("mason").setup(mason_opts)
vim.api.nvim_create_user_command("MasonInstallAll", function()
  if mason_opts.ensure_installed and #mason_opts.ensure_installed > 0 then
    vim.cmd("MasonInstall " .. table.concat(mason_opts.ensure_installed, " "))
  end
end, {})
vim.g.mason_binaries_list = mason_opts.ensure_installed

require("typescript-tools").setup({
  on_attach = function(_, bufnr)
    require("core.utils").load_mappings("lspconfig", { buffer = bufnr })
  end,
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

require("lspconfig").eslint.setup({
  on_attach = function(_, bufnr)
    require("core.utils").load_mappings("lspconfig", { buffer = bufnr })
  end,
  capabilities = require("blink.cmp").get_lsp_capabilities(),
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
})

require("lspconfig").tailwindcss.setup({
  on_attach = function(_, bufnr)
    require("core.utils").load_mappings("lspconfig", { buffer = bufnr })
  end,
  capabilities = require("blink.cmp").get_lsp_capabilities(),
  filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
})

require("bufferline").setup({})

require("lspsaga").setup({})

require("lsp_signature").setup({})

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

require("mini.animate").setup()
require("mini.notify").setup()
require("mini.pick").setup()
require("mini.doc").setup({
  lsp = {
    signature = true,
    completion = true,
  },
})

require("codecompanion").setup(require("plugins.configs.codecompanion"))
