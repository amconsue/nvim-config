vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
})


local cmp = require("blink.cmp")
local capabilities = cmp.get_lsp_capabilities()

-- lua_ls lsp config
vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    root_markers = { ".git", ".luarc.json", ".luarc.jsonc" },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                -- Tell the language server to explicitly search Neovim's runtime directories
                path = vim.split(package.path, ';'),
            },
            diagnostics = {
                globals = { 'vim' }
            },
            workspace = {
                checkThirdParty = false,
                -- Force the server to index all internal Neovim APIs (vim.api, vim.fn, etc.)
                library = {
                    vim.env.VIMRUNTIME,
                    -- Also index your local config so it autocompletes your own setup blocks
                    vim.fn.stdpath("config") .. "/lua"
                },
            },
            completion = {
                callSnippet = "Replace"
            }
        }
    }
})

-- tsc lsp config
vim.lsp.config("tsc", {
    capabilities = capabilities,
    root_markers = { "tsconfig.json", "package.json", ".git" },
})

-- lsp enable
vim.lsp.enable({ "lua_ls", "tsc" })
