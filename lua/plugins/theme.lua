vim.pack.add({ { src = "https://github.com/folke/tokyonight.nvim" } })
vim.cmd([[packloadall!]])

-- Configure it for your OLED black preference seamlessly
require("tokyonight").setup({
    style = "night",       -- High contrast dark
    transparent = true,    -- Forces a pure absolute black (#000000) terminal fallback background
})

vim.cmd.colorscheme('tokyonight')
