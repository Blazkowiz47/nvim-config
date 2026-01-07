return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require('nvim-treesitter').setup({
            ensure_installed = { "javascript", "python", "cpp", "cmake", "c", "lua", "vimdoc", "json", "latex" },
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = true,
            }
        })
    end,
}
