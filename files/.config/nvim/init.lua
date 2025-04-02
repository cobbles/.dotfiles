require('cobbles.options')
require('cobbles.keymaps')

require("config.lazy")

local augroup = vim.api.nvim_create_augroup
local CobblesGroup = augroup('CobblesGroup', {})
local autocmd = vim.api.nvim_create_autocmd

-- Keymaps for LSP
autocmd('LspAttach', {
    group = CobblesGroup,
    callback = function()
        vim.keymap.set('n', '<Leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>')
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
        vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
        vim.keymap.set('n', 'gi', ':Telescope lsp_implementations<CR>')
        vim.keymap.set('n', 'gr', ':Telescope lsp_references<CR>')
        vim.keymap.set('n', '<Leader>lr', ':LspRestart<CR>', { silent = true })
        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
        vim.keymap.set('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    end
})
