return {
  {
    "nickjvandyke/opencode.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    config = function()
      vim.g.opencode_opts = {
        provider = {
          enabled = "snacks",
        },
      }
      vim.o.autoread = true
    end,
    keys = {
      {
        "<leader>ao",
        function()
          require("opencode").toggle()
        end,
        desc = "Toggle OpenCode",
      },
      {
        "<leader>aa",
        function()
          require("opencode").ask("@this: ", { submit = false })
        end,
        mode = { "n", "x" },
        desc = "Ask OpenCode (with context)",
      },
      {
        "<leader>af",
        function()
          require("opencode").ask("@this: Fix this", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "OpenCode Fix",
      },
      {
        "<leader>ar",
        function()
          require("opencode").ask("@this: Review this code", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "OpenCode Review",
      },
      {
        "<leader>ae",
        function()
          require("opencode").ask("@this: Explain this code", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "OpenCode Explain",
      },
      {
        "<leader>at",
        function()
          require("opencode").ask("@this: Write tests for this", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "OpenCode Test",
      },
      {
        "<leader>ad",
        function()
          require("opencode").ask("@diagnostics: Fix these diagnostics", { submit = true })
        end,
        desc = "OpenCode Fix Diagnostics",
      },
    },
  },
}
