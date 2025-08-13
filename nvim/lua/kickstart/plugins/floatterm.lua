local M = {}
local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

-- Create a centered floating window
-- @param opts table Optional parameters: { width = 0.8, height = 0.8, buf = nil }
function M.create_float(opts)
  opts = opts or {}

  local width = opts.width or 0.8
  local height = opts.height or 0.8

  -- Get editor dimensions
  local screen_width = vim.o.columns
  local screen_height = vim.o.lines

  -- Calculate floating window size
  local win_width = math.floor(screen_width * width)
  local win_height = math.floor(screen_height * height)

  -- Calculate position to center the window
  local col = math.floor((screen_width - win_width) / 2)
  local row = math.floor((screen_height - win_height) / 2)

  -- Create buffer if not provided
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  -- Window configuration
  local win_opts = {
    relative = 'editor',
    width = win_width,
    height = win_height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_opts)

  return { win = win, buf = buf }
end

function M.setup()
  vim.keymap.set('n', '<leader>t', function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
      state.floating = M.create_float(state.floating)
      if vim.bo[state.floating.buf].buftype ~= 'terminal' then
        vim.cmd.terminal()
      end
    else
      vim.api.nvim_win_hide(state.floating.win)
    end
  end)
end
return M

