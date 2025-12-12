-- Language Server Client
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- language server 
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    -- completion
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    -- notifications
    "j-hui/fidget.nvim",
    -- formatters
    "stevearc/conform.nvim"
  },
  config = function()
    -- formatters
    require("conform").setup({})
    -- notifications
    require("fidget").setup({})
    -- completion
    local cmp = require("cmp")
    cmp.setup({
        mapping = cmp.mapping.preset.insert({
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'nvim_lsp_signature_help' },
        }),
    })
    local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities())

    -- language server
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        'lua_ls',
      },
      handlers = {
        function(server_name)
            local server_opts = {
                capabilities = capabilities
            }
            require("lspconfig")[server_name].setup(server_opts)
        end,
      }
    })

    vim.diagnostic.config({
        virtual_text = {
            source = true
        },
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    })
  end
}
