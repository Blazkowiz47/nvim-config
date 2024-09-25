require("tokyonight").setup({
    variant = "moon", -- auto, main, moon, or dawn
    dark_variant = "moon", -- main, moon, or dawn
    comments = { italic = true },
    keywords = { italic = true },
    transparent=true,
    cache = true,
    terminal_colors = true,
})

function ColorMyPencils(color)
	color = color or "tokyonight"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()
