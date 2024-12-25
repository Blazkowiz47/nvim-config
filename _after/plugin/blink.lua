local capabilities = require("blink.cmp").get_lsp_capabilities()

require("lspconfig").lua_ls.setup({ capabilities = capabilities })
require("lspconfig").ruff.setup({ capabilities = capabilities })
require("lspconfig").pyright.setup({ capabilities = capabilities })

print("Setting capabilities")
