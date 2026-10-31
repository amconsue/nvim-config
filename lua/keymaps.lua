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

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)

----------------- PLUGIN KEYMAPS -----------------

-- telescope keymaps
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>p', builtin.find_files, {})
vim.keymap.set('n', '<leader>f', builtin.live_grep, {})

-- neo-tree keymaps
vim.keymap.set('n', '<leader>t', ':Neotree filesystem toggle left reveal<CR>')

-- dap keymaps
local dap = require("dap")
local dapui = require("dapui")

vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "Debug: Start/Continue" })
vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "Debug: Step Out" })
vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<leader>T", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "Debug: Conditional Breakpoint" })
vim.keymap.set("n", "<leader>ui", function() dapui.toggle() end, { desc = "Debug: Toggle UI" })

-- autopairs/blink keymaps
local autopairs = require("nvim-autopairs")
local cmp = require("blink.cmp")

-- Connect nvim-autopairs cleanly into the native Enter key processing ring
-- If blink's menu is active, blink handles <CR>, otherwise autopairs handles formatting
vim.keymap.set('i', '<CR>', function()
    if cmp.is_visible() then
        cmp.accept()
        return ""
    else
        -- Fires nvim-autopairs native layout macros directly
        return autopairs.autopairs_cr()
    end
end, { expr = true, replace_keycodes = true })

-- Fugitive
vim.keymap.set('n', '<leader>gt', '<cmd>Git log --graph --oneline --all<cr>', { desc = 'Git [T]ree' })
