return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = vim.fn.has "win32" ~= 0 and "make install_jsregexp" or nil,
    dependencies = {
        { "rafamadriz/friendly-snippets", name = "friendly-snippets" },
    },
    config = function(_, opts)
        local ls = require("luasnip")
        if opts then ls.config.setup(opts) end
        vim.tbl_map(
            function(type) require("luasnip.loaders.from_" .. type).lazy_load() end,
            { "vscode", "snipmate", "lua" }
        )
        -- friendly-snippets - enable standardized comments snippets
        require("luasnip").filetype_extend("python", { "pydoc" })
        require("luasnip").filetype_extend("java", { "javadoc" })
        require("luasnip").filetype_extend("c", { "cdoc" })
        require("luasnip").filetype_extend("cpp", { "cppdoc" })
        require("luasnip").filetype_extend("sh", { "shelldoc" })

        vim.keymap.set("i", "<C-K>", function() ls.expand() end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<leader>;", function() ls.jump(1) end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<leader>,", function() ls.jump(-1) end, { silent = true })
    end,

}
