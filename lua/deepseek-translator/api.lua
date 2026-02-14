local curl = require('plenary.curl')
local config = require('deepseek-translator.config')

local M = {}

local function make_request(prompt, callback)
    local opts = config.options

    if opts.api_key == '' then
        callback({ error = 'API key not configured' })
        return
    end

    local body = vim.fn.json_encode({
        model = opts.model,
        messages = {
            {
                role = 'user',
                content = prompt
            }
        },
        max_tokens = opts.max_tokens,
        temperature = 0.7,
    })

    curl.post(opts.api_base, {
        headers = {
            ['Content-Type'] = 'application/json',
            ['Authorization'] = 'Bearer ' .. opts.api_key,
        },
        body = body,
        timeout = opts.timeout,
        callback = function(response)
            vim.schedule(function()
                if response.status ~= 200 then
                    callback({ error = 'API request failed: ' .. (response.body or 'Unknown error') })
                    return
                end

                local ok, data = pcall(vim.fn.json_decode, response.body)
                if not ok then
                    callback({ error = 'Failed to parse API response' })
                    return
                end

                if data.choices and data.choices[1] and data.choices[1].message then
                    callback({ content = data.choices[1].message.content })
                else
                    callback({ error = 'Invalid API response format' })
                end
            end)
        end,
    })
end

function M.query_word(word, callback)
    local prompt = string.format([[请提供单词 "%s" 的详细信息，包括：
1. 音标（英式和美式）
2. 中文释义（所有常见词性）
3. 近义词（至少3个）
4. 例句（至少2个，带中文翻译）

请用清晰的格式输出，使用以下结构：
【音标】
【释义】
【近义词】
【例句】]], word)

    make_request(prompt, callback)
end

function M.translate_text(text, callback)
    local prompt = string.format([[请将以下文本翻译成中文，保持原文的语气和风格：

%s

只需提供翻译结果，不需要额外说明。]], text)

    make_request(prompt, callback)
end

return M
