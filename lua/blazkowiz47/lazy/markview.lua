return {
    "OXY2DEV/markview.nvim",
    lazy = false,
    config = function()
        vim.keymap.set("n", "<leader>mt", "<cmd>Markview toggle<CR>")
    end,
}
