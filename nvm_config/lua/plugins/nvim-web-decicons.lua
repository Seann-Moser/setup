-- DevIcons https://github.com/nvim-tree/nvim-web-devicons
return {
    'nvim-tree/nvim-web-devicons',
    enabled = vim.g.icons_enabled,
    dependencies = {
        "nvim-lua/plenary.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
        require("nvim-web-devicons").set_default_icon('', '#6d8086', 65)
        require('nvim-web-devicons').setup(
            {
                color_icons = true,
                default = true,
                override = {
                    zsh = {
                        icon = "",
                        color = "#428850",
                        cterm_color = "65",
                        name = "Zsh"
                    },
                }
            }
        )
    end
}
