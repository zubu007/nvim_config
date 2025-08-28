-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.api.nvim_set_keymap('n', '<Home>', '^', { noremap = true, silent = true })

-- gcc compile and run keymaps for C/C++
vim.keymap.set('n', '<leader>cg', '<cmd>CMakeGenerate<cr>', { desc = 'CMake Generate' })
vim.keymap.set('n', '<leader>cb', '<cmd>CMakeBuild<cr>', { desc = 'CMake Build' })
vim.keymap.set('n', '<leader>cr', '<cmd>CMakeRun<cr>', { desc = 'CMake Run' })
vim.keymap.set('n', '<leader>cC', '<cmd>CMakeClean<cr>', { desc = 'CMake Clean' })

-- Keymap to select and evaluate the Python code block above the cursor
vim.keymap.set('n', '<localleader>rr', function()
  -- Find start of the Python block above cursor
  local start_line = vim.fn.search('^```python\\s*$', 'bnW')
  if start_line == 0 then
    print 'No Python block start found'
    return
  end

  -- Find end of the block below start
  local end_line = vim.fn.search('^```\\s*$', 'nW')
  if end_line == 0 or end_line <= start_line then
    print 'No block end found'
    return
  end

  -- Go to start of block + 1 (skip ```python line)
  vim.api.nvim_win_set_cursor(0, { start_line + 1, 0 })
  vim.cmd 'normal! V' -- enter visual line mode

  -- Move to last line of block - 1 (skip closing ```)
  vim.api.nvim_win_set_cursor(0, { end_line - 1, 0 })

  -- Execute the visual selection
  vim.defer_fn(function()
    vim.cmd 'MoltenEvaluateVisual'
  end, 10) -- 10ms is enough
end, { desc = 'Select and evaluate Python code block', silent = true })

-- Keymap to select python blocks in ipynb files
vim.keymap.set('n', '<leader>vib', function()
  -- Search backward for the start of the block
  local start_line = vim.fn.search('^```python\\s*$', 'bnW')
  -- Search forward for the end of the block
  local end_line = vim.fn.search('^```\\s*$', 'nW')

  if start_line > 0 and end_line > start_line + 1 then
    -- Move cursor to start of selection
    vim.api.nvim_win_set_cursor(0, { start_line + 1, 0 })
    -- Enter visual line mode
    vim.cmd 'normal! V'
    -- Move cursor to end of selection
    vim.api.nvim_win_set_cursor(0, { end_line - 1, 0 })
  else
    print 'No Python code block found.'
  end
end, { desc = 'Select inside Python code block' })

-- Helper: find the previous or next python cell start
local function find_python_block(direction)
  local search_cmd = '^```python\\s*$'
  if direction == 'prev' then
    return vim.fn.search(search_cmd, 'bnW')
  else
    return vim.fn.search(search_cmd, 'nW')
  end
end

-- 1. Go to previous cell
-- Go to previous cell (second previous "```python")
vim.keymap.set('n', '<localleader>k', function()
  -- First previous block start
  local first_match = vim.fn.search('^```python\\s*$', 'bnW')
  if first_match == 0 then
    print 'No previous Python block found'
    return
  end

  -- Move cursor above the first match so we can find the second one
  if first_match > 1 then
    vim.api.nvim_win_set_cursor(0, { first_match - 1, 0 })
  else
    print 'No earlier block found'
    return
  end

  -- Second previous block start
  local second_match = vim.fn.search('^```python\\s*$', 'bnW')
  if second_match == 0 then
    print 'No earlier Python block found'
    return
  end

  -- Move to the line after the second match (inside cell)
  vim.api.nvim_win_set_cursor(0, { second_match + 1, 0 })
end, { desc = 'Go to previous Python cell', silent = true })

-- 2. Go to next cell
vim.keymap.set('n', '<localleader>j', function()
  local match = find_python_block 'next'
  if match == 0 then
    print 'No next Python block found'
    return
  end
  vim.api.nvim_win_set_cursor(0, { match + 1, 0 })
end, { desc = 'Go to next Python cell', silent = true })

-- Helper: get current block start & end
local function get_current_block_bounds()
  local start_line = vim.fn.search('^```python\\s*$', 'bnW')
  local end_line = vim.fn.search('^```\\s*$', 'nW')
  if start_line == 0 or end_line == 0 or end_line <= start_line then
    return nil, nil
  end
  return start_line, end_line
