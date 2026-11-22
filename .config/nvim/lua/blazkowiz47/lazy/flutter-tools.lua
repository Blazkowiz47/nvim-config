return {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    config = function()
        require("flutter-tools").setup({
            default_run_args = {
                flutter = { "--dart-define-from-file=.env" },
            },
        })
        require("telescope").load_extension("flutter")
        vim.keymap.set("n", "<leader>fc", "<cmd>Telescope flutter commands<CR>", {
            desc = "Flutter commands",
        })
    end,
}
