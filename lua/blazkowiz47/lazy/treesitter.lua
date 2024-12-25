return {
    "nvim-treesitter/nvim-treesitter",
    config = function()
        require 'nvim-treesitter.configs'.setup({
            ensure_installed = { "javascript", "python", "cpp", "cmake", "c", "lua", "vim", "vimdoc", "json", },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            }
        })
    end,
}
