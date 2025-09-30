local fb_actions = require 'telescope._extensions.file_browser.actions'

return {
  'nvim-telescope/telescope-file-browser.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  init = function()
    vim.keymap.set('n', '<space>fb', ':Telescope file_browser<CR>')
  end,
  opts = {
    respect_gitignore = 0,
    mapping = {

      ['n'] = {
        ['c'] = fb_actions.create,
      },
    },
  },
}
