return {
  {
    "keaising/im-select.nvim",
    event = "InsertEnter",
    opts = {
      default_im_select = "com.apple.keylayout.ABC",
      default_command = "im-select",
      set_default_events = { "VimEnter", "InsertLeave", "CmdlineLeave" },
      set_previous_events = { "InsertEnter" },
    },
  },
}
