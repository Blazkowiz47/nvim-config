local autocmd = vim.api.nvim_create_autocmd
local ft_fold_augroup = vim.api.nvim_create_augroup('FileTypeFolding', { clear = true })

-- Global defaults: Pre-configure Treesitter foldexpr, but keep folding manual by default
vim.opt.foldmethod = 'manual'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Python: Use indent folding instead
autocmd('FileType', {
    pattern = { 'python' },
    callback = function()
        vim.opt_local.foldmethod = 'indent'
    end,
    group = ft_fold_augroup,
})

-- Dart: Enable expr folding (inherits the global Treesitter foldexpr)
autocmd('FileType', {
    pattern = { 'dart' },
    callback = function()
        vim.opt_local.foldmethod = 'expr'
    end,
    group = ft_fold_augroup,
})

-- Enable Treesitter highlighting globally
autocmd('FileType', {
    pattern = { '*' },
    callback = function()
        local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
        if lang then
            pcall(vim.treesitter.start)
        end
    end,
    group = ft_fold_augroup,
})

