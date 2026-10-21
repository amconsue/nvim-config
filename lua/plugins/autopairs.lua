vim.pack.add({
    { src = "https://github.com/windwp/nvim-autopairs" },
})


local autopairs = require('nvim-autopairs')

autopairs.setup({
    check_ts = true, -- Force the engine to query Treesitter before executing
    ts_config = {
        lua = { 'string', 'source' }, -- Don't add pairs inside literal lua string nodes
        javascript = { 'string', 'template_string' },
        typescript = { 'string', 'template_string' },
    },
    fast_wrap = {},
    disable_filetype = { "TelescopePrompt", "neo-tree" },
})
