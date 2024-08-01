-- https://github.com/williamboman/mason-lspconfig.nvim
return {
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")
        local capabilites = require("cmp_nvim_lsp").default_capabilities()

        lspconfig.lua_ls.setup({
            capabilites = capabilites,
        })
        lspconfig.bashls.setup({
            capabilites = capabilites,
        })
        lspconfig.clangd.setup({
            capabilites = capabilites,
        })
        -- "csharp_ls.setup({})
        lspconfig.cmake.setup({
            capabilites = capabilites,
        })
        lspconfig.cssls.setup({ capabilites = capabilites, })
        lspconfig.dockerls.setup({ capabilites = capabilites, })
        lspconfig.eslint.setup({ capabilites = capabilites, })
        lspconfig.flux_lsp.setup({ capabilites = capabilites, })
        lspconfig.gopls.setup({ capabilites = capabilites, })
        lspconfig.html.setup({ capabilites = capabilites, })
        lspconfig.jsonls.setup({ capabilites = capabilites, })
        -- "javatls.setup({})
        lspconfig.ansiblels.setup({ capabilites = capabilites, })
        lspconfig.autotools_ls.setup({ capabilites = capabilites, })
        lspconfig.intelephense.setup({ capabilites = capabilites, })
        lspconfig.sqlls.setup({ capabilites = capabilites, })
        lspconfig.terraformls.setup({ capabilites = capabilites, })
        lspconfig.vuels.setup({ capabilites = capabilites, })
        lspconfig.yamlls.setup({ capabilites = capabilites, })

        vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
        vim.keymap.set("n", "gI", vim.lsp.buf.implementation, {})
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
}
