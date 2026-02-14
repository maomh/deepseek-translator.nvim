# deepseek-translator.nvim

基于 DeepSeek API 的 Neovim 智能翻译插件

## 功能特性

- 📖 **单词查询**：获取单词的音标、释义、近义词和例句
- 🌐 **文本翻译**：将选中的文本翻译成中文
- 🎨 **浮动窗口**：使用 Neovim 原生浮动窗口的简洁界面
- ⚡ **异步请求**：使用 plenary.nvim 实现非阻塞 API 调用

## 依赖要求

- Neovim >= 0.8.0
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- DeepSeek API 密钥

## 安装方法

### 使用 [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'maomh/deepseek-translator.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('deepseek-translator').setup({
      api_key = 'your-deepseek-api-key', -- 或设置 DEEPSEEK_API_KEY 环境变量
    })
  end,
}
```

### 使用 [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'maomh/deepseek-translator.nvim',
  requires = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('deepseek-translator').setup({
      api_key = 'your-deepseek-api-key',
    })
  end,
}
```

### 使用 [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'nvim-lua/plenary.nvim'
Plug 'maomh/deepseek-translator.nvim'

" 在你的 init.vim 或 init.lua 中
lua << EOF
require('deepseek-translator').setup({
  api_key = 'your-deepseek-api-key',
})
EOF
```

## 配置选项

```lua
require('deepseek-translator').setup({
  -- API 配置
  api_key = '',  -- DeepSeek API 密钥（或使用 DEEPSEEK_API_KEY 环境变量）
  api_base = 'https://api.deepseek.com/v1/chat/completions',
  model = 'deepseek-chat',
  timeout = 30000,  -- 请求超时时间（毫秒）
  max_tokens = 2000,  -- API 响应的最大令牌数
  
  -- 窗口配置
  window = {
    width = 80,
    height = 20,
    border = 'rounded',  -- 'none', 'single', 'double', 'rounded', 'solid', 'shadow'
  },
})
```

## 使用方法

### 默认快捷键

- 普通模式：`<leader>t` - 查询光标下的单词
- 可视模式：`<leader>t` - 翻译选中的文本

### 命令

```vim
:DeepseekTranslateWord       " 查询光标下的单词
:DeepseekTranslateSelection  " 翻译可视选择的文本
```

### 自定义快捷键

如果你想使用自定义按键绑定：

```lua
-- 自定义快捷键映射
vim.keymap.set('n', '<leader>tw', '<Plug>(deepseek-translate-word)', { desc = '翻译单词' })
vim.keymap.set('v', '<leader>ts', '<Plug>(deepseek-translate-selection)', { desc = '翻译选中文本' })
```

### 浮动窗口控制

当结果窗口打开时：
- `q` 或 `<Esc>` - 关闭窗口

## API 密钥设置

你可以通过以下三种方式设置 DeepSeek API 密钥：

1. **环境变量**（推荐）：
   ```bash
   export DEEPSEEK_API_KEY='your-api-key'
   ```

2. **Setup 函数**：
   ```lua
   require('deepseek-translator').setup({
     api_key = 'your-api-key',
   })
   ```

3. **配置文件**：
   ```lua
   -- 在你的 init.lua 中
   vim.g.deepseek_api_key = 'your-api-key'
   
   require('deepseek-translator').setup({
     api_key = vim.g.deepseek_api_key,
   })
   ```

## 使用示例

1. 将光标放在单词上并按 `<leader>t` 可以查看：
   - 音标（英式和美式）
   - 词义（各种词性）
   - 近义词
   - 例句

2. 在可视模式下选中文本并按 `<leader>t` 获取中文翻译

## 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 贡献

欢迎贡献！请随时提交 Pull Request。
