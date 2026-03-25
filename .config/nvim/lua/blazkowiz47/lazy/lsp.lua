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
            -- 1. Activated conda env
            if vim.env.CONDA_PREFIX then
                local python = vim.env.CONDA_PREFIX .. "/bin/python"
                if vim.fn.executable(python) == 1 then
                    return python
                end
            end

            -- 2. Activated venv / virtualenv
            if vim.env.VIRTUAL_ENV then
                local python = vim.env.VIRTUAL_ENV .. "/bin/python"
                if vim.fn.executable(python) == 1 then
                    return python
                end
            end

            -- 3. Project-local .venv
            if workspace then
                local python = workspace .. "/.venv/bin/python"
                if vim.fn.executable(python) == 1 then
                    return python
                end
            end

            -- 4. Fallback
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
                    lspconfig.pyright.setup {
                        before_init = function(_, config)
                            config.settings = config.settings or {}
                            config.settings.python = config.settings.python or {}
                            config.settings.python.pythonPath = get_python_path(config.root_dir)
                        end,
                        settings = {
                            pyright = {
                                disableOrganizeImports = true, -- Using Ruff
                            },
                        },
                        capabilities = capabilities,
                    }
                end,
                ["ruff"] = function()
                    lspconfig.ruff.setup({
                        before_init = function(_, config)
                            local python = get_python_path(config.root_dir)

                            config.init_options = config.init_options or {}
                            config.init_options.settings = config.init_options.settings or {}
                            config.init_options.settings.interpreter = { python }
                        end,
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
