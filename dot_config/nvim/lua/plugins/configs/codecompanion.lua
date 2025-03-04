local options = {
  init = function()
    require("core.utils").load_mappings "codecompanion"
  end,
  strategies = {
    chat = {
      adapter = "ollama"
    },
    inline = {
      adapter = "ollama"
    }
  },
  display = {
    inline = {
      layout = "vertical"
    },
    action_palette = {
      width = 95,
      height = 10,
      prompt = "Prompt ",
      provider = "mini_pick",
      opts = {
        show_default_actions = true, -- Show the default actions in the action palette?
        show_default_prompt_library = true, -- Show the default prompt library in the action palette?
      },
    },
  },
  adapters = {
    ollama = function()
      return require("codecompanion.adapters").extend("ollama", {
        env = {
          url = "http://localhost:11434",
        },
        headers = {
          ["Content-Type"] = "application/json",
        },
        parameters = {
          sync = true,
        },
      })
    end,
  },
}

return options
