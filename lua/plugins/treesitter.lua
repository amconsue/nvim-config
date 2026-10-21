vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})


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
