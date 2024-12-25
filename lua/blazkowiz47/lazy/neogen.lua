return {
    "danymat/neogen",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require('neogen').setup({
            snippet_engine = "luasnip",
            enabled = true,
            languages = {
                python = {
                    template = {
                        annotation_convention = "google_docstrings",
                    },
                },
            },
        })
        local neogen = require('neogen')
        vim.keymap.set("n", "<leader>nf", function()
            neogen.generate({ type = "func" })
        end)
        vim.keymap.set("n", "<leader>nt", function()
            neogen.generate({ type = "type" })
        end)
        vim.keymap.set("n", "<leader>nl", function()
            neogen.generate({ type = "file" })
        end)
        vim.keymap.set("n", "<leader>nc", function()
            neogen.generate({ type = "class" })
        end)
    end
}
