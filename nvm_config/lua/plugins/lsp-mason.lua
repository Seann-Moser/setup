-- https://github.com/williamboman/mason-lspconfig.nvim
return {
    "https://github.com/williamboman/mason-lspconfig.nvim",
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "bashls",
                "clangd",
                -- "csharp_ls",
                "cmake",
                "cssls",
                "dockerls",
                "eslint",
                "flux_lsp",
                "gopls",
                "html",
                "jsonls",
                -- "javatls",
                "ansiblels",
                "autotools_ls",
                "intelephense",
                "sqlls",
                "terraformls",
                "vuels",
                "yamlls"
            }
        })
    end,
}
