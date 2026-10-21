vim.opt.tabstop = 2      -- Number of spaces a <Tab> counts for
vim.opt.softtabstop = 2  -- Number of spaces a <Tab> counts for while editing
vim.opt.shiftwidth = 4   -- Size of an indent
vim.opt.expandtab = true -- Turn tabs into spaces
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.winborder = "rounded"
vim.opt.signcolumn = "yes"
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true
vim.o.breakindent = true
vim.g.mapleader = " "

vim.keymap.set('n', '<leader>s', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
-- Save cursor state, auto-indent the entire file, and instantly restore view coordinates
vim.keymap.set('n', '<leader>i', function()
    local current_win = vim.api.nvim_get_current_win()
    local cursor_pos = vim.api.nvim_win_get_cursor(current_win) -- Saves line and column context

    -- Run the global auto-indent command silently without moving your view window
    vim.cmd('keepjumps normal! gg=G')

    -- Instantly restore the exact cursor location back to the saved state safely
    pcall(vim.api.nvim_win_set_cursor, current_win, cursor_pos)
end, { desc = "Auto-indent document keeping cursor position" })

-- Configure native wildmenu to use a popup menu
vim.opt.wildmode = 'noselect:lastused,full'

-- Automatically trigger the completion menu when typing a command
vim.api.nvim_create_autocmd('CmdlineChanged', {
    pattern = ':',
    callback = function()
        vim.fn.wildtrigger()
    end,
})

-- Cycle wildmenu autocomplete with Up and Down arrows
vim.keymap.set('c', '<Down>', function()
    return vim.fn.pumvisible() == 1 and '<C-n>' or '<Down>'
end, { expr = true })

vim.keymap.set('c', '<Up>', function()
    return vim.fn.pumvisible() == 1 and '<C-p>' or '<Up>'
end, { expr = true })

-- Confirm selection with Enter if menu is open, otherwise execute command
vim.keymap.set('c', '<CR>', function()
    return vim.fn.pumvisible() == 1 and '<C-y>' or '<CR>'
end, { expr = true })

vim.pack.add({
    -- oldworld colorscheme
    { src = "https://github.com/dgox16/oldworld.nvim", lazy = false, priority = 1000 },
    -- telescope
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    -- neo-tree
    { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", lazy = false, branch = "v3.x" },
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    -- lualine
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    -- lsp
    { src = "https://github.com/neovim/nvim-lspconfig" },
    -- treesitter
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/windwp/nvim-autopairs" },
    -- debugging
    { src = "https://github.com/mfussenegger/nvim-dap.git" },
    { src = "https://github.com/rcarriga/nvim-dap-ui.git" },
    { src = "https://github.com/nvim-neotest/nvim-nio.git" },
    { src = "https://github.com/mxsdev/nvim-dap-vscode-js" },
    -- git
    { src = "https://github.com/tpope/vim-fugitive" },
})

-- blink.cmp
vim.pack.add({{ src = "https://github.com/saghen/blink.lib" }})
vim.pack.add({{ src = "https://github.com/saghen/blink.cmp" }})

-- oldworld colorscheme config
local get_palette = require("oldworld.variants")
local p = get_palette("oled")

-- 2. Configure the theme native setup
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

-- telescope config
local telescope = require("telescope")
telescope.setup({
    defaults = {
        preview = { treesitter = true },
        color_devicons = true,
        sorting_strategy = "ascending",
        path_displays = { "smart" },
    },
    pickers = {
        find_files = {
            layout_config = {
                prompt_position = 'top',
            },
            sorting_strategy = 'ascending',
        },
        live_grep = {
            layout_config = {
                prompt_position = 'top',
            },
            sorting_strategy = 'ascending'
        }
    },
})
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>p', builtin.find_files, {})
vim.keymap.set('n', '<leader>f', builtin.live_grep, {})

-- neo-tree config
vim.keymap.set('n', '<leader>t', ':Neotree filesystem toggle left reveal<CR>')

-- lualine config
require("lualine").setup()

-- blink.cmp config
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

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)

-- treesitter config
vim.api.nvim_create_autocmd('FileType', {
    -- Added typescript and typescriptreact (for TSX) targets to the hook array
    pattern = {
        'lua',
        'typescript',
        'javascript',
        'typescriptreact',
        'python',
    },
    callback = function(args)
        if vim.bo[args.buf].buftype ~= "" or not vim.bo[args.buf].buflisted then return end
        pcall(vim.treesitter.start, args.buf)
    end,
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

-- Connect nvim-autopairs cleanly into the native Enter key processing ring
local cmp_status, blink_cmp = pcall(require, 'blink.cmp')
if cmp_status then
    -- If blink's menu is active, blink handles <CR>, otherwise autopairs handles formatting
    vim.keymap.set('i', '<CR>', function()
        if blink_cmp.is_visible() then
            blink_cmp.accept()
            return ""
        else
            -- Fires nvim-autopairs native layout macros directly
            return autopairs.autopairs_cr()
        end
    end, { expr = true, replace_keycodes = true })
end

local dap = require("dap")
local dapui = require("dapui")
local utils = require("dap.utils")

dapui.setup()
dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "Debug: Start/Continue" })
vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "Debug: Step Out" })
vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<leader>T", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "Debug: Conditional Breakpoint" })
vim.keymap.set("n", "<leader>ui", function() dapui.toggle() end, { desc = "Debug: Toggle UI" })

