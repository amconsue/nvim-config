local ts_languages = {
    'lua',
    'typescript',
    'javascript',
    'python',
    'go'
}

vim.pack.add({
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        version = "main",
    },
})

pcall(vim.cmd, "packadd nvim-treesitter")

vim.schedule(function()
    -- Ensure the TSInstall command is registered before executing
    if vim.fn.exists(":TSInstall") ~= 2 then return end

    -- The standard installation directory path used by nvim-treesitter
    local parser_dir = vim.fn.stdpath("data") .. "/site/parser/"
    local missing = {}

    for _, lang in ipairs(ts_languages) do
        -- Standard parser file names are compiled as 'lang.so' or 'lang.dylib'
        local glob_pattern = parser_dir .. lang .. ".*"
        local parser_exists = #vim.fn.glob(glob_pattern, true, true) > 0

        if not parser_exists then
            table.insert(missing, lang)
        end
    end

    -- If python or any other language is missing from disk, compile it cleanly
    if #missing > 0 then
        vim.cmd("TSInstall " .. table.concat(missing, " "))
    end
end)

local status_ok, configs = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
    -- If it fails on the very first boot because cloning is in progress,
    -- this prevents the editor from crashing and lets it finish downloading.
    return
end

configs.setup({
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})

vim.api.nvim_create_autocmd('FileType', {
    -- Added typescript and typescriptreact (for TSX) targets to the hook array
    pattern = ts_languages,
    callback = function(args)
        if vim.bo[args.buf].buftype ~= "" or not vim.bo[args.buf].buflisted then return end
        pcall(vim.treesitter.start, args.buf)
    end,
})
