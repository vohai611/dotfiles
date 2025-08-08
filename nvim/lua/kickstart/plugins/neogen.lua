return {
  'danymat/neogen',
  config = true,
  init = function()
    require('neogen').setup {
      enabled = true,
      languages = {
        python = {
          template = {
            annotation_convention = 'numpydoc',
          },
        },
      },
    }
  end,
}
