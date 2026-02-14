local M = {}

M.defaults = {
  api_key = os.getenv('DEEPSEEK_API_KEY') or '',
  api_base = 'https://api.deepseek.com/v1/chat/completions',
  model = 'deepseek-chat',
  timeout = 30000,
  max_tokens = 2000,
  window = {
    width = 80,
    height = 20,
    border = 'rounded',
  },
}

M.options = {}

function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', M.defaults, opts or {})
  
  if M.options.api_key == '' then
    vim.notify(
      'DeepSeek API key not set. Please set it via setup() or DEEPSEEK_API_KEY environment variable',
      vim.log.levels.WARN
    )
  end
end

return M
