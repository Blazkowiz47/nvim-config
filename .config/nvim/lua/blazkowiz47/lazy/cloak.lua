return {
  "laytan/cloak.nvim",
  config = function()
    require("cloak").setup({
        enabled=true, 
        cloak_charachter="*",
        highlight_group="Comment",
        patterns = {
          {
            file_pattern = {
              ".env*",
            },
            cloak_pattern = "=.*"
          },
        },
    })
  end,
}
