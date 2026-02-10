-- 共享工具函数库
-- 提供安全 require、快捷键映射等通用辅助函数

local M = {}

--- 安全 require 模块，失败时显示错误通知而不是崩溃
--- 用于 init.lua 加载各配置模块，避免单个模块错误导致整体配置不可用
function M.try_require(name)
    local ok, err = pcall(require, name)
    if not ok then
        local msg = string.format(
            'Requiring `%s` failed: %s',
            name, err
        )
        vim.notify(msg, vim.log.levels.ERROR)
    end
end

--- 通用按键映射（vim.keymap.set 的简写）
function M.map(mode, lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, opts or {})
end

--- 非递归映射（noremap = true）
function M.noremap(mode, lhs, rhs)
    local opts = { noremap = true }
    vim.keymap.set(mode, lhs, rhs, opts)
end

--- Normal 模式映射
function M.nmap(lhs, rhs)
    vim.keymap.set('n', lhs, rhs)
end

--- Normal 模式非递归映射
function M.nnoremap(lhs, rhs)
    M.noremap('n', lhs, rhs)
end

--- Insert 模式非递归映射
function M.inoremap(lhs, rhs)
    M.noremap('i', lhs, rhs)
end

--- Visual 模式非递归映射
function M.vnoremap(lhs, rhs)
    M.noremap('v', lhs, rhs)
end

--- Command 模式非递归映射
function M.cnoremap(lhs, rhs)
    M.noremap('c', lhs, rhs)
end

return M
