return {
    "emakman/nvim-latex-previewer",
    config = function()
        vim.keymap.set('n', '<leader>lp', '<cmd>LatexPreviewToggle<CR>')
    end
}
