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
    opts = {
      ensure_installed = {
        'lua',
        'php',
        'php_only',
        'phpdoc',
        'javascript',
        'blade',
        'markdown'
      },
      auto_intsall = false,
      highlight = { enable = true },
      indent = { enable = true },
      additional_vim_regex_highlighting = true,
      context_commentstring = { enabled = true }
    },
    config = function(_, opts)
      local parser_config = require "nvim-treesitter.parsers".get_parser_configs()

      parser_config.blade = {
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = {"src/parser.c"},
          branch = "main",
        },
        filetype = "blade"
      }

      vim.filetype.add({
        pattern = {
          ['.*%.blade%.php'] = 'blade',
        },
      })

      require'nvim-treesitter.configs'.setup(opts)
    end
  },
}
