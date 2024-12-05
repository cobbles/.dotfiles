-- Color scheme

return {
    'Mofiqul/dracula.nvim',
    lazy = false,
    priority = 1000,
    config = function (plugin, opts)
        require('dracula').setup({
            colors = {
                bg = "#282a36",
            }
        })
        vim.cmd('colorscheme dracula')
    end,
}

