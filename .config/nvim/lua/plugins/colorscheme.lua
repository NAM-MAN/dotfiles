return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "dark",
      transparent = true,
      term_colors = true,
      code_style = {
        comments = "italic",
        keywords = "bold",
        functions = "none",
        strings = "none",
        variables = "none",
      },
      colors = {
        bg0 = "#282c34",
        bg1 = "#31353f",
        bg2 = "#393f4a",
        bg3 = "#3e4451",
        bg_d = "#1e2127",
        fg = "#abb2bf",
        grey = "#5c6370",
        red = "#e06c75",
        orange = "#d19a66",
        yellow = "#e5c07b",
        green = "#98c379",
        cyan = "#56b6c2",
        blue = "#61afef",
        purple = "#c678dd",
        light_grey = "#848b98",
      },
      highlights = {
        CursorLine = { bg = "#2c313c" },
        Visual = { bg = "#3e4451" },
        FloatBorder = { fg = "#61afef" },
        NormalFloat = { bg = "#1e2127" },
      },
      lualine = { transparent = true },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
