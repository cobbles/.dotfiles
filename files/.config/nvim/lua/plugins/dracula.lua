-- Color scheme
return {
    'Mofiqul/dracula.nvim',
    lazy = false,
    priority = 1000,
    config = function (plugin, opts)
        require('dracula').setup({
            colors = {
                bg = "#282a36",
            },
            overrides = {
                SpellBad = { undercurl = true, sp = '#6272A4' },
                DiagnosticDeprecated = { undercurl = true, sp = '#8be9fd'}
            }
        })
        vim.cmd('colorscheme dracula')
    end,
}

