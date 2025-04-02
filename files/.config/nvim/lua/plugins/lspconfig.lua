-- Language Server Client
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- language server 
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    -- snippets
    "L3MON4D3/LuaSnip",
    -- completion
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
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

    -- snippets
    local luasnip = require('luasnip')

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
            { name = 'luasnip' },
            { name = 'buffer' },
            { name = 'path' },
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
        'phpactor',
        'ts_ls'
      },
      handlers = {
        function(server_name)
            require("lspconfig")[server_name].setup({
                capabilities = capabilities
            })
        end,
        ["phpactor"] = function()
            require("lspconfig").phpactor.setup({
                capabilities = capabilities,
                init_options = {
                    ["language_server_phpstan.enabled"] = true,
                }
            })
        end,
        ["lua_ls"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        }
                    }
                }
            }
        end
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
