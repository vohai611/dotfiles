return {
  'nvim-treesitter/nvim-treesitter-context',
  init = function()
    require('treesitter-context').setup {
      enable = true,
      separator = '-',
    }
    vim.keymap.set('n', 'xx', function()
      require('treesitter-context').toggle()
    end, { silent = true })
    vim.keymap.set('n', 'xc', function()
      require('treesitter-context').go_to_context(vim.v.count1)
    end, { silent = true })
  end,
}
