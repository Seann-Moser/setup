require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin-macchiato"


require('nvim-web-devicons').setup()

-- Telescope Setup for Fuzzy Find
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})


require('nvim-treesitter.configs').setup(
    {
        highlight = {
            enable = true,
            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        ensure_installed = {
            "c",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "markdown",
            "markdown_inline",
            "gleam",
            "go",
            "gomod",
            "gosum",
            "html",
            "java",
            "jq",
            "json",
            "nginx",
            "php",
            "proto",
            "python",
            "terraform",
            "tmux",
            "typescript",
            "javascript",
            "vue",
            "rust"
        },
    }
)


require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        go = { "goimports", "gofmt" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { "rustfmt", lsp_format = "fallback" },
        ["_"] = { "trim_whitespace" },
        -- Conform will run the first available formatter
        javascript = { "prettierd", "prettier", stop_after_first = true },
    },
})

-- AutoFormat On Save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({ bufnr = args.buf })
    end,
})
