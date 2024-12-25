return {
    'folke/tokyonight.nvim',
    as = 'tokyonight',
    config = function()
        require("tokyonight").setup({
            variant = "moon",      -- auto, main, moon, or dawn
            dark_variant = "moon", -- main, moon, or dawn
            comments = { italic = true },
            keywords = { italic = true },
            transparent = true,
            cache = true,
            terminal_colors = true,
        })
        vim.cmd('colorscheme tokyonight-storm')
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })
    end
}
