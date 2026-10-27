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

if vim.fn.executable('pyright-langserver') == 0 then
    print("Pyright language server not found. Installing globally via npm...")

    -- Execute global npm install asynchronously/synchronously on startup
    vim.fn.system('npm install -g pyright')

    -- Double check if installation succeeded
    if vim.fn.executable('pyright-langserver') == 1 then
        print("Pyright installed successfully!")
    else
        vim.notify("Failed to install Pyright. Please ensure node and npm are installed globally.", vim.log.levels.ERROR)
    end
end

vim.lsp.config('pyright', {
    capabilities = capabilities,
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
            },
        },
    },
})

-- lsp enable
vim.lsp.enable({ "lua_ls", "tsc", "pyright" })
