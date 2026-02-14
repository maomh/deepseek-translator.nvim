local M = {}
local api = require('deepseek-translator.api')
local ui = require('deepseek-translator.ui')
local config = require('deepseek-translator.config')

M.config = config

function M.setup(opts)
  config.setup(opts)
end

function M.translate_word()
  local word = vim.fn.expand('<cword>')
  if word == '' then
    vim.notify('No word under cursor', vim.log.levels.WARN)
    return
  end
  
  api.query_word(word, function(result)
    if result.error then
      vim.notify('Error: ' .. result.error, vim.log.levels.ERROR)
    else
      ui.show_result(result)
    end
  end)
end

function M.translate_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])
  
  if #lines == 0 then
    vim.notify('No text selected', vim.log.levels.WARN)
    return
  end
  
  local text
  if #lines == 1 then
    text = string.sub(lines[1], start_pos[3], end_pos[3])
  else
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
    text = table.concat(lines, '\n')
  end
  
  if text == '' then
    vim.notify('No text selected', vim.log.levels.WARN)
    return
  end
  
  api.translate_text(text, function(result)
    if result.error then
      vim.notify('Error: ' .. result.error, vim.log.levels.ERROR)
    else
      ui.show_result(result)
    end
  end)
end

return M
