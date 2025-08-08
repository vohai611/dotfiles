-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'jpalardy/vim-slime',
  init = function()
    vim.g.slime_no_mappings = 1
    vim.g.slime_target = 'tmux'
    vim.g.slime_default_config = { socket_name = 'default', target_pane = '{last}' }
    vim.g.slime_bracketed_paste = 1
    vim.keymap.set('n', '<leader><CR>', ':SlimeSend<CR><CR>', { noremap = true, silent = true })
    vim.keymap.set('v', '<leader><CR>', 'y:SlimeSend1 <C-R>"<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>rp', ':SlimeSend1 exit() <CR>:SlimeSend1 ipython<CR>', { noremap = true, silent = true })
    -- restart ipython kernel
  end,
}
