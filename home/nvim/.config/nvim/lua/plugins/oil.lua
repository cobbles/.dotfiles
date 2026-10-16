-- File explorer
return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  config = function()
    require('oil').setup {
      view_options = {
        show_hidden = true
      },
      keymaps = {
        ["yp"] = { "actions.yank_entry", opts = {modify = ":p:."} },
      }
    }

    vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory' })
  end
}

