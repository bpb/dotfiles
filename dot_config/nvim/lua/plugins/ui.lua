-- UI/UX: notifications, command line, statusline tweaks
return {
  -- Pretty notifications, replaces default vim.notify
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")
      notify.setup({ stages = "fade_in_slide_out", timeout = 2000, render = "compact" })
      vim.notify = notify
    end,
  },

  -- Better cmdline, messages, LSP hover routing
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = { progress = { enabled = true }, hover = { enabled = true }, signature = { enabled = false } },
      presets = { lsp_doc_border = true, bottom_search = true, command_palette = true },
    },
  },

  -- Optional: zen writing mode
  -- { "folke/zen-mode.nvim", cmd = "ZenMode" },
}
