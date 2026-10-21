vim.pack.add({
    { src = "https://github.com/saghen/blink.lib" },
    { src = "https://github.com/saghen/blink.cmp" }
})

local cmp = require('blink.cmp')
cmp.build():pwait()

cmp.setup({
    keymap = { preset = 'enter' },
    sources = {
        default = { "lsp", "path", "buffer" }
    },

    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            window = { border = "rounded" },
        },
    },

    signature = {
        enabled = true,
        window = { border = "rounded" },
    }
})
