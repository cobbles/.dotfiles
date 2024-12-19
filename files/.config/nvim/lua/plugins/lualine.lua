-- Status line

return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  dependencies = {
    'arkav/lualine-lsp-progress',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    options = {
      theme = 'dracula',
      component_separators = '|',
      section_separators = ''
    }
  }
}
