return {
  'norcalli/nvim-colorizer.lua',
  init = function()
    vim.opt.termguicolors = true
    require('colorizer').setup()

    vim.keymap.set('n', '<leader>sc', ':ColorizerToggle<CR>', { noremap = true, silent = true })
  end,
}
