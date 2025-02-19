local augroup = vim.api.nvim_create_augroup("LspFormattting",{})

local null_ls = require('null-ls')

null_ls.setup({
  sources = {
   null_ls.builtins.formatting.ruff,
   null_ls.builtins.diagnostics.ruff,
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  end,
})
