-- Core performance + telescope accelerator + which-key polish
return {
  -- Faster LuaJIT startup times
  {
    "lewis6991/impatient.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      pcall(require, "impatient")
    end,
  },

  -- Telescope native FZF perf (requires make; you’ve got it in bootstrap)
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      pcall(function()
        require("telescope").load_extension("fzf")
      end)
    end,
  },

  -- Better input/select UIs used by many plugins
  { "stevearc/dressing.nvim" },
}
