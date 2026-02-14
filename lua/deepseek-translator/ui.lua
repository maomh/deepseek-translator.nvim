local config = require('deepseek-translator.config')

local M = {}

local buf = nil
local win = nil

local function close_window()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  if buf and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
  end
  buf = nil
  win = nil
end

function M.show_result(result)
  close_window()
  
  local content = result.content or result.error or 'No content'
  local lines = vim.split(content, '\n')
  
  buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  
  local width = config.options.window.width
  local height = math.min(config.options.window.height, #lines + 2)
  
  local ui = vim.api.nvim_list_uis()[1]
  local win_width = ui.width
  local win_height = ui.height
  
  local col = math.floor((win_width - width) / 2)
  local row = math.floor((win_height - height) / 2)
  
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = config.options.window.border,
  }
  
  win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_win_set_option(win, 'wrap', true)
  vim.api.nvim_win_set_option(win, 'linebreak', true)
  
  local keymaps = {
    { 'n', 'q', close_window },
    { 'n', '<Esc>', close_window },
  }
  
  for _, keymap in ipairs(keymaps) do
    vim.api.nvim_buf_set_keymap(buf, keymap[1], keymap[2], '', {
      nowait = true,
      noremap = true,
      silent = true,
      callback = keymap[3],
    })
  end
end

return M
