require('cobbles.options')
require('cobbles.keymaps')

require("config.lazy")

local nvm_path = os.getenv("HOME") .. "/.nvm/versions/node/v20.17.0/bin"
vim.env.PATH = nvm_path .. ":" .. vim.env.PATH

local augroup = vim.api.nvim_create_augroup
local CobblesGroup = augroup('CobblesGroup', {})
local autocmd = vim.api.nvim_create_autocmd

-- Keymaps for LSP
autocmd('LspAttach', {
    group = CobblesGroup,
    callback = function()
        vim.keymap.set('n', '<Leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'LSP: Show diagnostics' })
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'LSP: Go to definition' })
        vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'LSP: Code action' })
        vim.keymap.set('n', 'gi', ':Telescope lsp_implementations<CR>', { desc = 'LSP: Go to implementation' })
        vim.keymap.set('n', 'gr', ':Telescope lsp_references<CR>', { desc = 'LSP: Go to references' })
        vim.keymap.set('n', '<Leader>lr', ':LspRestart<CR>', { silent = true, desc = 'LSP: Restart' })
        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { desc = 'LSP: Hover' })
        vim.keymap.set('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'LSP: Rename' })
    end
})
