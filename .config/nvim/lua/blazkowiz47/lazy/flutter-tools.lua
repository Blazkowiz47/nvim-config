return {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    config = function()
        require("flutter-tools").setup({})
        require("telescope").load_extension("flutter")
    end,
}
