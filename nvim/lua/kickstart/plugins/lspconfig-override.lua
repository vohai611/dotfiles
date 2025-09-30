local M = {}

function M.setup()
  vim.lsp.config('pylsp', {
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            enabled = true,
            ignore = { 'E501' },
          },
          pyflakes = { enabled = false },
          flake8 = {
            ignore = { 'E501' },
            enabled = true,
          },
          pylint = { enabled = false },
          ruff = {
            enabled = true, -- Enable the plugin
            formatEnabled = true, -- Enable formatting using ruffs formatter
            -- executable = '<path-to-ruff-bin>', -- Custom path to ruff
            -- config = '<path_to_custom_ruff_toml>', -- Custom config for ruff to use
            -- extendSelect = { 'I' }, -- Rules that are additionally used by ruff
            -- extendIgnore = { 'C90' }, -- Rules that are additionally ignored by ruff
            -- format = { 'I' }, -- Rules that are marked as fixable by ruff that should be fixed when running textDocument/formatting
            -- severities = { ['D212'] = 'I' }, -- Optional table of rules where a custom severity is desired
            -- unsafeFixes = false, -- Whether or not to offer unsafe fixes as code actions. Ignored with the "Fix All" action

            -- Rules that are ignored when a pyproject.toml or ruff.toml is present:
            lineLength = 100, -- Line length to pass to ruff checking and formatting
            exclude = { '__about__.py' }, -- Files to be excluded by ruff checking
            -- select = { 'F' }, -- Rules to be enabled by ruff
            ignore = { 'D210', 'E501' }, -- Rules to be ignored by ruff
            perFileIgnores = { ['__init__.py'] = 'CPY001' }, -- Rules that should be ignored for specific files
            preview = false, -- Whether to enable the preview style linting and formatting.
            targetVersion = 'py310', -- The minimum python version to target (applies for both linting and formatting).
          },
        },
      },
    },
    -- Optional: on_attach function for keybindings or other setup when LSP attaches
    on_attach = function(client, bufnr)
      -- Example: set keybindings for LSP features
      print 'Walkaround mason-lspconfig, wait for their bugfix'
      -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Go to Definition' })
      -- ... other keybindings
    end,
  })

  vim.lsp.config('lua_ls', {
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  })

  -- require('lspconfig').rust_analyzer.setup {}
  -- require('lspconfig').svelte.setup {}
  -- require('lspconfig').tailwindcss.setup {}
  --
end
return M