local debug_root = vim.fn.stdpath("data") .. "/site/debuggers"
local js_debug_path = debug_root .. "/vscode-js-debug"

-- 2. Pure Lua recursive file finder (handles layout changes cleanly)
local function locate_server_script(dir)
    local handle = vim.uv.fs_scandir(dir)
    if not handle then return nil end

    while true do
        local name, type = vim.uv.fs_scandir_next(handle)
        if not name then break end

        local full_path = dir .. "/" .. name
        if type == "directory" then
            local found = locate_server_script(full_path)
            if found then return found end
        elseif type == "file" and name == "dapDebugServer.js" then
            return full_path
        end
    end
    return nil
end

-- 3. Automatic Bootstrap Pipeline (Downloads & Extracts tar.gz payload)
local function bootstrap_js_debug()
    local existing_path = locate_server_script(js_debug_path)
    if existing_path then
        return existing_path
    end

    vim.notify("Bootstrapping clean standalone vscode-js-debug server...", vim.log.levels.INFO)

    vim.fn.delete(js_debug_path, "rf")
    vim.fn.mkdir(js_debug_path, "p")

    -- Query the GitHub API to dynamically parse the target download URL for the .tar.gz bundle
    local api_cmd = "curl -s https://api.github.com/repos/microsoft/vscode-js-debug/releases/latest " ..
    "| grep -o 'https://.*js-debug-dap-.*\\.tar\\.gz' | head -n 1"
    local download_url = vim.trim(vim.fn.system(api_cmd))

    if download_url == "" or not download_url:find("http") then
        -- Hard fallback if grep parsing fails or network is restricted
        download_url = "https://github.com"
    end

    local tar_path = debug_root .. "/js-debug-payload.tar.gz"

    -- Fetch asset and extract natively using tar
    vim.fn.system({ "curl", "-L", "-s", "-o", tar_path, download_url })
    vim.fn.system({ "tar", "-xzf", tar_path, "-C", js_debug_path })
    vim.fn.delete(tar_path)

    local discovered_path = locate_server_script(js_debug_path)
    if discovered_path then
        vim.notify("vscode-js-debug initialized automatically at: " .. discovered_path, vim.log.levels.INFO)
        return discovered_path
    end

    return nil
end

-- 4. Dynamic Execution Bind
local debug_server_js = bootstrap_js_debug()

dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = "node",
        args = {
            debug_server_js or "",
            "${port}",
        },
    },
}

if not debug_server_js then
    vim.notify("Dynamic initialization failed. Run :messages to check errors.", vim.log.levels.WARN)
end

for _, language in ipairs({ "typescript", "javascript" }) do
    dap.configurations[language] = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process ID",
            processId = utils.pick_process,
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch & Debug Chrome",
            url = function()
                local co = coroutine.running()
                return coroutine.create(function()
                    vim.ui.input({
                        prompt = "Enter URL: ",
                        default = "http://localhost:3000",
                    }, function(url)
                        if url == nil or url == "" then
                            return
                        else
                            coroutine.resume(co, url)
                        end
                    end)
                end)
            end,
            webRoot = vim.fn.getcwd(),
            protocol = "inspector",
            sourceMaps = true,
            userDataDir = false,
        },
        {
            name = "----- ↓ launch.json configs ↓ -----",
            type = "",
            request = "launch",
        },
    }
end
