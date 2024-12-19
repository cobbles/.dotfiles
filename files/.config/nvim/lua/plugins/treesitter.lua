-- Syntax highlighting

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      {
        'JoosepAlviste/nvim-ts-context-commentstring',
      }
    },
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = 'all',
        auto_intsall = false,
        highlight = { enable = true },
        indent = { enable = true },
        additional_vim_regex_highlighting = true
      }
    end
  },
}
