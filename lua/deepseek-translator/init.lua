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
    local regText = vim.fn.getreg('"') -- 获取当前寄存器中的文本
    vim.fn.exec('normal! gvy')         -- 重新选中视觉模式的文本
    local text = vim.fn.getreg('"')    -- 获取选中的文本
    vim.fn.setreg('"', regText)        -- 恢复寄存器中的文本

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
