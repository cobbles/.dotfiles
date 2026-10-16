return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
      local builtin = require('telescope.builtin')

      vim.keymap.set('n', '<leader>f', function() builtin.find_files({hidden = true, prompt_title = 'Files' }) end, { desc = "Find files" })
      vim.keymap.set('n', '<leader>F', function() builtin.find_files({ hidden = true, no_ignore = true, no_ignore_parent = true, prompt_title = 'All Files' }) end, { desc = "Find all files" })
      vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set('n', '<leader>g', function() builtin.live_grep({additional_args = function() return { "--hidden" } end, prompt_title = 'Grep Files' }) end, { desc = "Grep files" })
      vim.keymap.set('n', '<leader>G', function() builtin.live_grep({additional_args = function() return { "--hidden", "--no-ignore" } end, prompt_title = 'Grep All Files' }) end, { desc = "Grep all files" })
      vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = "Find help tags" })
      vim.keymap.set('n', '<leader>?', builtin.keymaps, { desc = "Find keymaps" })
    end
}
