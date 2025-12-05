return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
      { '<leader>f', function() require('telescope.builtin').find_files({hidden = true, prompt_title = 'Files' }) end },
      { '<leader>F', function() require('telescope.builtin').find_files({ hidden = true, no_ignore = true, no_ignore_parent = true, prompt_title = 'All Files' }) end },
      { '<leader>b', function() require('telescope.builtin').buffers() end },
      { '<leader>g', function() require('telescope.builtin').live_grep({additional_args = function() return { "--hidden" } end, prompt_title = 'Grep Files' }) end },
      { '<leader>G', function() require('telescope.builtin').live_grep({additional_args = function() return { "--hidden", "--no-ignore" } end, prompt_title = 'Grep All Files' }) end },
      { '<leader>h', function() require('telescope.builtin').help_tags() end },
      { '<leader>s', function() require('telescope.builtin').lsp_document_symbols() end },
    }
}
