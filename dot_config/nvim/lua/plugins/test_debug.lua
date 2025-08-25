-- Testing + language-specific debug helpers.
return {
  -- Test runner with adapters.
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-python",
    },
    keys = {
      {
        "<leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Test nearest",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Test file",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true })
        end,
        desc = "Test output",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test summary",
      },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-go")({ experimental = { test_table = true } }),
          require("neotest-python")({ dap = { justMyCode = false } }),
        },
      })
    end,
  },

  -- DAP helpers (LazyVim includes core nvim-dap; we add language glue).
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    config = function()
      require("dap-go").setup()
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function()
      -- Prefer rtx-managed Python if available, else fall back to "python".
      local venv = vim.fn.systemlist("rtx where python 2>/dev/null")[1]
      require("dap-python").setup(venv ~= "" and venv or "python")
    end,
  },
}
