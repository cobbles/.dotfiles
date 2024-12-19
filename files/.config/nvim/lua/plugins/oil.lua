-- File explorer

return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require('oil').setup {
      view_options = {
        show_hidden = true
      }
    }
  end,
  keys = {
    { '-', ':Oil --float<CR>', desc = 'Open parent directory' },
  },
}

