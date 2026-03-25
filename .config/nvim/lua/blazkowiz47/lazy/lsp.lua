local servers = {
    "pyright",
    "ruff",
    "lua_ls",
    "vimls",
    "jsonls",
}

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
        local function get_python_path(workspace)
            if vim.env.CONDA_PREFIX then
                local python = vim.env.CONDA_PREFIX .. "/bin/python"
                if vim.fn.executable(python) == 1 then
                    return python
                end
            end

            if vim.env.VIRTUAL_ENV then
                local python = vim.env.VIRTUAL_ENV .. "/bin/python"
                if vim.fn.executable(python) == 1 then
                    return python
                end
            end

            if workspace then
                local python = workspace .. "/.venv/bin/python"
                if vim.fn.executable(python) == 1 then
                    return python
                end
            end

            return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
        end

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
                ["pyright"] = function()
                    lspconfig.pyright.setup({
                        on_new_config = function(new_config, new_root_dir)
                            new_config.settings = new_config.settings or {}
                            new_config.settings.pyright = new_config.settings.pyright or {}
                            new_config.settings.pyright.disableOrganizeImports = true

                            new_config.settings.python = new_config.settings.python or {}
                            new_config.settings.python.pythonPath = get_python_path(new_root_dir)
                        end,
                        settings = {
                            pyright = {
                                disableOrganizeImports = true,
                            },
                        },
                        capabilities = capabilities,
                    })
                end,

                ["ruff"] = function()
                    lspconfig.ruff.setup({
                        init_options = {
                            settings = {},
                        },
                        capabilities = capabilities,
                    })
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
