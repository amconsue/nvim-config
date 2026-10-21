vim.opt.tabstop = 2      -- Number of spaces a <Tab> counts for
vim.opt.softtabstop = 2  -- Number of spaces a <Tab> counts for while editing
vim.opt.shiftwidth = 4   -- Size of an indent
vim.opt.expandtab = true -- Turn tabs into spaces
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.winborder = "rounded"
vim.opt.signcolumn = "yes"
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.wildmode = 'noselect:lastused,full' -- Configure native wildmenu to use a popup menu
vim.o.undofile = true
vim.o.breakindent = true
vim.g.mapleader = " "

-- Automatically trigger the completion menu when typing a command
vim.api.nvim_create_autocmd('CmdlineChanged', {
    pattern = ':',
    callback = function()
        vim.fn.wildtrigger()
    end,
})
