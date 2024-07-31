-- Formatter https://github.com/stevearc/conform.nvim
return {
    'stevearc/conform.nvim',
    opts = {},
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")
        conform.setup({
            formatters_by_ft = {
                typescript = { "prettier" },
                javascript = { "prettierd", "prettier", stop_after_first = true },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                svelte = { "prettier" },
                css = { "prettier" },
                go = { "goimports", "gofmt" },
                html = { "prettier" },
                rust = { "rustfmt", lsp_format = "fallback" },
                ["_"] = { "trim_whitespace" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                graphql = { "prettier" },
                lua = { "stylua" },
                python = { "isort", "black" },
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
            },
        })
        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
}
