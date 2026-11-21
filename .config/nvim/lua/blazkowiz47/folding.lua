local autocmd = vim.api.nvim_create_autocmd
local ft_fold_augroup = vim.api.nvim_create_augroup('FileTypeFolding', { clear = true })

vim.opt.foldmethod = 'syntax'
autocmd('FileType', {
    pattern = { 'python' },
    callback = function()
        vim.opt_local.foldmethod = 'indent'
    end,
    group = ft_fold_augroup,
})
autocmd('FileType', {
    pattern = { 'markdown', 'text' },
    callback = function()
        vim.opt_local.foldmethod = 'manual'
    end,
    group = ft_fold_augroup,
})
autocmd('FileType', {
    group = ft_fold_augroup,
    pattern = 'dart',
    callback = function()
        vim.opt_local.foldmethod = 'expr'
        vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end,
})
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


