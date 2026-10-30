vim.pack.add({
    { src = "https://github.com/abecodes/tabout.nvim" }
})

local tabout = require("tabout")

tabout.setup({
    tabkey = '<Tab>',             -- key to trigger tabout, set to an empty string to disable
    backwards_tabkey = '<S-Tab>',   -- key to trigger backwards tabout
    act_as_tab = true,            -- shift content if tab out is not possible
    act_as_shift_tab = false,     -- reverse shift content if shift tab out is not possible
    default_tab = '<C-t>',        -- shift default action (if act_as_tab is true)
    default_shift_tab = '<C-d>',  -- reverse shift default action
    enable_backwards = true,      -- well, backwards tabout
    completion = true,            -- if the tabkey is used in a completion popup
    tabouts = {
        {open = "'", close = "'"},
        {open = '"', close = '"'},
        {open = '`', close = '`'},
        {open = '(', close = ')'},
        {open = '[', close = ']'},
        {open = '{', close = '}'}
    },
    ignore_beginning = true,      -- if the cursor is at the beginning of a filled element it will rather tab out than shift the content
    exclude = {}                  -- tabout will ignore these filetypes
})
