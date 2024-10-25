return {
    "vim-test/vim-test",
    dependencies = {
        "preservim/vimux"
    },
    config = function()
        vim.api.nvim_set_keymap('n', '<leader>t', ':TestNearest<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>T', ':TestFile<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>a', ':TestSuite<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>l', ':TestLast<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>g', ':TestVisit<CR>', { noremap = true, silent = true })
        vim.cmd("let test#strategy = 'vimux'")
    end
}
