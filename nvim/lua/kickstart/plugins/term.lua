local M = {}

-- Private state
local job_id = 0
local current_win = 0
local term_win = 0
local term_buf = 0
local term_type = nil

-- Private function to get visual selection
local function get_visual_selection(normalize_indent)
  -- Get the start and end positions of the visual selection
  local s_start = vim.fn.getpos "'<"
  local s_end = vim.fn.getpos "'>"

  -- Calculate the number of lines in the selection
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1

  -- Retrieve the lines within the selection range
  -- nvim_buf_get_lines uses 0-indexed line numbers, so subtract 1 from s_start[2]
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)

  if n_lines == 1 then
    -- Single line selection
    lines[1] = string.sub(lines[1], s_start[3], s_end[3])
  else
    -- Multi-line selection
    -- Adjust the first line to start from the correct column
    lines[1] = string.sub(lines[1], s_start[3], -1)
    -- Adjust the last line to end at the correct column
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end

  -- Concatenate the lines to form the complete selected text
  local result = table.concat(lines, '\n')

  -- If normalizing, remove redundant consecutive newlines
  if normalize_indent then
    result = result:gsub('\n\n+', '\n') -- Replace 3+ newlines with just 2
    result = result:gsub('^\n+', '') -- Remove leading newlines
    result = result:gsub('\n+$', '') -- Remove trailing newlines
  end

  return result
end

-- Debug function to log variables to file
local function log_to_file(var, filename)
  filename = filename or '/tmp/nvim_debug.log'
  local file = io.open(filename, 'a')
  if file then
    file:write(os.date '[%Y-%m-%d %H:%M:%S] ' .. vim.inspect(var) .. '\n')
    file:close()
  end
end

-- Setup function
function M.setup()
  -- Terminal autocmd to disable line numbers
  vim.api.nvim_create_autocmd('Termopen', {
    group = vim.api.nvim_create_augroup('term_module', {
      clear = true,
    }),
    callback = function()
      vim.opt.number = false
      vim.opt.relativenumber = false
    end,
  })

  -- Start REPL with options
  vim.keymap.set('n', '<space>st', function()
    local options = {
      { name = 'python', command = 'python', term_type = 'python' },
      { name = 'ipython', command = 'ipython', term_type = 'ipython' },
      { name = 'lua', command = 'lua', term_type = 'ipython' },
      { name = 'uv ipython', command = 'uv run ipython', term_type = 'ipython' },
      { name = 'chi-di', command = 'ch-chidi', term_type = 'ipython' },
      { name = 'chi-share', command = 'ch-chishare', term_type = 'ipython' },
      { name = 'Custom command...', command = nil, term_type = nil },
    }

    vim.ui.select(options, {
      prompt = 'Select REPL:',
      format_item = function(item)
        return item.name
      end,
    }, function(choice)
      if choice then
        local command = choice.command

        if not command then
          -- Custom command input
          vim.ui.input({ prompt = 'Enter command: ' }, function(input)
            if input then
              command = input
            else
              return
            end

            current_win = vim.api.nvim_get_current_win()
            vim.cmd.vnew()
            vim.cmd.term()
            vim.cmd.wincmd 'L'
            vim.api.nvim_win_setwidth(0, 60)
            job_id = vim.bo.channel
            term_win = vim.api.nvim_get_current_win()
            term_buf = vim.api.nvim_get_current_buf()
            vim.api.nvim_set_current_win(current_win)

            vim.fn.chansend(job_id, { command .. '\r\n' })
          end)
        else
          term_type = choice.term_type
          current_win = vim.api.nvim_get_current_win()
          vim.cmd.vnew()
          vim.cmd.term()
          vim.cmd.wincmd 'L'
          vim.api.nvim_win_set_width(0, 60)
          job_id = vim.bo.channel
          term_win = vim.api.nvim_get_current_win()
          term_buf = vim.api.nvim_get_current_buf()
          vim.api.nvim_set_current_win(current_win)

          local file = vim.fn.getcwd() .. '/.venv/bin/activate'
          --NOTE:  1 if exist
          local venv_exist = vim.fn.filereadable(file)

          if venv_exist == 1 then
            print('Use existing venv at: ' .. file)
            vim.fn.chansend(job_id, { 'source .venv/bin/activate && ' .. command .. '\r\n' })
          else
            print('No existing venv at: ' .. file)
            vim.fn.chansend(job_id, { command .. '\r\n' })
          end
        end
      end
    end)
  end)

  -- Send visual selection to terminal
  vim.keymap.set('v', '<space>soe', function()
    current_win = vim.api.nvim_get_current_win()
    -- Exit visual mode to update the '< and '> marks
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', false)
    local selection = get_visual_selection()

    -- Handle different terminal types
    if term_type == 'ipython' then
      -- Use bracket paste mode for ipython
      vim.fn.chansend(job_id, '\x1b[200~' .. selection .. '\x1b[201~\r\n')
    elseif term_type == 'python' then
      -- For regular python REPL, get normalized selection to avoid indent errors
      local normalized_selection = get_visual_selection(true)
      vim.fn.chansend(job_id, normalized_selection .. '\r\n')
    else
      -- Default behavior for other terminals
      vim.fn.chansend(job_id, selection .. '\r\n')
    end

    -- Schedule the scroll to happen after terminal output
    vim.schedule(function()
      vim.api.nvim_set_current_win(term_win)
      vim.cmd 'normal! G'
      vim.api.nvim_set_current_win(current_win)
    end)
  end)

  -- Close terminal
  vim.keymap.set('n', '<space>pc', function()
    if term_win ~= 0 then
      vim.api.nvim_win_close(term_win, true)
      vim.api.nvim_buf_delete(term_buf, { force = true })
      term_win = 0
      job_id = 0
    end
  end)
end

return M
