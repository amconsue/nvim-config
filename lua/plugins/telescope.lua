vim.pack.add({
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
})


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
