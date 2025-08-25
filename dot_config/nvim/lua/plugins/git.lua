-- Git power-tools
return {
  -- Diff & PR review
  { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" } },

  -- Neogit (magit-like)
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    opts = { integrations = { diffview = true } },
  },

  -- Resolve conflicts with helpers
  { "akinsho/git-conflict.nvim", version = "*", config = true },
}
