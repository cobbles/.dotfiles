return {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        'lua',
      },
      auto_intsall = true,
      highlight = { enable = true },
      indent = { enable = true },
      additional_vim_regex_highlighting = true,
      context_commentstring = { enabled = true }
    },
    config = function(_, opts)
      require'nvim-treesitter.configs'.setup(opts)
    end
}
