-- File explorer
return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  keys = {
    { '-', ':Oil<CR>', desc = 'Open parent directory' },
  },
  config = function()
    require('oil').setup {
      view_options = {
        show_hidden = true
      },
      keymaps = {
        ["yp"] = { "actions.yank_entry", opts = {modify = ":p:."} },
      }
    }
  end
}

