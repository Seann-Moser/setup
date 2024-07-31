return {
    -- Theme https://github.com/catppuccin/nvim
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    -- FZF https://github.com/nvim-telescope/telescope.nvim
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    -- DevIcons https://github.com/nvim-tree/nvim-web-devicons
    {
        'nvim-tree/nvim-web-devicons'
    },
    -- Tree Sitter https://github.com/nvim-treesitter/nvim-treesitter
    {
        'nvim-treesitter/nvim-treesitter'
    },
    -- Formatter https://github.com/stevearc/conform.nvim
    {
        'stevearc/conform.nvim',
        opts = {},
    }
}