end

-- 3. Create new cell below
vim.keymap.set('n', '<localleader>oo', function()
  local _, end_line = get_current_block_bounds()
  if not end_line then
    print 'No current block found'
    return
  end
  -- Insert a new cell after the current block
  vim.api.nvim_buf_set_lines(0, end_line, end_line, false, {
    '```python',
    '',
    '```',
  })
  -- Move cursor into the empty line of the new cell
  vim.api.nvim_win_set_cursor(0, { end_line + 1, 0 })
end, { desc = 'Create new Python cell below', silent = true })

-- 4. Create new cell above
vim.keymap.set('n', '<localleader>or', function()
  local start_line, _ = get_current_block_bounds()
  if not start_line then
    print 'No current block found'
    return
  end
  -- Insert a new cell above the current block
  vim.api.nvim_buf_set_lines(0, start_line - 1, start_line - 1, false, {
    '```python',
    '',
    '```',
  })
  -- Move cursor into the empty line of the new cell
  vim.api.nvim_win_set_cursor(0, { start_line + 1, 0 })
end, { desc = 'Create new Python cell above', silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- MOLTEN KEYMAPS
vim.keymap.set('n', '<localleader>e', ':MoltenEvaluateOperator<CR>', { desc = 'evaluate operator', silent = true })
vim.keymap.set('n', '<localleader>os', ':noautocmd MoltenEnterOutput<CR>', { desc = 'open output window', silent = true })

-- Optional keymaps for Molten
-- vim.keymap.set('n', '<localleader>rr', ':MoltenReevaluateCell<CR>', { desc = 're-eval cell', silent = true })
vim.keymap.set('v', '<localleader>r', ':<C-u>MoltenEvaluateVisual<CR>gv', { desc = 'execute visual selection', silent = true })
vim.keymap.set('n', '<localleader>oh', ':MoltenHideOutput<CR>', { desc = 'close output window', silent = true })
vim.keymap.set('n', '<localleader>md', ':MoltenDelete<CR>', { desc = 'delete Molten cell', silent = true })

-- vim.keymap.set('n', '<C-Enter>', ':MoltenEvaluateOperator<CR>:call feedkeys("ib")<CR>', { desc = 'evaluate operator' })
vim.keymap.set('n', '<localleader>ik', ':MoltenInterrupt<CR>', { desc = 'interrupt kernel', silent = true })

-- if you work with html outputs:
vim.keymap.set('n', '<localleader>mx', ':MoltenOpenInBrowser<CR>', { desc = 'open output in browser', silent = true })

-- Automaticall launch the correct kernel for Molten.nvim
vim.keymap.set('n', '<localleader>ip', function()
  local venv = os.getenv 'VIRTUAL_ENV' or os.getenv 'CONDA_PREFIX'
  if venv ~= nil then
    -- in the form of /home/benlubas/.virtualenvs/VENV_NAME
    venv = string.match(venv, '/.+/(.+)')
    vim.cmd(('MoltenInit %s'):format(venv))
  else
    vim.cmd 'MoltenInit python3'
  end
end, { desc = 'Initialize Molten for python3', silent = true })

-- QUARTO KEYMAPS
local runner = require 'quarto.runner'
vim.keymap.set('n', '<localleader>rc', runner.run_cell, { desc = 'run cell', silent = true })
vim.keymap.set('n', '<localleader>ra', runner.run_above, { desc = 'run cell and above', silent = true })
vim.keymap.set('n', '<localleader>rA', runner.run_all, { desc = 'run all cells', silent = true })
vim.keymap.set('n', '<localleader>rl', runner.run_line, { desc = 'run line', silent = true })
vim.keymap.set('v', '<localleader>r', runner.run_range, { desc = 'run visual range', silent = true })
vim.keymap.set('n', '<localleader>RA', function()
  runner.run_all(true)
end, { desc = 'run all cells of all languages', silent = true })

local M = {}

M.copilot = {
  i = {
    ['<C-l>'] = {
      function()
        vim.fn.feedkeys(vim.fn['copilot#Accept'](), '')
      end,
      'Copilot Accept',
      { replace_keycodes = true, nowait = true, silent = true, expr = true, noremap = true },
    },
  },
}

return M
