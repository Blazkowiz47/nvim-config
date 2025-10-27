return {
    "OXY2DEV/markview.nvim",
    lazy = false,

    config = function()
        vim.keymap.set("n", "<leader>mt", ":Markview toggle<CR>")
    end,
    -- For blink.cmp's completion
    -- source
    -- dependencies = {
    --     "saghen/blink.cmp"
    -- },
}
