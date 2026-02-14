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

-- 获取可视模式下的选中文本
local function get_visual_selection()
    local _, ls, cs = unpack(vim.fn.getpos("'<"))
    local _, le, ce = unpack(vim.fn.getpos("'>"))
    if ls == le then
        return vim.fn.getline(ls):sub(cs, ce)
    else
        local lines = {}
        table.insert(lines, vim.fn.getline(ls):sub(cs))
        for i = ls + 1, le - 1 do
            table.insert(lines, vim.fn.getline(i))
        end
        table.insert(lines, vim.fn.getline(le):sub(1, ce))
        return table.concat(lines, "\n")
    end
end

function M.translate_selection()
    local text = get_visual_selection()

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
