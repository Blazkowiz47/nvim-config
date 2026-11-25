local servers = {
    "pyright",
    "ruff",
    "lua_ls",
    "vimls",
    "jsonls",
}

local function getPythonPath(workspace)
    -- Check for local .venv first
    local venv_python = workspace .. "/.venv/bin/python"
    if vim.fn.executable(venv_python) == 1 then
        return venv_python
    end

    -- Fallback to system Python
    return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",

        -- Auto Completion
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",

        -- Snippets
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },
    config = function()
        require("fidget").setup()
        require("mason").setup()
        local cmp = require("cmp")
        local lspconfig = require("lspconfig")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            require("cmp_nvim_lsp").default_capabilities()
        )

        -- Set up lspconfig.
        require("mason-lspconfig").setup({
            ensure_installed = servers,

            handlers = {
                function(servername) -- default handler (optional)
                    lspconfig[servername].setup({
                        capabilities = capabilities,
                    })
                end,
                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup {
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" }
                                }
                            }
                        },
                        capabilities = capabilities,
                    }
                end,
                ["ruff"] = function()
                    lspconfig.ruff.setup {
                        capabilities = capabilities,
                        before_init = function(_, config)
                            -- Point Ruff to the .venv interpreter so it resolves the right Python version/rules
                            config.settings = config.settings or {}
                            config.settings.interpreter = { getPythonPath(config.root_dir) }
                        end,
                        on_attach = function(client, _)
                            -- Disable hover in favor of Pyright
                            client.server_capabilities.hoverProvider = false
                        end,
                    }
                end,
                ["pyright"] = function()
                    lspconfig.pyright.setup {
                        before_init = function(_, config)
                            config.settings.python.pythonPath = getPythonPath(config.root_dir)
                        end,
                        settings = {
                            pyright = {
                                disableOrganizeImports = true, -- Using Ruff
                            },
                        },
                        capabilities = capabilities,
                    }
                end,
            },
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<c-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<c-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<c-y>"] = cmp.mapping.confirm({ select = true }),
                ["<c-space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
                -- { name = "friendly-snippets" },
            }, {
                { name = "buffer" },
            })
        })

        vim.diagnostic.config({
            update_in_insert = true,
            float = {
                source = "always",
                border = "rounded",
                header = " ",
                prefix = "",
                style = "minimal",
            },
        })
    end
}
