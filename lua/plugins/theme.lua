vim.pack.add({
    { src = "https://github.com/dgox16/oldworld.nvim", lazy = false, priority = 1000 },
})

-- oldworld colorscheme config
local get_palette = require("oldworld.variants")
local p = get_palette("oled")

require("oldworld").setup({
    variant = "oled", -- Enable the OLED black background
    -- Pass your custom overrides using the variant colors safely
    highlight_overrides = {
        TelescopeBorder = { fg = p.gray3 },         -- Borders around results/preview
        TelescopePromptBorder = { fg = p.gray3 },   -- Border around search prompt
        TelescopeResultsBorder = { fg = p.gray3 },  -- Border around search results
        TelescopePreviewBorder = { fg = p.gray3 },  -- Border around preview window

        -- Optional: style the titles inside the borders
        TelescopePromptTitle = { fg = p.bg, bg = p.purple },
        TelescopeResultsTitle = { fg = p.fg, italic = true },
        TelescopePreviewTitle = { fg = p.fg, italic = true },
    },
})

vim.cmd.colorscheme("oldworld")
