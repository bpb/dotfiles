-- Keep Mason-managed tool auto-install + extra schemas.
return {
  -- Ensure your preferred formatters/linters/LSPs are installed.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- formatters
          "stylua",
          "prettierd",
          "shfmt",
          "black",
          "isort",
          "gofumpt",
          -- linters
          "shellcheck",
          "eslint_d",
          "flake8",
          "golangci-lint",
          -- LSPs
          "lua-language-server",
          "pyright",
          "gopls",
          "tsserver",
          "eslint",
          "yamlls",
          "dockerls",
          "bash-language-server",
        },
        auto_update = false,
        run_on_start = true,
      })
    end,
  },

  -- -- Extra JSON/YAML schemas (K8s, Docker Compose, etc.)
  -- { "b0o/schemastore.nvim", ft = { "json", "yaml", "yml" } },
}
