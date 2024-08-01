-- https://github.com/williamboman/mason-lspconfig.nvim
return {
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")
        lspconfig.lua_ls.setup({})
        lspconfig.bashls.setup({})
        lspconfig.clangd.setup({})
        -- "csharp_ls.setup({})
        lspconfig.cmake.setup({})
        lspconfig.cssls.setup({})
        lspconfig.dockerls.setup({})
        lspconfig.eslint.setup({})
        lspconfig.flux_lsp.setup({})
        lspconfig.gopls.setup({})
        lspconfig.html.setup({})
        lspconfig.jsonls.setup({})
        -- "javatls.setup({})
        lspconfig.ansiblels.setup({})
        lspconfig.autotools_ls.setup({})
        lspconfig.intelephense.setup({})
        lspconfig.sqlls.setup({})
        lspconfig.terraformls.setup({})
        lspconfig.vuels.setup({})
        lspconfig.yamlls.setup({})

        -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
        -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})
        -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
        -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementations, {})
        -- vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
    end
}
