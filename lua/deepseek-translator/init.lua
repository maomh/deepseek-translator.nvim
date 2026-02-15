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

    ui.show_loading()

    api.query_word(word, function(result)
        if result.error then
            vim.notify('Error: ' .. result.error, vim.log.levels.ERROR)
            ui.close_window()
        else
            ui.show_result(result)
        end
    end)
end

function M.translate_selection()
    -- 获取可视模式选中的文本
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local start_line = start_pos[2]
    local start_col = start_pos[3]
    local end_line = end_pos[2]
    local end_col = end_pos[3]

    -- 获取选中的行
    local lines = vim.fn.getline(start_line, end_line)

    -- 处理单行选择
    if start_line == end_line then
        lines = { string.sub(lines[1], start_col, end_col) }
    else
        -- 处理多行选择
        lines[1] = string.sub(lines[1], start_col)
        lines[#lines] = string.sub(lines[#lines], 1, end_col)
    end

    local text = table.concat(lines, '\n')

    if text == '' then
        vim.notify('No text selected', vim.log.levels.WARN)
        return
    end

    ui.show_loading()

    api.translate_text(text, function(result)
        if result.error then
            vim.notify('Error: ' .. result.error, vim.log.levels.ERROR)
            ui.close_window()
        else
            ui.show_result(result)
        end
    end)
end

return M
